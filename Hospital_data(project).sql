create database hospital;
use hospital;

-- All Unique Disease
select distinct disease
from hospital_data;

-- Readmitted Patients 
select * from hospital_data
where readmitted = 'Yes';

-- Total and Average Treatment Cost Per Disease
select disease,
 count(*),
round(sum(treatment_cost),2) as total_cost,
round(avg(treatment_cost),2) as average_cost
from hospital_data
group by disease
order by average_cost;

--  Patients Are In Each Hospital Department
select hospital_department,
count(*) as total_patients from hospital_data
group by hospital_department
order by total_patients desc;

-- Readmission Rate Per Disease
select disease,
count(*) as total_patients,
round(sum(case when readmitted = "Yes" then 1 else 0 end) * 100 / count(*),1) as readmission_rate
from hospital_data
group by disease
order by  readmission_rate desc;

-- City Has The Highest Average Treatment Cost
select city,
count(*) as total_patients,
round(avg(treatment_cost),2) as avg_treatment_cost
from hospital_data
group by city
order by avg_treatment_cost desc;

-- How Many Patients Have Insurance vs No Insurance
select insurance,
count(*) as patients,
ROUND(AVG(treatment_cost), 2) AS avg_cost
from hospital_data
group by insurance

-- Gender Split Per Disease
select disease, gender,
count(*) as patients
from hospital_data 
group by  gender,disease;

-- Doctor Handles The Most Patients
select doctor_id, total_patients
from( select doctor_id, 
	 count(*) as total_patients,
     rank() over(order by count(*) desc) as rnk
     from hospital_data
     group by doctor_id) t
where rnk <= 10;

-- Patients With Treatment Cost Above The Overall Average
select patient_id,age,disease,treatment_cost
from hospital_data
where treatment_cost > (select avg(treatment_cost) from hospital_data)

-- Patients Admitted And Discharged In The Same Month
select patient_id, admission_date,discharge_date,disease
from hospital_data
where month(admission_date) = month(discharge_date) and
year(admission_date) = year(discharge_date);

--  Top 3 Most Expensive Treatments Per Department
SELECT hospital_department,patient_id,disease,treatment_cost
from ( select * ,
       rank() over (partition by hospital_department order by treatment_cost desc) as rnk
       from hospital_data) t
where rnk <=3;

--  Length Of Stay For Each Patient In Days
select patient_id,disease,admission_date,discharge_date,
datediff(discharge_date,admission_date) as stay_days
from hospital_data;
