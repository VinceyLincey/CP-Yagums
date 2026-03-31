<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/facilities.php
//  GET → returns all facilities with type info
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$db      = getDB();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') jsonResponse(false, 'Method not allowed.');

$stmt = $db->prepare('
    SELECT f.facility_id, f.facility_name, f.capacity, f.location, f.is_available,
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
}

jsonResponse(true, 'Facilities loaded.', ['facilities' => $rows]);
