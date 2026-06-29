-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2026 at 11:20 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bwd_hris`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_payroll_snapshot` (IN `p_run_id` INT)   BEGIN
    DECLARE v_snapshot_date DATE;
    DECLARE v_snapshot_id INT;
    
    SET v_snapshot_date = CURDATE();
    
    -- Generate overall snapshot
    INSERT INTO pr_tbl_payroll_snapshots 
        (run_id, snapshot_date, snapshot_type, group_by_value, group_by_label,
         personnel_count, total_gross, total_deductions, total_employer_share, total_net_pay,
         average_gross, average_net_pay, min_net_pay, max_net_pay)
    SELECT 
        p_run_id,
        v_snapshot_date,
        'overall',
        'ALL',
        'All Personnel',
        COUNT(*),
        SUM(gross_pay),
        SUM(total_deductions),
        SUM(total_employer_share),
        SUM(net_pay),
        AVG(gross_pay),
        AVG(net_pay),
        MIN(net_pay),
        MAX(net_pay)
    FROM pr_tbl_payroll_run_details
    WHERE run_id = p_run_id;
    
    SET v_snapshot_id = LAST_INSERT_ID();
    
    -- Generate department snapshots
    INSERT INTO pr_tbl_payroll_snapshots 
        (run_id, snapshot_date, snapshot_type, group_by_value, group_by_label,
         personnel_count, total_gross, total_deductions, total_employer_share, total_net_pay,
         average_gross, average_net_pay, min_net_pay, max_net_pay)
    SELECT 
        p_run_id,
        v_snapshot_date,
        'department',
        d.do_id,
        d.dept_office_name,
        COUNT(*),
        SUM(prd.gross_pay),
        SUM(prd.total_deductions),
        SUM(prd.total_employer_share),
        SUM(prd.net_pay),
        AVG(prd.gross_pay),
        AVG(prd.net_pay),
        MIN(prd.net_pay),
        MAX(prd.net_pay)
    FROM pr_tbl_payroll_run_details prd
    INNER JOIN personnels p ON prd.personnel_id = p.personnel_id
    INNER JOIN dept_offices d ON p.do_id = d.do_id
    WHERE prd.run_id = p_run_id
    GROUP BY d.do_id, d.dept_office_name;
    
    -- Generate income type summaries
    INSERT INTO pr_tbl_payroll_snapshot_items
        (snapshot_id, run_id, item_type, item_id, item_title, item_category,
         total_amount, personnel_count, average_amount, min_amount, max_amount)
    SELECT 
        v_snapshot_id,
        p_run_id,
        'income',
        income_id,
        income_title,
        income_type,
        SUM(amount),
        COUNT(DISTINCT personnel_id),
        AVG(amount),
        MIN(amount),
        MAX(amount)
    FROM pr_tbl_payroll_run_income
    WHERE run_id = p_run_id
    GROUP BY income_id, income_title, income_type;
    
    -- Generate deduction type summaries
    INSERT INTO pr_tbl_payroll_snapshot_items
        (snapshot_id, run_id, item_type, item_id, item_title, item_category,
         total_amount, personnel_count, average_amount, min_amount, max_amount)
    SELECT 
        v_snapshot_id,
        p_run_id,
        'deduction',
        deduction_id,
        deduction_title,
        deduction_type,
        SUM(employee_amount),
        COUNT(DISTINCT personnel_id),
        AVG(employee_amount),
        MIN(employee_amount),
        MAX(employee_amount)
    FROM pr_tbl_payroll_run_deductions
    WHERE run_id = p_run_id
    GROUP BY deduction_id, deduction_title, deduction_type;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account_signup_audit_logs`
--

CREATE TABLE `account_signup_audit_logs` (
  `audit_id` int(11) NOT NULL,
  `personnel_id_code` varchar(100) DEFAULT NULL,
  `fname` varchar(120) DEFAULT NULL,
  `lname` varchar(120) DEFAULT NULL,
  `matched_personnel_id` int(11) DEFAULT NULL,
  `status` varchar(40) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `client_ip` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `activity_calendar`
--

CREATE TABLE `activity_calendar` (
  `activity_id` int(11) NOT NULL,
  `actMM` varchar(2) NOT NULL,
  `actDD` varchar(2) NOT NULL,
  `actYYYY` varchar(4) NOT NULL,
  `completeDate` varchar(10) NOT NULL,
  `event_title` varchar(255) NOT NULL,
  `event_description` text NOT NULL,
  `act_type` varchar(55) NOT NULL,
  `status` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `backup_dbname`
--

CREATE TABLE `backup_dbname` (
  `backup_id` int(11) NOT NULL,
  `ID` varchar(12) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Date` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_computer`
--

CREATE TABLE `client_computer` (
  `client_id` int(11) NOT NULL,
  `ipAddress` varchar(20) NOT NULL,
  `compName` varchar(55) NOT NULL,
  `description` varchar(255) NOT NULL,
  `clientNumber` int(11) NOT NULL,
  `display_time` int(11) NOT NULL,
  `RFID_tag` varchar(55) NOT NULL,
  `announcement_img` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dept_offices`
--

CREATE TABLE `dept_offices` (
  `do_id` int(11) NOT NULL,
  `dept_office_name` varchar(255) NOT NULL,
  `officeHead_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `dept_offices`
--

INSERT INTO `dept_offices` (`do_id`, `dept_office_name`, `officeHead_id`) VALUES
(1, 'Administrative and Finance Division', 0),
(2, 'Commercial Division', 0),
(4, 'Operation Division', 0),
(5, 'Office of the General Manager', 0);

-- --------------------------------------------------------

--
-- Table structure for table `designation`
--

CREATE TABLE `designation` (
  `des_id` int(11) NOT NULL,
  `des_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `designation`
--

INSERT INTO `designation` (`des_id`, `des_name`) VALUES
(1, 'Customer Service Officer A'),
(2, 'Water Maintenance Man A'),
(3, 'General Manager C'),
(4, 'Cashier C'),
(5, 'Division Manager C (Commercial)'),
(6, 'Water Maintenance Man C'),
(7, 'Water Resources Facilities Operator A'),
(8, 'Water Maintenance Man B'),
(9, 'Engineering Aide A'),
(10, 'Water Resources Facilities Tender A'),
(11, 'Customer Service Assistant A'),
(12, 'Senior Water Maintenance Man A'),
(13, 'Water Resources Operator B'),
(14, 'Corporate Budget Specialist A'),
(15, 'Water Utilities Management  Officer B'),
(16, 'Water Utilities Facilities Operator A'),
(18, 'Water Resources Facilities Technician'),
(19, 'Water Maintenance Foreman'),
(20, 'Senior Corporate Account Analyst'),
(21, 'Water Resources Facilities Operator B'),
(22, 'Meter Reader/Maintenance'),
(23, 'Commercial Clerk'),
(24, 'Administrative and Finance Aide'),
(25, 'Pump Operator'),
(26, 'Maintenance Man'),
(27, 'Utility Worker'),
(28, 'Commercial Aide'),
(29, 'Industrial  Security Guard C');

-- --------------------------------------------------------

--
-- Table structure for table `emp_status`
--

CREATE TABLE `emp_status` (
  `empStat_id` int(11) NOT NULL,
  `emp_stat_name` varchar(255) NOT NULL,
  `position_class` varchar(55) NOT NULL,
  `status` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `emp_status`
--

INSERT INTO `emp_status` (`empStat_id`, `emp_stat_name`, `position_class`, `status`) VALUES
(1, 'Permanent', 'Career Positions', 'Active'),
(2, 'Resigned', 'Career Positions', 'Separated'),
(4, 'JOB ORDER', '-', 'Active'),
(5, 'CASUAL LABORERS', 'Non-Career Positions', 'Active'),
(6, 'COTERMINOUS', '-', '-');

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `file_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `uploaded_by_personnel_id` int(11) DEFAULT NULL,
  `uploaded_by_access` varchar(100) DEFAULT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `date_time_uploaded` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gass`
--

CREATE TABLE `gass` (
  `gass_id` int(11) NOT NULL,
  `gass_name` int(11) NOT NULL,
  `level` varchar(55) NOT NULL,
  `step` int(11) NOT NULL,
  `ratePerDay` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `gass`
--

INSERT INTO `gass` (`gass_id`, `gass_name`, `level`, `step`, `ratePerDay`) VALUES
(1, 8, 'First Level', 3, 22832.00),
(2, 16, 'Second Level', 2, 46152.00),
(3, 26, 'Executive / Managerial', 2, 133870.00),
(4, 4, 'First Level', 3, 17767.00),
(5, 4, 'First Level', 1, 17506.00),
(6, 5, 'First Level', 3, 18858.00),
(7, 3, 'First Level', 3, 16732.00),
(8, 8, 'First Level', 4, 23038.00),
(10, 16, 'Second Level', 1, 45694.00),
(11, 12, 'Second Level', 1, 33947.00),
(12, 22, 'Second Level', 2, 82963.00),
(13, 2, 'First Level', 1, 22432.00),
(14, 6, 'First Level', 1, 19716.00),
(15, 12, 'Second Level', 2, 34069.00),
(16, 5, 'First Level', 1, 18581.00),
(17, 5, 'First Level', 1, 18581.00),
(18, 5, 'First Level', 2, 18581.00),
(19, 5, 'First Level', 3, 18581.00),
(20, 5, 'First Level', 4, 18581.00),
(21, 5, 'First Level', 5, 18581.00),
(22, 5, 'First Level', 6, 18581.00),
(23, 5, 'First Level', 7, 18581.00),
(24, 5, 'First Level', 8, 18581.00),
(25, 18, 'Second Level', 1, 54371.00),
(26, 18, 'Second Level', 2, 54371.00),
(27, 18, 'Second Level', 3, 54371.00),
(28, 18, 'Second Level', 4, 54371.00),
(29, 18, 'Second Level', 5, 54371.00),
(30, 18, 'Second Level', 6, 54371.00),
(31, 18, 'Second Level', 7, 54371.00),
(32, 18, 'Second Level', 8, 54371.00),
(33, 14, 'Second Level', 1, 39141.00),
(34, 14, 'Second Level', 2, 39141.00),
(35, 14, 'Second Level', 3, 39141.00),
(36, 14, 'Second Level', 4, 39141.00),
(37, 14, 'Second Level', 5, 39141.00),
(38, 14, 'Second Level', 6, 39141.00),
(39, 14, 'Second Level', 7, 39141.00),
(40, 14, 'Second Level', 8, 39141.00),
(41, 11, 'Second Level', 1, 31820.00),
(42, 11, 'Second Level', 2, 31820.00),
(43, 11, 'Second Level', 3, 31820.00),
(44, 11, 'Second Level', 4, 31820.00),
(45, 11, 'Second Level', 5, 31820.00),
(46, 11, 'Second Level', 6, 31820.00),
(47, 11, 'Second Level', 7, 31820.00),
(48, 11, 'Second Level', 8, 31820.00),
(49, 15, 'Second Level', 1, 42178.00),
(50, 15, 'Second Level', 2, 42178.00),
(51, 15, 'Second Level', 3, 42178.00),
(52, 15, 'Second Level', 4, 42178.00),
(53, 15, 'Second Level', 5, 42178.00),
(54, 15, 'Second Level', 6, 42178.00),
(55, 15, 'Second Level', 7, 42178.00),
(56, 15, 'Second Level', 8, 42178.00),
(57, 4, 'First Level', 1, 17636.00),
(58, 4, 'First Level', 2, 17636.00),
(59, 4, 'First Level', 3, 17636.00),
(60, 4, 'First Level', 4, 17636.00),
(61, 4, 'First Level', 5, 17636.00),
(62, 4, 'First Level', 6, 17636.00),
(63, 4, 'First Level', 7, 17636.00),
(64, 4, 'First Level', 8, 17636.00),
(65, 6, 'First Level', 1, 19862.00),
(66, 6, 'First Level', 2, 19862.00),
(67, 6, 'First Level', 3, 19862.00),
(68, 6, 'First Level', 4, 19862.00),
(69, 6, 'First Level', 5, 19862.00),
(70, 6, 'First Level', 6, 19862.00),
(71, 6, 'First Level', 7, 19862.00),
(72, 6, 'First Level', 8, 19862.00),
(73, 1, 'First Level', 1, 14634.00),
(74, 1, 'First Level', 2, 14634.00),
(75, 1, 'First Level', 3, 14634.00),
(76, 1, 'First Level', 4, 14634.00),
(77, 1, 'First Level', 5, 14634.00),
(78, 1, 'First Level', 6, 14634.00),
(79, 1, 'First Level', 7, 14634.00),
(80, 1, 'First Level', 8, 14634.00);

-- --------------------------------------------------------

--
-- Table structure for table `institution_preferences`
--

CREATE TABLE `institution_preferences` (
  `id` int(11) NOT NULL,
  `zip_code` varchar(12) NOT NULL,
  `logo` varchar(255) NOT NULL,
  `region` varchar(255) NOT NULL,
  `division` varchar(255) NOT NULL,
  `institution_name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `emailAddress` varchar(255) NOT NULL,
  `contactNumber` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `institution_preferences`
--

INSERT INTO `institution_preferences` (`id`, `zip_code`, `logo`, `region`, `division`, `institution_name`, `address`, `emailAddress`, `contactNumber`) VALUES
(1, '6107', '21173-binalbagan-wd-logo.png', 'NIR', '5', 'BINALBAGAN WATER DISTRICT', 'BINALBAGAN, NEGROS OCCIDENTAL', 'binalbaganwater@yahoo.com', '(123) 456-7890');

-- --------------------------------------------------------

--
-- Table structure for table `lap_dates`
--

CREATE TABLE `lap_dates` (
  `lap_dates_id` int(11) NOT NULL,
  `lap_code` varchar(10) NOT NULL,
  `leave_date_mm` varchar(2) NOT NULL,
  `leave_date_dd` varchar(2) NOT NULL,
  `leave_date_yyyy` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_applicants`
--

CREATE TABLE `leave_applicants` (
  `lap_id` int(11) NOT NULL,
  `leave_code` varchar(55) NOT NULL,
  `leave_date` varchar(10) DEFAULT NULL,
  `leave_type` varchar(255) NOT NULL,
  `leave_type_desc` varchar(255) NOT NULL,
  `substitute_id` int(11) NOT NULL,
  `applicant_id` int(11) NOT NULL,
  `do_id` int(11) NOT NULL,
  `numDays` int(3) NOT NULL,
  `is_special` int(11) NOT NULL,
  `status` varchar(55) NOT NULL DEFAULT 'Pending',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_approved` varchar(10) DEFAULT NULL,
  `approved_by` int(11) NOT NULL,
  `leave_application_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_applications`
--

CREATE TABLE `leave_applications` (
  `id` int(11) NOT NULL,
  `leave_code` varchar(55) DEFAULT NULL,
  `personnel_id` int(11) NOT NULL,
  `office_agency` varchar(255) NOT NULL COMMENT 'Office/Agency/Department',
  `application_date` date NOT NULL COMMENT 'Date of filing',
  `leave_type` varchar(100) NOT NULL COMMENT 'Type of leave (Vacation, Sick, Maternity, etc.)',
  `other_leave_specification` varchar(255) DEFAULT NULL COMMENT 'Specification for "Others" leave type',
  `vacation_details` text DEFAULT NULL COMMENT 'Where vacation will be spent (within/abroad Philippines)',
  `sick_details` text DEFAULT NULL COMMENT 'Illness details or hospital name (in/out patient)',
  `study_details` text DEFAULT NULL COMMENT 'Study leave details (degree, university)',
  `inclusive_date_from` date NOT NULL COMMENT 'Start date of leave',
  `inclusive_date_to` date NOT NULL COMMENT 'End date of leave',
  `inclusive_dates_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JSON array of date ranges: [{"from": "YYYY-MM-DD", "to": "YYYY-MM-DD"}, ...]' CHECK (json_valid(`inclusive_dates_json`)),
  `number_of_days` decimal(5,2) NOT NULL COMMENT 'Number of working days applied for',
  `commutation` enum('requested','not_requested') DEFAULT 'not_requested' COMMENT 'Commutation request status',
  `as_of_date` date DEFAULT NULL COMMENT 'Date for leave credits certification',
  `total_earned_vl` decimal(10,3) DEFAULT 0.000 COMMENT 'Total Vacation Leave earned',
  `total_earned_sl` decimal(10,3) DEFAULT 0.000 COMMENT 'Total Sick Leave earned',
  `less_application_vl` decimal(10,3) DEFAULT 0.000 COMMENT 'VL deduction for this application',
  `less_application_vl_without_pay` decimal(10,3) DEFAULT 0.000 COMMENT 'VL without pay deduction for this application',
  `less_application_sl_without_pay` decimal(10,3) DEFAULT 0.000 COMMENT 'SL without pay deduction for this application',
  `less_application_sl` decimal(10,3) DEFAULT 0.000 COMMENT 'SL deduction for this application',
  `balance_vl` decimal(10,3) DEFAULT 0.000 COMMENT 'VL balance after application',
  `balance_sl` decimal(10,3) DEFAULT 0.000 COMMENT 'SL balance after application',
  `status` enum('pending','approved','disapproved') DEFAULT 'pending' COMMENT 'Application status',
  `recommendation` text DEFAULT NULL COMMENT 'Recommendation or remarks from authorized officer',
  `approved_by` int(11) DEFAULT NULL COMMENT 'User ID who approved/disapproved',
  `approved_date` datetime DEFAULT NULL COMMENT 'Date and time of approval/disapproval',
  `leave_card_entry_id` int(11) DEFAULT NULL COMMENT 'Linked leave_card entry ID (auto-created on approval)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CS Form No. 6 - Leave Applications';

-- --------------------------------------------------------

--
-- Table structure for table `leave_card`
--

CREATE TABLE `leave_card` (
  `id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `period_from` date DEFAULT NULL,
  `period_to` date DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  `vl_earned` decimal(13,3) NOT NULL,
  `vl_with_pay` decimal(13,3) NOT NULL,
  `vl_without_pay` decimal(13,3) NOT NULL,
  `sl_earned` decimal(13,3) NOT NULL,
  `sl_with_pay` decimal(13,3) NOT NULL,
  `sl_without_pay` decimal(13,3) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `is_special_leave` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Special leave indicator - no leave credit deductions',
  `created_from_application` tinyint(1) DEFAULT 0 COMMENT 'Auto-created from approved leave application',
  `date_from` date DEFAULT NULL COMMENT 'Leave start date',
  `date_to` date DEFAULT NULL COMMENT 'Leave end date',
  `number_of_days` decimal(5,2) DEFAULT NULL COMMENT 'Number of leave days'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_card`
--

INSERT INTO `leave_card` (`id`, `personnel_id`, `period_from`, `period_to`, `particulars`, `vl_earned`, `vl_with_pay`, `vl_without_pay`, `sl_earned`, `sl_with_pay`, `sl_without_pay`, `remarks`, `is_special_leave`, `created_from_application`, `date_from`, `date_to`, `number_of_days`) VALUES
(1, 681, '2026-05-01', '2026-05-31', 'Month of May 2026', 1.250, 0.000, 0.000, 1.250, 0.000, 0.000, 'Monthly Leave Credits', 0, 0, '2026-05-01', '2026-05-31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `monthly_leave_credits_log`
--

CREATE TABLE `monthly_leave_credits_log` (
  `id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `vl_earned` decimal(13,3) DEFAULT 1.250,
  `sl_earned` decimal(13,3) DEFAULT 1.250,
  `leave_card_id` int(11) DEFAULT NULL,
  `processed_date` datetime DEFAULT current_timestamp(),
  `processed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `monthly_leave_credits_log`
--

INSERT INTO `monthly_leave_credits_log` (`id`, `personnel_id`, `year`, `month`, `vl_earned`, `sl_earned`, `leave_card_id`, `processed_date`, `processed_by`) VALUES
(1, 681, 2026, 5, 1.250, 1.250, 1, '2026-06-15 14:58:09', 3);

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `news_id` int(11) NOT NULL,
  `news_title` varchar(255) NOT NULL,
  `news_contents` text NOT NULL,
  `dateTime` varchar(255) NOT NULL,
  `posted_by` varchar(255) NOT NULL,
  `ipAddress` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personnels`
--

CREATE TABLE `personnels` (
  `personnel_id` int(11) NOT NULL,
  `RFTag_id` varchar(25) NOT NULL,
  `personnel_id_code` varchar(25) NOT NULL,
  `shift_id` int(11) NOT NULL,
  `img` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `mname` varchar(255) NOT NULL,
  `suffix` varchar(5) NOT NULL,
  `age` int(11) NOT NULL,
  `sex` varchar(6) NOT NULL,
  `marital_status` varchar(15) NOT NULL,
  `bdMM` varchar(2) NOT NULL,
  `bdDD` varchar(2) NOT NULL,
  `bdYYYY` varchar(4) NOT NULL,
  `birth_place` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `personal_pnum` varchar(15) NOT NULL,
  `emergency_pnum` varchar(15) NOT NULL,
  `conPerson_lname` varchar(55) NOT NULL,
  `conPerson_fname` varchar(55) NOT NULL,
  `conPerson_mname` varchar(55) NOT NULL,
  `conPerson_relationship` varchar(55) NOT NULL,
  `do_id` int(11) NOT NULL,
  `des_id` int(11) NOT NULL,
  `sal_grade` int(11) NOT NULL,
  `sal_step` int(11) NOT NULL,
  `sal_level` int(11) NOT NULL,
  `rate_per_day` decimal(13,2) NOT NULL,
  `gass_id` int(11) NOT NULL,
  `empStat_id` int(11) NOT NULL,
  `eligibility` varchar(255) NOT NULL,
  `plantilla_num` varchar(25) NOT NULL,
  `appointment_date` varchar(10) NOT NULL,
  `separation_date` varchar(10) DEFAULT NULL,
  `num_of_yrs` int(11) NOT NULL,
  `tin_num` varchar(25) NOT NULL,
  `gsis_num` varchar(25) NOT NULL,
  `pagibig_num` varchar(25) NOT NULL,
  `philHealth_num` varchar(25) NOT NULL,
  `monthly_salary` decimal(14,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `personnels`
--

INSERT INTO `personnels` (`personnel_id`, `RFTag_id`, `personnel_id_code`, `shift_id`, `img`, `lname`, `fname`, `mname`, `suffix`, `age`, `sex`, `marital_status`, `bdMM`, `bdDD`, `bdYYYY`, `birth_place`, `address`, `email`, `personal_pnum`, `emergency_pnum`, `conPerson_lname`, `conPerson_fname`, `conPerson_mname`, `conPerson_relationship`, `do_id`, `des_id`, `sal_grade`, `sal_step`, `sal_level`, `rate_per_day`, `gass_id`, `empStat_id`, `eligibility`, `plantilla_num`, `appointment_date`, `separation_date`, `num_of_yrs`, `tin_num`, `gsis_num`, `pagibig_num`, `philHealth_num`, `monthly_salary`) VALUES
(677, 'NRF182B0', '01-064', 1, '', 'BAYONA', 'REA', 'CHAVEZ', '-', 31, 'Female', 'Married', '12', '20', '1994', 'SORSOGON, SORSOGON', 'JESUSA YULO, BRGY. SAN TO ROSARIO BINALBAGAN, NEGROS OCCIDENTAL', 'reachavez76@yahoo.com', '+639369507870', '+639166058696', 'CHAVEZ', 'ROMILA ', '', 'Parent', 2, 1, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-013', '  /  /    ', '  /  /    ', 0, '472-897-984', '2004-950-961', '121-172-066-632', '11-025515344-7', 10000.000),
(680, 'NRF69A0E', '023-03-006', 1, '', 'CLARENCE JUDE', 'CATALAN', 'MONTINOLA', '-', 27, 'Male', 'Single', '05', '09', '1999', 'BINALBAGAN, NEGROS OCCIDENTAL', 'NARRA CORNER MAHOGANY, MT. CARMEL BRGY. PROGRESO , BINALBAGAN, NEGROS OCCIDENTAL', 'clarencejudecatalan@gmail.com', '+639076566237', '+639166058738', ' CATALAN', 'REYNALDO', '', 'Parent', 1, 4, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-008', '  /  /    ', '  /  /    ', 0, '751-261-096', '2006-713-076', '121-322-975-069', '12-119756813-4', NULL),
(681, 'NRFAE57F', '021-02-022', 0, '', 'ROGRIGUEZ', 'RIO', 'VIGNO', 'JR.', 34, 'Male', 'Married', '03', '02', '1992', 'BINALBAGAN, NEGROS OCCIDENTAL', 'BRGY. ENCLARO BINALBAGAN, NEGROS OCCIDENTAL', 'riorodriguezjr@yahoo.com', '+639915392013', '+639163191920', 'RODRIGUEZ', 'CHRISE MARIE', 'BERMUDEZ', 'Spouse', 4, 15, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-020', '  /  /    ', '  /  /    ', 0, '466-197-521', '2005-863-183', '121-120-090-805', '11-050645693-2', NULL),
(682, 'NRFDC4D8', '003-12-001', 0, '', 'CHRISTOPHER', 'ARANDA', 'ELISAN', '-', 46, 'Male', 'Married', '01', '05', '1980', 'BINALBAGAN, NEGROS OCCIDENTAL', '3RD STREET BRGY. PROGRESO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639908395010', '+639924030214', 'ARANDA', 'MA. LOURDES', '', 'Spouse', 4, 2, 0, 0, 0, 0.00, 8, 1, '', 'BINALBAGANWD-2019-031', '  /  /    ', '  /  /    ', 0, '931-642-866', '2001-676-129', '110-000-788-465', '15-900030545-7', NULL),
(683, 'NRF03997', '992-01-002', 0, '', 'BAYLES', 'EUMARIE', 'TORRENTO', '-', 64, 'Male', 'Married', '01', '11', '1962', 'BACOLOD CITY, NEGROS OCCIDENTAL', 'VISTA ALEGRE BRGY. ENCLARO BINALBAGAN, NEGROS OCCIDENTAL', 'mbayles@yahoo.com', '+639         ', '+639         ', 'BAYLES', 'EMMILOU', '', '', 2, 1, 0, 0, 0, 0.00, 0, 1, '', '', '  /  /    ', '  /  /    ', 0, '156-724-691', '2001-676-153', '159-000-269-556', '11-000052710-6', NULL),
(684, 'NRF30327', '001-07-004', 0, '', 'CAÑON', 'ANGIE BLAISE', 'PIGAR', '-', 46, 'Female', 'Married', '02', '03', '1980', 'BINALBAGAN, NEGROS OCCIDENTAL', 'BLOCK 2, LOT 3 BABY\'S BREATH RPHS DC 2 BRGY. ALIJIS BACOLOD CITY, NEGROS OCCIDENTAL', 'angieblaise247@yahoo.com', '+639933865009', '+63994400922 ', 'CAÑON', 'CLARK', 'GADACA', 'Spouse', 5, 3, 0, 0, 0, 0.00, 0, 6, '', '', '  /  /    ', '  /  /    ', 0, '923-900-479', '2001-676-353', '159-000-305-735', '19-000795588-3', NULL),
(685, 'NRFE4CEB', '011-01-009', 0, '', 'GATPATAN', 'RHYAN', 'MANZANO', '-', 44, 'Male', 'Married', '12', '05', '1981', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PRK. NYLON SHELL BRGY, CANMOROS BINALBAGAN, NEGROS OCCIDENTAL', 'rhyangatpatan@gmail.com', '+639638809098', '+639997441063', 'GATPATAN', 'DIONA ', '', 'Spouse', 4, 7, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-027', '  /  /    ', '  /  /    ', 0, '933-825-169', '2004-086-133', '121-164-937-602', '11-000122148-5', NULL),
(686, 'NRF169A5', '011-01-008', 0, '', 'GAMPOSILAO', 'NARCISO', 'CALLAO', 'JR.', 51, 'Male', 'Married', '09', '16', '1974', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PRK. NYLON SHELL BRGY, CANMOROS BINALBAGAN, NEGROS OCCIDENTAL', '', '+639         ', '+639662635804', 'GAMPOSILAO', 'ROSALIA ', '', '', 4, 6, 0, 0, 0, 0.00, 0, 1, '', '', '  /  /    ', '  /  /    ', 0, '477-839-828', '2004-086-132', '121-164-936-283', '11-000123922-8', NULL),
(687, 'NRF00FC0', '009-07-010', 0, '', 'GEBELA', 'ARANTE ', 'CINCO', '-', 49, 'Male', 'Married', '06', '12', '1977', 'BRGY. AGUISAN HIMAMAYLAN CITY, NEGROS OCCIDENTAL', 'PRK. SEVERO BRGY. SANTO ROSARIO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639454264514', '+639         ', 'PARRENO', 'RIZZA ', '', '', 4, 6, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-035', '  /  /    ', '  /  /    ', 0, '938-370-065', '2003-956-817', '121-019-581-820', '11-000116101-6', NULL),
(688, 'NRF7A57F', '011-07-011', 0, '', 'GEMARINO', 'VIRGILIO', 'ESPAÑOLA', 'JR.', 39, 'Male', 'Married', '02', '24', '1987', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PUROK BONGAINVILLA BRGY., ENCLARO, BINALBAGAN NEGROS OCCIDENTAL', '', '+639102462841', '+639936416933', 'GEMARINO', 'LOVELLA', '', 'Spouse', 4, 8, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-033', '  /  /    ', '  /  /    ', 0, '929-990-020', '2004-129-046', '121-029-624-045', '11-000127277-2', NULL),
(689, 'NRFB73E7', '021-10-012', 0, '', 'GONZALES', 'JUN VINCENT', 'BASI', '-', 40, 'Male', 'Single', '03', '13', '1986', 'BINALBAGAN, NEGROS OCCIDENTAL', '6TH STREET BRGY. PAGLAUM BINALBAGAN, NEGROS OCCIDENTAL', 'junvincentgonzales@gmail.com', '+639120956935', '+639855215822', 'GONZALES', 'REBECCA', '', '', 4, 9, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-041', '  /  /    ', '  /  /    ', 0, '412-513-481', '2005-965-497', '121-166-476-476', '23-014500003-8', NULL),
(690, 'NRFB68A9', '005-08-013', 0, '', 'GOTERA', 'JUSTICE', 'GARZOLA', '-', 52, 'Male', 'Married', '02', '26', '1974', 'BINALBAGAN, NEGROS OCCIDENTAL', 'BLUMENTRIT ST. BRGY. STO. ROSARIO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639460762412', '+639941484581', 'GOTERA', 'MYLA', '', 'Spouse', 4, 10, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-039', '  /  /    ', '  /  /    ', 0, '932-003-094', '2003-956-819', '159-000-315-784', '11-000091064-3', NULL),
(691, 'NRF5741E', '010-03-014', 0, '', 'JORDAN', 'JACKEREN', 'ROTO', '-', 62, 'Female', 'Married', '09', '20', '1963', 'BINALBAGAN, NEGROS OCCIDENTAL', 'MAGNOLIA BRGY. SAN VICENTE BINALBAGAN, NEGROS', 'jackierj@yahoo.com', '+639210055386', '+639293871591', 'ROTO', 'NINITA ', '', 'Parent', 2, 11, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-031', '  /  /    ', '  /  /    ', 0, '933-306-248', '2004-086-134', '121-064-552-195', '11-000118006-1', NULL),
(692, 'NRF7212F', '005-08-015', 0, '', 'NACIONAL', 'EMMANUEL', 'GUINOO', '-', 63, 'Male', 'Married', '05', '09', '1963', 'BINALBAGAN, NEGROS OCCIDENTAL', 'HDA. YUSAY BRGY. SAN JUAN BINALBAGAN, NEGROS OCCIDENTAL', '', '+639300396532', '+639633031652', 'NACIONAL', 'MARY JEAN', '', 'Spouse', 1, 29, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-025', '  /  /    ', '  /  /    ', 0, '935-596-142', '2003-956-832', '159-000-315-795', '11-025069032-0', NULL),
(693, 'NRF66576', '009-07-016', 0, '', 'NORBE', 'JOSE', 'PIOLA', '-', 61, 'Male', 'Married', '02', '24', '1965', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PRK.4, BRGY. SAN JOSE BINALBAGAN, NEGROS OCCIDENTAL', '', '+639816455752', '+639816455752', 'NORBE', 'LORE MAE', '', 'Child', 4, 7, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-025', '  /  /    ', '  /  /    ', 0, '949-166-398', '2003-956-834', '121-027-755-053', '11-200699161-3', NULL),
(694, 'NRF9437F', '002-03-017', 0, '', 'OLMEDO', 'VINCENT', 'YULO', '-', 53, 'Male', 'Married', '08', '02', '1972', 'BINALBAGAN, NEGROS OCCIDENTAL', 'VILLA STA. MARIA BRGY. SANTO ROSARIO, BINALBAGAN, NEGROS OCCIDENTAL', 'olmedo_vincent@yahoo.com', '+639092786671', '+639171101412', '', '', '', 'Relative', 4, 12, 0, 0, 0, 0.00, 0, 1, '', '', '  /  /    ', '  /  /    ', 0, '927-327-169', '2001-676-308', '159-000-294-547', '19-000795585-9', NULL),
(695, 'NRF35EF9', '005-08-018', 0, '', 'OSORIO', 'RICK JOHN', 'AQUINO', '-', 46, 'Male', 'Married', '07', '31', '1979', 'BINALBAGAN, NEGROS OCCIDENTAL', 'CARMEN STREET, BRGY., SAN PEDRO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639         ', '+639996975173', ' OSORIO', 'ANNA LORRAINE', '', 'Spouse', 4, 12, 0, 0, 0, 0.00, 0, 1, '', '', '  /  /    ', '  /  /    ', 0, '934-892-119', '2003-956-836', '159-000-315-804', '11-000091065-1', NULL),
(696, 'NRFB8977', '011-01-019', 0, '', 'PADILLA', 'ROMEL', 'GARZOLA', '-', 44, 'Male', 'Married', '07', '29', '1981', 'SAN JOSE SIPALAY CITY, NEGROS OCCIDENTAL', 'PRK. AGUIHIS BRGY, CANMOROS BINALBAGAN, NEGROS OCCIDENTAL', 'romelpadilla29@gmail.com', '+639463184970', '+639692743724', 'PADILLA', 'KATHERINE', '', 'Spouse', 4, 13, 0, 0, 0, 0.00, 0, 0, '', 'BINALBAGANWD-2019-029', '  /  /    ', '  /  /    ', 0, '928-382-541', '2004-086-135', '121-015-331-515', '19-090557739-9', NULL),
(697, 'NRF97287', '011-07-020', 0, '', 'PINEDA', 'JOENEL', 'GAD', '-', 44, 'Male', 'Married', '09', '23', '1981', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PASCUAL FERMIZA BRGY. SANTOP ROSARIO BINALBAGAN, NEGROS OCCIDENTAL', 'jjoenilpineda81@gmail.com', '+639484521107', '+639190905577', 'PINEDA', 'MA. CORAZON', '', 'Spouse', 4, 10, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-040', '  /  /    ', '  /  /    ', 0, '411-490-105', '2004-129-045', '121-029-622-337', '11-201270225-9', NULL),
(698, 'NRF771F6', '983-07-021', 0, '', 'QUILANTANG', 'ROSEMARIE', 'JALME', '-', 64, 'Female', 'Married', '04', '11', '1962', 'JANIUAY, ILOILO CITY', '2ND STREET, PRK., CAMIA BRGY. PAGLAUM', '', '+639497073340', '+639622317952', 'QUILANTANG', 'BEN', '', 'Spouse', 1, 14, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-004', '  /  /    ', '  /  /    ', 0, '156-724-770', '1567-247-70 ', '159-000-270-013', '11-000052739-4', NULL),
(699, 'NRF37A2F', '055-08-023', 0, '', 'SALAZAR', 'DANILO', 'GUZMAN', '-', 56, 'Male', 'Married', '05', '09', '1970', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PRK,. INGKOY PALMA BRGY. SAN VICENTE BINALBAGAN, NEGROS OCCIDENTAL', '', '+639469830432', '+639285492164', 'SALAZAR', 'PORTIA', '', 'Spouse', 4, 18, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-030', '  /  /    ', '  /  /    ', 0, '923-497-864', '2003-956-839', '159-000-315-816', '11-000091078-3', NULL),
(700, 'NRF4A190', '020-01-025', 0, '', 'SALINAS', 'JENNY', 'PEDAN', '-', 28, 'Male', 'Single', '01', '12', '1998', 'HIMAMAYLAN CITY, NEGROS OCCIDENTAL', '1195 VITA CHOCO, BRGY., SAN VICENTE BINALBAGAN, NEGROS OCCIDENATL', 'sjhennaii@gmail.com', '+639126600719', '+639460292300', 'SALINAS', 'ALEX', '', 'Parent', 1, 20, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-006', '  /  /    ', '  /  /    ', 0, '460-292-300', '2005-754-432', '121-266-456-949', '11-025696937-8', NULL),
(701, 'NRFFE668', '005-08-024', 0, '', 'SARAD', 'ARLIE', 'MONCADA', '-', 53, 'Male', 'Married', '05', '19', '1973', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PRK. GREEN SHELL BRGY, CANMOROS BINALBAGAN, NEGROS OCCIDENTAL', '', '+639503850171', '+639093069905', 'SARAD', 'JOHN MICHAEL', '', 'Child', 4, 19, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-021', '  /  /    ', '  /  /    ', 0, '923-503-378', '2003-956-841', '159-000-315-827', '11-000091071-6', NULL),
(702, 'NRFDBD47', '002-09-026', 0, '', 'TALAVER', 'ELEUTERIO', 'GONZALES', 'JR.', 59, 'Male', 'Married', '08', '07', '1966', 'ISABELA, NEGROS OCCIDENTAL', 'VISTA ALEGRE BRGY. ENCLARO BINALBAGAN NEGROS OCCIDENTAL', '', '+639911858768', '+639266630128', 'TALAVER', 'ANA MARIETA', '', 'Spouse', 4, 7, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-029', '  /  /    ', '  /  /    ', 0, '429-709-417', '2001-676-151', '121-098-174-700', '19-000795594-8', NULL),
(703, 'NRF177A0', '007-08-027', 0, '', 'VAILOCES', 'NATHANIEL', 'PENDON', '-', 44, 'Male', 'Widowed', '12', '11', '1981', 'BINALBAGAN, NEGROS OCCIDENTAL', 'SITIO ALO, BRGYU. ENCLARO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639285492845', '+639567685270', 'VAILOCES', 'MARY LYNNIEL', '', '', 4, 10, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-038', '  /  /    ', '  /  /    ', 0, '944-530-801', '2003-956-845', '159-000-338-485', '11-000105012-5', NULL),
(704, 'NRF3AEB9', '011-01-028', 0, '', 'VERDE', 'ALADINON ARJOHN', 'AMANTILLO', '-', 47, 'Male', 'Single', '11', '28', '1978', 'BINALBAGAN, NEGROS OCCIDENTAL', 'BGRY. ENCLARO BINALBAGAN, NEGROS OCCIDENATAL', '', '+639503986920', '+639668839076', 'SAZON', 'SHERYL', '', '', 4, 6, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-036', '  /  /    ', '  /  /    ', 0, '466-316-470', '2004-086-136', '121-172-153-913', '11-000122149-3', NULL),
(705, 'NRF9D31E', '007-08-029', 0, '', 'VILLATURA', 'VOLTAIRE ANTHONY', 'SIM', '-', 57, 'Male', 'Married', '06', '13', '1969', 'CEBU CITY', '577 3RD STREET, BRGY. PROGRESO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639496268517', '+639497577270', 'VILLATURA', 'SHELYN', '', 'Spouse', 4, 21, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-028', '  /  /    ', '  /  /    ', 0, '919-733-283', '2003-956-847', '159-000-338-496', '11-000105111-7', NULL),
(706, 'NRFE028E', '025-07-032', 0, '', 'DEOCADES', 'JOY ', 'DIAZ', '-', 25, 'Female', 'Single', '12', '14', '2000', 'BACOLOD CITY, NEGROS OCCIDENTAL', '638 ADORADA PAGLAUM 1, BRGY. PAGLAUM BINALBAGAN, NEGROS OCCIDENTAL', 'jydiazdeocades@gmail.com', '+639454273825', '+639814071951', 'DINERO', 'LIAN ', 'DIAZ', 'Relative', 1, 24, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '627-685-774', '2006-713-076', '121-322-975-069', '11-251764056-8', NULL),
(707, 'NRF11B67', '025-07-031', 1, '', 'BALINDRES', 'ANALONA', 'FIGUEROA', '-', 44, 'Female', 'Single', '04', '27', '1982', 'BINALBAGAN, NEGROS OCCIDENTAL', 'ZONE 2, BRGY. BIAO, BINALBAGAN NEGROS OCCIDENTAL', 'balindresanalona@gmail.com', '+639276002499', '+639283048368', 'SALDE', 'ANA JEAN ', '', 'Relative', 2, 23, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '251-306-753', '2006-676-574', '121-096-720-05 ', '03-050307150-5', NULL),
(708, 'NRFA5384', '021-10-033', 1, '', 'DOCTO', 'RONNEL', 'TAJONERA', '-', 33, 'Male', 'Single', '12', '03', '1992', 'BINALBAGAN, NEGROS OCCIDENTAL', 'SITIO PASIL, BRGY. ENCALRO BINALBAGAN, NEGROS OCCIDENTAL', 'ronneldocto930@gmail.com', '+639153263506', '+639704621359', ' DOCTO', 'MICHAEL JOHN ', 'TAJONERA', 'Relative', 2, 22, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '508-676-553', '2005-965-493', '121-294-044-475', '11-251756813-1', NULL),
(709, 'NRF41560', '021-10-034', 0, '', 'MARTE', 'ROMELO', 'ZAMORA', '-', 42, 'Male', 'Married', '02', '12', '1984', 'BINALBAGAN, NEGROS OCCIDENTAL', 'ZONE 2, BRGY. PAYAO, BINALBAGAN NEGROS OCCIDENTAL', 'romelomarteg@yahoo.com', '+639123054635', '+639913808128', ' MARTE', 'NOEMI ', '', 'Spouse', 4, 25, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '946-202-776', '1120-266-067', '121-307-351-040', '11-202660677-5', NULL),
(710, 'NRF468E0', '021-10-035', 0, '', 'NACIONAL', 'JEFRANCE', 'YURO', '-', 37, 'Male', 'Married', '02', '17', '1989', 'BINALBAGAN, NEGROS OCCIDENTAL', 'BRGY. SANJUAN BINALBAGAN, NEGROS OCCIDENTAL', '', '+639128473488', '+639096425443', 'NACIONAL', 'RYNE NACIONA', '', 'Spouse', 2, 22, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '417-594-177', '2005-965-499', '121-293-818-851', '11-025515341-2', NULL),
(711, 'NRF12D80', '021-03-036', 0, '', 'NORBE', 'REYNALDO', 'PIOLA', '-', 63, 'Male', 'Single', '02', '06', '1963', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PRK. 4, BRGY. SAN JOSE BINALBAGAN, NEGROS OCCIDENTAL', '', '+639         ', '+639815650836', 'LOREMAE NORBE', 'LOREMAE ', '', 'Relative', 4, 25, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '943-501-701', '2005-898-365', '121-283-459-744', '11-050003240-5', NULL),
(712, 'NRFE9273', '011-07-037', 0, '', 'ORDANIEL', 'IVONNE REY', 'BANDIES', '-', 42, 'Male', 'Married', '09', '24', '1983', 'BINALBAGAN, NEGROS OCCIDENTAL', 'ZONE 6,BRGY. PAYAO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639074674507', '+639707516772', 'RENDON', 'JESSEL', '', 'Spouse', 4, 25, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '935-843-706', '2004-129-047', '121-029-622-303', '11-000127279-9', NULL),
(713, 'NRFE52AA', '021-10-038', 0, '', 'PADERES', 'JOHN MICHAEL', 'GEBELA', '-', 36, 'Male', 'Married', '12', '04', '1989', 'BINALBAGAN, NEGROS OCCIDENTAL', 'SAN GREGORIO STREET, BRGY. SANTO ROSARIO, BINALBAGAN NEGROS OCCIDENTAL', '', '+639076818742', '+639687081848', 'CASTOR', 'DAWN STAR ', '', '', 2, 22, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '500-037-657', '2005-965-501', '121-294-084-785', '11-025522585-5', NULL),
(714, 'NRFF7EBF', '011-07-039', 0, '', 'PAMEROYAN', 'CHRISTOPHER', 'GARPA', '-', 47, 'Male', 'Married', '09', '03', '1978', 'BRGY. AGUISAN HIMAMAYLAN CITY, NEGROS OCCIDENTAL', 'SITIO, PANTALAN BRGY. SANTO ROSARIO, BINALBAGAN, NEGROS OCCIDENTAL', '', '+639482577571', '+639947845841', 'PAMEROYAN', 'MARRITESS ', '', 'Spouse', 4, 25, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '298-877-531', '2004-129-042', '121-029-597-571', '11-201365981-0', NULL),
(715, 'NRF33BCE', '021-10-040', 0, '', 'YULO', 'ALLEN', 'CARPENTERO', '-', 38, 'Male', 'Married', '01', '13', '1988', 'BINALBAGAN, NEGROS OCCIDENTAL', 'CARMEN STREET, BRGY., PROGRESO BINALBAGAN, NEGROS OCCIDENTAL', '', '+639         ', '+639197369124', 'PINEDA', 'AMYJEAN ', '', 'Spouse', 4, 26, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '072-726-480', '2005-706-856', '121-299-053-333', '11-000141322-8', NULL),
(716, 'NRF4920B', '021-10-041', 0, '', 'YULO', 'JESUS', 'SEGUIDO', '-', 46, 'Male', 'Married', '09', '05', '1979', 'BINALBAGAN, NEGROS OCCIDENTAL', 'DON YULO STREET, BRGY. SAN PEDRO, BINALBAGAN NEGROS OCCIDENTAL', 'jesusgboyyulo@yahoo.com', '+639461127551', '+639214506513', ' YULO', 'MARY GRACE MICHELLE', '', 'Spouse', 4, 25, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '466-317-365', '2005-965-562', '121-305-699-146', '11-000141323-6', NULL),
(717, 'NRF8B433', '025-10-001', 0, '', 'ESPARAGOZA', 'FRITZ', 'CARBAQUIL', '-', 33, '', 'Single', '10', '22', '1992', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PRK. AGUIHIS BRGY, CANMOROS BINALBAGAN, NEGROS OCCIDENTAL', '', '+639812104718', '+639812104718', ' BUDIO', 'CRISSHA', '', 'Spouse', 4, 26, 0, 0, 0, 0.00, 0, 4, '', '', '  /  /    ', '  /  /    ', 0, '   -   -   ', '0736-519-687', '121-285-501-586', '11-025567979-1', NULL),
(718, 'NRFC6CFE', '025-10-002', 0, '', 'LACSON', 'JOHN IVAN ', 'PEROCHO', '-', 41, 'Male', 'Married', '07', '21', '1984', 'BINALBAGAN, NEGROS OCCIDENTAL', 'ZONE 2, BRGY. PAYAO, BINALBAGAN NEGROS OCCIDENTAL', '', '+639549808520', '+639278384561', 'LACSON', 'MARY JANE ', '', 'Spouse', 4, 25, 0, 0, 0, 0.00, 0, 4, '', '', '  /  /    ', '  /  /    ', 0, '456-276-348', '0746-560-082', '   -   -   -   ', '  -         - ', NULL),
(719, 'NRFBBFCA', '024-11-003', 0, '', 'PASTOR', 'JOHN SPENCER', 'MADRIGALEJO', '-', 27, 'Male', 'Single', '06', '25', '1998', 'HIMAMAYLAN CITY, NEGROS OCCIDENTAL', 'PUROK 7, BRGY. PALAYOG, HINIGARAN, NEGROS OCCIDENTAL', 'pastorjohnspencermadregalejo@gmail.com', '+639982155319', '+639516943418', 'PASTOR', 'GLENDA ', '', 'Parent', 2, 22, 0, 0, 0, 0.00, 0, 4, '', '', '  /  /    ', '  /  /    ', 0, '   -   -   ', '0744-707-795', '   -   -   -   ', '  -         - ', NULL),
(720, 'NRF03986', '024-11-004', 0, '', 'PERDENIA', 'JUNNIT', 'PITONG', '-', 33, 'Male', 'Single', '11', '09', '1992', 'BINALBAGAN, NEGROS OCCIDENTAL', '530 2ND STREET BRGY. PROGRESO BINALBAGAN, NEGROS OCCIDENTAL', 'perdeniajunnit@gmail.com', '+639157141937', '+639453855399', 'CUAYCONG', 'MELODY ', '', 'Spouse', 4, 26, 0, 0, 0, 0.00, 0, 4, '', '', '  /  /    ', '  /  /    ', 0, '   -   -   ', '0744-707-795', '   -   -   -   ', '  -         - ', NULL),
(721, 'NRF55320', '025-07-005', 0, '', 'SUANQUE', 'SURAYA', 'REYES', '-', 46, 'Female', 'Married', '05', '21', '1980', 'ISABELA, NEGROS OCCIDENTAL', 'PRK. PUNAW BRGY, CANMOROS BINALBAGAN, NEGROS OCCIDENTAL', '', '+639621262019', '+639543195345', 'SUANQUE', 'ADONIS ', '', 'Spouse', 1, 27, 0, 0, 0, 0.00, 0, 5, '', '', '  /  /    ', '  /  /    ', 0, '777-000-245', '3370-665-211', '   -   -   -   ', '21-050028037-3', NULL),
(722, 'NRFAF4DF', '025-10-006', 0, '', 'TORRENO', 'JEFFERSON', 'GERONAGA', '-', 28, 'Male', 'Single', '10', '31', '1997', 'BINALBAGAN, NEGROS OCCIDENTAL', 'KAUSWAGAN VILLAGE, BRGY. PROGRESO, BINALBAGAN, NEGROS OCCIDENTAL', 'geronagajp@gmail.com', '+639917441778', '+639481322983', 'TORRENO', 'CORAZON', 'GERONAGA', 'Parent', 2, 28, 0, 0, 0, 0.00, 0, 4, '', '', '  /  /    ', '  /  /    ', 0, '346-645-593', '0735-734-146', '121-198-450-651', '12-119845065-1', NULL),
(723, 'NRFF6974', '019-07-007', 0, '', 'TRANSFIERO', 'JUNAR', 'MAPARE', '-', 43, 'Male', '', '06', '13', '1983', 'BINALBAGAN, NEGROS OCCIDENTAL', 'SITIO PUCATOD, BRGY. PAYAO, BINALBAGAN, NEGROS OCCIDENTAL', '', '+639283210608', '+639852176144', 'CORDERO', 'FREYLN ', '', 'Spouse', 4, 25, 0, 0, 0, 0.00, 0, 4, '', '', '  /  /    ', '  /  /    ', 0, '932-195-367', '0734-194-855', '   -   -   -   ', '11-050285050-4', NULL),
(724, 'NRFD158E', '992-08-007', 0, '', 'COSAS', 'RUEL', 'ESPIRITU', '-', 59, 'Male', 'Married', '06', '09', '1967', 'BINALBAGAN, NEGROS OCCIDENTAL', 'PUROK PUNAY BRGY. PAGLAUM BINALBAGAN, NEGROS OCCIDENTAL', 'ruelcosas.1967@gmail.com', '+639283261401', '+639454077306', ' COSAS', 'JOHANNA ', '', 'Spouse', 2, 5, 0, 0, 0, 0.00, 0, 1, '', 'BINALBAGANWD-2019-011', '  /  /    ', '  /  /    ', 0, '156-724-705', '2001-676-302', '159-000-269-979', '11-000052724-6', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `personnel_educ_bg`
--

CREATE TABLE `personnel_educ_bg` (
  `eb_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `degree` varchar(55) NOT NULL,
  `course_details` varchar(255) NOT NULL,
  `units` int(5) NOT NULL,
  `year_grad` varchar(25) NOT NULL,
  `school_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `personnel_educ_bg`
--

INSERT INTO `personnel_educ_bg` (`eb_id`, `personnel_id`, `degree`, `course_details`, `units`, `year_grad`, `school_name`) VALUES
(1, 677, 'Masters', '', 0, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `personnel_fam_bg`
--

CREATE TABLE `personnel_fam_bg` (
  `fm_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `fullname` varchar(255) NOT NULL DEFAULT '-',
  `sex` varchar(6) NOT NULL DEFAULT '-',
  `relationship` varchar(55) NOT NULL DEFAULT '-',
  `contact_num` varchar(25) NOT NULL DEFAULT '-'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personnel_file_audit_logs`
--

CREATE TABLE `personnel_file_audit_logs` (
  `audit_id` int(11) NOT NULL,
  `action_name` varchar(100) NOT NULL,
  `actor_personnel_id` int(11) DEFAULT NULL,
  `actor_access` varchar(100) DEFAULT NULL,
  `target_personnel_id` int(11) NOT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `file_id` int(11) DEFAULT NULL,
  `action_details` text DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personnel_file_folders`
--

CREATE TABLE `personnel_file_folders` (
  `folder_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `folder_name` varchar(255) NOT NULL,
  `folder_slug` varchar(255) NOT NULL,
  `is_system_201` tinyint(1) NOT NULL DEFAULT 0,
  `date_created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `personnel_file_folders`
--

INSERT INTO `personnel_file_folders` (`folder_id`, `personnel_id`, `folder_name`, `folder_slug`, `is_system_201`, `date_created`) VALUES
(1, 707, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(2, 683, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(3, 677, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(4, 684, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(5, 682, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(6, 680, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(7, 724, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(8, 706, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(9, 708, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(10, 717, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(11, 686, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(12, 685, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(13, 687, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(14, 688, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(15, 689, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(16, 690, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(17, 691, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(18, 718, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(19, 709, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(20, 692, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(21, 710, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(22, 693, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(23, 711, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(24, 694, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(25, 712, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(26, 695, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(27, 713, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(28, 696, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(29, 714, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(30, 719, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(31, 720, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(32, 697, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(33, 698, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(34, 681, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(35, 699, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(36, 700, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(37, 701, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(38, 721, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(39, 702, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(40, 722, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(41, 723, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(42, 703, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(43, 704, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(44, 705, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(45, 715, '201-files', '201-files', 1, '2026-06-26 07:37:05'),
(46, 716, '201-files', '201-files', 1, '2026-06-26 07:37:05');

-- --------------------------------------------------------

--
-- Table structure for table `personnel_logs`
--

CREATE TABLE `personnel_logs` (
  `log_id` int(11) NOT NULL,
  `RFTag_id` varchar(55) NOT NULL,
  `img` varchar(255) NOT NULL,
  `captured_img` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `mname` varchar(255) NOT NULL,
  `suffix` varchar(5) NOT NULL,
  `do_id` int(12) NOT NULL,
  `shift_id` int(12) NOT NULL,
  `logDate` varchar(15) NOT NULL,
  `logTime` varchar(55) NOT NULL,
  `logTime_sec` int(11) NOT NULL,
  `late_status` varchar(3) NOT NULL,
  `logFlow` varchar(25) NOT NULL,
  `client_ip` varchar(25) NOT NULL,
  `remarks` varchar(55) NOT NULL,
  `travel_leave_code` varchar(55) NOT NULL,
  `ref_log_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personnel_official_travel_logs`
--

CREATE TABLE `personnel_official_travel_logs` (
  `travel_log_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `travel_code` varchar(55) NOT NULL,
  `purpose` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `travel_date` varchar(55) NOT NULL,
  `travel_type` varchar(55) NOT NULL,
  `numDays` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personnel_seminars`
--

CREATE TABLE `personnel_seminars` (
  `ps_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `seminar_title` varchar(255) NOT NULL,
  `seminar_desc` varchar(255) NOT NULL,
  `seminar_venue` varchar(255) NOT NULL,
  `event_date` varchar(10) NOT NULL,
  `entry_type` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_deductions`
--

CREATE TABLE `pr_tbl_deductions` (
  `deduction_id` int(11) NOT NULL,
  `deduction_type` varchar(55) DEFAULT NULL,
  `deduction_title` varchar(55) DEFAULT NULL,
  `is_deleted` tinyint(4) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_income`
--

CREATE TABLE `pr_tbl_income` (
  `income_id` int(11) NOT NULL,
  `income_type` varchar(55) DEFAULT NULL,
  `income_title` varchar(55) DEFAULT NULL,
  `is_deleted` tinyint(4) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_audit_log`
--

CREATE TABLE `pr_tbl_payroll_audit_log` (
  `audit_id` int(11) NOT NULL,
  `run_id` int(11) DEFAULT NULL,
  `detail_id` int(11) DEFAULT NULL,
  `action_type` enum('create','update','delete','approve','cancel','complete') NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `record_id` int(11) DEFAULT NULL,
  `field_name` varchar(100) DEFAULT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `performed_by` int(11) DEFAULT NULL COMMENT 'User who performed the action',
  `performed_at` datetime NOT NULL DEFAULT current_timestamp(),
  `ip_address` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Audit trail for all payroll changes';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_profiles`
--

CREATE TABLE `pr_tbl_payroll_profiles` (
  `profile_id` int(11) NOT NULL,
  `profile_name` varchar(100) NOT NULL COMMENT 'Template name (e.g., "Regular Monthly Payroll", "13th Month Pay")',
  `profile_description` text DEFAULT NULL COMMENT 'Detailed description of this template',
  `profile_type` enum('regular','special','13th_month','bonus','custom') NOT NULL DEFAULT 'regular',
  `pay_frequency` enum('monthly','semi-monthly','bi-weekly','weekly','one-time') NOT NULL DEFAULT 'monthly',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Is this the default profile for regular payroll?',
  `created_by` int(11) DEFAULT NULL COMMENT 'User who created this profile',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Payroll templates/profiles for easy cloning and reuse';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_profile_deductions`
--

CREATE TABLE `pr_tbl_payroll_profile_deductions` (
  `profile_deduction_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_profiles.profile_id',
  `deduction_id` int(11) NOT NULL COMMENT 'References pr_tbl_deductions.deduction_id',
  `default_employee_amt` decimal(10,2) DEFAULT NULL COMMENT 'Default employee amount',
  `default_employer_amt` decimal(10,2) DEFAULT NULL COMMENT 'Default employer amount',
  `amount_calculation` enum('fixed','percentage','formula','personnel_specific') NOT NULL DEFAULT 'personnel_specific',
  `calculation_base` varchar(50) DEFAULT NULL COMMENT 'For percentage: what to base on',
  `calculation_value` decimal(10,4) DEFAULT NULL COMMENT 'For percentage: the percentage value',
  `is_mandatory` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Deduction items included in payroll profiles';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_profile_filters`
--

CREATE TABLE `pr_tbl_payroll_profile_filters` (
  `filter_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL,
  `filter_type` enum('department','designation','emp_status','personnel','all') NOT NULL,
  `filter_value` varchar(50) NOT NULL COMMENT 'ID or "all"',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Define which personnel are included in profile';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_profile_income`
--

CREATE TABLE `pr_tbl_payroll_profile_income` (
  `profile_income_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_profiles.profile_id',
  `income_id` int(11) NOT NULL COMMENT 'References pr_tbl_income.income_id',
  `default_amount` decimal(10,2) DEFAULT NULL COMMENT 'Default amount (NULL = use personnel-specific amount)',
  `amount_calculation` enum('fixed','percentage','formula','personnel_specific') NOT NULL DEFAULT 'personnel_specific',
  `calculation_base` varchar(50) DEFAULT NULL COMMENT 'For percentage: what to base on (e.g., "basic_salary")',
  `calculation_value` decimal(10,4) DEFAULT NULL COMMENT 'For percentage: the percentage value',
  `is_mandatory` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Must this income be included?',
  `display_order` int(11) NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Income items included in payroll profiles';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_runs`
--

CREATE TABLE `pr_tbl_payroll_runs` (
  `run_id` int(11) NOT NULL,
  `profile_id` int(11) DEFAULT NULL COMMENT 'Profile used to generate this run',
  `run_name` varchar(150) NOT NULL COMMENT 'Payroll run name (e.g., "October 2025 Regular Payroll")',
  `run_type` enum('regular','special','13th_month','bonus','adjustment','custom') NOT NULL DEFAULT 'regular',
  `pay_period_start` date NOT NULL COMMENT 'Start of pay period',
  `pay_period_end` date NOT NULL COMMENT 'End of pay period',
  `payment_date` date DEFAULT NULL COMMENT 'Actual payment date',
  `run_status` enum('draft','pending','approved','processing','completed','cancelled') NOT NULL DEFAULT 'draft',
  `total_personnel` int(11) NOT NULL DEFAULT 0 COMMENT 'Total number of personnel in this run',
  `total_gross` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Total gross pay for all personnel',
  `total_deductions` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Total deductions (employee portion)',
  `total_employer_share` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Total employer contributions',
  `total_net_pay` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Total net pay for all personnel',
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT 'User who created this run',
  `approved_by` int(11) DEFAULT NULL COMMENT 'User who approved this run',
  `approved_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Payroll execution history - each row is one payroll run';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_run_deductions`
--

CREATE TABLE `pr_tbl_payroll_run_deductions` (
  `run_deduction_id` int(11) NOT NULL,
  `detail_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_run_details.detail_id',
  `run_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_runs.run_id',
  `personnel_id` varchar(50) NOT NULL,
  `deduction_id` int(11) NOT NULL COMMENT 'References pr_tbl_deductions.deduction_id',
  `deduction_title` varchar(100) NOT NULL COMMENT 'Snapshot of deduction name at time of run',
  `deduction_type` varchar(50) NOT NULL,
  `employee_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `employer_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Deduction breakdown snapshot for each payroll run';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_run_details`
--

CREATE TABLE `pr_tbl_payroll_run_details` (
  `detail_id` int(11) NOT NULL,
  `run_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_runs.run_id',
  `personnel_id` varchar(50) NOT NULL COMMENT 'References personnels.personnel_id',
  `gross_pay` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_deductions` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_employer_share` decimal(10,2) NOT NULL DEFAULT 0.00,
  `net_pay` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('pending','paid','hold','cancelled') NOT NULL DEFAULT 'pending',
  `payment_method` enum('bank_transfer','check','cash','other') DEFAULT NULL,
  `payment_reference` varchar(100) DEFAULT NULL COMMENT 'Check number, transaction ID, etc.',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Individual personnel records within each payroll run';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_run_income`
--

CREATE TABLE `pr_tbl_payroll_run_income` (
  `run_income_id` int(11) NOT NULL,
  `detail_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_run_details.detail_id',
  `run_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_runs.run_id',
  `personnel_id` varchar(50) NOT NULL,
  `income_id` int(11) NOT NULL COMMENT 'References pr_tbl_income.income_id',
  `income_title` varchar(100) NOT NULL COMMENT 'Snapshot of income name at time of run',
  `income_type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Income breakdown snapshot for each payroll run';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_snapshots`
--

CREATE TABLE `pr_tbl_payroll_snapshots` (
  `snapshot_id` int(11) NOT NULL,
  `run_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_runs.run_id',
  `snapshot_date` date NOT NULL COMMENT 'Date snapshot was generated',
  `snapshot_type` enum('department','designation','emp_status','income_type','deduction_type','overall') NOT NULL,
  `group_by_value` varchar(100) DEFAULT NULL COMMENT 'Department ID, Designation ID, etc.',
  `group_by_label` varchar(150) DEFAULT NULL COMMENT 'Department Name, Designation Name, etc.',
  `personnel_count` int(11) NOT NULL DEFAULT 0,
  `total_gross` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_deductions` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_employer_share` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_net_pay` decimal(15,2) NOT NULL DEFAULT 0.00,
  `average_gross` decimal(10,2) NOT NULL DEFAULT 0.00,
  `average_net_pay` decimal(10,2) NOT NULL DEFAULT 0.00,
  `min_net_pay` decimal(10,2) NOT NULL DEFAULT 0.00,
  `max_net_pay` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Aggregate payroll statistics for reporting and analysis';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_payroll_snapshot_items`
--

CREATE TABLE `pr_tbl_payroll_snapshot_items` (
  `snapshot_item_id` int(11) NOT NULL,
  `snapshot_id` int(11) NOT NULL COMMENT 'References pr_tbl_payroll_snapshots.snapshot_id',
  `run_id` int(11) NOT NULL,
  `item_type` enum('income','deduction') NOT NULL,
  `item_id` int(11) NOT NULL COMMENT 'income_id or deduction_id',
  `item_title` varchar(100) NOT NULL,
  `item_category` varchar(50) NOT NULL COMMENT 'income_type or deduction_type',
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `personnel_count` int(11) NOT NULL DEFAULT 0 COMMENT 'How many personnel have this item',
  `average_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `min_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `max_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Detailed breakdown of income/deductions in snapshots';

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_pay_pro_personnels`
--

CREATE TABLE `pr_tbl_pay_pro_personnels` (
  `ppp_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `payprofile_id` int(11) NOT NULL,
  `status` varchar(55) NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_personnel_deductions`
--

CREATE TABLE `pr_tbl_personnel_deductions` (
  `personnel_deduction_id` int(11) NOT NULL,
  `personnel_id` varchar(50) NOT NULL COMMENT 'References personnels.personnel_id',
  `deduction_id` int(11) NOT NULL COMMENT 'References pr_tbl_deductions.deduction_id',
  `employer_amt_per_pay` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Amount paid by employer per pay period',
  `employee_amt_per_pay` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Amount deducted from employee per pay period',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `user_id` int(11) DEFAULT NULL COMMENT 'User who created this record'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pr_tbl_personnel_income`
--

CREATE TABLE `pr_tbl_personnel_income` (
  `personnel_income_id` int(11) NOT NULL,
  `personnel_id` varchar(50) NOT NULL COMMENT 'References personnels.personnel_id',
  `income_id` int(11) NOT NULL COMMENT 'References pr_tbl_income.income_id',
  `amount_per_pay` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Amount paid per pay period',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `user_id` int(11) DEFAULT NULL COMMENT 'User who created this record'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Junction table: Links personnel to income types with amounts';

-- --------------------------------------------------------

--
-- Table structure for table `service_record`
--

CREATE TABLE `service_record` (
  `sr_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `maid_lname` varchar(55) NOT NULL,
  `maid_fname` varchar(55) NOT NULL,
  `maid_mname` varchar(55) NOT NULL,
  `appointDate_status` varchar(55) NOT NULL,
  `serv_date_from` varchar(10) NOT NULL,
  `serv_date_to` varchar(10) NOT NULL,
  `roa_designation` varchar(255) NOT NULL,
  `roa_status` varchar(255) NOT NULL,
  `monthly_salary` decimal(14,3) NOT NULL,
  `annual_salary` decimal(14,3) NOT NULL,
  `office_appointment` varchar(255) NOT NULL,
  `separate_date` varchar(10) NOT NULL,
  `separate_cause` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `service_record`
--

INSERT INTO `service_record` (`sr_id`, `personnel_id`, `maid_lname`, `maid_fname`, `maid_mname`, `appointDate_status`, `serv_date_from`, `serv_date_to`, `roa_designation`, `roa_status`, `monthly_salary`, `annual_salary`, `office_appointment`, `separate_date`, `separate_cause`) VALUES
(1, 677, 'Bayona', 'Rea', 'Chavez', '', '2026-01-10', '2026-02-25', 'Customer Service Officer A', 'Permanent', 10000.000, 120000.000, 'Commercial Division', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `shift_id` int(11) NOT NULL,
  `do_id` int(11) NOT NULL,
  `shift_name` varchar(255) NOT NULL,
  `type` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` (`shift_id`, `do_id`, `shift_name`, `type`) VALUES
(1, 2, 'Regular 8:00 a.m. - 5:00 p.m.', 'Regular Shift');

-- --------------------------------------------------------

--
-- Table structure for table `signatories_settings`
--

CREATE TABLE `signatories_settings` (
  `id` int(11) NOT NULL,
  `hrmo_name` varchar(255) DEFAULT NULL,
  `hrmo_position` varchar(255) DEFAULT 'Human Resource Management Officer',
  `recommending_name` varchar(255) DEFAULT NULL,
  `recommending_position` varchar(255) DEFAULT 'Immediate Supervisor',
  `approving_name` varchar(255) DEFAULT NULL,
  `approving_position` varchar(255) DEFAULT 'Regional Director',
  `monetization_constant` decimal(10,7) DEFAULT 0.0481927,
  `budget_officer_name` varchar(255) DEFAULT NULL,
  `budget_officer_position` varchar(255) DEFAULT 'Municipal Budget Officer',
  `treasurer_name` varchar(255) DEFAULT NULL,
  `treasurer_position` varchar(255) DEFAULT 'Acting Municipal Treasurer',
  `accountant_name` varchar(255) DEFAULT NULL,
  `accountant_position` varchar(255) DEFAULT 'Municipal Accountant',
  `mayor_name` varchar(255) DEFAULT NULL,
  `mayor_position` varchar(255) DEFAULT 'Municipal Mayor',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `signatories_settings`
--

INSERT INTO `signatories_settings` (`id`, `hrmo_name`, `hrmo_position`, `recommending_name`, `recommending_position`, `approving_name`, `approving_position`, `monetization_constant`, `budget_officer_name`, `budget_officer_position`, `treasurer_name`, `treasurer_position`, `accountant_name`, `accountant_position`, `mayor_name`, `mayor_position`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Human Resource Management Officer', NULL, 'Immediate Supervisor', NULL, 'Regional Director', 0.0481927, NULL, 'Municipal Budget Officer', NULL, 'Acting Municipal Treasurer', NULL, 'Municipal Accountant', NULL, 'Municipal Mayor', '2025-11-02 08:47:15', '2025-11-02 08:47:15'),
(2, NULL, 'Human Resource Management Officer', NULL, 'Immediate Supervisor', NULL, 'Regional Director', 0.0481927, NULL, 'Municipal Budget Officer', NULL, 'Acting Municipal Treasurer', NULL, 'Municipal Accountant', NULL, 'Municipal Mayor', '2025-11-02 08:50:03', '2025-11-02 08:50:03');

-- --------------------------------------------------------

--
-- Table structure for table `slides`
--

CREATE TABLE `slides` (
  `slide_id` int(11) NOT NULL,
  `img` varchar(255) NOT NULL,
  `sequence` int(11) NOT NULL,
  `status` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `slides`
--

INSERT INTO `slides` (`slide_id`, `img`, `sequence`, `status`) VALUES
(1, '4645-3879-for-the-lord-take-delight-in-his-people-he-crowns-the-humble-with-salvation-bible-quotes.jpg', 1, ''),
(2, '28966-7504-7.jpg', 2, ''),
(3, '89734-11700-13631-5.jpg', 3, ''),
(4, '27105-29176-1.jpg', 4, ''),
(5, '16958-72042-6.jpg', 5, ''),
(6, '96560-83175-3.jpg', 6, ''),
(7, '84030-80175-2.jpg', 7, ''),
(8, '77333-7504-7.jpg', 8, ''),
(9, '83077-29176-1.jpg', 9, ''),
(10, '99217-72042-6.jpg', 10, '');

-- --------------------------------------------------------

--
-- Table structure for table `time_schedules`
--

CREATE TABLE `time_schedules` (
  `schedule_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `day` varchar(15) NOT NULL,
  `am_IN` varchar(15) NOT NULL,
  `am_IN_co` varchar(15) NOT NULL,
  `am_OUT` varchar(15) NOT NULL,
  `am_OUT_co` varchar(15) NOT NULL,
  `pm_IN` varchar(15) NOT NULL,
  `pm_IN_co` varchar(15) NOT NULL,
  `pm_OUT` varchar(15) NOT NULL,
  `pm_OUT_co` varchar(15) NOT NULL,
  `do_id` int(11) NOT NULL,
  `shift_id` int(11) NOT NULL,
  `type` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `time_schedules`
--

INSERT INTO `time_schedules` (`schedule_id`, `school_id`, `day`, `am_IN`, `am_IN_co`, `am_OUT`, `am_OUT_co`, `pm_IN`, `pm_IN_co`, `pm_OUT`, `pm_OUT_co`, `do_id`, `shift_id`, `type`) VALUES
(1, 1, 'Monday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 1, 1, 'Regular Shift'),
(2, 1, 'Monday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 2, 1, 'Regular Shift'),
(3, 1, 'Tuesday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 1, 1, 'Regular Shift'),
(4, 1, 'Tuesday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 2, 1, 'Regular Shift'),
(5, 1, 'Wednesday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 1, 1, 'Regular Shift'),
(6, 1, 'Wednesday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 2, 1, 'Regular Shift'),
(7, 1, 'Thursday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 1, 1, 'Regular Shift'),
(8, 1, 'Thursday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 2, 1, 'Regular Shift'),
(9, 1, 'Friday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 1, 1, 'Regular Shift'),
(10, 1, 'Friday', '06:00 AM', '08:01 AM', '12:00 PM', '', '12:00 PM', '12:01 PM', '05:00 PM', '', 2, 1, 'Regular Shift');

-- --------------------------------------------------------

--
-- Table structure for table `travel_num_generator`
--

CREATE TABLE `travel_num_generator` (
  `pot_id` int(11) NOT NULL,
  `mm` varchar(2) NOT NULL,
  `sequence` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `travel_num_generator`
--

INSERT INTO `travel_num_generator` (`pot_id`, `mm`, `sequence`) VALUES
(1, '06', 0);

-- --------------------------------------------------------

--
-- Table structure for table `useraccount`
--

CREATE TABLE `useraccount` (
  `user_id` int(11) NOT NULL,
  `school_id` varchar(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `access` varchar(255) NOT NULL,
  `do_id` int(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `useraccount`
--

INSERT INTO `useraccount` (`user_id`, `school_id`, `personnel_id`, `fname`, `lname`, `email`, `username`, `password`, `access`, `do_id`) VALUES
(3, '1', 145, 'REA', 'BAYONA', '', 'admin', 'a1Bz20ydqelm8m1wql21232f297a57a5a743894a0e4a801fc3', 'Administrator', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_payroll_personnel_details`
-- (See below for the actual view)
--
CREATE TABLE `vw_payroll_personnel_details` (
`detail_id` int(11)
,`run_id` int(11)
,`run_name` varchar(150)
,`pay_period_start` date
,`pay_period_end` date
,`personnel_id` varchar(50)
,`personnel_name` text
,`dept_office_name` varchar(255)
,`designation_name` varchar(255)
,`gross_pay` decimal(10,2)
,`total_deductions` decimal(10,2)
,`total_employer_share` decimal(10,2)
,`net_pay` decimal(10,2)
,`payment_status` enum('pending','paid','hold','cancelled')
,`payment_method` enum('bank_transfer','check','cash','other')
,`payment_reference` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_payroll_run_summary`
-- (See below for the actual view)
--
CREATE TABLE `vw_payroll_run_summary` (
`run_id` int(11)
,`run_name` varchar(150)
,`run_type` enum('regular','special','13th_month','bonus','adjustment','custom')
,`pay_period_start` date
,`pay_period_end` date
,`payment_date` date
,`run_status` enum('draft','pending','approved','processing','completed','cancelled')
,`total_personnel` int(11)
,`total_gross` decimal(15,2)
,`total_deductions` decimal(15,2)
,`total_employer_share` decimal(15,2)
,`total_net_pay` decimal(15,2)
,`profile_name` varchar(100)
,`created_by_name` varchar(511)
,`approved_by_name` varchar(511)
,`approved_at` datetime
,`completed_at` datetime
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Table structure for table `yearly_dtr_summary`
--

CREATE TABLE `yearly_dtr_summary` (
  `yDTRs_id` int(11) NOT NULL,
  `personnel_id` int(11) NOT NULL,
  `ys_month` varchar(2) NOT NULL,
  `ys_year` varchar(4) NOT NULL,
  `day_present_AM` int(11) NOT NULL,
  `day_present_PM` int(11) NOT NULL,
  `day_present_Total` decimal(11,1) NOT NULL,
  `late_AM` int(11) NOT NULL,
  `late_PM` int(11) NOT NULL,
  `late_Total_num` int(11) NOT NULL,
  `late_Total_mins` int(11) NOT NULL,
  `late_Total_time` varchar(5) NOT NULL,
  `uTime_AM` int(11) NOT NULL,
  `uTime_PM` int(11) NOT NULL,
  `uTime_Total_num` int(11) NOT NULL,
  `uTime_Total_mins` int(11) NOT NULL,
  `uTime_Total_time` varchar(5) NOT NULL,
  `day_absent_AM` int(11) NOT NULL,
  `day_absent_PM` int(11) NOT NULL,
  `day_absent_Total` decimal(11,1) NOT NULL,
  `total_num_leave` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure for view `vw_payroll_personnel_details`
--
DROP TABLE IF EXISTS `vw_payroll_personnel_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_payroll_personnel_details`  AS SELECT `prd`.`detail_id` AS `detail_id`, `prd`.`run_id` AS `run_id`, `pr`.`run_name` AS `run_name`, `pr`.`pay_period_start` AS `pay_period_start`, `pr`.`pay_period_end` AS `pay_period_end`, `prd`.`personnel_id` AS `personnel_id`, concat(`p`.`fname`,' ',ifnull(concat(substr(`p`.`mname`,1,1),'. '),''),`p`.`lname`) AS `personnel_name`, `d`.`dept_office_name` AS `dept_office_name`, `des`.`des_name` AS `designation_name`, `prd`.`gross_pay` AS `gross_pay`, `prd`.`total_deductions` AS `total_deductions`, `prd`.`total_employer_share` AS `total_employer_share`, `prd`.`net_pay` AS `net_pay`, `prd`.`payment_status` AS `payment_status`, `prd`.`payment_method` AS `payment_method`, `prd`.`payment_reference` AS `payment_reference` FROM ((((`pr_tbl_payroll_run_details` `prd` join `pr_tbl_payroll_runs` `pr` on(`prd`.`run_id` = `pr`.`run_id`)) join `personnels` `p` on(`prd`.`personnel_id` = `p`.`personnel_id`)) left join `dept_offices` `d` on(`p`.`do_id` = `d`.`do_id`)) left join `designation` `des` on(`p`.`des_id` = `des`.`des_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_payroll_run_summary`
--
DROP TABLE IF EXISTS `vw_payroll_run_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_payroll_run_summary`  AS SELECT `pr`.`run_id` AS `run_id`, `pr`.`run_name` AS `run_name`, `pr`.`run_type` AS `run_type`, `pr`.`pay_period_start` AS `pay_period_start`, `pr`.`pay_period_end` AS `pay_period_end`, `pr`.`payment_date` AS `payment_date`, `pr`.`run_status` AS `run_status`, `pr`.`total_personnel` AS `total_personnel`, `pr`.`total_gross` AS `total_gross`, `pr`.`total_deductions` AS `total_deductions`, `pr`.`total_employer_share` AS `total_employer_share`, `pr`.`total_net_pay` AS `total_net_pay`, `pp`.`profile_name` AS `profile_name`, concat(`u1`.`fname`,' ',`u1`.`lname`) AS `created_by_name`, concat(`u2`.`fname`,' ',`u2`.`lname`) AS `approved_by_name`, `pr`.`approved_at` AS `approved_at`, `pr`.`completed_at` AS `completed_at`, `pr`.`created_at` AS `created_at` FROM (((`pr_tbl_payroll_runs` `pr` left join `pr_tbl_payroll_profiles` `pp` on(`pr`.`profile_id` = `pp`.`profile_id`)) left join `useraccount` `u1` on(`pr`.`created_by` = `u1`.`user_id`)) left join `useraccount` `u2` on(`pr`.`approved_by` = `u2`.`user_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_signup_audit_logs`
--
ALTER TABLE `account_signup_audit_logs`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indexes for table `activity_calendar`
--
ALTER TABLE `activity_calendar`
  ADD PRIMARY KEY (`activity_id`);

--
-- Indexes for table `backup_dbname`
--
ALTER TABLE `backup_dbname`
  ADD PRIMARY KEY (`backup_id`);

--
-- Indexes for table `client_computer`
--
ALTER TABLE `client_computer`
  ADD PRIMARY KEY (`client_id`);

--
-- Indexes for table `dept_offices`
--
ALTER TABLE `dept_offices`
  ADD PRIMARY KEY (`do_id`);

--
-- Indexes for table `designation`
--
ALTER TABLE `designation`
  ADD PRIMARY KEY (`des_id`);

--
-- Indexes for table `emp_status`
--
ALTER TABLE `emp_status`
  ADD PRIMARY KEY (`empStat_id`);

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`file_id`);

--
-- Indexes for table `gass`
--
ALTER TABLE `gass`
  ADD PRIMARY KEY (`gass_id`);

--
-- Indexes for table `institution_preferences`
--
ALTER TABLE `institution_preferences`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lap_dates`
--
ALTER TABLE `lap_dates`
  ADD PRIMARY KEY (`lap_dates_id`);

--
-- Indexes for table `leave_applicants`
--
ALTER TABLE `leave_applicants`
  ADD PRIMARY KEY (`lap_id`);

--
-- Indexes for table `leave_applications`
--
ALTER TABLE `leave_applications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_personnel_id` (`personnel_id`),
  ADD KEY `idx_application_date` (`application_date`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_leave_card_entry` (`leave_card_entry_id`);

--
-- Indexes for table `leave_card`
--
ALTER TABLE `leave_card`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_from_app` (`created_from_application`);

--
-- Indexes for table `monthly_leave_credits_log`
--
ALTER TABLE `monthly_leave_credits_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_personnel_month` (`personnel_id`,`year`,`month`),
  ADD KEY `idx_year_month` (`year`,`month`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `personnels`
--
ALTER TABLE `personnels`
  ADD PRIMARY KEY (`personnel_id`);

--
-- Indexes for table `personnel_educ_bg`
--
ALTER TABLE `personnel_educ_bg`
  ADD PRIMARY KEY (`eb_id`);

--
-- Indexes for table `personnel_fam_bg`
--
ALTER TABLE `personnel_fam_bg`
  ADD PRIMARY KEY (`fm_id`);

--
-- Indexes for table `personnel_file_audit_logs`
--
ALTER TABLE `personnel_file_audit_logs`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `idx_pfa_target_personnel` (`target_personnel_id`),
  ADD KEY `idx_pfa_action_name` (`action_name`);

--
-- Indexes for table `personnel_file_folders`
--
ALTER TABLE `personnel_file_folders`
  ADD PRIMARY KEY (`folder_id`),
  ADD UNIQUE KEY `uq_personnel_folder_slug` (`personnel_id`,`folder_slug`);

--
-- Indexes for table `personnel_logs`
--
ALTER TABLE `personnel_logs`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `personnel_official_travel_logs`
--
ALTER TABLE `personnel_official_travel_logs`
  ADD PRIMARY KEY (`travel_log_id`);

--
-- Indexes for table `personnel_seminars`
--
ALTER TABLE `personnel_seminars`
  ADD PRIMARY KEY (`ps_id`);

--
-- Indexes for table `pr_tbl_deductions`
--
ALTER TABLE `pr_tbl_deductions`
  ADD PRIMARY KEY (`deduction_id`);

--
-- Indexes for table `pr_tbl_income`
--
ALTER TABLE `pr_tbl_income`
  ADD PRIMARY KEY (`income_id`);

--
-- Indexes for table `pr_tbl_payroll_audit_log`
--
ALTER TABLE `pr_tbl_payroll_audit_log`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `idx_run_id` (`run_id`),
  ADD KEY `idx_detail_id` (`detail_id`),
  ADD KEY `idx_action_type` (`action_type`),
  ADD KEY `idx_table_name` (`table_name`),
  ADD KEY `idx_performed_at` (`performed_at`);

--
-- Indexes for table `pr_tbl_payroll_profiles`
--
ALTER TABLE `pr_tbl_payroll_profiles`
  ADD PRIMARY KEY (`profile_id`),
  ADD UNIQUE KEY `unique_profile_name` (`profile_name`),
  ADD KEY `idx_profile_type` (`profile_type`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_is_default` (`is_default`);

--
-- Indexes for table `pr_tbl_payroll_profile_deductions`
--
ALTER TABLE `pr_tbl_payroll_profile_deductions`
  ADD PRIMARY KEY (`profile_deduction_id`),
  ADD UNIQUE KEY `unique_profile_deduction` (`profile_id`,`deduction_id`),
  ADD KEY `idx_profile_id` (`profile_id`),
  ADD KEY `idx_deduction_id` (`deduction_id`),
  ADD KEY `idx_display_order` (`display_order`);

--
-- Indexes for table `pr_tbl_payroll_profile_filters`
--
ALTER TABLE `pr_tbl_payroll_profile_filters`
  ADD PRIMARY KEY (`filter_id`),
  ADD KEY `idx_profile_id` (`profile_id`),
  ADD KEY `idx_filter_type` (`filter_type`);

--
-- Indexes for table `pr_tbl_payroll_profile_income`
--
ALTER TABLE `pr_tbl_payroll_profile_income`
  ADD PRIMARY KEY (`profile_income_id`),
  ADD UNIQUE KEY `unique_profile_income` (`profile_id`,`income_id`),
  ADD KEY `idx_profile_id` (`profile_id`),
  ADD KEY `idx_income_id` (`income_id`),
  ADD KEY `idx_display_order` (`display_order`);

--
-- Indexes for table `pr_tbl_payroll_runs`
--
ALTER TABLE `pr_tbl_payroll_runs`
  ADD PRIMARY KEY (`run_id`),
  ADD KEY `idx_profile_id` (`profile_id`),
  ADD KEY `idx_run_status` (`run_status`),
  ADD KEY `idx_run_type` (`run_type`),
  ADD KEY `idx_pay_period` (`pay_period_start`,`pay_period_end`),
  ADD KEY `idx_payment_date` (`payment_date`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_run_status_date` (`run_status`,`pay_period_start`,`pay_period_end`);

--
-- Indexes for table `pr_tbl_payroll_run_deductions`
--
ALTER TABLE `pr_tbl_payroll_run_deductions`
  ADD PRIMARY KEY (`run_deduction_id`),
  ADD KEY `idx_detail_id` (`detail_id`),
  ADD KEY `idx_run_id` (`run_id`),
  ADD KEY `idx_personnel_id` (`personnel_id`),
  ADD KEY `idx_deduction_id` (`deduction_id`);

--
-- Indexes for table `pr_tbl_payroll_run_details`
--
ALTER TABLE `pr_tbl_payroll_run_details`
  ADD PRIMARY KEY (`detail_id`),
  ADD UNIQUE KEY `unique_run_personnel` (`run_id`,`personnel_id`),
  ADD KEY `idx_run_id` (`run_id`),
  ADD KEY `idx_personnel_id` (`personnel_id`),
  ADD KEY `idx_payment_status` (`payment_status`),
  ADD KEY `idx_detail_status` (`payment_status`,`run_id`);

--
-- Indexes for table `pr_tbl_payroll_run_income`
--
ALTER TABLE `pr_tbl_payroll_run_income`
  ADD PRIMARY KEY (`run_income_id`),
  ADD KEY `idx_detail_id` (`detail_id`),
  ADD KEY `idx_run_id` (`run_id`),
  ADD KEY `idx_personnel_id` (`personnel_id`),
  ADD KEY `idx_income_id` (`income_id`);

--
-- Indexes for table `pr_tbl_payroll_snapshots`
--
ALTER TABLE `pr_tbl_payroll_snapshots`
  ADD PRIMARY KEY (`snapshot_id`),
  ADD KEY `idx_run_id` (`run_id`),
  ADD KEY `idx_snapshot_type` (`snapshot_type`),
  ADD KEY `idx_snapshot_date` (`snapshot_date`),
  ADD KEY `idx_group_by` (`snapshot_type`,`group_by_value`),
  ADD KEY `idx_snapshot_run_type` (`run_id`,`snapshot_type`);

--
-- Indexes for table `pr_tbl_payroll_snapshot_items`
--
ALTER TABLE `pr_tbl_payroll_snapshot_items`
  ADD PRIMARY KEY (`snapshot_item_id`),
  ADD KEY `idx_snapshot_id` (`snapshot_id`),
  ADD KEY `idx_run_id` (`run_id`),
  ADD KEY `idx_item_type` (`item_type`),
  ADD KEY `idx_item_id` (`item_id`);

--
-- Indexes for table `pr_tbl_pay_pro_personnels`
--
ALTER TABLE `pr_tbl_pay_pro_personnels`
  ADD PRIMARY KEY (`ppp_id`);

--
-- Indexes for table `pr_tbl_personnel_deductions`
--
ALTER TABLE `pr_tbl_personnel_deductions`
  ADD PRIMARY KEY (`personnel_deduction_id`),
  ADD UNIQUE KEY `unique_personnel_deduction` (`personnel_id`,`deduction_id`),
  ADD KEY `idx_personnel_id` (`personnel_id`),
  ADD KEY `idx_deduction_id` (`deduction_id`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indexes for table `pr_tbl_personnel_income`
--
ALTER TABLE `pr_tbl_personnel_income`
  ADD PRIMARY KEY (`personnel_income_id`),
  ADD UNIQUE KEY `unique_personnel_income` (`personnel_id`,`income_id`),
  ADD KEY `idx_personnel_id` (`personnel_id`),
  ADD KEY `idx_income_id` (`income_id`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indexes for table `service_record`
--
ALTER TABLE `service_record`
  ADD PRIMARY KEY (`sr_id`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`shift_id`);

--
-- Indexes for table `signatories_settings`
--
ALTER TABLE `signatories_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `slides`
--
ALTER TABLE `slides`
  ADD PRIMARY KEY (`slide_id`);

--
-- Indexes for table `time_schedules`
--
ALTER TABLE `time_schedules`
  ADD PRIMARY KEY (`schedule_id`);

--
-- Indexes for table `travel_num_generator`
--
ALTER TABLE `travel_num_generator`
  ADD PRIMARY KEY (`pot_id`);

--
-- Indexes for table `useraccount`
--
ALTER TABLE `useraccount`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `yearly_dtr_summary`
--
ALTER TABLE `yearly_dtr_summary`
  ADD PRIMARY KEY (`yDTRs_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_signup_audit_logs`
--
ALTER TABLE `account_signup_audit_logs`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `activity_calendar`
--
ALTER TABLE `activity_calendar`
  MODIFY `activity_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `backup_dbname`
--
ALTER TABLE `backup_dbname`
  MODIFY `backup_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_computer`
--
ALTER TABLE `client_computer`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dept_offices`
--
ALTER TABLE `dept_offices`
  MODIFY `do_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `designation`
--
ALTER TABLE `designation`
  MODIFY `des_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `emp_status`
--
ALTER TABLE `emp_status`
  MODIFY `empStat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `file_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gass`
--
ALTER TABLE `gass`
  MODIFY `gass_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `institution_preferences`
--
ALTER TABLE `institution_preferences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `lap_dates`
--
ALTER TABLE `lap_dates`
  MODIFY `lap_dates_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_applicants`
--
ALTER TABLE `leave_applicants`
  MODIFY `lap_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_applications`
--
ALTER TABLE `leave_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_card`
--
ALTER TABLE `leave_card`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `monthly_leave_credits_log`
--
ALTER TABLE `monthly_leave_credits_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personnels`
--
ALTER TABLE `personnels`
  MODIFY `personnel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=725;

--
-- AUTO_INCREMENT for table `personnel_educ_bg`
--
ALTER TABLE `personnel_educ_bg`
  MODIFY `eb_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `personnel_fam_bg`
--
ALTER TABLE `personnel_fam_bg`
  MODIFY `fm_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personnel_file_audit_logs`
--
ALTER TABLE `personnel_file_audit_logs`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personnel_file_folders`
--
ALTER TABLE `personnel_file_folders`
  MODIFY `folder_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `personnel_logs`
--
ALTER TABLE `personnel_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personnel_official_travel_logs`
--
ALTER TABLE `personnel_official_travel_logs`
  MODIFY `travel_log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personnel_seminars`
--
ALTER TABLE `personnel_seminars`
  MODIFY `ps_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_deductions`
--
ALTER TABLE `pr_tbl_deductions`
  MODIFY `deduction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_income`
--
ALTER TABLE `pr_tbl_income`
  MODIFY `income_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_audit_log`
--
ALTER TABLE `pr_tbl_payroll_audit_log`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_profiles`
--
ALTER TABLE `pr_tbl_payroll_profiles`
  MODIFY `profile_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_profile_deductions`
--
ALTER TABLE `pr_tbl_payroll_profile_deductions`
  MODIFY `profile_deduction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_profile_filters`
--
ALTER TABLE `pr_tbl_payroll_profile_filters`
  MODIFY `filter_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_profile_income`
--
ALTER TABLE `pr_tbl_payroll_profile_income`
  MODIFY `profile_income_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_runs`
--
ALTER TABLE `pr_tbl_payroll_runs`
  MODIFY `run_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_run_deductions`
--
ALTER TABLE `pr_tbl_payroll_run_deductions`
  MODIFY `run_deduction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_run_details`
--
ALTER TABLE `pr_tbl_payroll_run_details`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_run_income`
--
ALTER TABLE `pr_tbl_payroll_run_income`
  MODIFY `run_income_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_snapshots`
--
ALTER TABLE `pr_tbl_payroll_snapshots`
  MODIFY `snapshot_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_payroll_snapshot_items`
--
ALTER TABLE `pr_tbl_payroll_snapshot_items`
  MODIFY `snapshot_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_pay_pro_personnels`
--
ALTER TABLE `pr_tbl_pay_pro_personnels`
  MODIFY `ppp_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_personnel_deductions`
--
ALTER TABLE `pr_tbl_personnel_deductions`
  MODIFY `personnel_deduction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pr_tbl_personnel_income`
--
ALTER TABLE `pr_tbl_personnel_income`
  MODIFY `personnel_income_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_record`
--
ALTER TABLE `service_record`
  MODIFY `sr_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `shift_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `signatories_settings`
--
ALTER TABLE `signatories_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `slides`
--
ALTER TABLE `slides`
  MODIFY `slide_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `time_schedules`
--
ALTER TABLE `time_schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `travel_num_generator`
--
ALTER TABLE `travel_num_generator`
  MODIFY `pot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `useraccount`
--
ALTER TABLE `useraccount`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `yearly_dtr_summary`
--
ALTER TABLE `yearly_dtr_summary`
  MODIFY `yDTRs_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `leave_applications`
--
ALTER TABLE `leave_applications`
  ADD CONSTRAINT `fk_leave_app_personnel` FOREIGN KEY (`personnel_id`) REFERENCES `personnels` (`personnel_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
