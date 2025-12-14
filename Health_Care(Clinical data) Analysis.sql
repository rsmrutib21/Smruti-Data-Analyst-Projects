CREATE DATABASE HEALTHCARE;
USE HEALTHCARE;
CREATE TABLE healthcare_temp (
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(20),
    Blood_Type VARCHAR(5),
    Medical_Condition VARCHAR(100),
    Date_of_Admission_txt VARCHAR(20),
    Doctor VARCHAR(100),
    Hospital VARCHAR(150),
    Insurance_Provider VARCHAR(100),
    Billing_Amount DECIMAL(10,2),
    Room_Number INT,
    Admission_Type VARCHAR(50),
    Discharge_Date_txt VARCHAR(20),
    Medication VARCHAR(200),
    Test_Results VARCHAR(100)
);
SELECT * FROM healthcare_temp;
CREATE TABLE healthcare_dataset (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(20),
    Blood_Type VARCHAR(5),
    Medical_Condition VARCHAR(100),
    Date_of_Admission DATE,
    Doctor VARCHAR(100),
    Hospital VARCHAR(150),
    Insurance_Provider VARCHAR(100),
    Billing_Amount DECIMAL(10,2),
    Room_Number INT,
    Admission_Type VARCHAR(50),
    Discharge_Date DATE,
    Medication VARCHAR(200),
    Test_Results VARCHAR(100)
);
INSERT INTO healthcare_dataset (
    Name, Age, Gender, Blood_Type, Medical_Condition,
    Date_of_Admission, Doctor, Hospital, Insurance_Provider,
    Billing_Amount, Room_Number, Admission_Type,
    Discharge_Date, Medication, Test_Results
)
SELECT
    Name,
    Age,
    Gender,
    Blood_Type,
    Medical_Condition,
    STR_TO_DATE(Date_of_Admission_txt, '%d-%m-%Y'),
    Doctor,
    Hospital,
    Insurance_Provider,
    Billing_Amount,
    Room_Number,
    Admission_Type,
    STR_TO_DATE(Discharge_Date_txt, '%d-%m-%Y'),
    Medication,
    Test_Results
FROM healthcare_temp;
SELECT * FROM healthcare_dataset;
DROP TABLE healthcare_temp;

-- Patient Demographic Over view by Age group
-- Age group that dominate my hospital dataset
SELECT 
    CASE 
        WHEN Age < 18 THEN 'Child'
        WHEN Age BETWEEN 18 AND 40 THEN 'Adult'
        WHEN Age BETWEEN 41 AND 60 THEN 'Middle Age'
        ELSE 'Senior'
    END AS Age_Group,
    COUNT(*) AS Total_Patients
FROM healthcare_dataset
GROUP BY Age_Group;

-- Most common medical conditions
-- Which deseses are the most frquently seenhealthcare_datasethealthcare_dataset
SELECT Medical_Condition, COUNT(*) AS Total_Cases
FROM healthcare_dataset
GROUP BY Medical_Condition
ORDER BY Total_Cases DESC;

-- Avg Hospital billing by medical conditions
-- Which conditions cost the most?
SELECT Medical_Condition, ROUND(AVG( Billing_Amount),2) as  Avg_Billing
FROM healthcare_dataset
group BY Medical_Condition
ORDER BY Avg_Billing DESC;

-- Billing trend over time
-- Revenue Pattern by admission month
SELECT date_format(date_of_admission, '%y-%m') AS month,
SUM(Billing_Amount) AS Total_Revenue
FROM healthcare_dataset
GROUP BY month
ORDER BY month;

-- Doctor Performance by patients
-- Which Doctor handles the most patients
SELECT Doctor, count(*) AS Patient_count
FROM healthcare_dataset 
GROUP BY Doctor
ORDER BY Patient_Count DESC
LIMIT 100;

-- Hospital_wise billing and patient load
-- Comparision of hospitals on paitient and revenue
SELECT 
    Hospital,
    COUNT(*) AS Total_Patients,
    SUM(Billing_Amount) AS Total_Billing
FROM healthcare_dataset
GROUP BY Hospital
ORDER BY Total_Billing DESC;

-- Insurance provider coverage
SELECT Insurance_Provider, COUNT(*) AS Total_Patients
FROM healthcare_dataset
GROUP BY Insurance_Provider
ORDER BY Total_Patients DESC;

-- Admission type analysis
-- how many patients are from emergency,urgent and routine
SELECT Admission_Type, COUNT(*) AS Total_Admissions
FROM healthcare_dataset
GROUP BY Admission_Type;

-- Medication usage frequency
-- Whice medicine are prescribed most
SELECT Medication, COUNT(*) AS Usage_Frequency
FROM healthcare_dataset
GROUP BY Medication
ORDER BY Usage_Frequency DESC;



