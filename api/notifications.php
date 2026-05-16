<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/notifications.php
//
//  GET  → user's notifications (deduped, latest 30)
//  POST action=read_all  → mark all as read
//  POST action=read_one  → mark one as read { notification_id }
//
//  Deduplication: before returning, we collapse consecutive
//  identical messages into one so users don't see repeats.
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();

// ── GET ────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $history = isset($_GET['history']) && $_GET['history'] === '1';

    if ($history) {
        // Full history — no deduplication, no cap, all notifications for this user
        $stmt = $db->prepare('
            SELECT notification_id, message, is_read, type, is_announcement, created_at
            FROM   notifications
            WHERE  user_id = ?
            ORDER  BY created_at DESC
            LIMIT  200
        ');
        $stmt->execute([$userId]);
        $rows = $stmt->fetchAll();
        foreach ($rows as &$r) {
            $r['notification_id'] = (int)  $r['notification_id'];
            $r['is_read']         = (bool) $r['is_read'];
            $r['is_announcement'] = (bool) $r['is_announcement'];
            $r['created_at']      = date('j M Y, g:ia', strtotime($r['created_at']));
        }
        $unread = $db->prepare('SELECT COUNT(*) FROM notifications WHERE user_id=? AND is_read=0');
        $unread->execute([$userId]);
        jsonResponse(true, 'Notification history loaded.', [
            'notifications' => $rows,
            'unread_count'  => (int) $unread->fetchColumn(),
        ]);
    }

    // Default — deduped, latest 20 unique for bell dropdown
    $stmt = $db->prepare('
        SELECT notification_id, message, is_read, type, is_announcement, created_at
        FROM   notifications
        WHERE  user_id = ?
        ORDER  BY created_at DESC
        LIMIT  50
    ');
    $stmt->execute([$userId]);
    $rows = $stmt->fetchAll();

    $seen    = [];
    $deduped = [];
    foreach ($rows as $r) {
        $key = md5($r['message']);
        if (isset($seen[$key])) continue;
        $seen[$key] = true;
        $r['notification_id'] = (int)  $r['notification_id'];
        $r['is_read']         = (bool) $r['is_read'];
        $r['is_announcement'] = (bool) $r['is_announcement'];
        $r['created_at']      = date('j M Y, g:ia', strtotime($r['created_at']));
        $deduped[] = $r;
        if (count($deduped) >= 20) break;
    }

    $unread = $db->prepare('SELECT COUNT(*) FROM notifications WHERE user_id=? AND is_read=0');
    $unread->execute([$userId]);

    jsonResponse(true, 'Notifications loaded.', [
        'notifications' => $deduped,
        'unread_count'  => (int) $unread->fetchColumn(),
    ]);
}

// ── POST ───────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body   = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = $body['action'] ?? 'read_all';

    if ($action === 'read_all') {
        $db->prepare('UPDATE notifications SET is_read=1 WHERE user_id=?')->execute([$userId]);
        jsonResponse(true, 'All notifications marked as read.');
    }

    if ($action === 'read_one') {
        $nid = (int)($body['notification_id'] ?? 0);
        if (!$nid) jsonResponse(false, 'notification_id required.');
        $db->prepare('UPDATE notifications SET is_read=1 WHERE notification_id=? AND user_id=?')->execute([$nid, $userId]);
        jsonResponse(true, 'Notification marked as read.');
    }

    jsonResponse(false, 'Unknown action.');
}

jsonResponse(false, 'Method not allowed.');
