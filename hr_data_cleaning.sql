-- Create Database
-- ===========================================  
CREATE DATABASE human_resource;
USE human_resource;

DESCRIBE hr;
SELECT * FROM hr;

-- Correcting the id field name
-- ===========================================  
ALTER TABLE hr
RENAME COLUMN ï»¿id TO id;


-- Reformatting date fields & modifying column
-- types.
-- =========================================== 
 
UPDATE hr
SET birthdate = CASE WHEN birthdate LIKE '%/%' THEN STR_TO_DATE(birthdate, "%m/%d/%Y")
					 WHEN birthdate LIKE '%-%' THEN STR_TO_DATE(birthdate, "%m-%d-%y")
				END;
                
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- Correct birthdates
UPDATE hr
SET birthdate = DATE_SUB(birthdate, INTERVAL 100 YEAR)
WHERE birthdate >= CURDATE(); 

UPDATE hr
SET hire_date = CASE WHEN hire_date LIKE '%/%' THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
					 WHEN hire_date LIKE '%-%' THEN STR_TO_DATE(hire_date, '%m-%d-%y')
				END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = CASE WHEN termdate <> '' THEN LEFT(termdate, 19)
					WHEN termdate = '0000-00-00 00:00:00' THEN NULL
			   END;

ALTER TABLE hr
MODIFY COLUMN termdate DATETIME;


ALTER TABLE hr
ADD COLUMN age INTEGER;
 
UPDATE hr
SET age = YEAR(FROM_DAYS(DATEDIFF(CURDATE(), birthdate)));