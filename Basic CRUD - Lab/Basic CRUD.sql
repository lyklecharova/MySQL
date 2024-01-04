use hotel;

-- 01: Select Employee Information
SELECT id, first_name, last_name, job_title 
FROM employees
ORDER BY id;

-- 02. Select Employees with Filter
SELECT id, 
CONCAT_WS(' ', first_name, last_name) AS 'full_name', 
job_title, 
salary
FROM employees
WHERE salary > 1000
ORDER BY id;