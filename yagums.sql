-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 02, 2026 at 04:47 AM
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
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_logs`
--

INSERT INTO `admin_logs` (`log_id`, `admin_id`, `action`, `target_type`, `target_id`, `description`, `ip_address`, `created_at`) VALUES
(1, 1, 'LOGIN', NULL, NULL, 'Super Admin logged into the Admin Dashboard', '::1', '2026-03-30 17:24:16'),
(2, 1, 'CREATE', 'user', 2, 'Created: Haziq Ibrahim (haziq@yagums.edu)', '::1', '2026-04-01 09:01:00'),
(3, 1, 'CREATE', 'user', 3, 'Created: Priya Nair (priya.fm@yagums.edu)', '::1', '2026-04-01 09:02:00'),
(4, 1, 'CREATE', 'user', 4, 'Created: Ahmad Rahman (ahmad@maintenance.edu)', '::1', '2026-04-01 09:03:00'),
(5, 1, 'CREATE', 'user', 5, 'Created: Rajan Pillai (rajan@maintenance.edu)', '::1', '2026-04-01 09:04:00'),
(6, 1, 'CREATE', 'user', 6, 'Created: Nurul Huda (nurul@maintenance.edu)', '::1', '2026-04-01 09:05:00'),
(7, 1, 'CREATE', 'user', 7, 'Created: Dr. Kumar (kumar@staff.edu)', '::1', '2026-04-01 09:06:00'),
(8, 1, 'CREATE', 'user', 11, 'Created: Alice Tan (alice@student.edu)', '::1', '2026-04-01 09:07:00'),
(9, 1, 'CREATE', 'user', 12, 'Created: Ben Lee (ben@student.edu)', '::1', '2026-04-01 09:08:00'),
(10, 1, 'CREATE', 'user', 17, 'Created: Admin Wong (adminwong@yagums.edu)', '::1', '2026-04-01 09:09:00'),
(11, 2, 'APPROVE', 'booking', 2, 'Approved booking #2 — Meeting Room 1 (Alice Tan)', '::1', '2026-04-16 10:00:00'),
(12, 2, 'APPROVE', 'booking', 3, 'Approved booking #3 — Basketball Court (Alice Tan)', '::1', '2026-04-09 10:00:00'),
(13, 2, 'REJECT', 'booking', 4, 'Rejected booking #4 — Computer Lab 1 (Alice Tan)', '::1', '2026-03-28 14:00:00'),
(14, 2, 'APPROVE', 'booking', 21, 'Approved booking #21 — Lecture Hall A (Dr. Kumar)', '::1', '2026-04-26 09:00:00'),
(15, 1, 'ANNOUNCE', 'announcement', 1, 'Posted: \"Welcome to YAGUMS\"', NULL, '2026-03-30 17:24:16'),
(16, 1, 'ANNOUNCE', 'announcement', 2, 'Posted: \"Booking Policy — 24-Hour Rule\"', NULL, '2026-04-01 09:00:00'),
(17, 2, 'ANNOUNCE', 'announcement', 3, 'Posted: \"Computer Lab 1 — Temporarily Unavailable\"', NULL, '2026-04-20 09:00:00'),
(18, 1, 'ANNOUNCE', 'announcement', 9, 'Posted: \"System Maintenance — May 1st\"', NULL, '2026-04-26 09:00:00'),
(19, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-04-27 09:00:00'),
(20, 17, 'LOGIN', NULL, NULL, 'Admin Wong (Admin) logged in', '::1', '2026-04-27 10:00:00'),
(21, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '::1', '2026-04-28 23:18:05'),
(22, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-04-29 14:03:57'),
(23, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-04-30 22:09:34'),
(24, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '::1', '2026-04-30 22:09:35'),
(25, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-01 19:23:36'),
(26, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-01 19:23:41'),
(27, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-02 00:43:57'),
(28, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '::1', '2026-05-02 00:43:58'),
(29, 1, 'APPROVE', 'booking', 1, 'Approved booking #1 — Study Room 5', '::1', '2026-05-02 04:35:57'),
(30, 1, 'LOGIN', NULL, NULL, 'Super Admin opened the Admin Dashboard', '::1', '2026-05-02 05:20:02'),
(31, 1, 'APPROVE', 'booking', 37, 'Approved booking #37 — Study Room 6', '::1', '2026-05-02 20:03:02'),
(32, 1, 'REJECT', 'booking', 36, 'Rejected booking #36 — Science Lab A', '::1', '2026-05-02 20:03:37'),
(33, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-02 20:37:11'),
(34, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-02 21:03:44'),
(35, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-02 21:03:49'),
(36, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-02 21:03:58'),
(37, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-02 21:11:37'),
(38, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-02 21:14:21'),
(39, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-02 21:14:30'),
(40, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-02 21:24:44'),
(41, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-02 21:24:54'),
(42, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-03 02:32:27'),
(43, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-03 02:33:47'),
(44, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-03 02:38:56'),
(45, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-03 02:39:01'),
(46, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-03 02:52:48'),
(47, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-03 02:53:47'),
(48, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-03 03:18:45'),
(49, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-03 03:20:06'),
(50, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-03 03:32:31'),
(51, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-03 03:34:33'),
(52, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-03 16:32:45'),
(53, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-03 16:33:00'),
(54, 1, 'LOGIN', NULL, NULL, 'Super Admin (Admin) logged in', '::1', '2026-05-03 22:25:21'),
(55, 1, 'LOGOUT', NULL, NULL, 'Super Admin logged out', '::1', '2026-05-03 22:26:32'),
(56, 2, 'CREATE', 'facility', 13, 'Added facility: chem lab 123', '127.0.0.1', '2026-06-01 14:13:35');

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`announcement_id`, `posted_by`, `title`, `message`, `priority`, `upvotes`, `downvotes`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'Welcome to YAGUMS', 'YAGUMS is now officially live. Students and staff can book facilities, report maintenance issues, and stay updated through announcements.', 'low', 16, 0, 1, '2026-03-30 17:24:16', '2026-03-30 17:24:16'),
(2, 1, 'Booking Policy — 24-Hour Rule', 'All facility bookings must be submitted at least 24 hours before the intended session. Last-minute requests will be automatically declined.', 'high', 12, 0, 1, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(3, 2, 'Computer Lab 1 — Temporarily Unavailable', 'Computer Lab 1 is currently under maintenance. Expected to reopen by end of this week. We apologise for the inconvenience.', 'high', 9, 0, 1, '2026-04-20 09:00:00', '2026-04-20 09:00:00'),
(4, 2, 'Swimming Pool Now Open for Bookings', 'The Swimming Pool at the Sports Complex is now available for bookings. Capacity is 100 pax. Please bring your own swimming attire.', 'medium', 12, 0, 1, '2026-04-22 09:00:00', '2026-04-22 09:00:00'),
(5, 1, 'Library Study Rooms — Extended Hours', 'Study Rooms will be available from 7:00 AM to 11:00 PM daily during the examination period (April 28 – May 15).', 'medium', 10, 0, 1, '2026-04-24 09:00:00', '2026-04-24 09:00:00'),
(6, 2, 'Sports Complex Closure — This Saturday', 'The Sports Complex will be closed this Saturday from 6:00 AM to 12:00 PM for routine cleaning and equipment inspection.', 'medium', 8, 0, 1, '2026-04-25 09:00:00', '2026-04-25 09:00:00'),
(7, 1, 'Reminder: Report Maintenance Issues Promptly', 'If you notice any facility problems — broken equipment, leaks, electrical faults — please report them via the dashboard immediately.', 'low', 6, 0, 1, '2026-04-25 10:00:00', '2026-04-25 10:00:00'),
(8, 2, 'Lecture Hall B — New Projectors Installed', 'Lecture Hall B has been upgraded with 4K laser projectors. The installation is complete. Presenters should use HDMI connections.', 'low', 10, 0, 1, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(9, 1, 'System Maintenance — May 1st (2:00 AM - 4:00 AM)', 'YAGUMS will be unavailable on May 1st from 2:00 AM to 4:00 AM. Please complete urgent bookings before midnight on April 30th.', 'high', 5, 0, 1, '2026-04-26 09:00:00', '2026-04-26 09:00:00'),
(10, 2, 'Science Lab A — Updated Safety Protocols', 'Updated chemical safety protocols are now in effect for Science Lab A. All users must complete the online safety briefing before their first session.', 'medium', 4, 0, 1, '2026-04-27 09:00:00', '2026-04-27 09:00:00');

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
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `announcement_votes`
--

INSERT INTO `announcement_votes` (`vote_id`, `announcement_id`, `user_id`, `vote`, `created_at`) VALUES
(1, 1, 2, 'up', '2026-03-30 18:00:00'),
(2, 1, 3, 'up', '2026-03-30 18:00:00'),
(3, 1, 4, 'up', '2026-03-30 18:00:00'),
(4, 1, 5, 'up', '2026-03-30 18:00:00'),
(5, 1, 6, 'up', '2026-03-30 18:00:00'),
(6, 1, 7, 'up', '2026-03-30 18:00:00'),
(7, 1, 8, 'up', '2026-03-30 18:00:00'),
(8, 1, 9, 'up', '2026-03-30 18:00:00'),
(9, 1, 10, 'up', '2026-03-30 18:00:00'),
(10, 1, 11, 'up', '2026-03-30 18:00:00'),
(11, 1, 12, 'up', '2026-03-30 18:00:00'),
(12, 1, 13, 'up', '2026-03-30 18:00:00'),
(13, 1, 14, 'up', '2026-03-30 18:00:00'),
(14, 1, 15, 'up', '2026-03-30 18:00:00'),
(15, 1, 16, 'up', '2026-03-30 18:00:00'),
(16, 1, 17, 'up', '2026-03-30 18:00:00'),
(17, 2, 4, 'up', '2026-04-01 10:00:00'),
(18, 2, 5, 'up', '2026-04-01 10:00:00'),
(19, 2, 7, 'up', '2026-04-01 10:00:00'),
(20, 2, 8, 'up', '2026-04-01 10:00:00'),
(21, 2, 9, 'up', '2026-04-01 10:00:00'),
(22, 2, 11, 'up', '2026-04-01 10:00:00'),
(23, 2, 12, 'up', '2026-04-01 10:00:00'),
(24, 2, 13, 'up', '2026-04-01 10:00:00'),
(25, 2, 14, 'up', '2026-04-01 10:00:00'),
(26, 2, 15, 'up', '2026-04-01 10:00:00'),
(27, 2, 16, 'up', '2026-04-01 10:00:00'),
(28, 2, 17, 'up', '2026-04-01 10:00:00'),
(29, 3, 11, 'up', '2026-04-20 10:00:00'),
(30, 3, 12, 'up', '2026-04-20 10:00:00'),
(31, 3, 13, 'up', '2026-04-20 10:00:00'),
(32, 3, 14, 'up', '2026-04-20 10:00:00'),
(33, 3, 7, 'up', '2026-04-20 10:00:00'),
(34, 3, 8, 'up', '2026-04-20 10:00:00'),
(35, 3, 9, 'up', '2026-04-20 10:00:00'),
(36, 4, 2, 'up', '2026-04-22 10:00:00'),
(37, 4, 3, 'up', '2026-04-22 10:00:00'),
(38, 4, 4, 'up', '2026-04-22 10:00:00'),
(39, 4, 5, 'up', '2026-04-22 10:00:00'),
(40, 4, 6, 'up', '2026-04-22 10:00:00'),
(41, 4, 8, 'up', '2026-04-22 10:00:00'),
(42, 4, 11, 'up', '2026-04-22 10:00:00'),
(43, 4, 12, 'up', '2026-04-22 10:00:00'),
(44, 4, 13, 'up', '2026-04-22 10:00:00'),
(45, 4, 14, 'up', '2026-04-22 10:00:00'),
(46, 4, 15, 'up', '2026-04-22 10:00:00'),
(47, 4, 16, 'up', '2026-04-22 10:00:00'),
(48, 5, 7, 'up', '2026-04-24 10:00:00'),
(49, 5, 8, 'up', '2026-04-24 10:00:00'),
(50, 5, 9, 'up', '2026-04-24 10:00:00'),
(51, 5, 10, 'up', '2026-04-24 10:00:00'),
(52, 5, 11, 'up', '2026-04-24 10:00:00'),
(53, 5, 12, 'up', '2026-04-24 10:00:00'),
(54, 5, 13, 'up', '2026-04-24 10:00:00'),
(55, 5, 14, 'up', '2026-04-24 10:00:00'),
(56, 5, 15, 'up', '2026-04-24 10:00:00'),
(57, 5, 16, 'up', '2026-04-24 10:00:00'),
(58, 6, 11, 'up', '2026-04-25 10:00:00'),
(59, 6, 12, 'up', '2026-04-25 10:00:00'),
(60, 6, 13, 'up', '2026-04-25 10:00:00'),
(61, 6, 15, 'up', '2026-04-25 10:00:00'),
(62, 6, 16, 'up', '2026-04-25 10:00:00'),
(63, 6, 7, 'up', '2026-04-25 10:00:00'),
(64, 6, 8, 'up', '2026-04-25 10:00:00'),
(65, 6, 9, 'up', '2026-04-25 10:00:00'),
(66, 7, 11, 'up', '2026-04-25 11:00:00'),
(67, 7, 12, 'up', '2026-04-25 11:00:00'),
(68, 7, 13, 'up', '2026-04-25 11:00:00'),
(69, 7, 7, 'up', '2026-04-25 11:00:00'),
(70, 7, 9, 'up', '2026-04-25 11:00:00'),
(71, 7, 10, 'up', '2026-04-25 11:00:00'),
(72, 8, 7, 'up', '2026-04-26 09:00:00'),
(73, 8, 8, 'up', '2026-04-26 09:00:00'),
(74, 8, 9, 'up', '2026-04-26 09:00:00'),
(75, 8, 10, 'up', '2026-04-26 09:00:00'),
(76, 8, 11, 'up', '2026-04-26 09:00:00'),
(77, 8, 12, 'up', '2026-04-26 09:00:00'),
(78, 8, 13, 'up', '2026-04-26 09:00:00'),
(79, 8, 14, 'up', '2026-04-26 09:00:00'),
(80, 8, 15, 'up', '2026-04-26 09:00:00'),
(81, 8, 16, 'up', '2026-04-26 09:00:00'),
(82, 9, 7, 'up', '2026-04-26 10:00:00'),
(83, 9, 11, 'up', '2026-04-26 10:00:00'),
(84, 9, 12, 'up', '2026-04-26 10:00:00'),
(85, 9, 13, 'up', '2026-04-26 10:00:00'),
(86, 9, 14, 'up', '2026-04-26 10:00:00'),
(87, 9, 17, 'up', '2026-04-26 10:00:00'),
(88, 10, 7, 'up', '2026-04-27 10:00:00'),
(89, 10, 9, 'up', '2026-04-27 10:00:00'),
(90, 10, 14, 'up', '2026-04-27 10:00:00'),
(91, 10, 16, 'up', '2026-04-27 10:00:00');

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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `recurring_weeks` tinyint DEFAULT NULL,
  `recurring_group_id` bigint DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `uq_booking_slot` (`facility_id`,`booking_date`,`start_time`,`end_time`),
  KEY `fk_booking_user` (`user_id`),
  KEY `fk_booking_status` (`status_id`),
  KEY `idx_booking_date` (`booking_date`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `user_id`, `facility_id`, `booking_date`, `start_time`, `end_time`, `status_id`, `purpose`, `created_at`, `updated_at`, `recurring_weeks`, `recurring_group_id`) VALUES
(1, 11, 11, '2026-05-02', '10:00:00', '12:00:00', 2, 'Algorithms study group', '2026-04-27 10:00:00', '2026-05-02 04:35:57', NULL, NULL),
(2, 11, 9, '2026-04-20', '09:00:00', '10:00:00', 2, 'Group project meeting', '2026-04-15 09:00:00', '2026-04-16 10:00:00', NULL, NULL),
(3, 11, 7, '2026-04-10', '16:00:00', '18:00:00', 2, 'Basketball practice', '2026-04-08 09:00:00', '2026-04-09 10:00:00', NULL, NULL),
(4, 11, 4, '2026-03-28', '13:00:00', '15:00:00', 3, 'Programming lab', '2026-03-26 09:00:00', '2026-03-28 14:00:00', NULL, NULL),
(5, 11, 12, '2026-04-25', '08:00:00', '09:00:00', 1, 'Solo study session', '2026-04-26 10:00:00', '2026-04-26 10:00:00', NULL, NULL),
(6, 12, 12, '2026-05-04', '13:00:00', '15:00:00', 1, 'Group study — Data Structures', '2026-04-26 14:00:00', '2026-04-26 14:00:00', NULL, NULL),
(7, 12, 9, '2026-04-22', '10:00:00', '11:00:00', 2, 'Project presentation prep', '2026-04-20 10:00:00', '2026-04-21 10:00:00', NULL, NULL),
(8, 12, 7, '2026-04-08', '17:00:00', '19:00:00', 2, 'Basketball friendly match', '2026-04-06 10:00:00', '2026-04-07 10:00:00', NULL, NULL),
(9, 12, 1, '2026-03-25', '09:00:00', '11:00:00', 3, 'Seminar attendance', '2026-03-23 10:00:00', '2026-03-25 10:00:00', NULL, NULL),
(10, 13, 8, '2026-05-05', '07:00:00', '09:00:00', 1, 'Morning swim training', '2026-04-26 09:00:00', '2026-04-26 09:00:00', NULL, NULL),
(11, 13, 11, '2026-04-25', '14:00:00', '16:00:00', 2, 'Networks study session', '2026-04-23 10:00:00', '2026-04-24 10:00:00', NULL, NULL),
(12, 13, 10, '2026-05-09', '15:00:00', '16:00:00', 1, 'Club committee meeting', '2026-04-26 08:00:00', '2026-04-26 08:00:00', NULL, NULL),
(13, 14, 12, '2026-05-02', '13:00:00', '15:00:00', 1, 'Math revision', '2026-04-26 12:00:00', '2026-04-26 12:00:00', NULL, NULL),
(14, 14, 9, '2026-04-22', '13:00:00', '14:00:00', 2, 'Thesis discussion', '2026-04-20 11:00:00', '2026-04-21 11:00:00', NULL, NULL),
(15, 14, 6, '2026-04-03', '10:00:00', '12:00:00', 2, 'Chemistry experiment', '2026-04-01 09:00:00', '2026-04-02 10:00:00', NULL, NULL),
(16, 15, 11, '2026-04-24', '09:00:00', '10:00:00', 2, 'Solo reading', '2026-04-22 10:00:00', '2026-04-23 10:00:00', NULL, NULL),
(17, 15, 7, '2026-05-06', '14:00:00', '16:00:00', 1, 'Badminton practice', '2026-04-26 11:00:00', '2026-04-26 11:00:00', NULL, NULL),
(18, 15, 4, '2026-03-30', '14:00:00', '16:00:00', 3, 'Programming assignment', '2026-03-29 10:00:00', '2026-03-30 15:00:00', NULL, NULL),
(19, 16, 12, '2026-05-03', '12:00:00', '13:00:00', 1, 'Lunch study', '2026-04-26 13:00:00', '2026-04-26 13:00:00', NULL, NULL),
(20, 16, 6, '2026-04-16', '13:00:00', '15:00:00', 2, 'Physics lab', '2026-04-14 10:00:00', '2026-04-15 10:00:00', NULL, NULL),
(21, 7, 1, '2026-05-02', '09:00:00', '11:00:00', 2, 'CS301 Algorithms lecture', '2026-04-25 09:00:00', '2026-04-26 09:00:00', NULL, NULL),
(22, 7, 4, '2026-05-04', '14:00:00', '17:00:00', 1, 'Database lab session', '2026-04-26 10:00:00', '2026-04-26 10:00:00', NULL, NULL),
(23, 7, 9, '2026-04-20', '10:00:00', '11:00:00', 2, 'Department meeting', '2026-04-18 10:00:00', '2026-04-19 10:00:00', NULL, NULL),
(24, 7, 2, '2026-04-08', '08:00:00', '10:00:00', 2, 'Operating Systems lecture', '2026-04-06 09:00:00', '2026-04-07 09:00:00', NULL, NULL),
(25, 8, 2, '2026-05-01', '13:00:00', '15:00:00', 2, 'Mathematics tutorial', '2026-04-25 10:00:00', '2026-04-26 10:00:00', NULL, NULL),
(26, 8, 1, '2026-05-05', '09:00:00', '12:00:00', 1, 'Calculus lecture', '2026-04-26 08:00:00', '2026-04-26 08:00:00', NULL, NULL),
(27, 8, 10, '2026-04-19', '14:00:00', '15:00:00', 2, 'Faculty board meeting', '2026-04-17 10:00:00', '2026-04-18 10:00:00', NULL, NULL),
(28, 9, 6, '2026-05-03', '10:00:00', '12:00:00', 1, 'Chemistry lab class', '2026-04-26 09:00:00', '2026-04-26 09:00:00', NULL, NULL),
(29, 9, 2, '2026-04-09', '08:00:00', '10:00:00', 2, 'Chemistry 101 lecture', '2026-04-07 09:00:00', '2026-04-08 09:00:00', NULL, NULL),
(30, 9, 10, '2026-05-06', '13:00:00', '14:00:00', 1, 'Research committee', '2026-04-26 10:00:00', '2026-04-26 10:00:00', NULL, NULL),
(31, 10, 1, '2026-05-07', '14:00:00', '16:00:00', 1, 'EE201 Electronics lecture', '2026-04-26 11:00:00', '2026-04-26 11:00:00', NULL, NULL),
(32, 10, 4, '2026-04-17', '10:00:00', '13:00:00', 2, 'Circuits lab session', '2026-04-15 10:00:00', '2026-04-16 10:00:00', NULL, NULL),
(33, 11, 2, '2026-05-12', '10:00:00', '12:00:00', 1, 'Extra revision session', '2026-04-27 08:00:00', '2026-04-27 08:00:00', NULL, NULL),
(34, 12, 8, '2026-05-11', '06:00:00', '08:00:00', 1, 'Morning swim', '2026-04-27 08:30:00', '2026-04-27 08:30:00', NULL, NULL),
(35, 13, 1, '2026-05-13', '08:00:00', '10:00:00', 2, 'Entrepreneurship club', '2026-04-27 09:00:00', '2026-06-01 14:17:05', NULL, NULL),
(36, 7, 6, '2026-05-04', '10:00:00', '12:00:00', 3, 'Science lab class', '2026-04-27 09:30:00', '2026-05-02 20:03:37', NULL, NULL),
(37, 14, 12, '2026-05-10', '09:00:00', '11:00:00', 2, 'Guest lecture attendance', '2026-04-27 10:00:00', '2026-05-02 20:03:02', NULL, NULL),
(38, 15, 4, '2026-04-01', '14:00:00', '16:00:00', 3, 'Lab session', '2026-03-30 10:00:00', '2026-04-01 15:00:00', NULL, NULL),
(39, 16, 10, '2026-04-15', '10:00:00', '11:00:00', 3, 'Meeting', '2026-04-13 10:00:00', '2026-04-15 11:00:00', NULL, NULL),
(40, 11, 3, '2026-04-20', '16:00:00', '18:00:00', 3, 'Sports session', '2026-04-18 10:00:00', '2026-04-20 17:00:00', NULL, NULL),
(41, 7, 1, '2026-06-03', '09:00:00', '10:00:00', 1, 'testing 123', '2026-06-02 12:44:44', '2026-06-02 12:44:44', 2, 1780375484504),
(42, 7, 1, '2026-06-10', '09:00:00', '10:00:00', 1, 'testing 123', '2026-06-02 12:44:44', '2026-06-02 12:44:44', NULL, 1780375484504),
(43, 7, 1, '2026-06-17', '09:00:00', '10:00:00', 1, 'testing 123', '2026-06-02 12:44:44', '2026-06-02 12:44:44', NULL, 1780375484504);

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `facilities`
--

INSERT INTO `facilities` (`facility_id`, `facility_name`, `emoji`, `type_id`, `capacity`, `location`, `is_available`, `created_at`) VALUES
(1, 'Lecture Hall A', '🏛️', 1, 120, 'Block A, Level 1', 1, '2026-03-30 17:24:16'),
(2, 'Lecture Hall B', '🎓', 1, 100, 'Block A, Level 2', 1, '2026-04-01 09:00:00'),
(3, 'Lecture Hall C', '🏫', 1, 80, 'Block B, Level 1', 0, '2026-04-01 09:00:00'),
(4, 'Computer Lab 1', '💻', 2, 40, 'Block B, Level 2', 1, '2026-03-30 17:24:16'),
(5, 'Computer Lab 2', '🖥️', 2, 40, 'Block B, Level 3', 0, '2026-04-01 09:00:00'),
(6, 'Science Lab A', '🔬', 2, 30, 'Block C, Level 1', 1, '2026-04-01 09:00:00'),
(7, 'Basketball Court', '🏀', 3, 50, 'Sports Complex', 1, '2026-03-30 17:24:16'),
(8, 'Swimming Pool', '🏊', 3, 100, 'Sports Complex', 1, '2026-04-01 09:00:00'),
(9, 'Meeting Room 1', '🗂️', 4, 20, 'Admin Block, Level 1', 1, '2026-03-30 17:24:16'),
(10, 'Meeting Room 2', '📋', 4, 15, 'Admin Block, Level 2', 1, '2026-04-01 09:00:00'),
(11, 'Study Room 5', '📚', 5, 10, 'Library, Level 2', 1, '2026-03-30 17:24:16'),
(12, 'Study Room 6', '📖', 5, 8, 'Library, Level 3', 1, '2026-04-01 09:00:00'),
(13, 'chem lab 123', '🧪', 2, 20, 'Block C, level 2', 1, '2026-06-01 14:13:35');

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenancerequests`
--

INSERT INTO `maintenancerequests` (`request_id`, `facility_id`, `reported_by`, `description`, `priority`, `status_id`, `created_at`, `updated_at`) VALUES
(1, 4, 11, 'Computers showing blue screen on startup — lab unusable', 'High', 1, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(2, 7, 12, 'Basketball court floodlights out — dangerously dark at night', 'High', 2, '2026-04-20 09:00:00', '2026-04-22 09:00:00'),
(3, 1, 7, 'Projector makes grinding noise and image flickers badly', 'High', 2, '2026-04-18 09:00:00', '2026-04-22 09:00:00'),
(4, 8, 14, 'Swimming pool pump failure — water turning green, pool unsafe', 'High', 1, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(5, 6, 9, 'Chemical fume hood not functioning — lab cannot be used safely', 'High', 3, '2026-04-10 09:00:00', '2026-04-20 09:00:00'),
(6, 11, 11, 'Air conditioning making loud rattling noise', 'Medium', 1, '2026-04-24 09:00:00', '2026-04-24 09:00:00'),
(7, 9, 13, 'Whiteboard markers dried up — no replacement stock in room', 'Medium', 2, '2026-04-22 10:00:00', '2026-04-24 10:00:00'),
(8, 5, 12, 'Several workstations have stuck keyboards', 'Medium', 2, '2026-04-21 09:00:00', '2026-04-23 09:00:00'),
(9, 10, 15, 'Video conferencing camera not working in Meeting Room 2', 'Medium', 1, '2026-04-23 09:00:00', '2026-04-23 09:00:00'),
(10, 12, 16, 'Power sockets not providing power — cannot charge devices', 'Medium', 3, '2026-04-05 09:00:00', '2026-04-15 09:00:00'),
(11, 4, 13, 'Two workstations with faulty monitors — no display output', 'Medium', 1, '2026-04-25 09:00:00', '2026-04-25 09:00:00'),
(12, 11, 14, 'Window blind broken — cannot block afternoon sunlight', 'Low', 1, '2026-04-23 10:00:00', '2026-04-23 10:00:00'),
(13, 9, 7, 'One chair in Meeting Room 1 is wobbly and unsafe', 'Low', 2, '2026-04-18 10:00:00', '2026-04-20 10:00:00'),
(14, 7, 15, 'Basketball scoreboard shows incorrect time', 'Low', 3, '2026-04-01 09:00:00', '2026-04-10 09:00:00'),
(15, 12, 12, 'Study Room 6 door handle is loose — needs tightening', 'Low', 1, '2026-04-24 10:00:00', '2026-04-24 10:00:00'),
(16, 1, 10, 'Notice board cracked frame — sharp edges visible', 'Low', 2, '2026-04-20 10:00:00', '2026-04-22 10:00:00'),
(17, 6, 16, 'Sink drains very slowly during experiments', 'Low', 3, '2026-04-05 09:00:00', '2026-04-15 09:00:00'),
(18, 5, 11, 'Room number sign is faded and hard to read', 'Low', 1, '2026-04-24 10:00:00', '2026-04-24 10:00:00'),
(19, 8, 13, 'Lifeguard chair is cracked and needs replacement', 'Low', 2, '2026-04-16 09:00:00', '2026-04-22 09:00:00'),
(20, 3, 14, 'Lecture Hall C ceiling has water leak after heavy rain', 'High', 2, '2026-04-25 10:00:00', '2026-06-01 14:15:09');

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
  `progress` text,
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_id`),
  KEY `fk_task_request` (`request_id`),
  KEY `fk_task_user` (`assigned_to`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenancetasks`
--

INSERT INTO `maintenancetasks` (`task_id`, `request_id`, `assigned_to`, `progress`, `completed`, `created_at`, `updated_at`) VALUES
(1, 1, 4, NULL, 0, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(2, 1, 5, NULL, 0, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(3, 1, 6, NULL, 0, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(4, 2, 4, 'Ordered replacement LED fixtures — awaiting delivery', 0, '2026-04-20 09:00:00', '2026-04-22 09:00:00'),
(5, 2, 5, 'Temporary portable lights installed to keep court operational', 0, '2026-04-20 09:00:00', '2026-04-22 10:00:00'),
(6, 2, 6, 'Electrical wiring for new fixtures checked and cleared', 0, '2026-04-20 09:00:00', '2026-04-22 11:00:00'),
(7, 3, 4, 'Fan mechanism replaced — noise reduced, monitoring', 0, '2026-04-18 09:00:00', '2026-04-22 08:00:00'),
(8, 3, 5, 'Lamp housing cleaned, image stabilised', 0, '2026-04-18 09:00:00', '2026-04-22 09:00:00'),
(9, 3, 6, 'Tested under full lecture load — no grinding noise observed', 0, '2026-04-18 09:00:00', '2026-04-22 10:00:00'),
(10, 4, 4, NULL, 0, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(11, 4, 5, NULL, 0, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(12, 4, 6, NULL, 0, '2026-04-26 08:00:00', '2026-04-26 08:00:00'),
(13, 5, 4, 'Fume hood motor replaced and sealed', 1, '2026-04-10 09:00:00', '2026-04-18 09:00:00'),
(14, 5, 5, 'Electrical connections inspected and certified safe', 1, '2026-04-10 09:00:00', '2026-04-18 10:00:00'),
(15, 5, 6, 'Air flow performance tested and verified', 1, '2026-04-10 09:00:00', '2026-04-18 11:00:00'),
(16, 6, 4, NULL, 0, '2026-04-24 09:00:00', '2026-04-24 09:00:00'),
(17, 6, 5, NULL, 0, '2026-04-24 09:00:00', '2026-04-24 09:00:00'),
(18, 6, 6, NULL, 0, '2026-04-24 09:00:00', '2026-04-24 09:00:00'),
(19, 7, 4, 'Procurement request submitted for 50 marker sets', 0, '2026-04-22 10:00:00', '2026-04-24 09:00:00'),
(20, 7, 5, 'Interim supply from storeroom — 10 sets delivered to room', 0, '2026-04-22 10:00:00', '2026-04-24 10:00:00'),
(21, 7, 6, 'Permanent supply cabinet installed in room', 0, '2026-04-22 10:00:00', '2026-04-24 11:00:00'),
(22, 8, 4, 'Replacement keyboards ordered', 0, '2026-04-21 09:00:00', '2026-04-23 09:00:00'),
(23, 8, 5, 'Cleaned 3 keyboards — partially resolved', 0, '2026-04-21 09:00:00', '2026-04-23 10:00:00'),
(24, 8, 6, 'Swapped 2 keyboards with spares from storage', 0, '2026-04-21 09:00:00', '2026-04-23 11:00:00'),
(25, 10, 4, 'All 6 power sockets rewired and grounded correctly', 1, '2026-04-05 09:00:00', '2026-04-13 09:00:00'),
(26, 10, 5, 'Circuit breaker replaced — tripping issue resolved', 1, '2026-04-05 09:00:00', '2026-04-13 10:00:00'),
(27, 10, 6, 'Full load test completed — all sockets verified functional', 1, '2026-04-05 09:00:00', '2026-04-13 11:00:00'),
(28, 13, 4, 'Chair bracket tightened — monitoring for further movement', 0, '2026-04-18 10:00:00', '2026-04-20 09:00:00'),
(29, 13, 5, 'Replacement chair sourced from storage', 0, '2026-04-18 10:00:00', '2026-04-20 10:00:00'),
(30, 13, 6, 'User notified — chair now safe for use', 0, '2026-04-18 10:00:00', '2026-04-20 11:00:00'),
(31, 14, 4, 'Control board firmware updated — time display accurate', 1, '2026-04-01 09:00:00', '2026-04-08 09:00:00'),
(32, 14, 5, 'Remote control batteries replaced and paired', 1, '2026-04-01 09:00:00', '2026-04-08 10:00:00'),
(33, 14, 6, 'End-of-game test confirmed scoreboard working correctly', 1, '2026-04-01 09:00:00', '2026-04-08 11:00:00'),
(34, 17, 4, 'Drain pipe cleared of chemical residue build-up', 1, '2026-04-05 09:00:00', '2026-04-13 09:00:00'),
(35, 17, 5, 'P-trap cleaned and reinstalled with new seal', 1, '2026-04-05 09:00:00', '2026-04-13 10:00:00'),
(36, 17, 6, 'Drain tested under full flow — clears in under 5 seconds', 1, '2026-04-05 09:00:00', '2026-04-13 11:00:00'),
(37, 19, 4, 'Replacement chair on order — delivery expected next week', 0, '2026-04-16 09:00:00', '2026-04-22 08:00:00'),
(38, 19, 5, 'Cracked chair removed from poolside — using backup chair', 0, '2026-04-16 09:00:00', '2026-04-22 09:00:00'),
(39, 19, 6, 'Safety tape placed around old chair — hazard mitigated', 0, '2026-04-16 09:00:00', '2026-04-22 10:00:00'),
(40, 20, 6, 'check wiring 123 321', 0, '2026-06-01 14:15:09', '2026-06-01 14:15:09');

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
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `message`, `is_read`, `type`, `is_announcement`, `created_at`) VALUES
(1, 2, 'Welcome to YAGUMS! Your account has been created by the administrator.', 1, 'success', 0, '2026-04-01 09:00:00'),
(2, 3, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(3, 4, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(4, 5, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(5, 6, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(6, 7, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(7, 8, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(8, 9, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(9, 10, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(10, 11, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(11, 12, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-01 09:00:00'),
(12, 13, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-02 09:00:00'),
(13, 14, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-03 09:00:00'),
(14, 15, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-04 09:00:00'),
(15, 16, 'Welcome to YAGUMS! Your account has been created by the administrator.', 0, 'success', 0, '2026-04-05 09:00:00'),
(16, 11, 'Your booking for Meeting Room 1 on 2026-04-20 has been Approved.', 1, 'success', 0, '2026-04-16 10:00:00'),
(17, 11, 'Your booking for Basketball Court on 2026-04-10 has been Approved.', 1, 'success', 0, '2026-04-09 10:00:00'),
(18, 12, 'Your booking for Meeting Room 1 on 2026-04-22 has been Approved.', 1, 'success', 0, '2026-04-21 10:00:00'),
(19, 12, 'Your booking for Basketball Court on 2026-04-08 has been Approved.', 1, 'success', 0, '2026-04-07 10:00:00'),
(20, 13, 'Your booking for Study Room 5 on 2026-04-25 has been Approved.', 1, 'success', 0, '2026-04-24 10:00:00'),
(21, 14, 'Your booking for Science Lab A on 2026-04-03 has been Approved.', 1, 'success', 0, '2026-04-02 10:00:00'),
(22, 15, 'Your booking for Study Room 5 on 2026-04-24 has been Approved.', 1, 'success', 0, '2026-04-23 10:00:00'),
(23, 16, 'Your booking for Science Lab A on 2026-04-16 has been Approved.', 1, 'success', 0, '2026-04-15 10:00:00'),
(24, 7, 'Your booking for Lecture Hall A on 2026-05-02 has been Approved.', 0, 'success', 0, '2026-04-26 09:00:00'),
(25, 8, 'Your booking for Lecture Hall B on 2026-05-01 has been Approved.', 0, 'success', 0, '2026-04-26 10:00:00'),
(26, 11, 'Your booking for Study Room 5 on 2026-05-02 is pending approval.', 0, 'info', 0, '2026-04-27 10:00:00'),
(27, 12, 'Your booking for Study Room 6 on 2026-05-04 is pending approval.', 0, 'info', 0, '2026-04-26 14:00:00'),
(28, 13, 'Your booking for Swimming Pool on 2026-05-05 is pending approval.', 0, 'info', 0, '2026-04-26 09:00:00'),
(29, 7, 'Your booking for Computer Lab 1 on 2026-05-04 is pending approval.', 0, 'info', 0, '2026-04-26 10:00:00'),
(30, 2, 'New booking from Alice Tan for Study Room 5 on 2026-05-02.', 1, 'info', 0, '2026-04-27 10:00:00'),
(31, 3, 'New booking from Ben Lee for Study Room 6 on 2026-05-04.', 0, 'info', 0, '2026-04-26 14:00:00'),
(32, 2, 'New booking from Chong Wei for Swimming Pool on 2026-05-05.', 1, 'info', 0, '2026-04-26 09:00:00'),
(33, 11, 'Your booking for Computer Lab 1 has been Rejected.', 1, 'warning', 0, '2026-03-28 14:00:00'),
(34, 15, 'Your booking for Computer Lab 1 has been Rejected.', 1, 'warning', 0, '2026-04-01 15:00:00'),
(35, 11, 'Your booking for Basketball Court on 2026-04-20 has been Rejected.', 1, 'warning', 0, '2026-04-20 17:00:00'),
(36, 11, 'Your maintenance report for Computer Lab 1 has been submitted.', 0, 'info', 0, '2026-04-26 08:00:00'),
(37, 7, 'Your maintenance report for Lecture Hall A has been submitted.', 1, 'info', 0, '2026-04-18 09:00:00'),
(38, 7, 'Maintenance update for Lecture Hall A: fan replaced (In Progress)', 0, 'info', 0, '2026-04-22 08:00:00'),
(39, 9, 'Your maintenance request for Science Lab A has been completed.', 1, 'success', 0, '2026-04-18 09:00:00'),
(40, 14, 'Your maintenance report for Swimming Pool has been submitted.', 0, 'info', 0, '2026-04-26 08:00:00'),
(41, 4, 'New maintenance report — Computer Lab 1: computers blue screen.', 0, 'warning', 0, '2026-04-26 08:00:00'),
(42, 11, '📢 Welcome to YAGUMS', 1, 'announcement', 1, '2026-03-30 17:24:16'),
(43, 12, '📢 Welcome to YAGUMS', 1, 'announcement', 1, '2026-03-30 17:24:16'),
(44, 11, '📢 Booking Policy — 24-Hour Rule', 1, 'announcement', 1, '2026-04-01 09:00:00'),
(45, 12, '📢 Booking Policy — 24-Hour Rule', 0, 'announcement', 1, '2026-04-01 09:00:00'),
(46, 11, '📢 Library Study Rooms — Extended Hours', 0, 'announcement', 1, '2026-04-24 09:00:00'),
(47, 12, '📢 Library Study Rooms — Extended Hours', 0, 'announcement', 1, '2026-04-24 09:00:00'),
(48, 13, '📢 Library Study Rooms — Extended Hours', 0, 'announcement', 1, '2026-04-24 09:00:00'),
(49, 7, '📢 System Maintenance — May 1st', 0, 'announcement', 1, '2026-04-26 09:00:00'),
(50, 11, '📢 System Maintenance — May 1st', 0, 'announcement', 1, '2026-04-26 09:00:00'),
(51, 16, '📢 Sports Complex Closure — This Saturday', 0, 'announcement', 1, '2026-04-25 09:00:00'),
(52, 1, 'New booking request from Alice Tan for Study Room 5 on 2026-05-02.', 1, 'info', 0, '2026-04-27 10:00:00'),
(53, 1, 'New booking request from Chong Wei for Swimming Pool on 2026-05-05.', 1, 'info', 0, '2026-04-26 09:00:00'),
(54, 1, 'New maintenance report submitted — Computer Lab 1: computers blue screen.', 1, 'warning', 0, '2026-04-26 08:00:00'),
(55, 1, 'New maintenance report submitted — Swimming Pool: pump failure.', 1, 'warning', 0, '2026-04-26 08:30:00'),
(56, 1, 'New user registered: Chong Wei (chong.wei@student.edu)', 1, 'success', 0, '2026-04-02 09:00:00'),
(57, 1, 'New user registered: Divya Menon (divya@student.edu)', 1, 'success', 0, '2026-04-03 09:00:00'),
(58, 1, '📢 Welcome to YAGUMS', 1, 'announcement', 1, '2026-03-30 17:24:16'),
(59, 1, '📢 System Maintenance — May 1st', 1, 'announcement', 1, '2026-04-26 09:00:00'),
(60, 17, 'New booking request from Ben Lee for Study Room 6 on 2026-05-04.', 0, 'info', 0, '2026-04-26 14:00:00'),
(61, 17, 'New maintenance report submitted — Lecture Hall A: projector noise.', 1, 'warning', 0, '2026-04-18 09:00:00'),
(62, 17, 'New user registered: Faridah Zainal (faridah@student.edu)', 1, 'success', 0, '2026-04-04 09:00:00'),
(63, 17, '📢 Booking Policy — 24-Hour Rule', 1, 'announcement', 1, '2026-04-01 09:00:00'),
(64, 17, '📢 Library Study Rooms — Extended Hours', 0, 'announcement', 1, '2026-04-24 09:00:00'),
(65, 11, 'Your booking for Study Room 5 on 2026-05-02 has been Approved ✅.', 0, 'success', 0, '2026-05-02 04:35:57'),
(66, 14, 'Your booking for Study Room 6 on 2026-05-10 has been Approved ✅.', 0, 'success', 0, '2026-05-02 20:03:02'),
(67, 7, 'Your booking for Science Lab A on 2026-05-04 has been Rejected ❌.', 0, 'warning', 0, '2026-05-02 20:03:37'),
(68, 6, 'You have been assigned a maintenance task for Lecture Hall C: check wiring 123 321', 0, 'info', 0, '2026-06-01 14:15:09'),
(69, 13, 'Your booking for Lecture Hall A on 2026-05-13 has been Approved ✅.', 0, 'success', 0, '2026-06-01 14:17:05'),
(70, 7, '📅 Your booking for Lecture Hall A on 2026-06-03 is pending approval.', 0, 'info', 0, '2026-06-02 12:44:44'),
(71, 2, '📅 New booking request from Dr. Kumar for Lecture Hall A on 2026-06-03 — awaiting your approval.', 0, 'info', 0, '2026-06-02 12:44:44'),
(72, 3, '📅 New booking request from Dr. Kumar for Lecture Hall A on 2026-06-03 — awaiting your approval.', 0, 'info', 0, '2026-06-02 12:44:44');

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `phone_number`, `password`, `role_id`, `profile_picture`, `backup_code`, `is_active`, `is_protected`, `created_at`, `updated_at`) VALUES
(1, 'Super', 'Admin', 'admin@yagums.edu', NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '1.jpg', '$2y$10$1RnB1ju1YB3sFaNQmL3Lh.lTLi7D/0wPXntOrSUD2yKMI31q7k0AK', 1, 1, '2026-03-30 17:24:16', '2026-03-30 17:24:16'),
(2, 'Haziq', 'Ibrahim', 'haziq@yagums.edu', '+60161112222', '123', 2, '2.jpg', NULL, 1, 0, '2026-04-01 09:00:00', '2026-06-01 14:21:31'),
(3, 'Priya', 'Nair', 'priya.fm@yagums.edu', '+60173334444', '123', 2, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(4, 'Ahmad', 'Rahman', 'ahmad@maintenance.edu', '+60195556666', '123', 3, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(5, 'Rajan', 'Pillai', 'rajan@maintenance.edu', '+60127778888', '123', 3, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(6, 'Nurul', 'Huda', 'nurul@maintenance.edu', '+60139990000', '123', 3, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(7, 'Dr.', 'Kumar', 'kumar@staff.edu', '+60131112222', '123', 4, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(8, 'Prof.', 'Lim', 'lim@staff.edu', '+60143334444', '123', 4, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(9, 'Dr.', 'Azizah', 'azizah@staff.edu', '+60165556666', '123', 4, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(10, 'Mr.', 'Hassan', 'hassan@staff.edu', '+60177778888', '123', 4, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(11, 'Alice', 'Tan', 'alice@student.edu', '+60123456789', '123', 5, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(12, 'Ben', 'Lee', 'ben@student.edu', '+60129876543', '123', 5, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00'),
(13, 'Chong', 'Wei', 'chong.wei@student.edu', '+60181112222', '123', 5, NULL, NULL, 1, 0, '2026-04-02 09:00:00', '2026-04-02 09:00:00'),
(14, 'Divya', 'Menon', 'divya@student.edu', '+60193334444', '123', 5, NULL, NULL, 1, 0, '2026-04-03 09:00:00', '2026-04-03 09:00:00'),
(15, 'Faridah', 'Zainal', 'faridah@student.edu', '+60125556666', '123', 5, NULL, NULL, 1, 0, '2026-04-04 09:00:00', '2026-04-04 09:00:00'),
(16, 'Gopal', 'Krishnan', 'gopal@student.edu', '+60137778888', '123', 5, NULL, NULL, 1, 0, '2026-04-05 09:00:00', '2026-04-05 09:00:00'),
(17, 'Admin', 'Wong', 'adminwong@yagums.edu', '+60112345678', '123', 1, NULL, NULL, 1, 0, '2026-04-01 09:00:00', '2026-04-01 09:00:00');

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
  ADD CONSTRAINT `fk_task_user` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
