-- Hospital Patient Management System Database
-- This script creates a complete database structure for managing hospital patients, doctors, visits, and related information

-- DATABASE SETUP

-- First, remove the existing database if it exists to start fresh
DROP DATABASE IF EXISTS hospital_management;

-- Create a new database named 'hospital_management'
CREATE DATABASE hospital_management;

-- Set the newly created database as the active database for subsequent commands
USE hospital_management;


-- PATIENTS TABLE
-- Stores core information about patients
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each patient, automatically increments
    first_name VARCHAR(50) NOT NULL,          -- Patient's first name (required)
    last_name VARCHAR(50) NOT NULL,           -- Patient's last name (required)
    date_of_birth DATE NOT NULL,              -- Patient's birth date (required)
    gender ENUM('Male', 'Female', 'Other') NOT NULL, -- Restricted to these three values
    address VARCHAR(100),                     -- Street address (optional)
    city VARCHAR(50),                         -- City (optional)
    state VARCHAR(50),                        -- State/Province (optional)
    postal_code VARCHAR(20),                  -- Zip/Postal code (optional)
    phone VARCHAR(20) NOT NULL,               -- Contact phone number (required)
    email VARCHAR(100) UNIQUE,               -- Email must be unique if provided
    insurance_provider VARCHAR(50),           -- Name of insurance company
    insurance_number VARCHAR(50),            -- Policy number
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Automatically set when record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Updates automatically when record changes
);

-- DOCTORS TABLE
-- Stores information about medical staff
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each doctor
    first_name VARCHAR(50) NOT NULL,          -- Doctor's first name (required)
    last_name VARCHAR(50) NOT NULL,           -- Doctor's last name (required)
    specialization VARCHAR(100) NOT NULL,     -- Medical specialty (e.g., Cardiology)
    phone VARCHAR(20) NOT NULL,               -- Contact number (required)
    email VARCHAR(100) UNIQUE NOT NULL,       -- Email must be unique and is required
    license_number VARCHAR(50) UNIQUE NOT NULL, -- Medical license number (unique and required)
    hire_date DATE NOT NULL,                  -- When the doctor joined the hospital
    department VARCHAR(50) NOT NULL,          -- Which department they work in
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- When record was last updated
);

-- VISITS TABLE
-- Tracks patient appointments/consultations
CREATE TABLE visits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique visit identifier
    patient_id INT NOT NULL,                  -- Which patient this visit is for
    doctor_id INT NOT NULL,                   -- Which doctor is seeing the patient
    visit_date DATETIME NOT NULL,             -- When the appointment is scheduled
    purpose VARCHAR(255),                     -- Reason for the visit
    diagnosis TEXT,                           -- Doctor's diagnosis notes
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled', -- Current status with default
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When visit record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update timestamp
    
    -- Establish relationships with other tables:
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE, 
    -- If a patient is deleted, all their visits are automatically deleted
    
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    -- If a doctor is deleted, all their visits are automatically deleted
    
    -- Create indexes for faster searching on these commonly queried fields:
    INDEX (visit_date),    -- Helps when searching by date
    INDEX (patient_id),    -- Speeds up finding all visits for a patient
    INDEX (doctor_id)      -- Speeds up finding all visits for a doctor
);

-- MEDICATIONS TABLE
-- Master list of all available medications
CREATE TABLE medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique drug identifier
    name VARCHAR(100) NOT NULL UNIQUE,         -- Medication name must be unique
    description TEXT,                         -- Description of the medication
    category VARCHAR(50),                     -- Drug category (e.g., antibiotic)
    unit_price DECIMAL(10, 2) NOT NULL,       -- Cost per unit with 2 decimal places
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When added to system
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Last update time
);

-- PRESCRIPTIONS TABLE
-- Records medications prescribed during visits
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique prescription ID
    visit_id INT NOT NULL,                  -- Which visit this prescription is from
    medication_id INT NOT NULL,              -- Which medication was prescribed
    dosage VARCHAR(50) NOT NULL,             -- How much to take (e.g., "500mg")
    frequency VARCHAR(50) NOT NULL,          -- How often (e.g., "twice daily")
    duration VARCHAR(50) NOT NULL,           -- How long (e.g., "7 days")
    instructions TEXT,                       -- Additional instructions
    prescribed_date DATE NOT NULL,           -- When prescription was written
    
    -- Establish relationships:
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE,
    -- If a visit is deleted, its prescriptions are automatically deleted
    
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE CASCADE,
    -- If a medication is deleted, prescriptions for it are automatically deleted
    
    -- Create indexes for better performance:
    INDEX (visit_id),        -- Faster lookup of all prescriptions for a visit
    INDEX (medication_id)    -- Faster lookup of all prescriptions for a medication
);

-- LAB_TESTS TABLE
-- Records laboratory tests ordered during visits
CREATE TABLE lab_tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique test identifier
    visit_id INT NOT NULL,                   -- Which visit this test is associated with
    test_name VARCHAR(100) NOT NULL,         -- Name of the test (e.g., "Blood Count")
    test_date DATE NOT NULL,                 -- When test was performed
    results TEXT,                            -- Test results (can be large text)
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending', -- Current status
    cost DECIMAL(10, 2) NOT NULL,            -- Cost of the test
    notes TEXT,                              -- Additional notes about the test
    
    -- Establish relationship with visits:
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE,
    -- If a visit is deleted, its lab tests are automatically deleted
    
    -- Create index for better performance:
    INDEX (visit_id)  -- Faster lookup of all tests for a visit
);

-- BILLING TABLE
-- Tracks financial transactions for visits
CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique bill identifier
    visit_id INT NOT NULL,                   -- Which visit this bill is for
    total_amount DECIMAL(10, 2) NOT NULL,    -- Total amount due
    paid_amount DECIMAL(10, 2) DEFAULT 0,    -- Amount paid (defaults to 0)
    -- Automatically calculated field (total - paid):
    balance DECIMAL(10, 2) GENERATED ALWAYS AS (total_amount - paid_amount) STORED,
    billing_date DATE NOT NULL,               -- When bill was generated
    due_date DATE NOT NULL,                   -- Payment due date
    status ENUM('Pending', 'Partially Paid', 'Paid', 'Overdue') DEFAULT 'Pending', -- Payment status
    payment_method VARCHAR(50),              -- How payment was made (if any)
    
    -- Establish relationship with visits:
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE,
    -- If a visit is deleted, its billing record is automatically deleted
    
    -- Create index for better performance:
    INDEX (visit_id)  -- Faster lookup of bills for a visit
);