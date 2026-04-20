<?php
// ═══════════════════════════════════════════════
//  YAGUMS — setup.php
//
//  Run this ONCE after importing the database:
//    http://localhost/yagums/setup.php
//
//  This script:
//   1. Creates the uploads/avatars/ folder
//   2. Generates a new 10-digit numeric backup code
//      for the Super Admin (user_id = 1)
//   3. Stores the bcrypt hash in the database
//   4. Displays the plain code ONCE — copy it and
//      store it somewhere safe. It will NOT be shown again.
//
//  DELETE or rename this file after running it.
// ═══════════════════════════════════════════════

require_once __DIR__ . '/config.php';

// ── 1. Create upload folder ───────────────────────
$avatarDir = __DIR__ . '/uploads/avatars/';
if (!is_dir($avatarDir)) {
    if (mkdir($avatarDir, 0755, true)) {
        echo "✅ Created folder: uploads/avatars/<br>";
    } else {
        echo "❌ Could not create uploads/avatars/ — check permissions<br>";
    }
} else {
    echo "✅ uploads/avatars/ already exists<br>";
}

// Write .htaccess to prevent direct PHP execution in uploads folder
$htaccess = __DIR__ . '/uploads/.htaccess';
if (!file_exists($htaccess)) {
    file_put_contents($htaccess, "php_flag engine off\n");
    echo "✅ Created uploads/.htaccess (PHP execution blocked in uploads)<br>";
}

// ── 2. Generate 10-digit numeric backup code ─────
function generateNumericCode(int $length = 10): string {
    $code = '';
    for ($i = 0; $i < $length; $i++) {
        $code .= random_int(0, 9);
    }
    return $code;
}

$db = getDB();

// Check super admin exists
$check = $db->prepare('SELECT user_id, first_name, last_name, email FROM users WHERE user_id = 1 AND is_protected = 1 LIMIT 1');
$check->execute();
$admin = $check->fetch();

if (!$admin) {
    echo "❌ Super Admin (user_id=1, is_protected=1) not found. Import yagums_final.sql first.<br>";
    exit;
}

$plainCode   = generateNumericCode(10);
$hashedCode  = password_hash($plainCode, PASSWORD_BCRYPT);

$db->prepare('UPDATE users SET backup_code = ? WHERE user_id = 1')
   ->execute([$hashedCode]);

// ── 3. Display ────────────────────────────────────
echo "<br>";
echo "<div style='font-family:monospace;background:#1a1a2e;color:#e8e6ff;padding:24px;border-radius:12px;max-width:560px;border:2px solid #7c3aed;'>";
echo "<h2 style='color:#c084fc;margin:0 0 16px;font-size:18px;'>⚙️ YAGUMS Setup Complete</h2>";
echo "<p style='color:#7b7a9d;margin:0 0 8px;font-size:13px;'>Super Admin account:</p>";
echo "<p style='margin:0 0 4px;'><strong>Name:</strong> {$admin['first_name']} {$admin['last_name']}</p>";
echo "<p style='margin:0 0 16px;'><strong>Email:</strong> {$admin['email']}</p>";
echo "<p style='color:#7b7a9d;margin:0 0 8px;font-size:13px;'>Your 10-digit backup recovery code:</p>";
echo "<div style='background:#252540;border:1px solid #7c3aed;border-radius:8px;padding:14px 18px;letter-spacing:.25em;font-size:22px;font-weight:bold;color:#9d5bff;margin-bottom:16px;text-align:center;'>{$plainCode}</div>";
echo "<p style='color:#f87171;font-size:12px;margin:0;'>⚠️ This code will NOT be shown again. Write it down and store it securely.</p>";
echo "<p style='color:#7b7a9d;font-size:12px;margin-top:8px;'>Use this code as your \"current password\" when changing the Super Admin password if you forget it.</p>";
echo "</div><br>";
echo "<p style='color:#f87171;font-family:monospace;'>🗑️ DELETE or rename setup.php now that you have copied the backup code.</p>";
