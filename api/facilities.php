<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/facilities.php
//
//  GET  → list all facilities
//  POST action=create → add facility (FM + Admin)
//  POST action=toggle → toggle is_available
//  POST action=delete → remove facility
//
//  NOTE: The `emoji` column must exist on the facilities
//  table. If you haven't run the ALTER yet, add it:
//    ALTER TABLE facilities ADD COLUMN emoji varchar(10) DEFAULT '🏛️';
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();
$role    = getUserRole($db, $userId);

// Silently add emoji column if it doesn't exist (migration-safe)
try {
    $cols = $db->query("SHOW COLUMNS FROM facilities LIKE 'emoji'")->fetchAll();
    if (empty($cols)) {
        $db->exec("ALTER TABLE facilities ADD COLUMN emoji varchar(10) NOT NULL DEFAULT '🏛️' AFTER facility_name");
    }
} catch (Exception $e) { /* ignore if fails */ }

// ── GET — list facilities ─────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $db->prepare('
        SELECT f.facility_id, f.facility_name, f.emoji, f.capacity, f.location, f.is_available,
               ft.type_name
        FROM   facilities f
        LEFT JOIN facilitytypes ft ON f.type_id = ft.type_id
        ORDER  BY f.facility_id
    ');
    $stmt->execute();
    $rows = $stmt->fetchAll();
    foreach ($rows as &$r) {
        $r['facility_id']  = (int)  $r['facility_id'];
        $r['capacity']     = (int)  $r['capacity'];
        $r['is_available'] = (bool) $r['is_available'];
        $r['emoji']        = $r['emoji'] ?: '🏛️';
    }
    jsonResponse(true, 'Facilities loaded.', ['facilities' => $rows]);
}

// ── POST — manager/admin actions ─────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $managerRoles = ['Admin', 'Facility Manager'];
    if (!in_array($role, $managerRoles)) {
        jsonResponse(false, 'Only Admins and Facility Managers can manage facilities.');
    }

    $body   = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = trim($body['action'] ?? '');

    // ── create ────────────────────────────────────
    if ($action === 'create') {
        $name     = trim($body['facility_name'] ?? '');
        $typeId   = (int)   ($body['type_id']   ?? 1);
        $capacity = (int)   ($body['capacity']  ?? 0);
        $location = trim($body['location']      ?? '');
        $emoji    = trim($body['emoji']         ?? '🏛️');

        if (empty($name))     jsonResponse(false, 'Facility name is required.');
        if ($capacity <= 0)   jsonResponse(false, 'Capacity must be greater than 0.');
        if (empty($location)) jsonResponse(false, 'Location is required.');

        // Sanitise emoji — keep only first grapheme cluster
        if (mb_strlen($emoji) > 4) $emoji = '🏛️';

        $db->prepare('
            INSERT INTO facilities (facility_name, emoji, type_id, capacity, location, is_available)
            VALUES (?, ?, ?, ?, ?, 1)
        ')->execute([$name, $emoji, $typeId, $capacity, $location]);
        $newId = (int) $db->lastInsertId();

        // Log
        try {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null;
            $db->prepare('INSERT INTO admin_logs (admin_id,action,target_type,target_id,description,ip_address) VALUES (?,?,?,?,?,?)')
               ->execute([$userId,'CREATE','facility',$newId,"Added facility: {$name}",$ip]);
        } catch (Exception $e) {}

        jsonResponse(true, 'Facility added.', ['facility_id' => $newId]);
    }

    // ── update ────────────────────────────────────
    if ($action === 'update') {
        $facId    = (int)   ($body['facility_id']  ?? 0);
        $name     = trim($body['facility_name']    ?? '');
        $typeId   = (int)   ($body['type_id']      ?? 1);
        $capacity = (int)   ($body['capacity']     ?? 0);
        $location = trim($body['location']         ?? '');
        $emoji    = trim($body['emoji']            ?? '🏛️');

        if (!$facId)      jsonResponse(false, 'facility_id required.');
        if (empty($name)) jsonResponse(false, 'Facility name is required.');
        if ($capacity <= 0) jsonResponse(false, 'Capacity must be greater than 0.');
        if (empty($location)) jsonResponse(false, 'Location is required.');
        if (mb_strlen($emoji) > 4) $emoji = '🏛️';

        $check = $db->prepare('SELECT facility_id FROM facilities WHERE facility_id=? LIMIT 1');
        $check->execute([$facId]);
        if (!$check->fetch()) jsonResponse(false, 'Facility not found.');

        $db->prepare('UPDATE facilities SET facility_name=?, emoji=?, type_id=?, capacity=?, location=? WHERE facility_id=?')
           ->execute([$name, $emoji, $typeId, $capacity, $location, $facId]);

        try {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null;
            $db->prepare('INSERT INTO admin_logs (admin_id,action,target_type,target_id,description,ip_address) VALUES (?,?,?,?,?,?)')
               ->execute([$userId,'UPDATE','facility',$facId,"Updated facility: {$name}",$ip]);
        } catch (Exception $e) {}

        jsonResponse(true, 'Facility updated.');
    }

    // ── toggle availability ───────────────────────
    if ($action === 'toggle') {
        $facId    = (int) ($body['facility_id']  ?? 0);
        $newState = (int) ($body['is_available'] ?? 0);
        if (!$facId) jsonResponse(false, 'facility_id required.');
        $db->prepare('UPDATE facilities SET is_available=? WHERE facility_id=?')->execute([$newState, $facId]);
        jsonResponse(true, 'Facility availability updated.');
    }

    // ── delete ────────────────────────────────────
    if ($action === 'delete') {
        $facId = (int) ($body['facility_id'] ?? 0);
        if (!$facId) jsonResponse(false, 'facility_id required.');

        // Get name for log
        $row = $db->prepare('SELECT facility_name FROM facilities WHERE facility_id=? LIMIT 1');
        $row->execute([$facId]);
        $fac = $row->fetch();
        if (!$fac) jsonResponse(false, 'Facility not found.');

        // CASCADE will remove related bookings and maintenance requests if FK is set
        $db->prepare('DELETE FROM facilities WHERE facility_id=?')->execute([$facId]);

        try {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null;
            $db->prepare('INSERT INTO admin_logs (admin_id,action,target_type,target_id,description,ip_address) VALUES (?,?,?,?,?,?)')
               ->execute([$userId,'DELETE','facility',$facId,"Deleted facility: {$fac['facility_name']}",$ip]);
        } catch (Exception $e) {}

        jsonResponse(true, 'Facility deleted.');
    }

    jsonResponse(false, 'Unknown action. Use "create", "toggle", or "delete".');
}

jsonResponse(false, 'Method not allowed.');
