<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/profile.php
//
//  GET  → load own profile
//  POST → update profile (two modes via "action")
//
//    action = "info"     → update first_name, last_name, email, phone_number
//                          NO password required
//    action = "password" → change password only
//                          requires current_password + new_password + confirm_password
// ═══════════════════════════════════════════════

require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();

// ── GET — return profile ──────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $db->prepare('
        SELECT u.user_id, u.first_name, u.last_name,
               u.email, u.phone_number, r.role_name
        FROM   users u
        JOIN   roles r ON u.role_id = r.role_id
        WHERE  u.user_id = ?
    ');
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    if (!$user) jsonResponse(false, 'User not found.');

    jsonResponse(true, 'Profile loaded.', [
        'user' => buildUser($user)
    ]);
}

// ── POST — update ─────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body   = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = trim($body['action'] ?? 'info');

    // ── ACTION: update info (no password needed) ──
    if ($action === 'info') {
        $firstName = trim($body['first_name']   ?? '');
        $lastName  = trim($body['last_name']    ?? '');
        $email     = trim($body['email']        ?? '');
        $phone     = trim($body['phone_number'] ?? '');

        // Validate
        if (empty($firstName))   jsonResponse(false, 'First name is required.');
        if (empty($lastName))    jsonResponse(false, 'Last name is required.');
        if (empty($email))       jsonResponse(false, 'Email is required.');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) jsonResponse(false, 'Invalid email format.');

        // Check email not taken by another user
        $chk = $db->prepare('SELECT user_id FROM users WHERE email = ? AND user_id != ? LIMIT 1');
        $chk->execute([$email, $userId]);
        if ($chk->fetch()) {
            jsonResponse(false, 'That email is already used by another account.');
        }

        $db->prepare('
            UPDATE users
            SET first_name = ?, last_name = ?, email = ?, phone_number = ?
            WHERE user_id = ?
        ')->execute([$firstName, $lastName, $email, $phone ?: null, $userId]);

        // Notification
        $db->prepare('INSERT INTO notifications (user_id, message, is_read) VALUES (?,?,0)')
           ->execute([$userId, 'Your profile information was updated successfully.']);

        $updated = fetchUser($db, $userId);
        jsonResponse(true, 'Profile updated successfully.', [
            'token' => generateToken($userId),
            'user'  => buildUser($updated),
        ]);
    }

    // ── ACTION: change password ──────────────────
    if ($action === 'password') {
        $currPass = $body['current_password']  ?? '';
        $newPass  = $body['new_password']      ?? '';
        $confPass = $body['confirm_password']  ?? '';

        if (empty($currPass))   jsonResponse(false, 'Current password is required.');
        if (empty($newPass))    jsonResponse(false, 'New password is required.');
        if (empty($confPass))   jsonResponse(false, 'Please confirm your new password.');
        if ($newPass !== $confPass) jsonResponse(false, 'New passwords do not match.');
        if (strlen($newPass) < 6)   jsonResponse(false, 'New password must be at least 6 characters.');

        // Verify current password (supports bcrypt + plain-text legacy)
        $row = $db->prepare('SELECT password FROM users WHERE user_id = ?');
        $row->execute([$userId]);
        $cur = $row->fetch();
        $valid = password_verify($currPass, $cur['password']) || ($cur['password'] === $currPass);
        if (!$valid) jsonResponse(false, 'Current password is incorrect.');

        $db->prepare('UPDATE users SET password = ? WHERE user_id = ?')
           ->execute([password_hash($newPass, PASSWORD_BCRYPT), $userId]);

        $db->prepare('INSERT INTO notifications (user_id, message, is_read) VALUES (?,?,0)')
           ->execute([$userId, 'Your password was changed successfully.']);

        $updated = fetchUser($db, $userId);
        jsonResponse(true, 'Password changed successfully.', [
            'token' => generateToken($userId),
            'user'  => buildUser($updated),
        ]);
    }

    jsonResponse(false, 'Unknown action. Use "info" or "password".');
}

jsonResponse(false, 'Method not allowed.');

// ── Helpers ───────────────────────────────────────
function fetchUser(PDO $db, int $id): array {
    $s = $db->prepare('
        SELECT u.user_id, u.first_name, u.last_name,
               u.email, u.phone_number, r.role_name
        FROM   users u JOIN roles r ON u.role_id = r.role_id
        WHERE  u.user_id = ?
    ');
    $s->execute([$id]);
    return $s->fetch();
}

function buildUser(array $u): array {
    return [
        'user_id'      => (int) $u['user_id'],
        'first_name'   => $u['first_name'],
        'last_name'    => $u['last_name'],
        'name'         => trim($u['first_name'] . ' ' . $u['last_name']),
        'email'        => $u['email'],
        'phone_number' => $u['phone_number'] ?? '',
        'role'         => $u['role_name'],
    ];
}
