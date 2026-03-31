create database	Faith_Specialist_Hospital;
USE Faith_Specialist_Hospital;

-- patients table
CREATE TABLE patients (
hospital_no INT PRIMARY KEY,
name VARCHAR(150),
age INT,
sex VARCHAR (10),
occupation VARCHAR (100),
level_of_education VARCHAR (100),
marital_status VARCHAR (20)
);

-- doctors table
CREATE TABLE doctors (
doctor_id VARCHAR (20) PRIMARY KEY,
doctor VARCHAR (150),
gender VARCHAR (10),
email VARCHAR (150),
specialization VARCHAR (100)
);

-- admission table
CREATE TABLE admissions (
    hospital_no INT,
    doctor_id VARCHAR(20),
    dama VARCHAR(3),
    reason_for_dama VARCHAR(255),
    dead VARCHAR(3),
    cause_of_death VARCHAR(255),
    ckd VARCHAR(255),
    cause_of_ckd VARCHAR(255),
    dialysis VARCHAR(255),
    no_of_dialysis_session INT,
    stroke VARCHAR(3),
    dm VARCHAR(3),
    cancer VARCHAR(3),
    type_of_cancer VARCHAR(255),
    pud VARCHAR(3),
    FOREIGN KEY (hospital_no) REFERENCES patients(hospital_no),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- risk factors table
CREATE TABLE Risk_Factors (
hospital_no INT PRIMARY KEY,
alcohol_hx VARCHAR (3),
tobaco_hx VARCHAR (3),
nsaid_use VARCHAR (3),
FOREIGN KEY (hospital_no) REFERENCES patients(hospital_no)
);

-- indexes
CREATE INDEX idx_adm_doctor_id ON admissions(doctor_id);
CREATE INDEX idx_adm_risk_hospital_no ON risk_factors(hospital_no);
CREATE INDEX idx_risk_hospital_no ON risk_factors(hospital_no);

SHOW TABLES;

SELECT COUNT(*) FROM admissions;
SELECT * FROM admissions;

-- Change age to VARCHAR for import
ALTER TABLE patients
MODIFY age VARCHAR(10);

-- Import your data (it will work now)

-- Then convert back to INT
UPDATE patients SET age = NULL WHERE age = '';
ALTER TABLE patients MODIFY age INT;

-- To import data for admission, Change no_of_dialysis_session to VARCHAR for import
ALTER TABLE admissions
MODIFY no_of_dialysis_session VARCHAR(10);
ALTER TABLE admissions
MODIFY dm VARCHAR(10);

-- Import your data (it will work now)

-- Then convert back to INT
UPDATE admissions SET no_of_dialysis_session = NULL WHERE no_of_dialysis_session = '';
ALTER TABLE admissions MODIFY no_of_dialysis_session INT;

SELECT COUNT(*) FROM risk_factors;
SELECT * FROM doctors;

-- COMPREHENSIVE HEALTHCARE ANALYTICS FOR FAITH SPECIALIST HOSPITAL
-- =================================================================

USE Faith_Specialist_Hospital;

-- OBJECTIVE 1: Analyze patient demographics in relation to hospital outcomes
-- =========================================================================

-- 1.1 Age distribution and outcomes
SELECT 
    CASE 
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 35 THEN '18-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age BETWEEN 51 AND 65 THEN '51-65'
        ELSE 'Over 65'
    END AS age_group,
    COUNT(*) AS total_patients,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate,
    ROUND(AVG(CASE WHEN dama = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS dama_rate,
    ROUND(AVG(CASE WHEN ckd IS NOT NULL THEN 1 ELSE 0 END) * 100, 2) AS ckd_rate,
    ROUND(AVG(CASE WHEN dm = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS diabetes_rate
FROM patients p
LEFT JOIN admissions a ON p.hospital_no = a.hospital_no
GROUP BY age_group
ORDER BY MIN(age);

-- 1.2 Gender-based outcomes
SELECT 
    sex,
    COUNT(*) AS total_patients,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate,
    ROUND(AVG(CASE WHEN dama = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS dama_rate,
    ROUND(AVG(CASE WHEN stroke = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS stroke_rate
FROM patients p
LEFT JOIN admissions a ON p.hospital_no = a.hospital_no
WHERE sex IS NOT NULL
GROUP BY sex;

-- 1.3 Education level and health outcomes
SELECT 
    level_of_education,
    COUNT(*) AS total_patients,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate,
    ROUND(AVG(CASE WHEN dama = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS dama_rate,
    ROUND(AVG(CASE WHEN ckd IS NOT NULL THEN 1 ELSE 0 END) * 100, 2) AS ckd_rate
FROM patients p
LEFT JOIN admissions a ON p.hospital_no = a.hospital_no
WHERE level_of_education IS NOT NULL AND level_of_education != ''
GROUP BY level_of_education
ORDER BY total_patients DESC;

-- OBJECTIVE 2: Analyze Discharge Against Medical Advice (DAMA)
-- ============================================================

-- 2.1 DAMA rates and reasons
SELECT 
    reason_for_dama,
    COUNT(*) AS cases,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM admissions WHERE dama = 'Yes'), 2) AS percentage,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS mortality_rate_after_dama
FROM admissions
WHERE dama = 'Yes' AND reason_for_dama IS NOT NULL
GROUP BY reason_for_dama
ORDER BY cases DESC;

-- 2.2 DAMA by demographic factors
SELECT 
    p.sex,
    p.level_of_education,
    COUNT(*) AS dama_cases,
    ROUND(AVG(p.age), 1) AS avg_age
FROM admissions a
JOIN patients p ON a.hospital_no = p.hospital_no
WHERE a.dama = 'Yes'
GROUP BY p.sex, p.level_of_education
ORDER BY dama_cases DESC;


-- OBJECTIVE 3: Chronic Illness Analysis
-- =====================================

-- 3.1 Prevalence of chronic diseases
SELECT 
    ROUND(AVG(CASE WHEN ckd = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS ckd_prevalence,
    ROUND(AVG(CASE WHEN dm = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS diabetes_prevalence,
    ROUND(AVG(CASE WHEN stroke = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS stroke_prevalence,
    ROUND(AVG(CASE WHEN cancer = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS cancer_prevalence,
    ROUND(AVG(CASE WHEN pud = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS pud_prevalence
FROM admissions;

-- 3.2 Chronic disease comorbidities
SELECT 
    COUNT(*) AS patients_with_comorbidities,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate
FROM (
    SELECT 
        hospital_no,
        MAX(dead) AS dead,  -- capture death status per patient
        (
            (CASE WHEN ckd = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN dm = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN stroke = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN cancer = 'Yes' THEN 1 ELSE 0 END)
        ) AS comorbidity_count
    FROM admissions
    GROUP BY hospital_no, ckd, dm, stroke, cancer
) AS comorb
WHERE comorbidity_count >= 2;

-- breakdown by comorbidity level
SELECT 
    comorbidity_count,
    COUNT(*) AS num_patients,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate
FROM (
    SELECT 
        hospital_no,
        MAX(dead) AS dead,
        (
            (CASE WHEN ckd = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN dm = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN stroke = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN cancer = 'Yes' THEN 1 ELSE 0 END)
        ) AS comorbidity_count
    FROM admissions
    GROUP BY hospital_no, ckd, dm, stroke, cancer
) AS comorb
GROUP BY comorbidity_count
ORDER BY comorbidity_count;

-- 3.3 CKD analysis
SELECT 
    cause_of_ckd,
    COUNT(*) AS cases,
    ROUND(AVG(CASE WHEN dialysis IS NOT NULL THEN 1 ELSE 0 END) * 100, 2) AS dialysis_rate,
    ROUND(AVG(no_of_dialysis_session), 1) AS avg_dialysis_sessions
FROM admissions
WHERE ckd IS NOT NULL AND cause_of_ckd IS NOT NULL
GROUP BY cause_of_ckd
ORDER BY cases DESC;

-- OBJECTIVE 4: Lifestyle Factors Impact
-- =====================================

-- 4.1 Lifestyle factors prevalence
SELECT 
    ROUND(AVG(CASE WHEN alcohol_hx = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS alcohol_users,
    ROUND(AVG(CASE WHEN tobaco_hx = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS tobacco_users,
    ROUND(AVG(CASE WHEN nsaid_use = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS nsaid_users
FROM risk_factors;

-- 4.2 Lifestyle factors and chronic diseases
SELECT 
    r.alcohol_hx,
    r.tobaco_hx,
    r.nsaid_use,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN a.ckd = 'Yes' THEN 1 ELSE 0 END) AS ckd_count,
    ROUND(100.0 * SUM(CASE WHEN a.ckd = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS ckd_rate,
    ROUND(100.0 * SUM(CASE WHEN a.dm = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS diabetes_rate,
    ROUND(100.0 * SUM(CASE WHEN a.stroke = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS stroke_rate,
    SUM(CASE WHEN a.dead = 'Yes' THEN 1 ELSE 0 END) AS deaths,
    ROUND(100.0 * SUM(CASE WHEN a.dead = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS mortality_rate
FROM risk_factors r
JOIN admissions a ON r.hospital_no = a.hospital_no
GROUP BY r.alcohol_hx, r.tobaco_hx, r.nsaid_use
ORDER BY total_patients DESC;

-- 4.3 Lifestyle factors and mortality
SELECT 
    alcohol_hx,
    tobaco_hx,
    COUNT(*) AS patients,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS mortality_rate
FROM risk_factors r
JOIN admissions a ON r.hospital_no = a.hospital_no
GROUP BY alcohol_hx, tobaco_hx
ORDER BY mortality_rate DESC;

-- OBJECTIVE 5: Doctor Performance Evaluation
-- ==========================================

-- 5.1 Doctor workload and outcomes
SELECT 
    d.doctor_id,
    d.doctor,
    d.specialization,
    COUNT(a.hospital_no) AS patient_count,
    ROUND(AVG(CASE WHEN a.dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate,
    ROUND(AVG(CASE WHEN a.dama = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS dama_rate,
    ROUND(AVG(CASE WHEN a.ckd IS NOT NULL THEN 1 ELSE 0 END) * 100, 2) AS ckd_patient_rate
FROM doctors d
LEFT JOIN admissions a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor, d.specialization
HAVING patient_count > 0
ORDER BY patient_count DESC;

-- 5.2 Specialization-wise outcomes
SELECT 
    d.specialization,
    COUNT(DISTINCT d.doctor_id) AS doctor_count,
    COUNT(*) AS total_patients,
    ROUND(AVG(CASE WHEN dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate,
    ROUND(AVG(CASE WHEN dama = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS dama_rate
FROM doctors d
JOIN admissions a ON d.doctor_id = a.doctor_id
GROUP BY specialization
ORDER BY total_patients DESC;

-- 5.3 Doctor performance with chronic disease patients
SELECT 
    d.doctor_id,
    d.doctor,
    d.specialization,
    SUM(CASE WHEN a.ckd IS NOT NULL THEN 1 ELSE 0 END) AS ckd_patients,
    SUM(CASE WHEN a.dm = 'Yes' THEN 1 ELSE 0 END) AS diabetes_patients,
    ROUND(AVG(CASE WHEN a.dead = 'Yes' AND a.ckd IS NOT NULL THEN 1 ELSE 0 END) * 100, 2) AS ckd_death_rate
FROM doctors d
JOIN admissions a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor, d.specialization
HAVING ckd_patients > 0
ORDER BY ckd_patients DESC;

-- OBJECTIVE 6: Overall Hospital Insights & Recommendations
-- =======================================================

-- 6.1 Key Performance Indicators
SELECT 
    COUNT(DISTINCT p.hospital_no) AS total_patients,
    COUNT(DISTINCT a.doctor_id) AS total_doctors,
    ROUND(AVG(CASE WHEN a.dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS overall_death_rate,
    ROUND(AVG(CASE WHEN a.dama = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS overall_dama_rate,
    ROUND(AVG(CASE WHEN a.ckd IS NOT NULL THEN 1 ELSE 0 END) * 100, 2) AS overall_ckd_rate,
    ROUND(AVG(p.age), 1) AS average_patient_age
FROM patients p
LEFT JOIN admissions a ON p.hospital_no = a.hospital_no;

-- 6.2 High-risk patient profiles
SELECT 
    p.sex,
    FLOOR(p.age/10)*10 AS age_decade,
    r.alcohol_hx,
    r.tobaco_hx,
    COUNT(*) AS patients,
    ROUND(AVG(CASE WHEN a.dead = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS death_rate,
    ROUND(AVG(CASE WHEN a.dama = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS dama_rate
FROM patients p
JOIN risk_factors r ON p.hospital_no = r.hospital_no
JOIN admissions a ON p.hospital_no = a.hospital_no
GROUP BY p.sex, age_decade, r.alcohol_hx, r.tobaco_hx
HAVING patients >= 5
ORDER BY death_rate DESC
LIMIT 10;
