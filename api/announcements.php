<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/announcements.php
//
//  GET              → list active announcements
//  POST action=post → create (admin/manager only)
//  POST action=vote → upvote or downvote
//                     body: { announcement_id, vote: "up"|"down" }
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();
$role    = getUserRole($db, $userId);

// ── GET ────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // ?history=1 → return ALL announcements (including archived) for history page
    // default    → return only active announcements (for dashboards)
    $history = isset($_GET['history']) && $_GET['history'] === '1';

    if ($history) {
        // Full history — all roles can access, includes archived
        $stmt = $db->prepare("
            SELECT a.announcement_id, a.title, a.message, a.priority,
                   a.upvotes, a.downvotes, a.is_active, a.created_at,
                   CONCAT(u.first_name,' ',u.last_name) AS posted_by_name,
                   (SELECT av.vote FROM announcement_votes av
                    WHERE av.announcement_id=a.announcement_id AND av.user_id=? LIMIT 1) AS user_vote
            FROM   announcements a
            JOIN   users u ON a.posted_by = u.user_id
            ORDER  BY a.created_at DESC
        ");
        $stmt->execute([$userId]);
    } else {
        // Active only — for dashboards, max 30
        $stmt = $db->prepare("
            SELECT a.announcement_id, a.title, a.message, a.priority,
                   a.upvotes, a.downvotes, a.is_active, a.created_at,
                   CONCAT(u.first_name,' ',u.last_name) AS posted_by_name,
                   (SELECT av.vote FROM announcement_votes av
                    WHERE av.announcement_id=a.announcement_id AND av.user_id=? LIMIT 1) AS user_vote
            FROM   announcements a
            JOIN   users u ON a.posted_by = u.user_id
            WHERE  a.is_active = 1
            ORDER  BY a.created_at DESC
            LIMIT  30
        ");
        $stmt->execute([$userId]);
    }

    $rows = $stmt->fetchAll();
    foreach ($rows as &$r) {
        $r['created_at']  = date('j M Y, g:ia', strtotime($r['created_at']));
        $r['upvotes']     = (int)  $r['upvotes'];
        $r['downvotes']   = (int)  $r['downvotes'];
        $r['is_active']   = (bool) $r['is_active'];
    }

    jsonResponse(true, 'Announcements loaded.', ['announcements' => $rows]);
}

// ── POST ───────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body   = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = trim($body['action'] ?? 'post');

    // ── action=post (admin/manager only) ─────────────
    if ($action === 'post') {
        if (!in_array($role, ANNOUNCE_ROLES)) {
            jsonResponse(false, 'Only Admins and Facility Managers can post announcements.');
        }

        $title    = trim($body['title']    ?? '');
        $message  = trim($body['message']  ?? '');
        $priority = $body['priority'] ?? 'medium';

        if (empty($title))   jsonResponse(false, 'Title is required.');
        if (empty($message)) jsonResponse(false, 'Message is required.');
        if (!in_array($priority, ['low','medium','high'])) $priority = 'medium';

        $db->prepare('INSERT INTO announcements (posted_by,title,message,priority) VALUES (?,?,?,?)')
           ->execute([$userId, $title, $message, $priority]);
        $annId = (int) $db->lastInsertId();

        // Push notification to all active users
        $users = $db->query('SELECT user_id FROM users WHERE is_active=1')->fetchAll();
        $notif = $db->prepare("INSERT INTO notifications (user_id,message,type,is_announcement,is_read) VALUES (?,?,?,1,0)");
        foreach ($users as $u) {
            $notif->execute([$u['user_id'], "📢 {$title}: ".mb_substr($message,0,100).(mb_strlen($message)>100?'…':''), 'announcement']);
        }

        // Log admin action
        try {
            $db->prepare('INSERT INTO admin_logs (admin_id,action,target_type,target_id,description) VALUES (?,?,?,?,?)')
               ->execute([$userId,'ANNOUNCE','announcement',$annId,"Posted: \"{$title}\""]);
        } catch (Exception $e) {}

        jsonResponse(true, 'Announcement posted and sent to all users.', ['announcement_id' => $annId]);
    }

    // ── action=vote ───────────────────────────────────
    if ($action === 'vote') {
        $annId = (int) ($body['announcement_id'] ?? 0);
        $vote  = in_array($body['vote'] ?? '', ['up','down']) ? $body['vote'] : null;

        if (!$annId) jsonResponse(false, 'Announcement ID is required.');
        if (!$vote)  jsonResponse(false, 'Vote must be "up" or "down".');

        // Check announcement exists
        $chk = $db->prepare('SELECT announcement_id FROM announcements WHERE announcement_id=? AND is_active=1');
        $chk->execute([$annId]);
        if (!$chk->fetch()) jsonResponse(false, 'Announcement not found.');

        // Check existing vote for this user
        $existing = $db->prepare('SELECT vote_id, vote FROM announcement_votes WHERE announcement_id=? AND user_id=?');
        $existing->execute([$annId, $userId]);
        $prev = $existing->fetch();

        if ($prev) {
            if ($prev['vote'] === $vote) {
                // Same vote → toggle off (delete row)
                $db->prepare('DELETE FROM announcement_votes WHERE vote_id=?')->execute([$prev['vote_id']]);
                $action_result = 'removed';
            } else {
                // Different vote → switch
                $db->prepare('UPDATE announcement_votes SET vote=? WHERE vote_id=?')->execute([$vote, $prev['vote_id']]);
                $action_result = 'changed';
            }
        } else {
            // New vote
            $db->prepare('INSERT INTO announcement_votes (announcement_id,user_id,vote) VALUES (?,?,?)')->execute([$annId,$userId,$vote]);
            $action_result = 'added';
        }

        // Always resync from COUNT(*) — can never drift regardless of manual DB edits
        $db->prepare('
            UPDATE announcements SET
              upvotes   = (SELECT COUNT(*) FROM announcement_votes WHERE announcement_id=? AND vote="up"),
              downvotes = (SELECT COUNT(*) FROM announcement_votes WHERE announcement_id=? AND vote="down")
            WHERE announcement_id=?
        ')->execute([$annId, $annId, $annId]);

        // Return accurate counts direct from the resynced row
        $counts = $db->prepare('SELECT upvotes, downvotes FROM announcements WHERE announcement_id=?');
        $counts->execute([$annId]);
        $row = $counts->fetch();

        jsonResponse(true, 'Vote recorded.', [
            'action'    => $action_result,
            'vote'      => $action_result === 'removed' ? null : $vote,
            'upvotes'   => (int)$row['upvotes'],
            'downvotes' => (int)$row['downvotes'],
        ]);
    }

    // ── action=edit ───────────────────────────────────
    if ($action === 'edit') {
        if (!in_array($role, ANNOUNCE_ROLES)) jsonResponse(false, 'Only Admins and Facility Managers can edit announcements.');
        $annId    = (int)   ($body['announcement_id'] ?? 0);
        $title    = trim($body['title']    ?? '');
        $message  = trim($body['message']  ?? '');
        $priority = $body['priority'] ?? 'medium';

        if (!$annId)         jsonResponse(false, 'Announcement ID required.');
        if (empty($title))   jsonResponse(false, 'Title is required.');
        if (empty($message)) jsonResponse(false, 'Message is required.');
        if (!in_array($priority, ['low','medium','high'])) $priority = 'medium';

        $chk = $db->prepare('SELECT announcement_id FROM announcements WHERE announcement_id=? LIMIT 1');
        $chk->execute([$annId]);
        if (!$chk->fetch()) jsonResponse(false, 'Announcement not found.');

        $db->prepare('UPDATE announcements SET title=?, message=?, priority=? WHERE announcement_id=?')
           ->execute([$title, $message, $priority, $annId]);

        try {
            $db->prepare('INSERT INTO admin_logs (admin_id,action,target_type,target_id,description) VALUES (?,?,?,?,?)')
               ->execute([$userId,'UPDATE','announcement',$annId,"Edited: \"{$title}\""]);
        } catch (Exception $e) {}

        jsonResponse(true, 'Announcement updated.');
    }

    // ── action=archive ────────────────────────────────
    if ($action === 'archive') {
        if (!in_array($role, ANNOUNCE_ROLES)) jsonResponse(false, 'Access denied.');
        $annId = (int)($body['announcement_id'] ?? 0);
        if (!$annId) jsonResponse(false, 'Announcement ID required.');
        $db->prepare('UPDATE announcements SET is_active=0 WHERE announcement_id=?')->execute([$annId]);
        jsonResponse(true, 'Announcement archived.');
    }

    // ── action=restore ────────────────────────────────
    if ($action === 'restore') {
        if (!in_array($role, ANNOUNCE_ROLES)) jsonResponse(false, 'Access denied.');
        $annId = (int)($body['announcement_id'] ?? 0);
        if (!$annId) jsonResponse(false, 'Announcement ID required.');
        $db->prepare('UPDATE announcements SET is_active=1 WHERE announcement_id=?')->execute([$annId]);
        jsonResponse(true, 'Announcement restored.');
    }

    // ── action=delete ─────────────────────────────────
    if ($action === 'delete') {
        if (!in_array($role, ANNOUNCE_ROLES)) jsonResponse(false, 'Access denied.');
        $annId = (int)($body['announcement_id'] ?? 0);
        if (!$annId) jsonResponse(false, 'Announcement ID required.');
        // Also delete related votes
        $db->prepare('DELETE FROM announcement_votes WHERE announcement_id=?')->execute([$annId]);
        $db->prepare('DELETE FROM announcements WHERE announcement_id=?')->execute([$annId]);
        jsonResponse(true, 'Announcement deleted.');
    }

    jsonResponse(false, 'Unknown action. Use "post", "vote", "archive", "restore", or "delete".');
}

jsonResponse(false, 'Method not allowed.');
