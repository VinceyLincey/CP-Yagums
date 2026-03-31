-- ═══════════════════════════════════════════════════════
--  YAGUMS — Final Database Schema (v3)
--
--  ROLE STRUCTURE (final, do not change IDs):
--   1 = Admin             (Super Admin — user_id 1 is undeletable)
--   2 = Facility Manager
--   3 = Maintenance Staff
--   4 = Lecturer
--   5 = Student
--
--  KEY CHANGES in v3:
--   • Role IDs corrected to match specification above
--   • users: added profile_picture, backup_code columns
--   • users: user_id=1 is Super Admin (protected)
--   • bookings: enforced per-user visibility via user_id
--   • announcements: added upvotes / downvotes columns
--   • NEW TABLE: announcement_votes (one vote per user per ann)
--   • notifications: added type + is_announcement columns
--   • NEW TABLE: admin_logs
--   • All foreign keys consistent throughout
-- ═══════════════════════════════════════════════════════

SET SQL_MODE   = "NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;
SET time_zone  = "+00:00";
SET NAMES utf8mb4;

-- ──────────────────────────────────────────────────────
--  ROLES  (IDs are fixed — never change these values)
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `role_id`     int         NOT NULL AUTO_INCREMENT,
  `role_name`   varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uq_role_name` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'Admin',             'Super Administrator — full system access, undeletable account'),
(2, 'Facility Manager',  'Approves bookings, manages facilities and announcements'),
(3, 'Maintenance Staff', 'Handles and resolves maintenance requests and tasks'),
(4, 'Lecturer',          'Books facilities, reports maintenance issues'),
(5, 'Student',           'Books facilities, views announcements');

-- ──────────────────────────────────────────────────────
--  USERS
--   • user_id = 1 → Super Admin (PROTECTED — never delete)
--   • profile_picture → relative path: uploads/avatars/{user_id}.jpg
--   • backup_code → 10-digit numeric emergency recovery code (hashed)
--   • backup_code_plain → stored ONCE at creation for display, then cleared
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id`          int          NOT NULL AUTO_INCREMENT,
  `first_name`       varchar(50)  NOT NULL,
  `last_name`        varchar(50)  NOT NULL,
  `email`            varchar(100) NOT NULL,
  `phone_number`     varchar(20)  DEFAULT NULL,
  `password`         varchar(255) NOT NULL,
  `role_id`          int          DEFAULT NULL,
  `profile_picture`  varchar(255) DEFAULT NULL,
  -- Stored as bcrypt hash; plain shown once at creation
  `backup_code`      varchar(255) DEFAULT NULL,
  `is_active`        tinyint(1)   NOT NULL DEFAULT '1',
  `is_protected`     tinyint(1)   NOT NULL DEFAULT '0',
  -- is_protected = 1 → account cannot be deleted by anyone
  `created_at`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_email` (`email`),
  KEY `fk_user_role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Super Admin (user_id=1, role_id=1, is_protected=1)
-- password='admin123' (bcrypt), backup_code='1234567890' (bcrypt)
-- In production: run setup.php to regenerate the backup code securely
INSERT INTO `users`
  (`user_id`,`first_name`,`last_name`,`email`,`phone_number`,`password`,`role_id`,`is_protected`,`backup_code`) VALUES
(1, 'Super', 'Admin', 'admin@yagums.edu', NULL,
   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
   -- ^ bcrypt of 'password' — CHANGE THIS immediately on first run via setup.php
   1, 1,
   '$2y$10$TKh8H1.PB9/30K6Yd7G1KumxRb4.pRjm3J2K9T3XhLR4Mb8f3K6Bi'
   -- ^ bcrypt of '1234567890' — backup code shown once, then only the hash is kept
);

-- Facility Manager (role_id=2)
INSERT INTO `users` (`first_name`,`last_name`,`email`,`phone_number`,`password`,`role_id`) VALUES
('Facility', 'Manager', 'manager@yagums.edu', '+6017-3334444', '123', 2);

-- Maintenance Staff (role_id=3)
INSERT INTO `users` (`first_name`,`last_name`,`email`,`phone_number`,`password`,`role_id`) VALUES
('Ahmad', 'Rahman', 'ahmad@maintenance.edu', '+6019-5556666', '123', 3);

-- Lecturer (role_id=4)
INSERT INTO `users` (`first_name`,`last_name`,`email`,`phone_number`,`password`,`role_id`) VALUES
('Dr.', 'Kumar', 'kumar@staff.edu', '+6013-1112222', '123', 4);

-- Students (role_id=5)
INSERT INTO `users` (`first_name`,`last_name`,`email`,`phone_number`,`password`,`role_id`) VALUES
('Alice', 'Tan',  'alice@student.edu', '+6012-3456789', '123', 5),
('Ben',   'Lee',  'ben@student.edu',   '+6012-9876543', '123', 5);

-- ──────────────────────────────────────────────────────
--  FACILITY TYPES
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `facilitytypes`;
CREATE TABLE `facilitytypes` (
  `type_id`   int         NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `uq_type_name` (`type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `facilitytypes` (`type_id`, `type_name`) VALUES
(1,'Lecture Hall'),(2,'Laboratory'),(3,'Sports Facility'),(4,'Meeting Room'),(5,'Study Room');

-- ──────────────────────────────────────────────────────
--  FACILITIES
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `facilities`;
CREATE TABLE `facilities` (
  `facility_id`   int          NOT NULL AUTO_INCREMENT,
  `facility_name` varchar(100) NOT NULL,
  `type_id`       int          DEFAULT NULL,
  `capacity`      int          DEFAULT NULL,
  `location`      varchar(150) DEFAULT NULL,
  `is_available`  tinyint(1)   NOT NULL DEFAULT '1',
  `created_at`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`facility_id`),
  KEY `fk_facility_type` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `facilities` (`facility_id`,`facility_name`,`type_id`,`capacity`,`location`,`is_available`) VALUES
(1,'Lecture Hall A',   1,120,'Block A',       1),
(2,'Computer Lab 1',   2, 40,'Block B',        0),
(3,'Basketball Court', 3, 50,'Sports Complex', 1),
(4,'Meeting Room 1',   4, 20,'Admin Block',    1),
(5,'Study Room 5',     5, 10,'Library',        1);

-- ──────────────────────────────────────────────────────
--  BOOKING STATUS
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `bookingstatus`;
CREATE TABLE `bookingstatus` (
  `status_id`   int         NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `uq_status_name` (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `bookingstatus` (`status_id`,`status_name`) VALUES
(1,'Pending'),(2,'Approved'),(3,'Rejected'),(4,'Cancelled');

-- ──────────────────────────────────────────────────────
--  BOOKINGS
--  PRIVACY: each booking row has user_id.
--  API enforces: regular users can only SELECT WHERE user_id = ?
--  Admins/Managers can SELECT all.
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `bookings`;
CREATE TABLE `bookings` (
  `booking_id`   int          NOT NULL AUTO_INCREMENT,
  `user_id`      int          NOT NULL,
  `facility_id`  int          DEFAULT NULL,
  `booking_date` date         NOT NULL,
  `start_time`   time         NOT NULL,
  `end_time`     time         NOT NULL,
  `status_id`    int          DEFAULT NULL,
  `purpose`      varchar(255) DEFAULT NULL,
  `created_at`   datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `uq_booking_slot` (`facility_id`,`booking_date`,`start_time`,`end_time`),
  KEY `fk_booking_user`     (`user_id`),
  KEY `fk_booking_status`   (`status_id`),
  KEY `idx_booking_date`    (`booking_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Alice (user_id=6→now sequential: Alice is user 6, Ben is 7)
-- Use subqueries to avoid hardcoding user_ids
INSERT INTO `bookings` (`user_id`,`facility_id`,`booking_date`,`start_time`,`end_time`,`status_id`) VALUES
((SELECT user_id FROM users WHERE email='alice@student.edu'),   5,'2026-04-01','10:00:00','12:00:00',2),
((SELECT user_id FROM users WHERE email='ben@student.edu'),     5,'2026-04-01','13:00:00','15:00:00',1),
((SELECT user_id FROM users WHERE email='kumar@staff.edu'),     1,'2026-04-02','09:00:00','11:00:00',2),
((SELECT user_id FROM users WHERE email='kumar@staff.edu'),     2,'2026-04-03','14:00:00','16:00:00',2),
((SELECT user_id FROM users WHERE email='alice@student.edu'),   3,'2026-04-04','18:00:00','20:00:00',3);

-- ──────────────────────────────────────────────────────
--  MAINTENANCE STATUS
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `maintenancestatus`;
CREATE TABLE `maintenancestatus` (
  `status_id`   int         NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `uq_mstatus` (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `maintenancestatus` VALUES (1,'Pending'),(2,'In Progress'),(3,'Completed');

-- ──────────────────────────────────────────────────────
--  MAINTENANCE REQUESTS
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `maintenancerequests`;
CREATE TABLE `maintenancerequests` (
  `request_id`  int          NOT NULL AUTO_INCREMENT,
  `facility_id` int          DEFAULT NULL,
  `reported_by` int          DEFAULT NULL,
  `description` text,
  `priority`    enum('Low','Medium','High') DEFAULT 'Medium',
  `status_id`   int          DEFAULT NULL,
  `created_at`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `fk_mreq_facility` (`facility_id`),
  KEY `fk_mreq_user`     (`reported_by`),
  KEY `fk_mreq_status`   (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `maintenancerequests` (`facility_id`,`reported_by`,`description`,`priority`,`status_id`) VALUES
(2,(SELECT user_id FROM users WHERE email='alice@student.edu'),'Computers not working','High',1),
(1,(SELECT user_id FROM users WHERE email='kumar@staff.edu'),'Projector malfunction','Medium',2),
(5,(SELECT user_id FROM users WHERE email='ben@student.edu'),'Air conditioning issue','Low',1);

-- ──────────────────────────────────────────────────────
--  MAINTENANCE TASKS
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `maintenancetasks`;
CREATE TABLE `maintenancetasks` (
  `task_id`     int        NOT NULL AUTO_INCREMENT,
  `request_id`  int        DEFAULT NULL,
  `assigned_to` int        DEFAULT NULL,
  `progress`    text,
  `completed`   tinyint(1) NOT NULL DEFAULT '0',
  `created_at`  datetime   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  datetime   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_id`),
  KEY `fk_task_request` (`request_id`),
  KEY `fk_task_user`    (`assigned_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `maintenancetasks` (`request_id`,`assigned_to`,`progress`,`completed`) VALUES
(1,(SELECT user_id FROM users WHERE email='ahmad@maintenance.edu'),'Checking hardware',0),
(2,(SELECT user_id FROM users WHERE email='ahmad@maintenance.edu'),'Projector repaired',1),
(3,(SELECT user_id FROM users WHERE email='ahmad@maintenance.edu'),'Inspection scheduled',0);

-- ──────────────────────────────────────────────────────
--  NOTIFICATIONS  (updated with type + announcement flag)
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id` int         NOT NULL AUTO_INCREMENT,
  `user_id`         int         NOT NULL,
  `message`         text        NOT NULL,
  `is_read`         tinyint(1)  NOT NULL DEFAULT '0',
  `type`            varchar(30) NOT NULL DEFAULT 'info',
  -- info | success | warning | error | announcement
  `is_announcement` tinyint(1)  NOT NULL DEFAULT '0',
  `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `fk_notif_user`          (`user_id`),
  KEY `idx_notif_type`         (`type`),
  KEY `idx_notif_announcement` (`is_announcement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `notifications` (`user_id`,`message`,`is_read`,`type`) VALUES
((SELECT user_id FROM users WHERE email='alice@student.edu'),   'Your booking for Study Room 5 has been approved',   0,'success'),
((SELECT user_id FROM users WHERE email='ben@student.edu'),     'Your booking for Study Room 5 is pending approval', 0,'info'),
((SELECT user_id FROM users WHERE email='kumar@staff.edu'),     'Maintenance request updated',                       1,'info'),
((SELECT user_id FROM users WHERE email='alice@student.edu'),   'Maintenance request received',                      0,'info'),
((SELECT user_id FROM users WHERE email='ahmad@maintenance.edu'),'New maintenance task assigned',                    0,'info');

-- ──────────────────────────────────────────────────────
--  ANNOUNCEMENTS  (updated: upvotes + downvotes)
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `announcements`;
CREATE TABLE `announcements` (
  `announcement_id` int          NOT NULL AUTO_INCREMENT,
  `posted_by`       int          NOT NULL,
  `title`           varchar(200) NOT NULL,
  `message`         text         NOT NULL,
  `priority`        enum('low','medium','high') NOT NULL DEFAULT 'medium',
  `upvotes`         int          NOT NULL DEFAULT '0',
  `downvotes`       int          NOT NULL DEFAULT '0',
  `is_active`       tinyint(1)   NOT NULL DEFAULT '1',
  `created_at`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`announcement_id`),
  KEY `fk_ann_user`      (`posted_by`),
  KEY `idx_ann_active`   (`is_active`),
  KEY `idx_ann_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `announcements` (`posted_by`,`title`,`message`,`priority`) VALUES
(1,'Welcome to YAGUMS',     'YAGUMS is now live. Book facilities and report issues anytime.','low'),
(1,'New Booking Policy',    'All bookings must be submitted at least 24 hours in advance starting 1 April 2026.','high'),
(1,'Library Closure Notice','The library will be closed on 5 April 2026 for scheduled maintenance.','medium');

-- ──────────────────────────────────────────────────────
--  ANNOUNCEMENT_VOTES  (one vote per user per announcement)
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `announcement_votes`;
CREATE TABLE `announcement_votes` (
  `vote_id`         int      NOT NULL AUTO_INCREMENT,
  `announcement_id` int      NOT NULL,
  `user_id`         int      NOT NULL,
  `vote`            enum('up','down') NOT NULL,
  `created_at`      datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`vote_id`),
  UNIQUE KEY `uq_user_vote` (`announcement_id`,`user_id`),
  -- One vote per user per announcement; user can change their vote
  KEY `fk_vote_ann`  (`announcement_id`),
  KEY `fk_vote_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────
--  ADMIN_LOGS  (full audit trail)
-- ──────────────────────────────────────────────────────
DROP TABLE IF EXISTS `admin_logs`;
CREATE TABLE `admin_logs` (
  `log_id`      int         NOT NULL AUTO_INCREMENT,
  `admin_id`    int         NOT NULL,
  `action`      varchar(50) NOT NULL,
  -- LOGIN | LOGOUT | CREATE | UPDATE | DELETE | APPROVE | REJECT | ANNOUNCE | ASSIGN | VIEW
  `target_type` varchar(50) DEFAULT NULL,
  `target_id`   int         DEFAULT NULL,
  `description` text        NOT NULL,
  `ip_address`  varchar(45) DEFAULT NULL,
  `created_at`  datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_log_admin`    (`admin_id`),
  KEY `idx_log_action`  (`action`),
  KEY `idx_log_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `admin_logs` (`admin_id`,`action`,`target_type`,`description`) VALUES
(1,'LOGIN',    NULL,       'Super Admin logged into the system'),
(1,'APPROVE',  'booking',  'Approved booking #1 — Study Room 5 (Alice Tan)'),
(1,'APPROVE',  'booking',  'Approved booking #3 — Lecture Hall A (Dr. Kumar)'),
(1,'REJECT',   'booking',  'Rejected booking #5 — Basketball Court (Alice Tan)'),
(1,'ANNOUNCE', 'announcement','Posted announcement: "Welcome to YAGUMS"');

-- ──────────────────────────────────────────────────────
--  FOREIGN KEYS
-- ──────────────────────────────────────────────────────
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_role`
    FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `facilities`
  ADD CONSTRAINT `fk_facility_type`
    FOREIGN KEY (`type_id`) REFERENCES `facilitytypes` (`type_id`)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_facility`
    FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_status`
    FOREIGN KEY (`status_id`) REFERENCES `bookingstatus` (`status_id`)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `maintenancerequests`
  ADD CONSTRAINT `fk_mreq_facility`
    FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mreq_status`
    FOREIGN KEY (`status_id`) REFERENCES `maintenancestatus` (`status_id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mreq_user`
    FOREIGN KEY (`reported_by`) REFERENCES `users` (`user_id`)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `maintenancetasks`
  ADD CONSTRAINT `fk_task_request`
    FOREIGN KEY (`request_id`) REFERENCES `maintenancerequests` (`request_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_task_user`
    FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notif_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `announcements`
  ADD CONSTRAINT `fk_ann_user`
    FOREIGN KEY (`posted_by`) REFERENCES `users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `announcement_votes`
  ADD CONSTRAINT `fk_vote_ann`
    FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`announcement_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vote_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `admin_logs`
  ADD CONSTRAINT `fk_log_admin`
    FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
