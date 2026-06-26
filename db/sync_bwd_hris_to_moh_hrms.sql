-- Sync bwd_hris schema to match moh_hrms master schema
-- Run this against the bwd_hris database

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

USE `bwd_hris`;

-- Remove table that exists only in bwd_hris
DROP TABLE IF EXISTS `bio_dtr`;

-- New tables from the master schema
CREATE TABLE IF NOT EXISTS `account_signup_audit_logs` (
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `personnel_id_code` varchar(100) DEFAULT NULL,
  `fname` varchar(120) DEFAULT NULL,
  `lname` varchar(120) DEFAULT NULL,
  `matched_personnel_id` int(11) DEFAULT NULL,
  `status` varchar(40) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `client_ip` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `personnel_file_audit_logs` (
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `action_name` varchar(100) NOT NULL,
  `actor_personnel_id` int(11) DEFAULT NULL,
  `actor_access` varchar(100) DEFAULT NULL,
  `target_personnel_id` int(11) NOT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `file_id` int(11) DEFAULT NULL,
  `action_details` text DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`audit_id`),
  KEY `idx_pfa_target_personnel` (`target_personnel_id`),
  KEY `idx_pfa_action_name` (`action_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `personnel_file_folders` (
  `folder_id` int(11) NOT NULL AUTO_INCREMENT,
  `personnel_id` int(11) NOT NULL,
  `folder_name` varchar(255) NOT NULL,
  `folder_slug` varchar(255) NOT NULL,
  `is_system_201` tinyint(1) NOT NULL DEFAULT 0,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`folder_id`),
  UNIQUE KEY `uq_personnel_folder_slug` (`personnel_id`,`folder_slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Align existing tables to master
ALTER TABLE `files`
  ADD COLUMN `folder_id` int(11) DEFAULT NULL AFTER `personnel_id`,
  ADD COLUMN `uploaded_by_personnel_id` int(11) DEFAULT NULL AFTER `folder_id`,
  ADD COLUMN `uploaded_by_access` varchar(100) DEFAULT NULL AFTER `uploaded_by_personnel_id`;

ALTER TABLE `leave_applications`
  ADD COLUMN `inclusive_dates_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JSON array of date ranges: [{"from": "YYYY-MM-DD", "to": "YYYY-MM-DD"}, ...]' CHECK (json_valid(`inclusive_dates_json`)) AFTER `inclusive_date_to`,
  ADD COLUMN `less_application_vl_without_pay` decimal(10,3) DEFAULT 0.000 COMMENT 'VL without pay deduction for this application' AFTER `less_application_vl`,
  ADD COLUMN `less_application_sl_without_pay` decimal(10,3) DEFAULT 0.000 COMMENT 'SL without pay deduction for this application' AFTER `less_application_vl_without_pay`;

ALTER TABLE `personnels`
  MODIFY `separation_date` varchar(10) DEFAULT NULL;

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;