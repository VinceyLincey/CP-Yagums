-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 17, 2026 at 04:57 AM
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(11, 4, 5, '2026-06-13', '10:00:00', '11:00:00', 1, NULL, 1, 2147483647, '2026-05-17 02:50:57', '2026-05-17 02:50:57'),
(12, 4, 5, '2026-06-20', '10:00:00', '11:00:00', 1, NULL, NULL, 2147483647, '2026-05-17 02:50:57', '2026-05-17 02:50:57'),
(13, 4, 1, '2026-05-30', '10:00:00', '11:00:00', 1, NULL, 2, 2147483647, '2026-05-17 02:51:17', '2026-05-17 02:51:17'),
(14, 4, 1, '2026-06-06', '10:00:00', '11:00:00', 1, NULL, NULL, 2147483647, '2026-05-17 02:51:17', '2026-05-17 02:51:17'),
(15, 4, 1, '2026-06-13', '10:00:00', '11:00:00', 1, NULL, NULL, 2147483647, '2026-05-17 02:51:17', '2026-05-17 02:51:17');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_status` FOREIGN KEY (`status_id`) REFERENCES `bookingstatus` (`status_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
