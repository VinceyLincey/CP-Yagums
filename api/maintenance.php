<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/maintenance.php
//
//  GET  → tasks assigned to the logged-in staff member
//         + summary counts + all requests (for overview)
//  POST action=update_progress → update progress notes + status
//  POST action=complete        → mark task completed
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();
$role    = getUserRole($db, $userId);

// All authenticated users can report issues or view their own reports.
// Maintenance Staff / Admin / FM get the full task + all-requests view.
$isStaff = in_array($role, ['Maintenance Staff', 'Admin', 'Facility Manager']);

// ── GET ────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    // ?my_reports=1 — anyone can fetch their own submitted requests
    if (isset($_GET['my_reports'])) {
        $stmt = $db->prepare('
            SELECT mr.request_id, mr.description, mr.priority, mr.created_at,
                   ms.status_name, f.facility_name, f.location, f.emoji
            FROM   maintenancerequests mr
            JOIN   maintenancestatus ms ON mr.status_id   = ms.status_id
            JOIN   facilities        f  ON mr.facility_id = f.facility_id
            WHERE  mr.reported_by = ?
            ORDER  BY mr.created_at DESC
        ');
        $stmt->execute([$userId]);
        $rows = $stmt->fetchAll();
        foreach ($rows as &$r) {
            $r['request_id'] = (int) $r['request_id'];
            $r['created_at'] = date('j M Y, g:ia', strtotime($r['created_at']));
        }
        jsonResponse(true, 'Your reports loaded.', ['requests' => $rows]);
    }

    // Full staff view — Maintenance Staff / Admin / FM only
    if (!$isStaff) {
        jsonResponse(false, 'Access denied.');
    }

    // Tasks assigned to this staff member (join with request + facility)
    $taskStmt = $db->prepare('
        SELECT
            t.task_id, t.request_id, t.progress, t.completed, t.updated_at,
            mr.description, mr.priority, mr.created_at AS reported_at,
            mr.status_id,
            f.facility_name, f.location,
            CONCAT(u.first_name," ",u.last_name) AS reported_by_name
        FROM   maintenancetasks t
        JOIN   maintenancerequests mr ON t.request_id  = mr.request_id
        JOIN   facilities          f  ON mr.facility_id = f.facility_id
        JOIN   users               u  ON mr.reported_by = u.user_id
        WHERE  t.assigned_to = ?
        ORDER  BY t.completed ASC, mr.priority DESC, mr.created_at DESC
    ');
    $taskStmt->execute([$userId]);
    $tasks = $taskStmt->fetchAll();

    foreach ($tasks as &$t) {
        $t['task_id']    = (int)  $t['task_id'];
        $t['request_id'] = (int)  $t['request_id'];
        $t['completed']  = (bool) $t['completed'];
        $t['reported_at']= date('j M Y', strtotime($t['reported_at']));
        $t['updated_at'] = date('j M Y, g:ia', strtotime($t['updated_at']));
        // Derive status_name from task's completed flag — not from request status
        // This ensures the dashboard reflects the actual task state correctly
        if ($t['completed']) {
            $t['status_name'] = 'Completed';
        } elseif ((int)$t['status_id'] === 2) {
            $t['status_name'] = 'In Progress';
        } else {
            $t['status_name'] = 'Pending';
        }
    }

    // Summary counts — completed boolean is the single source of truth
    $open      = array_filter($tasks, fn($t) => !$t['completed']);
    $done      = array_filter($tasks, fn($t) =>  $t['completed']);
    $highCount = array_filter($open,  fn($t) => strtolower($t['priority']) === 'high');

    // All maintenance requests — for "All Requests" table
    $reqStmt = $db->prepare('
        SELECT mr.request_id, mr.description, mr.priority, mr.created_at,
               ms.status_name,
               f.facility_name, f.location,
               CONCAT(u.first_name," ",u.last_name) AS reported_by_name
        FROM   maintenancerequests mr
        JOIN   maintenancestatus   ms ON mr.status_id   = ms.status_id
        JOIN   facilities          f  ON mr.facility_id = f.facility_id
        JOIN   users               u  ON mr.reported_by = u.user_id
        ORDER  BY mr.created_at DESC
    ');
    $reqStmt->execute();
    $requests = $reqStmt->fetchAll();
    foreach ($requests as &$r) {
        $r['request_id'] = (int) $r['request_id'];
        $r['created_at'] = date('j M Y', strtotime($r['created_at']));
    }

    // Facility health: has open request = issue, in-progress = warn, else ok
    $facStmt = $db->query('
        SELECT f.facility_id, f.facility_name, f.location,
               COUNT(CASE WHEN mr.status_id=1 THEN 1 END) AS pending_count,
               COUNT(CASE WHEN mr.status_id=2 THEN 1 END) AS inprog_count
        FROM   facilities f
        LEFT JOIN maintenancerequests mr ON mr.facility_id = f.facility_id
        GROUP  BY f.facility_id
        ORDER  BY f.facility_id
    ');
    $facilities = $facStmt->fetchAll();
    foreach ($facilities as &$f) {
        $f['facility_id']    = (int) $f['facility_id'];
        $f['pending_count']  = (int) $f['pending_count'];
        $f['inprog_count']   = (int) $f['inprog_count'];
        $f['health'] = $f['pending_count'] > 0 ? 'issue' : ($f['inprog_count'] > 0 ? 'warn' : 'ok');
    }

    jsonResponse(true, 'Maintenance data loaded.', [
        'tasks'       => $tasks,
        'requests'    => $requests,
        'facilities'  => $facilities,
        'summary'     => [
            'open_tasks'   => count($open),
            'high_priority'=> count($highCount),
            'completed'    => count($done),
            'total_tasks'  => count($tasks),
        ],
    ]);
}

// ── POST ───────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body   = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = trim($body['action'] ?? '');

    // ── delete_report (reporter only, pending only) ──
    if ($action === 'delete_report') {
        $reqId = (int) ($body['request_id'] ?? 0);
        if (!$reqId) jsonResponse(false, 'request_id required.');

        // Verify the request belongs to this user and is still Pending
        $chk = $db->prepare('SELECT reported_by, status_id, description FROM maintenancerequests WHERE request_id=? LIMIT 1');
        $chk->execute([$reqId]);
        $req = $chk->fetch();

        if (!$req) jsonResponse(false, 'Report not found.');
        if ((int)$req['reported_by'] !== $userId) jsonResponse(false, 'You can only delete your own reports.');
        if ((int)$req['status_id'] !== 1) jsonResponse(false, 'Only Pending reports can be deleted. This report is already being actioned.');

        // Delete any associated tasks first, then the request
        $db->prepare('DELETE FROM maintenancetasks WHERE request_id=?')->execute([$reqId]);
        $db->prepare('DELETE FROM maintenancerequests WHERE request_id=?')->execute([$reqId]);

        jsonResponse(true, 'Report deleted successfully.');
    }

    // ── report (all roles) ────────────────────────
    if ($action === 'report') {
        $facilityId  = (int)   ($body['facility_id']  ?? 0);
        $description = trim($body['description']      ?? '');
        $priority    = trim($body['priority']         ?? 'Medium');

        if (!$facilityId)       jsonResponse(false, 'Please select a facility.');
        if (empty($description))jsonResponse(false, 'Please describe the issue.');
        if (!in_array($priority, ['Low','Medium','High'])) $priority = 'Medium';

        // Check facility exists
        $fac = $db->prepare('SELECT facility_name FROM facilities WHERE facility_id=? LIMIT 1');
        $fac->execute([$facilityId]);
        $facRow = $fac->fetch();
        if (!$facRow) jsonResponse(false, 'Facility not found.');

        // Fetch all active Maintenance Staff first (needed for task assignment + notifications)
        $staff = $db->query("SELECT u.user_id FROM users u JOIN roles r ON u.role_id=r.role_id WHERE r.role_name='Maintenance Staff' AND u.is_active=1")->fetchAll();

        // Insert request — status Pending (1)
        $db->prepare('INSERT INTO maintenancerequests (facility_id, reported_by, description, priority, status_id) VALUES (?,?,?,?,1)')
           ->execute([$facilityId, $userId, $description, $priority]);
        $reqId = (int) $db->lastInsertId();

        // Auto-assign a task to every active Maintenance Staff member
        // so the report appears immediately on their dashboard
        if (!empty($staff)) {
            $taskInsert = $db->prepare('INSERT INTO maintenancetasks (request_id, assigned_to, progress, completed) VALUES (?,?,?,0)');
            foreach ($staff as $s) {
                $taskInsert->execute([$reqId, $s['user_id'], '']);
            }
        }

        // Notify the reporter
        $db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
           ->execute([$userId, "🔧 Your maintenance report for {$facRow['facility_name']} has been submitted and is pending review.", 'info']);

        // Notify all active Maintenance Staff
        $notif = $db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)");
        foreach ($staff as $s) {
            $notif->execute([$s['user_id'], "🔧 New maintenance report for {$facRow['facility_name']}: ".mb_substr($description,0,80).(mb_strlen($description)>80?'…':''), 'warning']);
        }

        jsonResponse(true, 'Maintenance report submitted successfully!', ['request_id' => $reqId]);
    }

    // ── staff-only actions below ──────────────────
    if (!$isStaff) {
        jsonResponse(false, 'Access denied.');
    }

    // ── update_progress ───────────────────────────
    if ($action === 'update_progress') {
        $taskId   = (int)  ($body['task_id']  ?? 0);
        $progress = trim($body['progress']    ?? '');
        $statusId = (int)  ($body['status_id'] ?? 0); // 1=Pending 2=In Progress 3=Completed

        if (!$taskId) jsonResponse(false, 'task_id required.');
        if (!$progress) jsonResponse(false, 'Progress notes required.');
        if (!in_array($statusId, [1,2,3])) $statusId = 2; // default In Progress

        // Verify task belongs to this user
        $chk = $db->prepare('SELECT request_id FROM maintenancetasks WHERE task_id=? AND assigned_to=? LIMIT 1');
        $chk->execute([$taskId, $userId]);
        $row = $chk->fetch();
        if (!$row) jsonResponse(false, 'Task not found or not assigned to you.');

        // Update task progress — also mark completed if status is Completed (3)
        $db->prepare('UPDATE maintenancetasks SET progress=?, completed=? WHERE task_id=?')
           ->execute([$progress, ($statusId === 3 ? 1 : 0), $taskId]);

        // Update request status
        $db->prepare('UPDATE maintenancerequests SET status_id=? WHERE request_id=?')
           ->execute([$statusId, $row['request_id']]);

        // Notify the reporter
        $reporter = $db->prepare('
            SELECT mr.reported_by, f.facility_name
            FROM   maintenancerequests mr
            JOIN   facilities f ON mr.facility_id = f.facility_id
            WHERE  mr.request_id=? LIMIT 1
        ');
        $reporter->execute([$row['request_id']]);
        $rep = $reporter->fetch();
        if ($rep) {
            $statusLabels = [1=>'Pending',2=>'In Progress',3=>'Completed'];
            $label = $statusLabels[$statusId] ?? 'Updated';
            $db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
               ->execute([$rep['reported_by'], "Maintenance update for {$rep['facility_name']}: {$progress} (Status: {$label})", 'info']);
        }

        jsonResponse(true, 'Progress updated.');
    }

    // ── complete ───────────────────────────────────
    if ($action === 'complete') {
        $taskId = (int) ($body['task_id'] ?? 0);
        if (!$taskId) jsonResponse(false, 'task_id required.');

        $chk = $db->prepare('SELECT request_id FROM maintenancetasks WHERE task_id=? AND assigned_to=? LIMIT 1');
        $chk->execute([$taskId, $userId]);
        $row = $chk->fetch();
        if (!$row) jsonResponse(false, 'Task not found or not assigned to you.');

        // Mark task complete
        $db->prepare('UPDATE maintenancetasks SET completed=1, progress=COALESCE(NULLIF(progress,""),"Task completed") WHERE task_id=?')
           ->execute([$taskId]);

        // Mark request completed (status_id=3)
        $db->prepare('UPDATE maintenancerequests SET status_id=3 WHERE request_id=?')
           ->execute([$row['request_id']]);

        // Notify reporter
        $rep = $db->prepare('
            SELECT mr.reported_by, f.facility_name
            FROM   maintenancerequests mr
            JOIN   facilities f ON mr.facility_id=f.facility_id
            WHERE  mr.request_id=? LIMIT 1
        ');
        $rep->execute([$row['request_id']]);
        $r = $rep->fetch();
        if ($r) {
            $db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
               ->execute([$r['reported_by'], "✅ Your maintenance request for {$r['facility_name']} has been completed!", 'success']);
        }

        jsonResponse(true, 'Task marked as completed.');
    }

    jsonResponse(false, 'Unknown action.');
}

jsonResponse(false, 'Method not allowed.');
