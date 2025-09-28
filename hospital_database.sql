-- Hospital Database Creation and Data Migration
-- ---------------------------------------------------------------------------------

-- creating database
CREATE DATABASE IF NOT EXISTS medicare_db;
USE medicare_db;

-- creating tables
		-- departments
        -- doctors
        -- patients
        -- apointments
        -- prescription
        -- bills
        -- lab_reports
        

-- creating departments table:
CREATE TABLE departments(
	department_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL UNIQUE
);


-- creating doctors table:
CREATE TABLE doctors(
	doctor_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialization VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    department_id INTEGER ,
    
    CONSTRAINT fk_key_doctor_departments
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
    
    CONSTRAINT uq_doctor_password UNIQUE (doctor_id , password)
);


-- creating patients table:
CREATE TABLE patients(
	patient_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    dob DATE,
    gender CHAR(1) NOT NULL,
    mobile VARCHAR(15),
    
    CONSTRAINT check_gender 
    CHECK (gender IN ('M','F','O'))
);


-- creating appointments table:
CREATE TABLE appointments(
	appointment_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    patient_id INTEGER ,
    appointment_time DATETIME NOT NULL,
    status VARCHAR(255) NOT NULL,
    doctor_id INTEGER ,
    
    CONSTRAINT fk_key_appointments_patients
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
    
	CONSTRAINT fk_key_appointments_doctors
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
	ON DELETE SET NULL
    ON UPDATE CASCADE,
    
    CONSTRAINT check_status 
    CHECK (status IN ('scheduled','completed','cancelled'))
);


-- creating prescription table:
CREATE TABLE prescription(
	prescription_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    appointment_id INTEGER NOT NULL,
    medication VARCHAR(255),
    dosage VARCHAR(255) ,
    
    CONSTRAINT fk_key_prescription_appointments
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- creating bills table
CREATE TABLE bills(
	bill_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    appointment_id INTEGER NOT NULL,
    amount FLOAT,
    paid ENUM('0','1'),
    bill_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_key_bills_appointments
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- creating table lab_reports
CREATE TABLE lab_reports(
	report_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    appointment_id INTEGER NOT NULL,
    report_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    report_data TEXT,
    
	CONSTRAINT fk_key_lab_reports_appointments
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);



-- Importing existing data into Tables


-- extracting departments columns from hospital_data
SELECT GROUP_CONCAT(CONCAT("`",COLUMN_NAME,"`")) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'medicare_db'
AND TABLE_NAME = 'hospital_data'
AND COLUMN_NAME LIKE 'Departments.%';

-- `Departments.DepartmentID`,`Departments.Name`
 
-- inserting data into departments table
INSERT INTO departments(department_id,department_name)
SELECT `Departments.DepartmentID`,`Departments.Name` FROM hospital_data
WHERE `Departments.DepartmentID` != "";


-- extracting doctors columns from hospital_data
SELECT GROUP_CONCAT(CONCAT("`",COLUMN_NAME,"`")) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'medicare_db'
AND TABLE_NAME = 'hospital_data'
AND COLUMN_NAME LIKE 'Doctors.%';

-- `Doctors.DepartmentID`,`Doctors.DoctorID`,`Doctors.Name`,`Doctors.Role`,`Doctors.Specialization`

--  inserting data into doctors table
INSERT INTO doctors(department_id,doctor_id,name,role,specialization)
SELECT `Doctors.DepartmentID`,`Doctors.DoctorID`,`Doctors.Name`,`Doctors.Role`,`Doctors.Specialization`
FROM hospital_data WHERE `Doctors.DepartmentID` != "";


-- extracting patients columns from hospital_data
SELECT GROUP_CONCAT(CONCAT("`",COLUMN_NAME,"`")) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'medicare_db'
AND TABLE_NAME = 'hospital_data'
AND COLUMN_NAME LIKE 'Patients.%';

-- `Patients.DateOfBirth`,`Patients.Gender`,`Patients.Name`,`Patients.PatientID`,`Patients.Phone`

--  inserting data into patients table
INSERT INTO patients(dob,gender,name,patient_id,mobile)
SELECT STR_TO_DATE(`Patients.DateOfBirth`,"%d-%m-%Y"),`Patients.Gender`,`Patients.Name`,`Patients.PatientID`,`Patients.Phone`
FROM hospital_data WHERE `Patients.DateOfBirth` != "";


-- extracting appointments columns from hospital_data
SELECT GROUP_CONCAT(CONCAT("`",COLUMN_NAME,"`")) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'medicare_db'
AND TABLE_NAME = 'hospital_data'
AND COLUMN_NAME LIKE 'Appointments.%';

-- `Appointments.AppointmentID`,`Appointments.AppointmentTime`,`Appointments.DoctorID`,
-- `Appointments.PatientID`,`Appointments.Status`

--  inserting data into appointments table
INSERT INTO appointments(appointment_id,appointment_time,doctor_id,patient_id,status)
SELECT `Appointments.AppointmentID`,STR_TO_DATE(`Appointments.AppointmentTime`,"%d-%m-%Y %H:%i"),
`Appointments.DoctorID`,`Appointments.PatientID`,`Appointments.Status` FROM hospital_data;


-- extracting prescription columns from hospital_data
SELECT GROUP_CONCAT(CONCAT("`",COLUMN_NAME,"`")) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'medicare_db'
AND TABLE_NAME = 'hospital_data'
AND COLUMN_NAME LIKE 'Prescriptions.%';

-- `Prescriptions.AppointmentID`,`Prescriptions.Dosage`,`Prescriptions.Medication`,
-- `Prescriptions.PrescriptionID`

--  inserting data into prescription table
INSERT INTO prescription(appointment_id,dosage,medication,prescription_id)
SELECT `Prescriptions.AppointmentID`,`Prescriptions.Dosage`,`Prescriptions.Medication`,
`Prescriptions.PrescriptionID` FROM hospital_data
WHERE `Prescriptions.AppointmentID` != "";


-- extracting lab_reports columns from hospital_data
SELECT GROUP_CONCAT(CONCAT("`",COLUMN_NAME,"`")) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'medicare_db'
AND TABLE_NAME = 'hospital_data'
AND COLUMN_NAME LIKE 'LabReports.%';

-- `LabReports.AppointmentID`,`LabReports.CreatedAt`,`LabReports.ReportData`,`LabReports.ReportID`

--  inserting data into lab_reports table
INSERT INTO lab_reports(appointment_id,report_date,report_data,report_id)
SELECT `LabReports.AppointmentID`,`LabReports.CreatedAt`,`LabReports.ReportData`,
`LabReports.ReportID` FROM hospital_data WHERE `LabReports.AppointmentID` != "";


-- extracting bills columns from hospital_data
SELECT GROUP_CONCAT(CONCAT("`",COLUMN_NAME,"`")) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'medicare_db'
AND TABLE_NAME = 'hospital_data'
AND COLUMN_NAME LIKE 'BILLS.%';

-- `Bills.Amount`,`Bills.AppointmentID`,`Bills.BillDate`,`Bills.BillID`,`Bills.Paid`

--  inserting data into bills table
INSERT INTO bills(amount,appointment_id,bill_date,bill_id,paid)
SELECT `Bills.Amount`,`Bills.AppointmentID`,`Bills.BillDate`,`Bills.BillID`,`Bills.Paid`
FROM hospital_data WHERE `Bills.Amount` != "";



-- creating trigger so no doctor get double booked at same time and no appointment is being 
-- scheduled in past by mistake. 

DELIMITER //

CREATE TRIGGER check_new_appointment
BEFORE INSERT
ON appointments
FOR EACH ROW
BEGIN

	-- Check if appointment time is in the past
    IF NEW.appointment_time < NOW() THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Error: Can not set appointment time in the past";
	END IF;
    
    -- Check if doctor already has appointment at same time
    IF EXISTS
    (
		SELECT * FROM appointments WHERE doctor_id = NEW.doctor_id
        AND appointment_time = NEW.appointment_time
        AND status = "Scheduled"
    ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Error: doctor already has appointment at same time";
    END IF;

END //

DELIMITER ;


-- Open Access to Sensitive Patient Information:
-- All doctors currently see all data, regardless of their role or department.
-- Creating limitations that allow access to data based on credentials and roles provided by the firm. 
-- Only senior doctors can view all patients in their department, else doctors can only see details 
-- (medication, appointment, reports) of their respective patients.


DELIMITER //

CREATE PROCEDURE view_doctor_data(IN input_doctor_id INT, IN input_password VARCHAR(255))
BEGIN

    DECLARE department_ VARCHAR(255);
    DECLARE role_ VARCHAR(255);
    DECLARE department_id_ INT;
    
    SELECT department_id, role INTO department_id_, role_ FROM doctors WHERE doctor_id = input_doctor_id;
    
    IF EXISTS(
		SELECT 1 FROM doctor_credentials
        WHERE doctor_id = input_doctor_id AND password = input_password
    ) 
    THEN 
		IF LOWER(role_) != 'senior'
        THEN
			SELECT ap.doctor_id, pa.name , pa.gender, ap.appointment_time, ap.status, medication, dosage, report_date, report_data
			FROM patients pa
			JOIN appointments ap 
			ON pa.patient_id = ap.patient_id
			JOIN doctors d
            ON d.doctor_id = ap.doctor_id
			LEFT JOIN prescription pr
			ON ap.appointment_id = pr.appointment_id
			LEFT JOIN lab_reports lab 
			ON lab.appointment_id = pr.appointment_id
			WHERE d.doctor_id = input_doctor_id;
		ELSE
			SELECT ap.doctor_id, pa.name , pa.gender, ap.appointment_time, ap.status, medication, dosage, report_date, report_data
			FROM patients pa
			JOIN appointments ap 
			ON pa.patient_id = ap.patient_id
			JOIN doctors d
            ON d.doctor_id = ap.doctor_id
			LEFT JOIN prescription pr
			ON ap.appointment_id = pr.appointment_id
			LEFT JOIN lab_reports lab 
			ON lab.appointment_id = pr.appointment_id
			WHERE d.department_id = department_id_;
		END IF;
        
	ELSE 
		SIGNAL SQLSTATE "45000"
        SET MESSAGE_TEXT = "Error: Credentials Incorrect";
        
	END IF;
END //

DELIMITER ; 


-- Implementing a way that generates monthly revenue reports by department.

DELIMITER //

CREATE PROCEDURE monthly_revenue_by_department(IN input_month_num INT, IN input_year INT)
BEGIN

	SELECT dpt.department_name,
           COALESCE(ROUND(SUM(amount)),0) AS month_revenue
    FROM BILLS b 
	JOIN appointments ap 
	ON b.appointment_id = ap.appointment_id
	JOIN doctors d 
	ON ap.doctor_id = d.doctor_id
	JOIN departments dpt
	ON dpt.department_id = d.department_id
	WHERE paid = '1' AND
    MONTH(bill_date) = input_month_num AND
    YEAR(bill_date) = input_year 
    GROUP BY dpt.department_name;
    

END //

DELIMITER ;















