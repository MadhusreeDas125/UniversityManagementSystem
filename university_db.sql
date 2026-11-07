-- ==========================================
-- 1. DATABASE & SCHEMA CREATION
-- ==========================================

CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- Departments Table (5 Departments specified in notes)
CREATE TABLE IF NOT EXISTS departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT IGNORE INTO departments (dept_name) VALUES 
('CSE'), ('ECE'), ('ME'), ('Business Administration'), ('Law');

-- Users Table (Handles Student, Faculty, and Admin with Role & Department links)
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL, -- 'STUDENT', 'FACULTY', 'ADMIN'
    dept_id INT,
    enrollment_no VARCHAR(50) UNIQUE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Attendance Table
CREATE TABLE IF NOT EXISTS attendance (
    att_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    subject VARCHAR(100),
    attended_classes INT,
    total_classes INT,
    FOREIGN KEY (student_id) REFERENCES users(user_id)
);

-- Grades Table (Semester-wise SGPA / CGPA)
CREATE TABLE IF NOT EXISTS grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    semester VARCHAR(20),
    sgpa DECIMAL(3,2),
    cgpa DECIMAL(3,2),
    FOREIGN KEY (student_id) REFERENCES users(user_id)
);

-- Routine Table (Managed by Admin)
CREATE TABLE IF NOT EXISTS routine (
    routine_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT,
    semester VARCHAR(20),
    day_of_week VARCHAR(20),
    time_slot VARCHAR(50),
    subject VARCHAR(100),
    faculty_name VARCHAR(100),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Syllabus Table (Semester & Department-wise, Managed by Admin)
CREATE TABLE IF NOT EXISTS syllabus (
    syllabus_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT,
    semester VARCHAR(20),
    subject_name VARCHAR(100),
    syllabus_details TEXT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Notifications Table (Broadcasted by Admin/Faculty)
CREATE TABLE IF NOT EXISTS notifications (
    notif_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    message TEXT,
    date_posted TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fees Table (Tuition Fee Payment Method & Status)
CREATE TABLE IF NOT EXISTS fees (
    fee_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    semester VARCHAR(20),
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (student_id) REFERENCES users(user_id)
);

-- Default Admin Account
INSERT IGNORE INTO users (name, password, role, enrollment_no) 
VALUES ('Admin Master', 'admin123', 'ADMIN', 'ADM-00001');


-- ==========================================
-- 2. SELECT QUERIES TO VIEW TABLE DATA
-- ==========================================

-- View all departments
SELECT * FROM departments;

-- View all users (Students, Faculty, Admins)
SELECT * FROM users;

-- View all attendance records
SELECT * FROM attendance;

-- View all grades
SELECT * FROM grades;

-- View class routines
SELECT * FROM routine;

-- View syllabus details
SELECT * FROM syllabus;

-- View broadcast notifications
SELECT * FROM notifications;

-- View fee payment statuses
SELECT * FROM fees;