<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/reports.php  (Admin only)
//  GET ?type=summary|bookings|maintenance|users|facilities|announcements
//      &from=YYYY-MM-DD &to=YYYY-MM-DD
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();
$role    = getUserRole($db, $userId);

if (!in_array($role, ['Admin', 'Facility Manager'])) {
    jsonResponse(false, 'Access denied.');
}

if ($_SERVER['REQUEST_METHOD'] !== 'GET') jsonResponse(false, 'Method not allowed.');

$type = $_GET['type'] ?? 'summary';
$from = $_GET['from'] ?? '2000-01-01';
$to   = $_GET['to']   ?? '2099-12-31';

switch ($type) {

    // ── summary ───────────────────────────────────
    case 'summary': {
        $s = [];
        $s['total_users']           = (int)$db->query('SELECT COUNT(*) FROM users WHERE is_active=1')->fetchColumn();
        $s['total_bookings']        = (int)$db->query('SELECT COUNT(*) FROM bookings')->fetchColumn();
        $s['approved_bookings']     = (int)$db->query('SELECT COUNT(*) FROM bookings WHERE status_id=2')->fetchColumn();
        $s['pending_bookings']      = (int)$db->query('SELECT COUNT(*) FROM bookings WHERE status_id=1')->fetchColumn();
        $s['total_maintenance']     = (int)$db->query('SELECT COUNT(*) FROM maintenancerequests')->fetchColumn();
        $s['pending_maintenance']   = (int)$db->query('SELECT COUNT(*) FROM maintenancerequests WHERE status_id=1')->fetchColumn();
        $s['available_facilities']  = (int)$db->query('SELECT COUNT(*) FROM facilities WHERE is_available=1')->fetchColumn();
        $s['active_announcements']  = (int)$db->query('SELECT COUNT(*) FROM announcements WHERE is_active=1')->fetchColumn();
        jsonResponse(true,'Summary loaded.',['summary'=>$s]);
    }

    // ── bookings ──────────────────────────────────
    case 'bookings': {
        $stmt=$db->prepare('
            SELECT b.booking_id,b.booking_date,b.start_time,b.end_time,b.purpose,b.created_at,
                   f.facility_name,f.location,bs.status_name,
                   CONCAT(u.first_name," ",u.last_name) AS user_name,u.email AS user_email
            FROM   bookings b
            JOIN   facilities f    ON b.facility_id=f.facility_id
            JOIN   bookingstatus bs ON b.status_id=bs.status_id
            JOIN   users u         ON b.user_id=u.user_id
            WHERE  b.booking_date BETWEEN ? AND ?
            ORDER  BY b.booking_date DESC,b.created_at DESC
        ');
        $stmt->execute([$from,$to]);
        $rows=$stmt->fetchAll();
        foreach($rows as &$r){ $r['booking_date']=date('j M Y',strtotime($r['booking_date'])); $r['start_time']=date('g:ia',strtotime($r['start_time'])); $r['end_time']=date('g:ia',strtotime($r['end_time'])); $r['created_at']=date('j M Y',strtotime($r['created_at'])); }
        $stats=['total'=>count($rows),'approved'=>0,'pending'=>0,'rejected'=>0,'cancelled'=>0];
        foreach($rows as $r){ $k=strtolower($r['status_name']); if(isset($stats[$k])) $stats[$k]++; }
        jsonResponse(true,'Bookings report.',['bookings'=>$rows,'stats'=>$stats]);
    }

    // ── maintenance ───────────────────────────────
    case 'maintenance': {
        $stmt=$db->prepare('
            SELECT mr.request_id,mr.description,mr.priority,mr.created_at,
                   f.facility_name,
                   CONCAT(u.first_name," ",u.last_name) AS reported_by_name,
                   ms.status_name
            FROM   maintenancerequests mr
            JOIN   facilities f    ON mr.facility_id=f.facility_id
            JOIN   users u         ON mr.reported_by=u.user_id
            JOIN   maintenancestatus ms ON mr.status_id=ms.status_id
            WHERE  mr.created_at BETWEEN ? AND ?
            ORDER  BY mr.created_at DESC
        ');
        $stmt->execute([$from.' 00:00:00',$to.' 23:59:59']);
        $rows=$stmt->fetchAll();
        foreach($rows as &$r){ $r['created_at']=date('j M Y',strtotime($r['created_at'])); }
        jsonResponse(true,'Maintenance report.',['requests'=>$rows]);
    }

    // ── users ─────────────────────────────────────
    case 'users': {
        $stmt=$db->prepare('
            SELECT u.user_id,u.first_name,u.last_name,u.email,u.is_active,
                   u.created_at,r.role_name,
                   (SELECT COUNT(*) FROM bookings b WHERE b.user_id=u.user_id) AS booking_count
            FROM   users u
            LEFT JOIN roles r ON u.role_id=r.role_id
            ORDER  BY u.role_id, u.user_id
        ');
        $stmt->execute();
        $rows=$stmt->fetchAll();
        foreach($rows as &$r){ $r['user_id']=(int)$r['user_id']; $r['is_active']=(bool)$r['is_active']; $r['booking_count']=(int)$r['booking_count']; $r['created_at']=date('j M Y',strtotime($r['created_at'])); }
        jsonResponse(true,'Users report.',['users'=>$rows]);
    }

    // ── facilities ────────────────────────────────
    case 'facilities': {
        $stmt=$db->prepare('
            SELECT f.facility_id,f.facility_name,f.capacity,f.location,f.is_available,
                   ft.type_name,
                   (SELECT COUNT(*) FROM bookings b WHERE b.facility_id=f.facility_id) AS total_bookings,
                   (SELECT COUNT(*) FROM bookings b WHERE b.facility_id=f.facility_id AND b.status_id=2) AS approved_bookings,
                   (SELECT COUNT(*) FROM maintenancerequests mr WHERE mr.facility_id=f.facility_id AND mr.status_id!=3) AS open_maintenance
            FROM   facilities f
            LEFT JOIN facilitytypes ft ON f.type_id=ft.type_id
            ORDER  BY f.facility_id
        ');
        $stmt->execute();
        $rows=$stmt->fetchAll();
        foreach($rows as &$r){ $r['facility_id']=(int)$r['facility_id']; $r['capacity']=(int)$r['capacity']; $r['is_available']=(bool)$r['is_available']; $r['total_bookings']=(int)$r['total_bookings']; $r['approved_bookings']=(int)$r['approved_bookings']; $r['open_maintenance']=(int)$r['open_maintenance']; }
        jsonResponse(true,'Facilities report.',['facilities'=>$rows]);
    }

    // ── announcements ─────────────────────────────
    case 'announcements': {
        $stmt=$db->prepare('
            SELECT a.announcement_id,a.title,a.message,a.priority,
                   a.upvotes,a.downvotes,a.is_active,a.created_at,
                   CONCAT(u.first_name," ",u.last_name) AS posted_by_name
            FROM   announcements a
            JOIN   users u ON a.posted_by=u.user_id
            ORDER  BY a.created_at DESC
        ');
        $stmt->execute();
        $rows=$stmt->fetchAll();
        foreach($rows as &$r){ $r['announcement_id']=(int)$r['announcement_id']; $r['upvotes']=(int)$r['upvotes']; $r['downvotes']=(int)$r['downvotes']; $r['is_active']=(bool)$r['is_active']; $r['created_at']=date('j M Y, g:ia',strtotime($r['created_at'])); }
        jsonResponse(true,'Announcements report.',['announcements'=>$rows]);
    }

    default:
        jsonResponse(false,'Unknown report type.');
}
