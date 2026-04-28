<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/profile.php
//  GET              → own profile
//  POST action=info → update name/email/phone (no password)
//  POST action=password → change password (requires current)
//  POST action=avatar   → upload profile picture (multipart)
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();

// ── GET ────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $db->prepare('
        SELECT u.user_id,u.first_name,u.last_name,u.email,
               u.phone_number,u.profile_picture,u.is_protected,
               r.role_id, r.role_name
        FROM   users u JOIN roles r ON u.role_id=r.role_id
        WHERE  u.user_id=?
    ');
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    if (!$user) jsonResponse(false, 'User not found.');

    // Booking counts — user only sees their OWN bookings
    $bc = $db->prepare('SELECT COUNT(*) as total, SUM(status_id=2) as approved, SUM(status_id=1) as pending FROM bookings WHERE user_id=?');
    $bc->execute([$userId]);
    $bookingStats = $bc->fetch();

    // Unread notifications
    $nc = $db->prepare('SELECT COUNT(*) as cnt FROM notifications WHERE user_id=? AND is_read=0');
    $nc->execute([$userId]);
    $notifCount = (int)$nc->fetch()['cnt'];

    jsonResponse(true, 'Profile loaded.', [
        'user'   => buildUserPayload($user),
        'stats'  => [
            'total_bookings'    => (int)($bookingStats['total']    ?? 0),
            'approved_bookings' => (int)($bookingStats['approved'] ?? 0),
            'pending_bookings'  => (int)($bookingStats['pending']  ?? 0),
            'unread_notifs'     => $notifCount,
        ]
    ]);
}

// ── POST ───────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // ── Avatar upload (multipart/form-data) ─────────
    if (!empty($_FILES['avatar'])) {
        $file     = $_FILES['avatar'];
        $mimeType = mime_content_type($file['tmp_name']);

        if ($file['error'] !== UPLOAD_ERR_OK)          jsonResponse(false, 'Upload error. Try again.');
        if ($file['size'] > AVATAR_MAX_BYTES)           jsonResponse(false, 'Image too large. Max 2MB.');
        if (!in_array($mimeType, AVATAR_ALLOWED))       jsonResponse(false, 'Only JPEG, PNG, WebP and GIF are allowed.');

        // Create directory if needed
        if (!is_dir(AVATAR_DIR)) {
            if (!mkdir(AVATAR_DIR, 0755, true)) jsonResponse(false, 'Could not create upload directory. Check permissions.');
        }

        // Filename: {user_id}.{ext} — always overwrites old avatar
        $ext      = match($mimeType) { 'image/png'=>'png','image/webp'=>'webp','image/gif'=>'gif',default=>'jpg' };
        $filename = $userId . '.' . $ext;
        $dest     = AVATAR_DIR . $filename;

        // Remove any old avatar files for this user (different extensions)
        foreach (['jpg','jpeg','png','webp','gif'] as $e) {
            $old = AVATAR_DIR . $userId . '.' . $e;
            if (file_exists($old) && $old !== $dest) @unlink($old);
        }

        if (!move_uploaded_file($file['tmp_name'], $dest)) jsonResponse(false, 'Failed to save image. Check server permissions.');

        $db->prepare('UPDATE users SET profile_picture=? WHERE user_id=?')->execute([$filename, $userId]);
        jsonResponse(true, 'Profile picture updated.', [
            'profile_picture' => AVATAR_URL_BASE . $filename . '?v=' . time()
        ]);
    }

    // JSON body actions
    $body   = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = trim($body['action'] ?? 'info');

    // ── action=info (no password required) ──────────
    if ($action === 'info') {
        $fn    = trim($body['first_name']   ?? '');
        $ln    = trim($body['last_name']    ?? '');
        $email = trim($body['email']        ?? '');
        $phone = trim($body['phone_number'] ?? '');

        if (empty($fn))    jsonResponse(false, 'First name is required.');
        if (empty($ln))    jsonResponse(false, 'Last name is required.');
        if (empty($email)) jsonResponse(false, 'Email is required.');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) jsonResponse(false, 'Invalid email format.');

        // Check email not used by someone else
        $chk = $db->prepare('SELECT user_id FROM users WHERE email=? AND user_id!=? LIMIT 1');
        $chk->execute([$email, $userId]);
        if ($chk->fetch()) jsonResponse(false, 'That email is already in use by another account.');

        $db->prepare('UPDATE users SET first_name=?,last_name=?,email=?,phone_number=? WHERE user_id=?')
           ->execute([$fn, $ln, $email, $phone ?: null, $userId]);

        $db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
           ->execute([$userId, 'Your profile information was updated.', 'info']);

        $updated = fetchFullUser($db, $userId);
        jsonResponse(true, 'Profile updated.', ['token'=>generateToken($userId),'user'=>buildUserPayload($updated)]);
    }

    // ── action=password ──────────────────────────────
    if ($action === 'password') {
        $curr = $body['current_password']  ?? '';
        $new  = $body['new_password']      ?? '';
        $conf = $body['confirm_password']  ?? '';

        if (empty($curr)) jsonResponse(false, 'Current password is required.');
        if (empty($new))  jsonResponse(false, 'New password is required.');
        if ($new !== $conf) jsonResponse(false, 'New passwords do not match.');
        if (strlen($new) < 6) jsonResponse(false, 'New password must be at least 6 characters.');

        $row = $db->prepare('SELECT password, is_protected, backup_code FROM users WHERE user_id=?');
        $row->execute([$userId]);
        $cur = $row->fetch();

        // Support: bcrypt verify OR plain-text legacy OR backup code
        $valid = password_verify($curr, $cur['password'])
              || $cur['password'] === $curr
              || (!empty($cur['backup_code']) && (password_verify($curr, $cur['backup_code']) || $cur['backup_code'] === $curr));

        if (!$valid) jsonResponse(false, 'Current password is incorrect.');

        $db->prepare('UPDATE users SET password=? WHERE user_id=?')
           ->execute([password_hash($new, PASSWORD_BCRYPT), $userId]);

        $db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
           ->execute([$userId, 'Your password was changed successfully.', 'success']);

        $updated = fetchFullUser($db, $userId);
        jsonResponse(true, 'Password changed.', ['token'=>generateToken($userId),'user'=>buildUserPayload($updated)]);
    }

    jsonResponse(false, 'Unknown action. Use "info", "password", or upload an "avatar" file.');
}

jsonResponse(false, 'Method not allowed.');

function fetchFullUser(PDO $db, int $id): array {
    $s = $db->prepare('SELECT u.*,r.role_id,r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE u.user_id=?');
    $s->execute([$id]);
    return $s->fetch();
}
