<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/admin_log.php
//  GET  → return last 50 log entries (admin only)
//  POST → insert log entry (admin + sendBeacon logout)
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

// Token can come from header, cookie, or body (sendBeacon)
$rawBody = file_get_contents('php://input');
$body    = json_decode($rawBody, true) ?? [];

$token = '';
$headers = function_exists('getallheaders') ? getallheaders() : [];
if (!empty($headers['Authorization'])) $token = str_replace('Bearer ', '', trim($headers['Authorization']));
if (empty($token) && !empty($_COOKIE['yagums_token'])) $token = $_COOKIE['yagums_token'];
if (empty($token) && !empty($body['token'])) $token = $body['token'];

$payload = validateToken($token);
if (!$payload) jsonResponse(false, 'Unauthorised.');

$userId = (int) $payload['user_id'];
$db     = getDB();
$role   = getUserRole($db, $userId);

// ── GET ────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!in_array($role, ADMIN_ROLES)) jsonResponse(false, 'Access denied.');

    $stmt = $db->prepare('
        SELECT l.log_id, l.action, l.target_type, l.target_id,
               l.description, l.ip_address, l.created_at,
               CONCAT(u.first_name," ",u.last_name) AS admin_name,
               r.role_name AS admin_role
        FROM   admin_logs l
        JOIN   users u ON l.admin_id = u.user_id
        JOIN   roles r ON u.role_id  = r.role_id
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

// ── POST ───────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action      = strtoupper(trim($body['action'] ?? 'UPDATE'));
    $description = trim($body['description'] ?? '');
    $targetType  = trim($body['target_type'] ?? '') ?: null;
    $targetId    = isset($body['target_id']) ? (int)$body['target_id'] : null;

    $valid = ['LOGIN','LOGOUT','CREATE','UPDATE','DELETE','APPROVE','REJECT','ANNOUNCE','ASSIGN','VIEW'];
    if (!in_array($action, $valid)) $action = 'UPDATE';
    if (empty($description)) $description = $action . ' action performed';

    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null;
    $db->prepare('INSERT INTO admin_logs (admin_id,action,target_type,target_id,description,ip_address) VALUES (?,?,?,?,?,?)')
       ->execute([$userId, $action, $targetType, $targetId, $description, $ip]);

    jsonResponse(true, 'Log entry recorded.');
}

jsonResponse(false, 'Method not allowed.');
