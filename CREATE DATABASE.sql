CREATE DATABASE Hospital_management_system;
USE Hospital_management_system;
CREATE TABLE Doctor(
d_id INT PRIMARY KEY,
doc_name VARCHAR(50) NOT NULL,
area_of_treatment VARCHAR(40) NOT NULL,
doctor_charges DECIMAL(10,2));
DESC Doctor;
CREATE TABLE Patient(
p_id INT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
phone_number INT NOT NULL UNIQUE,
gender ENUM('Male', 'Female'),
age INT NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
area_of_treatment VARCHAR(50) NOT NULL,
slot VARCHAR(20) NOT NULL,
d_id INT NOT NULL,
FOREIGN KEY(d_id) REFERENCES Doctor(d_id));
DESC Patient;
CREATE TABLE Room(
room_id INT PRIMARY KEY,
room_charges DECIMAL(10,2) DEFAULT 0.0,
P_id INT NOT NULL,
FOREIGN KEY (p_id) REFERENCES Patient(p_id));
DESC Room;
CREATE TABLE Bill(
bill_num INT PRIMARY KEY,
p_id INT,
d_id INT,
room_id INT,
total_charges INT,
FOREIGN KEY (p_id) REFERENCES Patient(p_id),
FOREIGN KEY (d_id) REFERENCES Doctor(d_id),
FOREIGN KEY (room_id) REFERENCES Room(room_id));
DESC Bill;
INSERT INTO Doctor(d_id,doc_name,area_of_treatment,doctor_charges)
VALUES (1,"Dr.Drisana","Pediatrics",1500.00),
(2,"Dr.John Doe","Cardiology",2000.00),
(3,"Dr.Olivia Smith","Gynaecology",2500.00),
(4,"Dr.Jane Smith","Neurology",1800.00);
ALTER TABLE Patient MODIFY COLUMN phone_number BIGINT NOT NULL;
INSERT INTO Patient (p_id, name, phone_number, gender, age, email,
area_of_treatment, slot, d_id)
VALUES
(101, 'Jack Brown', 1234567890, 'Male', 35, 'jack@example.com', 'Cardiology',
'Morning', 2),
(102, 'Bob Johnson', 9876543280, 'Male', 45, 'bob@example.com', 'Neurology',
'Afternoon', 4),
(103, 'Charlie Brown', 5551234567, 'Male', 28, 'charlie@example.com', 'Pediatrics',
'Morning', 1),
(104, 'Diana Lee', 1112223333, 'Female', 50, 'diana@example.com', 'Neurology',
'Evening', 4),
(105, 'Ella Chen', 9998887777, 'Female', 40, 'ella@example.com', 'Gynaecology',
'Afternoon', 3),
(106, 'Frank Wilson', 7779998888, 'Male', 55, 'frank@example.com', 'Cardiology',
'Evening', 2),
(107, 'Grace Taylor', 2223334444, 'Female', 30, 'grace@example.com',
'Pediatrics', 'Afternoon', 1),
(108, 'Ivy White', 8887776666, 'Female', 25, 'ivy@example.com', 'Gynaecology',
'Evening', 3);
INSERT INTO Room (room_id, p_id, room_charges)
VALUES
(1001, 101, 0.00),
(1002, 102, 300.00),
(1003, 103, 0.00),
(1004, 104, 400.00),
(1005, 105, 0.00),
(1006, 106, 450.00),
(1007, 107, 350.00),
(1008, 108, 450.00);
INSERT INTO Bill (bill_num,p_id, d_id, room_id, total_charges)
SELECT
12000 + ROW_NUMBER() OVER () AS bill_num,
Patient.p_id,
Doctor.d_id,
Room.room_id,
(Doctor.doctor_charges + Room.room_charges) AS total_charges
FROM
Patient
JOIN
Room ON Patient.p_id = Room.p_id
JOIN
Doctor ON Patient.d_id = Doctor.d_id;
select * from Bill;
SELECT
Patient.name AS patient_name,
Room.room_id,
Doctor.doc_name AS doctor_name,
Doctor.doctor_charges
FROM
Patient
INNER JOIN
Room ON Patient.p_id = Room.p_id
INNER JOIN
Doctor ON Patient.d_id = Doctor.d_id;
SELECT area_of_treatment,
ROUND(MAX(doctor_charges), 2) AS max_charges,
ROUND(MIN(doctor_charges), 2) AS min_charges,
ROUND(SUM(doctor_charges), 2) AS total_charges
FROM Doctor
GROUP BY area_of_treatment
HAVING total_charges > 1000
ORDER BY total_charges DESC;
SELECT
Doctor.doc_name AS doctor_name,
AVG(Patient.age) AS average_patient_age
FROM
Patient
INNER JOIN
Doctor ON Patient.d_id = Doctor.d_id
GROUP BY
Doctor.doc_name;
SELECT
*
FROM
Patient
WHERE
name LIKE '%a_%' OR name LIKE '%A_%';
DELIMITER //
CREATE TRIGGER calculate_total_charges
AFTER INSERT ON Bill
FOR EACH ROW
BEGIN
UPDATE Bill
SET total_charges = (SELECT doctor_charges FROM Doctor WHERE d_id =
NEW.d_id) + (SELECT room_charges FROM Room WHERE room_id =
NEW.room_id)
WHERE bill_num = NEW.bill_num;
END//
DELIMITER ;
Select * from Bill;
—VIEW—-
CREATE VIEW Room_Bill_Info_View AS
SELECT
r.room_id AS Room_ID,
r.room_charges AS Room_Charges,
p.name AS Patient_Name,
b.bill_num AS Bill_Number,
b.total_charges AS Total_Charges
FROM
Room r
JOIN
Patient p ON r.p_id = p.p_id
JOIN
Bill b ON r.room_id = b.room_id;
SELECT * FROM Room_Bill_Info_View;