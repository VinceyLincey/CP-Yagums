<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/login.php  (live DB, no demo)
//  POST { email, password }
//  → { success, token, user, dashboard }
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(false, 'Method not allowed.');

$body     = json_decode(file_get_contents('php://input'), true) ?? [];
$email    = trim($body['email']    ?? $_POST['email']    ?? '');
$password =      $body['password'] ?? $_POST['password'] ?? '';

if (empty($email) || empty($password)) jsonResponse(false, 'Email and password are required.');
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) jsonResponse(false, 'Invalid email address.');

$db   = getDB();
$stmt = $db->prepare('
    SELECT u.user_id, u.first_name, u.last_name, u.email,
           u.phone_number, u.password, u.profile_picture,
           u.is_active, u.is_protected,
           r.role_id, r.role_name
    FROM   users u
    JOIN   roles r ON u.role_id = r.role_id
    WHERE  u.email = ?
    LIMIT  1
');
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user)                            jsonResponse(false, 'Incorrect email or password.');
if (!($user['is_active'] ?? 1))        jsonResponse(false, 'This account has been deactivated. Contact your administrator.');

// Password check — bcrypt + plain-text legacy
if (!password_verify($password, $user['password']) && $user['password'] !== $password) {
    jsonResponse(false, 'Incorrect email or password.');
}

// Dashboard routing
$routes = [
    'Admin'             => 'dashboard-admin.html',
    'Facility Manager'  => 'dashboard-facility.html',
    'Maintenance Staff' => 'dashboard-maintenance.html',
    'Lecturer'          => 'dashboard-lecturer.html',
    'Student'           => 'dashboard-student.html',
];
$dashboard = $routes[$user['role_name']] ?? 'dashboard-student.html';
$token     = generateToken((int) $user['user_id']);

// Log login for admin roles
if (in_array($user['role_name'], ADMIN_ROLES)) {
    try {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null;
        $db->prepare('INSERT INTO admin_logs (admin_id,action,description,ip_address) VALUES (?,?,?,?)')
           ->execute([(int)$user['user_id'],'LOGIN',
               trim($user['first_name'].' '.$user['last_name']).' ('.$user['role_name'].') logged in', $ip]);
    } catch (Exception $e) { /* non-fatal */ }
}

jsonResponse(true, 'Login successful.', [
    'token'     => $token,
    'dashboard' => $dashboard,
    'user'      => buildUserPayload($user),
]);
