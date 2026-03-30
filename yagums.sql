-- ═══════════════════════════════════════════════
--  YAGUMS — Database Schema (Updated)
--  Changes from original:
--   1. notifications table: added `type` and `is_announcement` columns
--   2. NEW TABLE: announcements — for admin broadcast messages
--   3. NEW TABLE: admin_logs   — records every admin action
-- ═══════════════════════════════════════════════

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

-- ─────────────────────────────────────────────────
--  roles
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `role_id`   int          NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50)  NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(1, 'Student'),
(2, 'Lecturer'),
(3, 'Facility Manager'),
(4, 'Maintenance Staff'),
(5, 'System Admin');

-- ─────────────────────────────────────────────────
--  users
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id`      int          NOT NULL AUTO_INCREMENT,
  `first_name`   varchar(50)  NOT NULL,
  `last_name`    varchar(50)  NOT NULL,
  `email`        varchar(100) NOT NULL,
  `phone_number` varchar(20)  DEFAULT NULL,
  `password`     varchar(255) NOT NULL,
  `role_id`      int          DEFAULT NULL,
  `created_at`   datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_user_role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `users` (`user_id`,`first_name`,`last_name`,`email`,`phone_number`,`password`,`role_id`) VALUES
(1, 'Alice',  'Tan',    'alice@student.edu',    '+6012-3456789', '123', 1),
(2, 'Ben',    'Lee',    'ben@student.edu',       '+6012-9876543', '123', 1),
(3, 'Dr.',    'Kumar',  'kumar@staff.edu',       '+6013-1112222', '123', 2),
(4, 'Ms.',    'Lim',    'lim@admin.edu',         '+6017-3334444', '123', 3),
(5, 'Ahmad',  'Rahman', 'ahmad@maintenance.edu', '+6019-5556666', '123', 4);

-- ─────────────────────────────────────────────────
--  facility types
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `facilitytypes`;
CREATE TABLE `facilitytypes` (
  `type_id`   int         NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `facilitytypes` VALUES
(1,'Lecture Hall'),(2,'Laboratory'),(3,'Sports Facility'),(4,'Meeting Room'),(5,'Study Room');

-- ─────────────────────────────────────────────────
--  facilities
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `facilities`;
CREATE TABLE `facilities` (
  `facility_id`   int          NOT NULL AUTO_INCREMENT,
  `facility_name` varchar(100) NOT NULL,
  `type_id`       int          DEFAULT NULL,
  `capacity`      int          DEFAULT NULL,
  `location`      varchar(150) DEFAULT NULL,
  PRIMARY KEY (`facility_id`),
  KEY `fk_facility_type` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `facilities` VALUES
(1,'Lecture Hall A',1,120,'Block A'),
(2,'Computer Lab 1',2,40,'Block B'),
(3,'Basketball Court',3,50,'Sports Complex'),
(4,'Meeting Room 1',4,20,'Admin Block'),
(5,'Study Room 5',5,10,'Library');

-- ─────────────────────────────────────────────────
--  booking status
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `bookingstatus`;
CREATE TABLE `bookingstatus` (
  `status_id`   int         NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `bookingstatus` VALUES (1,'Pending'),(2,'Approved'),(3,'Rejected'),(4,'Cancelled');

-- ─────────────────────────────────────────────────
--  bookings
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `bookings`;
CREATE TABLE `bookings` (
  `booking_id`   int  NOT NULL AUTO_INCREMENT,
  `user_id`      int  DEFAULT NULL,
  `facility_id`  int  DEFAULT NULL,
  `booking_date` date NOT NULL,
  `start_time`   time NOT NULL,
  `end_time`     time NOT NULL,
  `status_id`    int  DEFAULT NULL,
  `created_at`   datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `unique_booking` (`facility_id`,`booking_date`,`start_time`,`end_time`),
  KEY `fk_booking_user` (`user_id`),
  KEY `fk_booking_status` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `bookings` (`booking_id`,`user_id`,`facility_id`,`booking_date`,`start_time`,`end_time`,`status_id`) VALUES
(1,1,5,'2026-04-01','10:00:00','12:00:00',2),
(2,2,5,'2026-04-01','13:00:00','15:00:00',1),
(3,3,1,'2026-04-02','09:00:00','11:00:00',2),
(4,3,2,'2026-04-03','14:00:00','16:00:00',2),
(5,1,3,'2026-04-04','18:00:00','20:00:00',3);

-- ─────────────────────────────────────────────────
--  maintenance status
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `maintenancestatus`;
CREATE TABLE `maintenancestatus` (
  `status_id`   int         NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `maintenancestatus` VALUES (1,'Pending'),(2,'In Progress'),(3,'Completed');

-- ─────────────────────────────────────────────────
--  maintenance requests
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `maintenancerequests`;
CREATE TABLE `maintenancerequests` (
  `request_id`  int          NOT NULL AUTO_INCREMENT,
  `facility_id` int          DEFAULT NULL,
  `reported_by` int          DEFAULT NULL,
  `description` text,
  `priority`    varchar(20)  DEFAULT NULL,
  `status_id`   int          DEFAULT NULL,
  `created_at`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `fk_request_facility` (`facility_id`),
  KEY `fk_request_user` (`reported_by`),
  KEY `fk_request_status` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `maintenancerequests` (`request_id`,`facility_id`,`reported_by`,`description`,`priority`,`status_id`) VALUES
(1,2,1,'Computers not working','High',1),
(2,1,3,'Projector malfunction','Medium',2),
(3,5,2,'Air conditioning issue','Low',1);

-- ─────────────────────────────────────────────────
--  maintenance tasks
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `maintenancetasks`;
CREATE TABLE `maintenancetasks` (
  `task_id`     int         NOT NULL AUTO_INCREMENT,
  `request_id`  int         DEFAULT NULL,
  `assigned_to` int         DEFAULT NULL,
  `progress`    text,
  `completed`   tinyint(1)  DEFAULT '0',
  `updated_at`  datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_id`),
  KEY `fk_task_request` (`request_id`),
  KEY `fk_task_user` (`assigned_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `maintenancetasks` VALUES
(1,1,4,'Checking hardware components',0,NOW()),
(2,2,4,'Projector repaired',1,NOW()),
(3,3,4,'Inspection scheduled',0,NOW());

-- ─────────────────────────────────────────────────
--  notifications  (UPDATED — added type + announcement flag)
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id`  int          NOT NULL AUTO_INCREMENT,
  `user_id`          int          NOT NULL,
  `message`          text         NOT NULL,
  `is_read`          tinyint(1)   DEFAULT '0',
  -- NEW: what kind of notification is this?
  `type`             varchar(30)  NOT NULL DEFAULT 'info',
                                  -- values: info | success | warning | error | announcement
  -- NEW: is this an admin broadcast announcement?
  `is_announcement`  tinyint(1)   DEFAULT '0',
  `created_at`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `fk_notification_user` (`user_id`),
  KEY `idx_notif_type` (`type`),
  KEY `idx_notif_announcement` (`is_announcement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `notifications` (`notification_id`,`user_id`,`message`,`is_read`,`type`,`is_announcement`) VALUES
(1, 1, 'Your booking has been approved',          0, 'success',      0),
(2, 2, 'Your booking is pending approval',        0, 'info',         0),
(3, 3, 'Maintenance request updated',             1, 'info',         0),
(4, 1, 'Maintenance request received',            0, 'info',         0),
(5, 4, 'New maintenance task assigned',           0, 'info',         0);

-- ─────────────────────────────────────────────────
--  announcements  (NEW TABLE)
--  Admin posts these; all users see them on login
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `announcements`;
CREATE TABLE `announcements` (
  `announcement_id` int          NOT NULL AUTO_INCREMENT,
  `posted_by`       int          NOT NULL,              -- FK → users.user_id (admin)
  `title`           varchar(200) NOT NULL,
  `message`         text         NOT NULL,
  `priority`        enum('low','medium','high') NOT NULL DEFAULT 'medium',
  `is_active`       tinyint(1)   NOT NULL DEFAULT '1',  -- 0 = archived/hidden
  `created_at`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`announcement_id`),
  KEY `fk_announcement_user` (`posted_by`),
  KEY `idx_announcement_active` (`is_active`),
  KEY `idx_announcement_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `announcements` (`posted_by`,`title`,`message`,`priority`) VALUES
(4, 'Welcome to YAGUMS',         'The new university management system is now live. Use it to book facilities and report maintenance issues.', 'low'),
(4, 'New Booking Policy',        'All facility bookings must be submitted at least 24 hours in advance. Same-day bookings will no longer be accepted.', 'high'),
(4, 'Library Closure Notice',    'The library will be closed on 5 April 2026 for scheduled maintenance.', 'medium');

-- ─────────────────────────────────────────────────
--  admin_logs  (NEW TABLE)
--  Records every admin action for audit trail
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `admin_logs`;
CREATE TABLE `admin_logs` (
  `log_id`      int          NOT NULL AUTO_INCREMENT,
  `admin_id`    int          NOT NULL,              -- FK → users.user_id
  `action`      varchar(50)  NOT NULL,
                              -- values: LOGIN | LOGOUT | CREATE | UPDATE | DELETE
                              --         APPROVE | REJECT | ANNOUNCE | ASSIGN | VIEW
  `target_type` varchar(50)  DEFAULT NULL,          -- e.g. 'user', 'booking', 'announcement'
  `target_id`   int          DEFAULT NULL,          -- ID of the affected record
  `description` text         NOT NULL,              -- human-readable summary
  `ip_address`  varchar(45)  DEFAULT NULL,          -- IPv4 or IPv6
  `created_at`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_log_admin` (`admin_id`),
  KEY `idx_log_action` (`action`),
  KEY `idx_log_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed some demo log entries
INSERT INTO `admin_logs` (`admin_id`,`action`,`target_type`,`target_id`,`description`) VALUES
(4, 'LOGIN',    NULL,          NULL, 'Admin Ms. Lim logged in'),
(4, 'APPROVE',  'booking',     1,    'Approved booking #1 (Study Room 5 — Alice Tan)'),
(4, 'APPROVE',  'booking',     3,    'Approved booking #3 (Lecture Hall A — Dr. Kumar)'),
(4, 'REJECT',   'booking',     5,    'Rejected booking #5 (Basketball Court — Alice Tan)'),
(4, 'ANNOUNCE', 'announcement',1,    'Posted announcement: "Welcome to YAGUMS"'),
(4, 'LOGOUT',   NULL,          NULL, 'Admin Ms. Lim logged out');

-- ─────────────────────────────────────────────────
--  Foreign key constraints
-- ─────────────────────────────────────────────────
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `facilities`
  ADD CONSTRAINT `fk_facility_type` FOREIGN KEY (`type_id`) REFERENCES `facilitytypes` (`type_id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities`     (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_status`   FOREIGN KEY (`status_id`)   REFERENCES `bookingstatus`  (`status_id`)   ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_user`     FOREIGN KEY (`user_id`)     REFERENCES `users`          (`user_id`)     ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `maintenancerequests`
  ADD CONSTRAINT `fk_request_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities`       (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_request_status`   FOREIGN KEY (`status_id`)   REFERENCES `maintenancestatus`(`status_id`)   ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_request_user`     FOREIGN KEY (`reported_by`) REFERENCES `users`            (`user_id`)     ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `maintenancetasks`
  ADD CONSTRAINT `fk_task_request` FOREIGN KEY (`request_id`)  REFERENCES `maintenancerequests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_task_user`    FOREIGN KEY (`assigned_to`) REFERENCES `users`               (`user_id`)    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `announcements`
  ADD CONSTRAINT `fk_announcement_user` FOREIGN KEY (`posted_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `admin_logs`
  ADD CONSTRAINT `fk_log_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT;
