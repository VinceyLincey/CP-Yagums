<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/admin_log.php
//
//  GET  → returns recent admin log entries
//  POST → appends a new log entry
//
//  POST body: { action, description, target_type?, target_id? }
//  Actions: LOGIN | LOGOUT | CREATE | UPDATE | DELETE |
//           APPROVE | REJECT | ANNOUNCE | ASSIGN | VIEW
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

// ── POST via navigator.sendBeacon sends body differently ─
// sendBeacon sends as text/plain, so we try both
$rawBody = file_get_contents('php://input');
$body    = json_decode($rawBody, true) ?? [];

// Allow token from body (used by sendBeacon on logout)
$token = '';
$headers = function_exists('getallheaders') ? getallheaders() : [];
if (!empty($headers['Authorization'])) {
    $token = str_replace('Bearer ', '', $headers['Authorization']);
} elseif (!empty($_COOKIE['yagums_token'])) {
    $token = $_COOKIE['yagums_token'];
} elseif (!empty($body['token'])) {
    $token = $body['token']; // sendBeacon fallback
}

$payload = validateToken($token);
if (!$payload) {
    jsonResponse(false, 'Unauthorised.');
}
$userId = (int) $payload['user_id'];
$db     = getDB();

// ── Verify admin/manager role ─────────────────────
$roleStmt = $db->prepare('SELECT r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE u.user_id=?');
$roleStmt->execute([$userId]);
$roleRow = $roleStmt->fetch();
$role    = $roleRow['role_name'] ?? '';
$allowed = ['Facility Manager','System Admin'];

// ── GET — return log entries ──────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!in_array($role, $allowed)) jsonResponse(false, 'Access denied.');

    $stmt = $db->prepare('
        SELECT l.log_id, l.action, l.target_type, l.target_id,
               l.description, l.ip_address, l.created_at,
               CONCAT(u.first_name," ",u.last_name) AS admin_name
        FROM   admin_logs l
        JOIN   users u ON l.admin_id = u.user_id
        ORDER  BY l.created_at DESC
        LIMIT  50
    ');
    $stmt->execute();
    $logs = $stmt->fetchAll();

    foreach ($logs as &$log) {
        $log['created_at'] = date('j M Y, g:ia', strtotime($log['created_at']));
    }

    jsonResponse(true, 'Logs loaded.', ['logs' => $logs]);
}

// ── POST — insert new log entry ────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action      = strtoupper(trim($body['action']      ?? 'UPDATE'));
    $description = trim($body['description'] ?? '');
    $targetType  = trim($body['target_type'] ?? '') ?: null;
    $targetId    = isset($body['target_id']) ? (int)$body['target_id'] : null;

    $validActions = ['LOGIN','LOGOUT','CREATE','UPDATE','DELETE','APPROVE','REJECT','ANNOUNCE','ASSIGN','VIEW'];
    if (!in_array($action, $validActions)) $action = 'UPDATE';
    if (empty($description)) $description = 'Admin performed action: ' . $action;

    // Capture IP
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null;

    $db->prepare('
        INSERT INTO admin_logs (admin_id, action, target_type, target_id, description, ip_address)
        VALUES (?, ?, ?, ?, ?, ?)
    ')->execute([$userId, $action, $targetType, $targetId, $description, $ip]);

    jsonResponse(true, 'Log entry recorded.');
}

jsonResponse(false, 'Method not allowed.');
