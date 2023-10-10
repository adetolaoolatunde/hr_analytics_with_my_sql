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
					 WHEN birthdate LIKE '%-%' THEN STR_TO_DATE(birthdate, "%m-%d-%Y")
				END;
                
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

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
               
UPDATE hr
SET termdate = NULL
WHERE termdate = '0000-00-00 00:00:00';

ALTER TABLE hr
MODIFY COLUMN termdate DATETIME;