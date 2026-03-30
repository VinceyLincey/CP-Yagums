<?php
// ═══════════════════════════════════════════════
//  YAGUMS — config.php
//
//  Place this file at the ROOT of your project:
//
//  htdocs/yagums/          ← your project root
//  ├── config.php          ← THIS FILE
//  ├── api/
//  │   ├── login.php
//  │   ├── register.php
//  │   └── profile.php
//  ├── login.html
//  └── ...
//
//  DATABASE: In phpMyAdmin, create a database
//  named "yagums" then import yagums.sql into it.
//  The DB_NAME below must match that database name.
// ═══════════════════════════════════════════════

// ── Database credentials ─────────────────────────
// These are the default XAMPP / WAMP settings.
// Change if your setup is different.
define('DB_HOST',    'localhost');
define('DB_NAME',    'yagums');      // Must match your phpMyAdmin database name
define('DB_USER',    'root');        // XAMPP default
define('DB_PASS',    '');            // XAMPP default is blank
define('DB_CHARSET', 'utf8mb4');

// ── Token config ─────────────────────────────────
define('SESSION_LIFETIME', 86400); // 24 hours
define('TOKEN_SECRET',     'yagums_super_secret_2026_changeme');

// ── PDO connection (singleton) ───────────────────
function getDB(): PDO {
    static $pdo = null;
    if ($pdo !== null) return $pdo;

    $dsn = sprintf(
        'mysql:host=%s;dbname=%s;charset=%s',
        DB_HOST, DB_NAME, DB_CHARSET
    );
    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        header('Content-Type: application/json');
        // Return a helpful message so the front-end can show it
        echo json_encode([
            'success' => false,
            'message' => 'DB connection failed: ' . $e->getMessage(),
            'hint'    => 'Check DB_HOST / DB_NAME / DB_USER / DB_PASS in config.php',
        ]);
        exit;
    }
    return $pdo;
}

// ── JSON response helper ─────────────────────────
function jsonResponse(bool $success, string $message, array $data = []): void {
    header('Content-Type: application/json');
    echo json_encode(array_merge(
        ['success' => $success, 'message' => $message],
        $data
    ));
    exit;
}

// ── Token: generate ──────────────────────────────
function generateToken(int $userId): string {
    $payload = base64_encode(json_encode([
        'user_id' => $userId,
        'issued'  => time(),
        'expires' => time() + SESSION_LIFETIME,
        'rand'    => bin2hex(random_bytes(8)),
    ]));
    $sig = hash_hmac('sha256', $payload, TOKEN_SECRET);
    return $payload . '.' . $sig;
}

// ── Token: validate ──────────────────────────────
function validateToken(string $token): array|false {
    $parts = explode('.', $token, 2);
    if (count($parts) !== 2) return false;
    [$payload, $sig] = $parts;
    if (!hash_equals(hash_hmac('sha256', $payload, TOKEN_SECRET), $sig)) return false;
    $data = json_decode(base64_decode($payload), true);
    if (!$data || $data['expires'] < time()) return false;
    return $data;
}

// ── Auth guard ────────────────────────────────────
function requireAuth(): array {
    $token = '';
    // 1. From Authorization header
    $headers = function_exists('getallheaders') ? getallheaders() : [];
    if (!empty($headers['Authorization'])) {
        $token = str_replace('Bearer ', '', $headers['Authorization']);
    }
    // 2. Fallback: cookie
    if (empty($token) && !empty($_COOKIE['yagums_token'])) {
        $token = $_COOKIE['yagums_token'];
    }
    $payload = validateToken($token);
    if (!$payload) {
        jsonResponse(false, 'Unauthorised — please log in again.', ['redirect' => '../login.html']);
    }
    return $payload;
}

// ── CORS (allows fetch() from same origin & local) ─
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
