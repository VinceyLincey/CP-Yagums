<?php
// ═══════════════════════════════════════════════
//  YAGUMS — config.php  (project root)
//
//  ROLE IDs (fixed — do not change):
//   1 = Admin
//   2 = Facility Manager
//   3 = Maintenance Staff
//   4 = Lecturer
//   5 = Student
// ═══════════════════════════════════════════════

define('DB_HOST',    'localhost');
define('DB_NAME',    'yagums');
define('DB_USER',    'root');
define('DB_PASS',    '');
define('DB_CHARSET', 'utf8mb4');

define('SESSION_LIFETIME', 86400);
define('TOKEN_SECRET',     'yagums_jwt_secret_v3_2026_changeme');

define('ADMIN_ROLES',    ['Admin']);                          // only super admin logs to admin_logs
define('ANNOUNCE_ROLES', ['Admin', 'Facility Manager']);      // both can post announcements
define('MANAGER_ROLES',  ['Admin', 'Facility Manager']);      // both can approve bookings

// Avatar upload settings
define('AVATAR_DIR',      __DIR__ . '/uploads/avatars/');
define('AVATAR_URL_BASE', 'uploads/avatars/');
define('AVATAR_MAX_BYTES', 2 * 1024 * 1024);
define('AVATAR_ALLOWED',  ['image/jpeg','image/png','image/webp','image/gif']);

// ── PDO connection ───────────────────────────────
function getDB(): PDO {
    static $pdo = null;
    if ($pdo !== null) return $pdo;
    $dsn = sprintf('mysql:host=%s;dbname=%s;charset=%s', DB_HOST, DB_NAME, DB_CHARSET);
    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode(['success'=>false,'message'=>'DB connection failed: '.$e->getMessage(),'hint'=>'Edit config.php credentials']);
        exit;
    }
    return $pdo;
}

function jsonResponse(bool $success, string $message, array $data = []): void {
    header('Content-Type: application/json');
    echo json_encode(array_merge(['success'=>$success,'message'=>$message], $data));
    exit;
}

function generateToken(int $userId): string {
    $payload = base64_encode(json_encode(['user_id'=>$userId,'issued'=>time(),'expires'=>time()+SESSION_LIFETIME,'rand'=>bin2hex(random_bytes(8))]));
    return $payload . '.' . hash_hmac('sha256', $payload, TOKEN_SECRET);
}

function validateToken(string $token): array|false {
    $parts = explode('.', $token, 2);
    if (count($parts) !== 2) return false;
    [$payload, $sig] = $parts;
    if (!hash_equals(hash_hmac('sha256', $payload, TOKEN_SECRET), $sig)) return false;
    $data = json_decode(base64_decode($payload), true);
    if (!$data || $data['expires'] < time()) return false;
    return $data;
}

function requireAuth(): array {
    $token = '';
    $headers = function_exists('getallheaders') ? getallheaders() : [];
    if (!empty($headers['Authorization'])) $token = str_replace('Bearer ', '', trim($headers['Authorization']));
    if (empty($token) && !empty($_COOKIE['yagums_token'])) $token = $_COOKIE['yagums_token'];
    $payload = validateToken($token);
    if (!$payload) jsonResponse(false, 'Unauthorised — please log in again.', ['redirect'=>'../login.html']);
    return $payload;
}

function getUserRole(PDO $db, int $userId): string {
    $s = $db->prepare('SELECT r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE u.user_id=? LIMIT 1');
    $s->execute([$userId]);
    return $s->fetch()['role_name'] ?? '';
}

function buildUserPayload(array $u): array {
    $pic = $u['profile_picture'] ?? null;
    return [
        'user_id'         => (int)  $u['user_id'],
        'first_name'      =>        $u['first_name'],
        'last_name'       =>        $u['last_name'],
        'name'            => trim(  $u['first_name'].' '.$u['last_name']),
        'email'           =>        $u['email'],
        'phone_number'    =>        $u['phone_number'] ?? '',
        'role'            =>        $u['role_name']    ?? ($u['role'] ?? ''),
        'role_id'         => (int) ($u['role_id']      ?? 0),
        'profile_picture' => $pic  ? AVATAR_URL_BASE.$pic : null,
        'is_protected'    => (bool)($u['is_protected'] ?? false),
    ];
}

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }
