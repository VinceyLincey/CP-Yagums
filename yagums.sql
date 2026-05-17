-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 17, 2026 at 06:25 AM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `yagums`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_logs`
--

DROP TABLE IF EXISTS `admin_logs`;
CREATE TABLE IF NOT EXISTS `admin_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `action` varchar(50) NOT NULL,
  `target_type` varchar(50) DEFAULT NULL,
  `target_id` int DEFAULT NULL,
  `description` text NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_log_admin` (`admin_id`),
  KEY `idx_log_action` (`action`),
  KEY `idx_log_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_logs`
--

INSERT INTO `admin_logs` (`log_id`, `admin_id`, `action`, `target_type`, `target_id`, `description`, `ip_address`, `created_at`) VALUES
(1, 1, 'LOGIN', NULL, NULL, 'Super Admin logged into the system', NULL, '2026-05-05 09:19:59'),
(2, 1, 'APPROVE', 'booking', NULL, 'Approved booking #1 — Study Room 5 (Alice Tan)', NULL, '2026-05-05 09:19:59'),
(3, 1, 'APPROVE', 'booking', NULL, 'Approved booking #3 — Lecture Hall A (Dr. Kumar)', NULL, '2026-05-05 09:19:59'),
(4, 1, 'REJECT', 'booking', NULL, 'Rejected booking #5 — Basketball Court (Alice Tan)', NULL, '2026-05-05 09:19:59'),
(5, 1, 'ANNOUNCE', 'announcement', NULL, 'Posted announcement: \"Welcome to YAGUMS\"', NULL, '2026-05-05 09:19:59'),
(6, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-11 17:10:48'),
(7, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '127.0.0.1', '2026-05-11 17:10:49'),
(8, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-11 17:13:43'),
(9, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '127.0.0.1', '2026-05-11 17:16:41'),
(10, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '127.0.0.1', '2026-05-11 17:19:39'),
(11, 2, 'LOGOUT', NULL, NULL, 'Facility Manager logged out', '127.0.0.1', '2026-05-11 17:20:13'),
(12, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-11 17:20:38'),
(13, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-17 01:10:52'),
(14, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '127.0.0.1', '2026-05-17 01:10:53'),
(15, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-17 01:37:00'),
(16, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '127.0.0.1', '2026-05-17 02:40:20'),
(17, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-17 03:07:02'),
(18, 1, 'UPDATE', 'user', 2, 'Reset password for user #2', '127.0.0.1', '2026-05-17 03:07:27'),
(19, 1, 'UPDATE', 'user', 2, 'Reset password for Facility Manager', '127.0.0.1', '2026-05-17 03:07:27'),
(20, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-17 13:14:03'),
(21, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '127.0.0.1', '2026-05-17 13:14:04'),
(22, 1, 'CREATE', 'user', 7, 'Created: Fan Cheng (fancheng@yagums.maintenance.edu)', '127.0.0.1', '2026-05-17 13:14:44'),
(23, 1, 'CREATE', 'user', 7, 'Created user: Fan Cheng (fancheng@yagums.maintenance.edu)', '127.0.0.1', '2026-05-17 13:14:44'),
(24, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '127.0.0.1', '2026-05-17 13:15:01'),
(25, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-17 13:17:23'),
(26, 1, 'CREATE', 'user', 8, 'Created: Hern Xn (hernxn@yagums.student.edu)', '127.0.0.1', '2026-05-17 13:17:43'),
(27, 1, 'CREATE', 'user', 8, 'Created user: Hern Xn (hernxn@yagums.student.edu)', '127.0.0.1', '2026-05-17 13:17:43'),
(28, 1, 'CREATE', 'user', 9, 'Created: Al i (ali@yagums.student.edu)', '127.0.0.1', '2026-05-17 13:18:35'),
(29, 1, 'CREATE', 'user', 9, 'Created user: Al i (ali@yagums.student.edu)', '127.0.0.1', '2026-05-17 13:18:35'),
(30, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '127.0.0.1', '2026-05-17 13:18:41'),
(31, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-17 13:19:13'),
(32, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '127.0.0.1', '2026-05-17 13:19:14'),
(33, 1, 'CREATE', 'user', 10, 'Created: Test 1 (test1@yagums.staff.edu)', '127.0.0.1', '2026-05-17 13:19:34'),
(34, 1, 'CREATE', 'user', 10, 'Created user: Test 1 (test1@yagums.staff.edu)', '127.0.0.1', '2026-05-17 13:19:34'),
(35, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '127.0.0.1', '2026-05-17 13:19:43'),
(36, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '127.0.0.1', '2026-05-17 13:48:27'),
(37, 1, 'CREATE', 'user', 11, 'Created: test 2 (test2@yagums.admin.edu)', '127.0.0.1', '2026-05-17 13:48:53'),
(38, 1, 'CREATE', 'user', 11, 'Created user: test 2 (test2@yagums.admin.edu)', '127.0.0.1', '2026-05-17 13:48:53'),
(39, 1, 'CREATE', 'user', 12, 'Created: test 3 (test3@yagums.maintenance.edu)', '127.0.0.1', '2026-05-17 13:49:18'),
(40, 1, 'CREATE', 'user', 12, 'Created user: test 3 (test3@yagums.maintenance.edu)', '127.0.0.1', '2026-05-17 13:49:18'),
(41, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '127.0.0.1', '2026-05-17 13:49:41'),
(42, 11, 'LOGIN', NULL, NULL, 'test 2 (Admin) logged in', '127.0.0.1', '2026-05-17 13:49:55'),
(43, 11, 'LOGOUT', NULL, NULL, 'test 2 logged out', '127.0.0.1', '2026-05-17 14:14:01');

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
CREATE TABLE IF NOT EXISTS `announcements` (
  `announcement_id` int NOT NULL AUTO_INCREMENT,
  `posted_by` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `priority` enum('low','medium','high') NOT NULL DEFAULT 'medium',
  `upvotes` int NOT NULL DEFAULT '0',
  `downvotes` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`announcement_id`),
  KEY `fk_ann_user` (`posted_by`),
  KEY `idx_ann_active` (`is_active`),
  KEY `idx_ann_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`announcement_id`, `posted_by`, `title`, `message`, `priority`, `upvotes`, `downvotes`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'Welcome to YAGUMS', 'YAGUMS is now live. Book facilities and report issues anytime.', 'low', 0, 0, 1, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(2, 1, 'New Booking Policy', 'All bookings must be submitted at least 24 hours in advance starting 1 April 2026.', 'high', 0, 0, 1, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(3, 1, 'Library Closure Notice', 'The library will be closed on 5 April 2026 for scheduled maintenance.', 'medium', 0, 0, 1, '2026-05-05 09:19:59', '2026-05-05 09:19:59');

-- --------------------------------------------------------

--
-- Table structure for table `announcement_votes`
--

DROP TABLE IF EXISTS `announcement_votes`;
CREATE TABLE IF NOT EXISTS `announcement_votes` (
  `vote_id` int NOT NULL AUTO_INCREMENT,
  `announcement_id` int NOT NULL,
  `user_id` int NOT NULL,
  `vote` enum('up','down') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`vote_id`),
  UNIQUE KEY `uq_user_vote` (`announcement_id`,`user_id`),
  KEY `fk_vote_ann` (`announcement_id`),
  KEY `fk_vote_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `facility_id` int DEFAULT NULL,
  `booking_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status_id` int DEFAULT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `recurring_weeks` int DEFAULT NULL,
  `recurring_group_id` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `uq_booking_slot` (`facility_id`,`booking_date`,`start_time`,`end_time`),
  KEY `fk_booking_user` (`user_id`),
  KEY `fk_booking_status` (`status_id`),
  KEY `idx_booking_date` (`booking_date`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `user_id`, `facility_id`, `booking_date`, `start_time`, `end_time`, `status_id`, `purpose`, `recurring_weeks`, `recurring_group_id`, `created_at`, `updated_at`) VALUES
(1, 5, 5, '2026-04-01', '10:00:00', '12:00:00', 2, NULL, NULL, NULL, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(2, 6, 5, '2026-04-01', '13:00:00', '15:00:00', 1, NULL, NULL, NULL, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(3, 4, 1, '2026-04-02', '09:00:00', '11:00:00', 2, NULL, NULL, NULL, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(4, 4, 2, '2026-04-03', '14:00:00', '16:00:00', 2, NULL, NULL, NULL, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(5, 5, 3, '2026-04-04', '18:00:00', '20:00:00', 3, NULL, NULL, NULL, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(6, 5, 3, '2026-05-17', '12:22:00', '12:32:00', 1, '123', NULL, NULL, '2026-05-17 01:03:00', '2026-05-17 01:03:00'),
(7, 4, 5, '2026-05-16', '09:00:00', '11:00:00', 1, '123', 3, 2147483647, '2026-05-17 02:49:03', '2026-05-17 02:49:03'),
(8, 4, 5, '2026-05-23', '09:00:00', '11:00:00', 1, '123', NULL, 2147483647, '2026-05-17 02:49:03', '2026-05-17 02:49:03'),
(9, 4, 5, '2026-05-30', '09:00:00', '11:00:00', 1, '123', NULL, 2147483647, '2026-05-17 02:49:03', '2026-05-17 02:49:03'),
(10, 4, 5, '2026-06-06', '09:00:00', '11:00:00', 1, '123', NULL, 2147483647, '2026-05-17 02:49:03', '2026-05-17 02:49:03'),
(11, 4, 5, '2026-06-13', '10:00:00', '11:00:00', 3, NULL, 1, 2147483647, '2026-05-17 02:50:57', '2026-05-17 13:11:50'),
(12, 4, 5, '2026-06-20', '10:00:00', '11:00:00', 1, NULL, NULL, 2147483647, '2026-05-17 02:50:57', '2026-05-17 02:50:57'),
(13, 4, 1, '2026-05-30', '10:00:00', '11:00:00', 2, NULL, 2, 2147483647, '2026-05-17 02:51:17', '2026-05-17 13:11:44'),
(14, 4, 1, '2026-06-06', '10:00:00', '11:00:00', 2, NULL, NULL, 2147483647, '2026-05-17 02:51:17', '2026-05-17 13:11:48'),
(15, 4, 1, '2026-06-13', '10:00:00', '11:00:00', 3, NULL, NULL, 2147483647, '2026-05-17 02:51:17', '2026-05-17 13:11:51'),
(16, 4, 4, '2026-07-17', '09:00:00', '11:00:00', 3, '123', 2, 1778994009337, '2026-05-17 13:00:09', '2026-05-17 13:11:40'),
(17, 4, 4, '2026-07-24', '09:00:00', '11:00:00', 3, '123', NULL, 1778994009337, '2026-05-17 13:00:09', '2026-05-17 13:11:41'),
(18, 4, 4, '2026-07-31', '09:00:00', '11:00:00', 2, '123', NULL, 1778994009337, '2026-05-17 13:00:09', '2026-05-17 13:11:46');

-- --------------------------------------------------------

--
-- Table structure for table `bookingstatus`
--

DROP TABLE IF EXISTS `bookingstatus`;
CREATE TABLE IF NOT EXISTS `bookingstatus` (
  `status_id` int NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `uq_status_name` (`status_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bookingstatus`
--

INSERT INTO `bookingstatus` (`status_id`, `status_name`) VALUES
(2, 'Approved'),
(4, 'Cancelled'),
(1, 'Pending'),
(3, 'Rejected');

-- --------------------------------------------------------

--
-- Table structure for table `facilities`
--

DROP TABLE IF EXISTS `facilities`;
CREATE TABLE IF NOT EXISTS `facilities` (
  `facility_id` int NOT NULL AUTO_INCREMENT,
  `facility_name` varchar(100) NOT NULL,
  `emoji` varchar(10) NOT NULL DEFAULT 0xF09F8F9BEFB88F,
  `type_id` int DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`facility_id`),
  KEY `fk_facility_type` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `facilities`
--

INSERT INTO `facilities` (`facility_id`, `facility_name`, `emoji`, `type_id`, `capacity`, `location`, `is_available`, `created_at`) VALUES
(1, 'Lecture Hall A', '🏛️', 1, 120, 'Block A', 1, '2026-05-05 09:19:59'),
(2, 'Computer Lab 1', '🏛️', 2, 40, 'Block B', 0, '2026-05-05 09:19:59'),
(3, 'Basketball Court', '🏛️', 3, 50, 'Sports Complex', 1, '2026-05-05 09:19:59'),
(4, 'Meeting Room 1', '🏛️', 4, 20, 'Admin Block', 1, '2026-05-05 09:19:59'),
(5, 'Study Room 5', '🏛️', 5, 10, 'Library', 1, '2026-05-05 09:19:59');

-- --------------------------------------------------------

--
-- Table structure for table `facilitytypes`
--

DROP TABLE IF EXISTS `facilitytypes`;
CREATE TABLE IF NOT EXISTS `facilitytypes` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `uq_type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `facilitytypes`
--

INSERT INTO `facilitytypes` (`type_id`, `type_name`) VALUES
(2, 'Laboratory'),
(1, 'Lecture Hall'),
(4, 'Meeting Room'),
(3, 'Sports Facility'),
(5, 'Study Room');

-- --------------------------------------------------------

--
-- Table structure for table `maintenancerequests`
--

DROP TABLE IF EXISTS `maintenancerequests`;
CREATE TABLE IF NOT EXISTS `maintenancerequests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int DEFAULT NULL,
  `reported_by` int DEFAULT NULL,
  `description` text,
  `priority` enum('Low','Medium','High') DEFAULT 'Medium',
  `status_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `fk_mreq_facility` (`facility_id`),
  KEY `fk_mreq_user` (`reported_by`),
  KEY `fk_mreq_status` (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenancerequests`
--

INSERT INTO `maintenancerequests` (`request_id`, `facility_id`, `reported_by`, `description`, `priority`, `status_id`, `created_at`, `updated_at`) VALUES
(1, 2, 5, 'Computers not working', 'High', 3, '2026-05-05 09:19:59', '2026-05-17 03:05:46'),
(2, 1, 4, 'Projector malfunction', 'Medium', 3, '2026-05-05 09:19:59', '2026-05-17 14:21:59'),
(3, 5, 6, 'Air conditioning issue', 'Low', 3, '2026-05-05 09:19:59', '2026-05-17 13:16:56'),
(4, 4, 5, '123123123123123123 test test test', 'Medium', 3, '2026-05-17 14:16:22', '2026-05-17 14:21:58'),
(5, 4, 5, 'HEAVY TASKS 123 123', 'Medium', 2, '2026-05-17 14:20:50', '2026-05-17 14:21:39');

-- --------------------------------------------------------

--
-- Table structure for table `maintenancestatus`
--

DROP TABLE IF EXISTS `maintenancestatus`;
CREATE TABLE IF NOT EXISTS `maintenancestatus` (
  `status_id` int NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `uq_mstatus` (`status_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenancestatus`
--

INSERT INTO `maintenancestatus` (`status_id`, `status_name`) VALUES
(3, 'Completed'),
(2, 'In Progress'),
(1, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `maintenancetasks`
--

DROP TABLE IF EXISTS `maintenancetasks`;
CREATE TABLE IF NOT EXISTS `maintenancetasks` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int DEFAULT NULL,
  `assigned_to` int DEFAULT NULL,
  `assigned_by` int DEFAULT NULL,
  `progress` text,
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_id`),
  KEY `fk_task_request` (`request_id`),
  KEY `fk_task_user` (`assigned_to`),
  KEY `assigned_by` (`assigned_by`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenancetasks`
--

INSERT INTO `maintenancetasks` (`task_id`, `request_id`, `assigned_to`, `assigned_by`, `progress`, `completed`, `created_at`, `updated_at`) VALUES
(1, 1, 3, NULL, 'Checking hardware', 1, '2026-05-05 09:19:59', '2026-05-17 03:05:46'),
(2, 2, 3, NULL, 'Projector repaired', 1, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(3, 3, 3, NULL, 'Inspection scheduled', 0, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(4, 3, 7, NULL, '123', 1, '2026-05-17 13:16:39', '2026-05-17 13:16:56'),
(5, 2, 12, NULL, 'Task completed', 1, '2026-05-17 14:14:34', '2026-05-17 14:21:59'),
(6, 4, 3, NULL, '', 0, '2026-05-17 14:16:22', '2026-05-17 14:16:22'),
(7, 4, 7, NULL, '', 0, '2026-05-17 14:16:22', '2026-05-17 14:16:22'),
(8, 4, 12, NULL, 'Task completed', 1, '2026-05-17 14:16:22', '2026-05-17 14:21:58'),
(9, 5, 12, NULL, '', 0, '2026-05-17 14:21:39', '2026-05-17 14:21:39');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(30) NOT NULL DEFAULT 'info',
  `is_announcement` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `fk_notif_user` (`user_id`),
  KEY `idx_notif_type` (`type`),
  KEY `idx_notif_announcement` (`is_announcement`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `message`, `is_read`, `type`, `is_announcement`, `created_at`) VALUES
(1, 5, 'Your booking for Study Room 5 has been approved', 0, 'success', 0, '2026-05-05 09:19:59'),
(2, 6, 'Your booking for Study Room 5 is pending approval', 0, 'info', 0, '2026-05-05 09:19:59'),
(3, 4, 'Maintenance request updated', 1, 'info', 0, '2026-05-05 09:19:59'),
(4, 5, 'Maintenance request received', 0, 'info', 0, '2026-05-05 09:19:59'),
(5, 3, 'New maintenance task assigned', 0, 'info', 0, '2026-05-05 09:19:59'),
(6, 5, '📅 Your booking for Basketball Court on 2026-05-17 is pending approval.', 0, 'info', 0, '2026-05-17 01:03:00'),
(7, 2, '📅 New booking request from Alice Tan for Basketball Court on 2026-05-17 — awaiting your approval.', 0, 'info', 0, '2026-05-17 01:03:00'),
(8, 4, '📅 Your booking for Study Room 5 on 2026-05-16 is pending approval.', 0, 'info', 0, '2026-05-17 02:49:03'),
(9, 2, '📅 New booking request from Dr. Kumar for Study Room 5 on 2026-05-16 — awaiting your approval.', 0, 'info', 0, '2026-05-17 02:49:03'),
(10, 4, '📅 Your booking for Study Room 5 on 2026-06-13 is pending approval.', 0, 'info', 0, '2026-05-17 02:50:57'),
(11, 2, '📅 New booking request from Dr. Kumar for Study Room 5 on 2026-06-13 — awaiting your approval.', 0, 'info', 0, '2026-05-17 02:50:57'),
(12, 4, '📅 Your booking for Lecture Hall A on 2026-05-30 is pending approval.', 0, 'info', 0, '2026-05-17 02:51:17'),
(13, 2, '📅 New booking request from Dr. Kumar for Lecture Hall A on 2026-05-30 — awaiting your approval.', 0, 'info', 0, '2026-05-17 02:51:17'),
(14, 5, 'Maintenance update for Computer Lab 1: Checking hardware (Status: Completed)', 0, 'info', 0, '2026-05-17 03:05:46'),
(15, 2, 'Your password was reset by an administrator. Please log in with your new password.', 0, 'warning', 0, '2026-05-17 03:07:27'),
(16, 4, '📅 Your booking for Meeting Room 1 on 2026-07-17 is pending approval.', 0, 'info', 0, '2026-05-17 13:00:09'),
(17, 2, '📅 New booking request from Dr. Kumar for Meeting Room 1 on 2026-07-17 — awaiting your approval.', 0, 'info', 0, '2026-05-17 13:00:09'),
(18, 4, 'Your booking for Meeting Room 1 on 2026-07-17 has been Rejected ❌.', 0, 'warning', 0, '2026-05-17 13:11:40'),
(19, 4, 'Your booking for Meeting Room 1 on 2026-07-24 has been Rejected ❌.', 0, 'warning', 0, '2026-05-17 13:11:41'),
(20, 4, 'Your booking for Meeting Room 1 on 2026-07-31 has been Approved ✅.', 0, 'success', 0, '2026-05-17 13:11:42'),
(21, 4, 'Your booking for Lecture Hall A on 2026-05-30 has been Approved ✅.', 0, 'success', 0, '2026-05-17 13:11:44'),
(22, 4, 'Your booking for Meeting Room 1 on 2026-07-31 has been Approved ✅.', 0, 'success', 0, '2026-05-17 13:11:46'),
(23, 4, 'Your booking for Lecture Hall A on 2026-06-06 has been Approved ✅.', 0, 'success', 0, '2026-05-17 13:11:48'),
(24, 4, 'Your booking for Study Room 5 on 2026-06-13 has been Rejected ❌.', 0, 'warning', 0, '2026-05-17 13:11:50'),
(25, 4, 'Your booking for Lecture Hall A on 2026-06-13 has been Rejected ❌.', 0, 'warning', 0, '2026-05-17 13:11:51'),
(26, 7, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-05-17 13:14:44'),
(27, 7, 'Your password was changed successfully.', 0, 'success', 0, '2026-05-17 13:15:58'),
(28, 7, 'You have been assigned a maintenance task for Study Room 5: 123', 0, 'info', 0, '2026-05-17 13:16:39'),
(29, 6, '✅ Your maintenance request for Study Room 5 has been completed!', 0, 'success', 0, '2026-05-17 13:16:56'),
(30, 8, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-05-17 13:17:43'),
(31, 9, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-05-17 13:18:35'),
(32, 10, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-05-17 13:19:34'),
(33, 10, 'Your password was changed successfully.', 0, 'success', 0, '2026-05-17 13:38:40'),
(34, 11, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-05-17 13:48:53'),
(35, 12, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-05-17 13:49:18'),
(36, 12, 'You have been assigned a maintenance task for Lecture Hall A.', 0, 'info', 0, '2026-05-17 14:14:34'),
(37, 5, '🔧 Your maintenance report for Meeting Room 1 has been submitted and is pending review.', 0, 'info', 0, '2026-05-17 14:16:22'),
(38, 3, '🔧 New maintenance report for Meeting Room 1: 123123123123123123 test test test', 0, 'warning', 0, '2026-05-17 14:16:22'),
(39, 7, '🔧 New maintenance report for Meeting Room 1: 123123123123123123 test test test', 0, 'warning', 0, '2026-05-17 14:16:22'),
(40, 12, '🔧 New maintenance report for Meeting Room 1: 123123123123123123 test test test', 0, 'warning', 0, '2026-05-17 14:16:22'),
(41, 5, '🔧 Your maintenance report for Meeting Room 1 has been submitted and is pending review.', 0, 'info', 0, '2026-05-17 14:20:50'),
(42, 3, '🔧 New maintenance report for Meeting Room 1: HEAVY TASKS 123 123', 0, 'warning', 0, '2026-05-17 14:20:50'),
(43, 7, '🔧 New maintenance report for Meeting Room 1: HEAVY TASKS 123 123', 0, 'warning', 0, '2026-05-17 14:20:50'),
(44, 12, '🔧 New maintenance report for Meeting Room 1: HEAVY TASKS 123 123', 0, 'warning', 0, '2026-05-17 14:20:50'),
(45, 12, 'You have been assigned a maintenance task for Meeting Room 1.', 0, 'info', 0, '2026-05-17 14:21:39'),
(46, 5, '✅ Your maintenance request for Meeting Room 1 has been completed!', 0, 'success', 0, '2026-05-17 14:21:58'),
(47, 4, '✅ Your maintenance request for Lecture Hall A has been completed!', 0, 'success', 0, '2026-05-17 14:21:59');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uq_role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'Admin', 'Super Administrator — full system access, undeletable account'),
(2, 'Facility Manager', 'Approves bookings, manages facilities and announcements'),
(3, 'Maintenance Staff', 'Handles and resolves maintenance requests and tasks'),
(4, 'Lecturer', 'Books facilities, reports maintenance issues'),
(5, 'Student', 'Books facilities, views announcements');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `backup_code` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_protected` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_email` (`email`),
  KEY `fk_user_role` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `phone_number`, `password`, `role_id`, `profile_picture`, `backup_code`, `is_active`, `is_protected`, `created_at`, `updated_at`) VALUES
(1, 'Super', 'Admin', 'admin@yagums.edu', NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '1.png', '$2y$10$TKh8H1.PB9/30K6Yd7G1KumxRb4.pRjm3J2K9T3XhLR4Mb8f3K6Bi', 1, 1, '2026-05-05 09:19:59', '2026-05-17 01:47:09'),
(2, 'Facility', 'Manager', 'manager@yagums.edu', '+6017-3334444', '123', 2, NULL, NULL, 1, 0, '2026-05-05 09:19:59', '2026-05-17 12:44:10'),
(3, 'Ahmad', 'Rahman', 'ahmad@maintenance.edu', '+6019-5556666', '123', 3, NULL, NULL, 1, 0, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(4, 'Dr.', 'Kumar', 'kumar@staff.edu', '+6013-1112222', '123', 4, NULL, NULL, 1, 0, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(5, 'Alice', 'Tan', 'alice@student.edu', '+6012-3456789', '123', 5, NULL, NULL, 1, 0, '2026-05-05 09:19:59', '2026-05-05 09:19:59'),
(6, 'Ben', 'Lee', 'ben@student.edu', '+6012-9876543', '123', 5, '6.jpg', NULL, 1, 0, '2026-05-05 09:19:59', '2026-05-05 17:20:51'),
(7, 'Fan', 'Cheng', 'fancheng@yagums.maintenance.edu', NULL, '123', 3, NULL, NULL, 1, 0, '2026-05-17 13:14:44', '2026-05-17 13:52:15'),
(8, 'Hern', 'Xn', 'hernxn@yagums.student.edu', NULL, '123', 5, NULL, NULL, 1, 0, '2026-05-17 13:17:43', '2026-05-17 13:52:19'),
(9, 'Al', 'i', 'ali@yagums.student.edu', NULL, '123', 5, NULL, NULL, 1, 0, '2026-05-17 13:18:34', '2026-05-17 13:52:25'),
(10, 'Test', '1', 'test1@yagums.staff.edu', NULL, '123', 4, NULL, NULL, 1, 0, '2026-05-17 13:19:34', '2026-05-17 13:52:27'),
(11, 'test', '2', 'test2@yagums.admin.edu', NULL, '123', 1, NULL, NULL, 1, 0, '2026-05-17 13:48:53', '2026-05-17 13:52:30'),
(12, 'test', '3', 'test3@yagums.maintenance.edu', NULL, '123', 3, NULL, NULL, 1, 0, '2026-05-17 13:49:18', '2026-05-17 13:52:29');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD CONSTRAINT `fk_log_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `fk_ann_user` FOREIGN KEY (`posted_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `announcement_votes`
--
ALTER TABLE `announcement_votes`
  ADD CONSTRAINT `fk_vote_ann` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`announcement_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vote_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_status` FOREIGN KEY (`status_id`) REFERENCES `bookingstatus` (`status_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `facilities`
--
ALTER TABLE `facilities`
  ADD CONSTRAINT `fk_facility_type` FOREIGN KEY (`type_id`) REFERENCES `facilitytypes` (`type_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `maintenancerequests`
--
ALTER TABLE `maintenancerequests`
  ADD CONSTRAINT `fk_mreq_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mreq_status` FOREIGN KEY (`status_id`) REFERENCES `maintenancestatus` (`status_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mreq_user` FOREIGN KEY (`reported_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `maintenancetasks`
--
ALTER TABLE `maintenancetasks`
  ADD CONSTRAINT `fk_task_request` FOREIGN KEY (`request_id`) REFERENCES `maintenancerequests` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_task_user` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `maintenancetasks_ibfk_1` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
