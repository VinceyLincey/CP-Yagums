<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/bookings.php
//
//  GET  → returns ONLY the logged-in user's bookings
//         (Admins/Facility Managers get all bookings)
//  POST → submit a new booking for the logged-in user
//
//  Privacy rule: users NEVER see other users' bookings.
//  A fresh account returns an empty array.
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();
$role    = getUserRole($db, $userId);

// Admin-level roles that can see all bookings
$adminRoles = ['Admin', 'Facility Manager'];

// ── GET ────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    if (in_array($role, $adminRoles)) {
        // Admins see everything
        $stmt = $db->prepare('
            SELECT b.booking_id, b.booking_date, b.start_time, b.end_time,
                   b.purpose, b.created_at,
                   f.facility_name, f.location,
                   bs.status_name,
                   CONCAT(u.first_name," ",u.last_name) AS user_name,
                   u.email AS user_email
            FROM   bookings b
            JOIN   facilities f   ON b.facility_id = f.facility_id
            JOIN   bookingstatus bs ON b.status_id  = bs.status_id
            JOIN   users u        ON b.user_id      = u.user_id
            ORDER  BY b.created_at DESC
            LIMIT  50
        ');
        $stmt->execute();
    } else {
        // Regular users — ONLY their own bookings, no other user data leaked
        $stmt = $db->prepare('
            SELECT b.booking_id, b.booking_date, b.start_time, b.end_time,
                   b.purpose, b.created_at,
                   f.facility_name, f.location,
                   bs.status_name
            FROM   bookings b
            JOIN   facilities f    ON b.facility_id = f.facility_id
            JOIN   bookingstatus bs ON b.status_id  = bs.status_id
            WHERE  b.user_id = ?
            ORDER  BY b.created_at DESC
            LIMIT  20
        ');
        $stmt->execute([$userId]);
    }

    $bookings = $stmt->fetchAll();

    // Format dates/times
    foreach ($bookings as &$b) {
        $b['booking_date'] = date('j M Y', strtotime($b['booking_date']));
        $b['start_time']   = date('g:ia',  strtotime($b['start_time']));
        $b['end_time']     = date('g:ia',  strtotime($b['end_time']));
        $b['created_at']   = date('j M Y', strtotime($b['created_at']));
    }

    // Count totals per status (for stats cards) — always scoped to this user
    $counts = $db->prepare('
        SELECT bs.status_name, COUNT(*) as cnt
        FROM   bookings b
        JOIN   bookingstatus bs ON b.status_id = bs.status_id
        WHERE  b.user_id = ?
        GROUP  BY bs.status_name
    ');
    $counts->execute([$userId]);
    $statusCounts = [];
    foreach ($counts->fetchAll() as $row) {
        $statusCounts[strtolower($row['status_name'])] = (int)$row['cnt'];
    }

    jsonResponse(true, 'Bookings loaded.', [
        'bookings' => $bookings,
        'counts'   => [
            'total'     => array_sum($statusCounts),
            'pending'   => $statusCounts['pending']   ?? 0,
            'approved'  => $statusCounts['approved']  ?? 0,
            'rejected'  => $statusCounts['rejected']  ?? 0,
            'cancelled' => $statusCounts['cancelled'] ?? 0,
        ],
    ]);
}

// ── POST ───────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body       = json_decode(file_get_contents('php://input'), true) ?? [];
    $facilityId = (int) ($body['facility_id'] ?? 0);
    $date       = trim($body['booking_date']  ?? '');
    $startTime  = trim($body['start_time']    ?? '');
    $endTime    = trim($body['end_time']      ?? '');
    $purpose    = trim($body['purpose']       ?? '');

    if (!$facilityId)  jsonResponse(false, 'Please select a facility.');
    if (empty($date))  jsonResponse(false, 'Please select a date.');
    if (empty($startTime) || empty($endTime)) jsonResponse(false, 'Start and end time are required.');
    if ($startTime >= $endTime) jsonResponse(false, 'End time must be after start time.');

    // Validate date not in past
    if (strtotime($date) < strtotime('today')) {
        jsonResponse(false, 'Booking date cannot be in the past.');
    }

    // Check facility exists and is available
    $fac = $db->prepare('SELECT facility_name, is_available FROM facilities WHERE facility_id=? LIMIT 1');
    $fac->execute([$facilityId]);
    $facility = $fac->fetch();
    if (!$facility) jsonResponse(false, 'Facility not found.');
    if (!$facility['is_available']) jsonResponse(false, $facility['facility_name'] . ' is currently unavailable for booking.');

    // Check for slot conflict
    $conflict = $db->prepare('
        SELECT booking_id FROM bookings
        WHERE  facility_id=? AND booking_date=?
        AND    status_id NOT IN (3,4)
        AND    start_time < ? AND end_time > ?
        LIMIT  1
    ');
    $conflict->execute([$facilityId, $date, $endTime, $startTime]);
    if ($conflict->fetch()) {
        jsonResponse(false, 'That time slot is already booked. Please choose a different time.');
    }

    // Insert — status_id=1 (Pending)
    $ins = $db->prepare('
        INSERT INTO bookings (user_id, facility_id, booking_date, start_time, end_time, purpose, status_id)
        VALUES (?, ?, ?, ?, ?, ?, 1)
    ');
    $ins->execute([$userId, $facilityId, $date, $startTime, $endTime, $purpose ?: null]);
    $bookingId = (int) $db->lastInsertId();

    // Notification to user
    $db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
       ->execute([$userId, "Your booking for {$facility['facility_name']} on {$date} is pending approval.", 'info']);

    jsonResponse(true, 'Booking submitted successfully! Awaiting approval.', [
        'booking_id' => $bookingId,
        'facility'   => $facility['facility_name'],
        'date'       => $date,
    ]);
}

jsonResponse(false, 'Method not allowed.');
