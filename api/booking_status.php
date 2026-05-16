<?php
// ═══════════════════════════════════════════════
//  YAGUMS — api/booking_status.php
//  POST { booking_id, status_id }
//  Admin / Facility Manager only
// ═══════════════════════════════════════════════
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

$payload = requireAuth();
$userId  = (int) $payload['user_id'];
$db      = getDB();
$role    = getUserRole($db, $userId);

if (!in_array($role, ['Admin', 'Facility Manager'])) {
    jsonResponse(false, 'Access denied. Only Admins and Facility Managers can update booking status.');
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') jsonResponse(false, 'Method not allowed.');

$body      = json_decode(file_get_contents('php://input'), true) ?? [];
$bookingId = (int) ($body['booking_id'] ?? 0);
$statusId  = (int) ($body['status_id']  ?? 0);

if (!$bookingId) jsonResponse(false, 'Booking ID is required.');
if (!in_array($statusId, [1,2,3,4])) jsonResponse(false, 'Invalid status ID. Use 1=Pending, 2=Approved, 3=Rejected, 4=Cancelled.');

// Fetch booking + user
$stmt = $db->prepare('
    SELECT b.booking_id, b.user_id, b.status_id,
           f.facility_name, b.booking_date,
           CONCAT(u.first_name," ",u.last_name) AS user_name,
           bs.status_name
    FROM   bookings b
    JOIN   facilities f    ON b.facility_id = f.facility_id
    JOIN   users u         ON b.user_id     = u.user_id
    JOIN   bookingstatus bs ON bs.status_id  = b.status_id
    WHERE  b.booking_id = ?
    LIMIT  1
');
$stmt->execute([$bookingId]);
$booking = $stmt->fetch();
if (!$booking) jsonResponse(false, 'Booking not found.');

// Update status
$db->prepare('UPDATE bookings SET status_id=?, updated_at=NOW() WHERE booking_id=?')
   ->execute([$statusId, $bookingId]);

// Notify the booking owner
$statusLabels = [1=>'is now Pending', 2=>'has been Approved ✅', 3=>'has been Rejected ❌', 4=>'has been Cancelled'];
$statusTypes  = [1=>'info', 2=>'success', 3=>'warning', 4=>'info'];
$msg  = "Your booking for {$booking['facility_name']} on {$booking['booking_date']} {$statusLabels[$statusId]}.";
$type = $statusTypes[$statusId] ?? 'info';

$db->prepare("INSERT INTO notifications (user_id,message,type,is_read) VALUES (?,?,?,0)")
   ->execute([$booking['user_id'], $msg, $type]);

jsonResponse(true, "Booking #{$bookingId} status updated to {$statusLabels[$statusId]}.", [
    'booking_id' => $bookingId,
    'new_status_id' => $statusId,
]);
