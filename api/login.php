<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/login.php
//  POST  { email, password }
//  Returns { success, message, token, user, dashboard }
// ═══════════════════════════════════════════════

// config.php is one level UP from api/
require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonResponse(false, 'Method not allowed.');
}

// ── Read request body ────────────────────────────
$raw  = file_get_contents('php://input');
$body = json_decode($raw, true);

// Also accept regular POST form fields as fallback
$email    = trim($body['email']    ?? $_POST['email']    ?? '');
$password =      $body['password'] ?? $_POST['password'] ?? '';

if (empty($email) || empty($password)) {
    jsonResponse(false, 'Email and password are required.');
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    jsonResponse(false, 'Please enter a valid email address.');
}

// ── Fetch user from DB ───────────────────────────
$db   = getDB();
$stmt = $db->prepare('
    SELECT u.user_id,
           u.first_name,
           u.last_name,
           u.email,
           u.phone_number,
           u.password,
           r.role_name
    FROM   users u
    INNER JOIN roles r ON u.role_id = r.role_id
    WHERE  u.email = ?
    LIMIT  1
');
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user) {
    // Vague message on purpose (security)
    jsonResponse(false, 'Incorrect email or password.');
}

// ── Password check ────────────────────────────────
// Supports: bcrypt hash (password_hash) AND plain-text legacy passwords
$valid = password_verify($password, $user['password'])
      || $user['password'] === $password;   // plain-text fallback (dev data)

if (!$valid) {
    jsonResponse(false, 'Incorrect email or password.');
}

// ── Build response ────────────────────────────────
$routes = [
    'Student'           => 'dashboard-student.html',
    'Lecturer'          => 'dashboard-lecturer.html',
    'Facility Manager'  => 'dashboard-admin.html',
    'Maintenance Staff' => 'dashboard-maintenance.html',
    'System Admin'      => 'dashboard-admin.html',
];
$dashboard = $routes[$user['role_name']] ?? 'dashboard.html';
$token     = generateToken((int) $user['user_id']);

jsonResponse(true, 'Login successful.', [
    'token'     => $token,
    'dashboard' => $dashboard,
    'user'      => [
        'user_id'      => (int) $user['user_id'],
        'first_name'   => $user['first_name'],
        'last_name'    => $user['last_name'],
        'name'         => trim($user['first_name'] . ' ' . $user['last_name']),
        'email'        => $user['email'],
        'phone_number' => $user['phone_number'] ?? '',
        'role'         => $user['role_name'],
    ],
]);
