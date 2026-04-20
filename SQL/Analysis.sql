-- =========================================
-- 1. DATABASE SETUP
-- =========================================
CREATE DATABASE hospital_db;
USE hospital_db;


-- =========================================
-- 2. TABLE CREATION 
-- =========================================
CREATE TABLE admissions (
    encounter_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    admission_type VARCHAR(50),
    time_in_hospital INT,
    num_procedures INT,
    num_lab_procedures INT,
    num_medications INT,
    number_emergency INT,
    readmitted VARCHAR(10)
);


-- =========================================
-- 3. DATA PREPARATION 
-- =========================================
-- 3.1. Total records
SELECT COUNT(*) FROM admissions;

-- 3.2. Readmission distribution
SELECT readmitted, COUNT(*) AS total
FROM admissions
GROUP BY readmitted;

-- 3.3. Average hospital stay
SELECT AVG(time_in_hospital) AS avg_stay
FROM admissions;


-- =========================================
-- 4. Asking real questions
-- =========================================
-- 4.1. Does hospital stay affect readmission?
SELECT 
    readmitted,
    AVG(time_in_hospital) AS avg_stay,
    COUNT(*) AS total
FROM admissions
GROUP BY readmitted;

-- 4.2. Admission type impact
SELECT 
    admission_type_id,
    readmitted,
    COUNT(*) AS total
FROM admissions
GROUP BY admission_type_id, readmitted
ORDER BY admission_type_id;

-- 4.3. Medication usage
SELECT 
    readmitted,
    AVG(num_medications) AS avg_meds
FROM admissions
GROUP BY readmitted;

-- 4.4. Emergency visits correlation
SELECT 
    readmitted,
    AVG(number_emergency) AS avg_emergency_visits
FROM admissions
GROUP BY readmitted;


-- =========================================
-- 5. Creating View
-- =========================================
CREATE VIEW admissions_enriched AS
SELECT *,
  CASE
    WHEN time_in_hospital > 7 THEN 'High'
    WHEN time_in_hospital > 3 THEN 'Medium'
    ELSE 'Low'
  END AS risk_tier,
  CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS readmit_flag
FROM admissions;


-- =========================================
-- 6. KPI's
-- =========================================
-- 6.1. Readmission Rate
SELECT 
    COUNT(CASE WHEN readmitted != 'NO' THEN 1 END) * 100.0 / COUNT(*) AS readmission_rate
FROM admissions;

-- 6.2. Average Length of Stay
SELECT AVG(time_in_hospital) FROM admissions;

-- 6.3. Avg Medications per Patient
SELECT AVG(num_medications) FROM admissions;

-- 6.4. Emergency Visit Rate
SELECT AVG(number_emergency) FROM admissions;


-- =========================================
-- 6. Final conclusion
-- =========================================
-- “The analysis shows that hospital readmissions are strongly associated with patient severity indicators such as longer hospital stays, higher medication usage, and frequent emergency visits. Emergency admissions, in particular, exhibit higher readmission rates, suggesting that targeted post-discharge monitoring for high-risk patients could help reduce readmissions.”--