<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/users.php  (Admin only)
//  GET  → list all users + roles
//  POST action=create        → new user, auto 6-char password
//  POST action=update        → edit user
//  POST action=reset_password→ new 6-char password
//  POST action=delete        → soft-deactivate (is_active=0)
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();

if (getUserRole($db, $userId) !== 'Admin') {
    jsonResponse(false, 'Admin access required.');
}

function genPw(): string {
    $c = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789';
    $p = '';
    for ($i=0;$i<6;$i++) $p .= $c[random_int(0,strlen($c)-1)];
    return $p;
}

function logAct(PDO $db, int $adminId, string $action, string $tt, int $tid, string $desc): void {
    try {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? null;
        $db->prepare('INSERT INTO admin_logs (admin_id,action,target_type,target_id,description,ip_address) VALUES (?,?,?,?,?,?)')->execute([$adminId,$action,$tt,$tid,$desc,$ip]);
    } catch (Exception $e) {}
}

// ── GET ────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $db->prepare('
        SELECT u.user_id,u.first_name,u.last_name,u.email,u.phone_number,
               u.is_active,u.is_protected,u.created_at,
               r.role_id,r.role_name
        FROM   users u LEFT JOIN roles r ON u.role_id=r.role_id
        ORDER  BY u.role_id ASC, u.user_id ASC
    ');
    $stmt->execute();
    $users = $stmt->fetchAll();
    foreach ($users as &$u) {
        $u['user_id']=(int)$u['user_id']; $u['role_id']=(int)$u['role_id'];
        $u['is_active']=(bool)$u['is_active']; $u['is_protected']=(bool)$u['is_protected'];
        $u['created_at']=date('j M Y',strtotime($u['created_at']));
    }
    $roles=$db->query('SELECT role_id,role_name FROM roles ORDER BY role_id')->fetchAll();
    jsonResponse(true,'Users loaded.',['users'=>$users,'roles'=>$roles]);
}

// ── POST ───────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body=json_decode(file_get_contents('php://input'),true)??[];
    $act=trim($body['action']??'');

    if ($act==='create') {
        $fn=trim($body['first_name']??''); $ln=trim($body['last_name']??'');
        $email=trim($body['email']??''); $phone=trim($body['phone_number']??'');
        $roleId=(int)($body['role_id']??5);
        if(!$fn||!$ln||!$email) jsonResponse(false,'First name, last name and email required.');
        if(!filter_var($email,FILTER_VALIDATE_EMAIL)) jsonResponse(false,'Invalid email format.');
        $c=$db->prepare('SELECT user_id FROM users WHERE email=? LIMIT 1'); $c->execute([$email]);
        if($c->fetch()) jsonResponse(false,'Email already exists.');
        $plain=genPw(); $hash=password_hash($plain,PASSWORD_BCRYPT);
        $db->prepare('INSERT INTO users(first_name,last_name,email,phone_number,password,role_id)VALUES(?,?,?,?,?,?)')->execute([$fn,$ln,$email,$phone?:null,$hash,$roleId]);
        $nid=(int)$db->lastInsertId();
        $db->prepare("INSERT INTO notifications(user_id,message,type,is_read)VALUES(?,?,?,0)")->execute([$nid,'Welcome to YAGUMS! Your account has been created by the administrator.','success']);
        logAct($db,$userId,'CREATE','user',$nid,"Created: {$fn} {$ln} ({$email})");
        jsonResponse(true,'User created.',['user_id'=>$nid,'plain_password'=>$plain]);
    }

    if ($act==='update') {
        $tid=(int)($body['user_id']??0); $fn=trim($body['first_name']??''); $ln=trim($body['last_name']??'');
        $email=trim($body['email']??''); $phone=trim($body['phone_number']??'');
        $roleId=(int)($body['role_id']??5); $isActive=isset($body['is_active'])?(int)$body['is_active']:1;
        if(!$tid||!$fn||!$ln||!$email) jsonResponse(false,'User ID, name and email required.');
        if(!filter_var($email,FILTER_VALIDATE_EMAIL)) jsonResponse(false,'Invalid email.');
        $p=$db->prepare('SELECT is_protected FROM users WHERE user_id=? LIMIT 1'); $p->execute([$tid]); $prow=$p->fetch();
        if(!$prow) jsonResponse(false,'User not found.');
        if($prow['is_protected']&&!$isActive) jsonResponse(false,'Protected account cannot be deactivated.');
        $d=$db->prepare('SELECT user_id FROM users WHERE email=? AND user_id!=? LIMIT 1'); $d->execute([$email,$tid]);
        if($d->fetch()) jsonResponse(false,'Email already used by another account.');
        $db->prepare('UPDATE users SET first_name=?,last_name=?,email=?,phone_number=?,role_id=?,is_active=? WHERE user_id=?')->execute([$fn,$ln,$email,$phone?:null,$roleId,$isActive,$tid]);
        logAct($db,$userId,'UPDATE','user',$tid,"Updated: {$fn} {$ln} (#{$tid})");
        jsonResponse(true,'User updated.');
    }

    if ($act==='reset_password') {
        $tid=(int)($body['user_id']??0);
        if(!$tid) jsonResponse(false,'User ID required.');
        $plain=genPw(); $hash=password_hash($plain,PASSWORD_BCRYPT);
        $db->prepare('UPDATE users SET password=? WHERE user_id=?')->execute([$hash,$tid]);
        $db->prepare("INSERT INTO notifications(user_id,message,type,is_read)VALUES(?,?,?,0)")->execute([$tid,'Your password was reset by an administrator. Please log in with your new password.','warning']);
        logAct($db,$userId,'UPDATE','user',$tid,"Reset password for user #{$tid}");
        jsonResponse(true,'Password reset.',['plain_password'=>$plain]);
    }

    if ($act==='hard_delete') {
        $tid=(int)($body['user_id']??0);
        if(!$tid) jsonResponse(false,'User ID required.');
        if($tid===$userId) jsonResponse(false,'Cannot delete your own account.');
        $p=$db->prepare('SELECT is_protected,first_name,last_name,role_id FROM users WHERE user_id=? LIMIT 1');
        $p->execute([$tid]); $row=$p->fetch();
        if(!$row) jsonResponse(false,'User not found.');
        if($row['is_protected']) jsonResponse(false,'The Super Admin account is protected and cannot be deleted.');
        // Only Super Admin (is_protected=1) can delete other Admin accounts
        $adminCheck=$db->prepare('SELECT is_protected FROM users WHERE user_id=? LIMIT 1');
        $adminCheck->execute([$userId]); $adminRow=$adminCheck->fetch();
        $isSuperAdmin = $adminRow && (bool)$adminRow['is_protected'];
        if(!$isSuperAdmin && (int)$row['role_id']===1) {
            jsonResponse(false,'Only the Super Admin can permanently delete Admin accounts.');
        }
        $name=$row['first_name'].' '.$row['last_name'];
        // FK CASCADE will remove bookings, notifications, votes, etc.
        $db->prepare('DELETE FROM users WHERE user_id=?')->execute([$tid]);
        logAct($db,$userId,'DELETE','user',$tid,"Permanently deleted: {$name} (#{$tid})");
        jsonResponse(true,'User permanently deleted.');
    }

    if ($act==='delete') {
        $tid=(int)($body['user_id']??0);
        if(!$tid) jsonResponse(false,'User ID required.');
        if($tid===$userId) jsonResponse(false,'Cannot deactivate your own account.');
        $p=$db->prepare('SELECT is_protected,first_name,last_name FROM users WHERE user_id=? LIMIT 1'); $p->execute([$tid]); $row=$p->fetch();
        if(!$row) jsonResponse(false,'User not found.');
        if($row['is_protected']) jsonResponse(false,'This account is protected and cannot be deleted.');
        $db->prepare('UPDATE users SET is_active=0 WHERE user_id=?')->execute([$tid]);
        $name=$row['first_name'].' '.$row['last_name'];
        logAct($db,$userId,'DELETE','user',$tid,"Deactivated: {$name} (#{$tid})");
        jsonResponse(true,"User deactivated.");
    }

    jsonResponse(false,'Unknown action.');
}
jsonResponse(false,'Method not allowed.');
