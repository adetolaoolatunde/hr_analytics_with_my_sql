-- Questions
-- ============
-- What is the gender breakdown of employees in the company?
-- What is the race/ethnicity breakdown of employees in the company?
-- What is the age distribution of employees in the company?
-- How many employees work at headquarters versus remote locations?
-- What is the average length of employment for employees who have been terminated?
-- How does the gender distribution/count vary across departments and job titles?
-- What is the distribution/count of job titles across the company?
-- Which department has the highest turnover rate?
-- What is the distribution/count of employees across locations by city and state?
-- How has the company's employee count changed over time based on hire and term dates?


-- What is the gender breakdown of employees in the company?
-- ==========================================================
SELECT gender, COUNT(gender) num_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender
;


-- What is the race/ethnicity breakdown of employees in the company?
-- =================================================================
SELECT race, COUNT(race) num_of_employees  
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
;
 
-- What is the age distribution of employees in the company?
-- ==========================================================
SELECT 
  CASE 
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS num_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group
;

SELECT 
  CASE 
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+'
  END AS age_group,
  gender,
  COUNT(*) AS num_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group
;

-- How many employees work at headquarters versus remote locations?
-- ================================================================
SELECT location, COUNT(*) num_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location
;

-- What is the average length of employment for employees who have been terminated?
-- =================================================================================
SELECT ROUND(AVG(length_of_employment)) avg_length_of_employment
FROM (SELECT YEAR(FROM_DAYS(DATEDIFF(termdate, hire_date))) length_of_employment 
		FROM hr
		WHERE age >= 18 AND 
			  termdate IS NOT NULL AND
              termdate < CURDATE()) temp
;

-- How does the gender distribution/count vary across departments and job titles?
-- ===============================================================================
SELECT department, jobtitle, gender, COUNT(*) num_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender, department, jobtitle
ORDER BY department
;

-- What is the distribution/count of job titles across the company?
-- ======================================================================
SELECT jobtitle, COUNT(*) num_of_employees 
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle
;

-- Which department has the highest turnover rate?
-- =========================================================
SELECT department,
  total_count,
  terminated_count,
  terminated_count/total_count AS termination_rate
FROM (
  SELECT department,
    COUNT(*) AS total_count,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
  FROM hr
  WHERE age >= 18
  GROUP BY department) AS t
ORDER BY termination_rate DESC
;

-- What is the distribution/count of employees across locations by city and state?
-- ===============================================================================
SELECT location, location_state, location_city, COUNT(*) num_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location, location_city, location_state
ORDER BY num_of_employees
;

-- How has the company's employee count changed over time based on hire and term dates?
-- ====================================================================================
SELECT 
	b.year year, 
	a.hire hired, 
    b.term term,
    a.hire - b.term AS net_change,
    ROUND(((a.hire - b.term)/a.hire) * 100, 2) AS net_change_percent
FROM 
	( SELECT YEAR(hire_date) year, 
			 COUNT(*) hire
	  FROM hr
      WHERE age >= 18
      GROUP BY year
      ORDER BY year
	) a RIGHT JOIN 
    ( SELECT YEAR(termdate) year, COUNT(*) term 
      FROM hr
      WHERE age >= 18
      GROUP BY year
      ORDER BY year
	) b 
ON a.year = b.year
WHERE b.year <= YEAR(CURDATE())
;
