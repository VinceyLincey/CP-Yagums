-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Mar 23, 2026 at 06:57 PM
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
  `user_id` int DEFAULT NULL,
  `facility_id` int DEFAULT NULL,
  `booking_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status_id` int DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `unique_booking` (`facility_id`,`booking_date`,`start_time`,`end_time`),
  KEY `fk_booking_user` (`user_id`),
  KEY `fk_booking_status` (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `user_id`, `facility_id`, `booking_date`, `start_time`, `end_time`, `status_id`) VALUES
(1, 1, 5, '2026-04-01', '10:00:00', '12:00:00', 2),
(2, 2, 5, '2026-04-01', '13:00:00', '15:00:00', 1),
(3, 3, 1, '2026-04-02', '09:00:00', '11:00:00', 2),
(4, 3, 2, '2026-04-03', '14:00:00', '16:00:00', 2),
(5, 1, 3, '2026-04-04', '18:00:00', '20:00:00', 3);

-- --------------------------------------------------------

--
-- Table structure for table `bookingstatus`
--

DROP TABLE IF EXISTS `bookingstatus`;
CREATE TABLE IF NOT EXISTS `bookingstatus` (
  `status_id` int NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
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
  `type_id` int DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`facility_id`),
  KEY `fk_facility_type` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `facilities`
--

INSERT INTO `facilities` (`facility_id`, `facility_name`, `type_id`, `capacity`, `location`) VALUES
(1, 'Lecture Hall A', 1, 120, 'Block A'),
(2, 'Computer Lab 1', 2, 40, 'Block B'),
(3, 'Basketball Court', 3, 50, 'Sports Complex'),
(4, 'Meeting Room 1', 4, 20, 'Admin Block'),
(5, 'Study Room 5', 5, 10, 'Library');

-- --------------------------------------------------------

--
-- Table structure for table `facilitytypes`
--

DROP TABLE IF EXISTS `facilitytypes`;
CREATE TABLE IF NOT EXISTS `facilitytypes` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `type_name` (`type_name`)
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
  `priority` varchar(20) DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `fk_request_facility` (`facility_id`),
  KEY `fk_request_user` (`reported_by`),
  KEY `fk_request_status` (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenancerequests`
--

INSERT INTO `maintenancerequests` (`request_id`, `facility_id`, `reported_by`, `description`, `priority`, `status_id`) VALUES
(1, 2, 1, 'Computers not working', 'High', 1),
(2, 1, 3, 'Projector malfunction', 'Medium', 2),
(3, 5, 2, 'Air conditioning issue', 'Low', 1);

-- --------------------------------------------------------

--
-- Table structure for table `maintenancestatus`
--

DROP TABLE IF EXISTS `maintenancestatus`;
CREATE TABLE IF NOT EXISTS `maintenancestatus` (
  `status_id` int NOT NULL AUTO_INCREMENT,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
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
  `completed` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`task_id`),
  KEY `fk_task_request` (`request_id`),
  KEY `fk_task_user` (`assigned_to`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenancetasks`
--

INSERT INTO `maintenancetasks` (`task_id`, `request_id`, `assigned_to`, `progress`, `completed`) VALUES
(1, 1, 4, 'Checking hardware components', 0),
(2, 2, 4, 'Projector repaired', 1),
(3, 3, 4, 'Inspection scheduled', 0);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`notification_id`),
  KEY `fk_notification_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `message`, `is_read`) VALUES
(1, 1, 'Your booking has been approved', 0),
(2, 2, 'Your booking is pending approval', 0),
(3, 3, 'Maintenance request updated', 1),
(4, 1, 'Maintenance request received', 0),
(5, 4, 'New maintenance task assigned', 0);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(3, 'Facility Manager'),
(2, 'Lecturer'),
(4, 'Maintenance Staff'),
(1, 'Student'),
(5, 'System Admin');

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
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_user_role` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `phone_number`, `password`, `role_id`) VALUES
(1, 'Alice', 'Tan', 'alice@student.edu', '+6012-3456789', '123', 1),
(2, 'Ben', 'Lee', 'ben@student.edu', '+6012-9876543', '123', 1),
(3, 'Dr.', 'Kumar', 'kumar@staff.edu', '+6013-1112222', '123', 2),
(4, 'Ms.', 'Lim', 'lim@admin.edu', '+6017-3334444', '123', 3),
(5, 'Ahmad', 'Rahman', 'ahmad@maintenance.edu', '+6019-5556666', '123', 4);

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

--
-- Constraints for table `facilities`
--
ALTER TABLE `facilities`
  ADD CONSTRAINT `fk_facility_type` FOREIGN KEY (`type_id`) REFERENCES `facilitytypes` (`type_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `maintenancerequests`
--
ALTER TABLE `maintenancerequests`
  ADD CONSTRAINT `fk_request_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_request_status` FOREIGN KEY (`status_id`) REFERENCES `maintenancestatus` (`status_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_request_user` FOREIGN KEY (`reported_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
