<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/announcements.php
//
//  GET  → returns all active announcements (all users)
//  POST → creates new announcement (admin only)
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();

// ── GET — fetch announcements ─────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $db->prepare('
        SELECT a.announcement_id, a.title, a.message, a.priority,
               a.is_active, a.created_at,
               CONCAT(u.first_name," ",u.last_name) AS posted_by_name
        FROM   announcements a
        JOIN   users u ON a.posted_by = u.user_id
        WHERE  a.is_active = 1
        ORDER  BY a.created_at DESC
        LIMIT  20
    ');
    $stmt->execute();
    $rows = $stmt->fetchAll();

    // Format dates nicely
    foreach ($rows as &$r) {
        $r['created_at'] = date('j M Y, g:ia', strtotime($r['created_at']));
    }

    jsonResponse(true, 'Announcements loaded.', ['announcements' => $rows]);
}

// ── POST — create announcement (admin/manager only) ─
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check role
    $roleStmt = $db->prepare('SELECT r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE u.user_id=?');
    $roleStmt->execute([$userId]);
    $roleRow = $roleStmt->fetch();
    $role    = $roleRow['role_name'] ?? '';

    $allowed = ['Facility Manager', 'System Admin'];
    if (!in_array($role, $allowed)) {
        jsonResponse(false, 'Only admins and facility managers can post announcements.');
    }

    $body     = json_decode(file_get_contents('php://input'), true) ?? [];
    $title    = trim($body['title']    ?? '');
    $message  = trim($body['message']  ?? '');
    $priority = $body['priority'] ?? 'medium';

    if (empty($title))   jsonResponse(false, 'Title is required.');
    if (empty($message)) jsonResponse(false, 'Message is required.');
    if (!in_array($priority, ['low','medium','high'])) $priority = 'medium';

    // Insert announcement
    $ins = $db->prepare('
        INSERT INTO announcements (posted_by, title, message, priority)
        VALUES (?, ?, ?, ?)
    ');
    $ins->execute([$userId, $title, $message, $priority]);
    $annId = (int) $db->lastInsertId();

    // Also push a notification to every user
    $users = $db->query('SELECT user_id FROM users')->fetchAll();
    $notif = $db->prepare('
        INSERT INTO notifications (user_id, message, type, is_announcement)
        VALUES (?, ?, "announcement", 1)
    ');
    foreach ($users as $u) {
        $notif->execute([$u['user_id'], "📢 {$title}: {$message}"]);
    }

    // Log admin action
    $db->prepare('
        INSERT INTO admin_logs (admin_id, action, target_type, target_id, description)
        VALUES (?, "ANNOUNCE", "announcement", ?, ?)
    ')->execute([$userId, $annId, "Posted announcement: \"{$title}\""]);

    jsonResponse(true, 'Announcement posted and sent to all users.', ['announcement_id' => $annId]);
}

jsonResponse(false, 'Method not allowed.');
