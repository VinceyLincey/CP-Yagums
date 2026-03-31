<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/register.php
//  POST { first_name, last_name, email, phone_number, password }
//  Always registers as Student (role_id = 5)
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(false, 'Method not allowed.');

$body      = json_decode(file_get_contents('php://input'), true) ?? [];
$firstName = trim($body['first_name']   ?? '');
$lastName  = trim($body['last_name']    ?? '');
$email     = trim($body['email']        ?? '');
$phone     = trim($body['phone_number'] ?? '');
$password  =      $body['password']     ?? '';

$errors = [];
if (empty($firstName))                               $errors[] = 'First name is required.';
if (empty($lastName))                                $errors[] = 'Last name is required.';
if (empty($email))                                   $errors[] = 'Email is required.';
elseif (!filter_var($email, FILTER_VALIDATE_EMAIL))  $errors[] = 'Invalid email format.';
if (strlen($password) < 6)                           $errors[] = 'Password must be at least 6 characters.';
if ($errors) jsonResponse(false, implode(' ', $errors));

$db = getDB();

// Duplicate email check
$chk = $db->prepare('SELECT user_id FROM users WHERE email = ? LIMIT 1');
$chk->execute([$email]);
if ($chk->fetch()) jsonResponse(false, 'An account with this email already exists.');

// Get Student role_id dynamically (should be 5 but fetched from DB to be safe)
$r = $db->prepare("SELECT role_id FROM roles WHERE role_name = 'Student' LIMIT 1");
$r->execute();
$roleRow = $r->fetch();
$roleId  = $roleRow ? (int)$roleRow['role_id'] : 5;

// Insert user — new accounts start with 0 bookings, no profile picture
$db->prepare('INSERT INTO users (first_name,last_name,email,phone_number,password,role_id) VALUES (?,?,?,?,?,?)')
   ->execute([$firstName, $lastName, $email, $phone ?: null, password_hash($password, PASSWORD_BCRYPT), $roleId]);
$userId = (int) $db->lastInsertId();

// Welcome notification
$db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
   ->execute([$userId, 'Welcome to YAGUMS! Your account has been created.', 'success']);

$token = generateToken($userId);

jsonResponse(true, 'Account created successfully.', [
    'token'     => $token,
    'dashboard' => 'dashboard-student.html',
    'user'      => [
        'user_id'         => $userId,
        'first_name'      => $firstName,
        'last_name'       => $lastName,
        'name'            => trim($firstName.' '.$lastName),
        'email'           => $email,
        'phone_number'    => $phone,
        'role'            => 'Student',
        'role_id'         => $roleId,
        'profile_picture' => null,
        'is_protected'    => false,
    ],
]);
