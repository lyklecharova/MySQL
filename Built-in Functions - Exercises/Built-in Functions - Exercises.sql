use soft_uni;
 -- 1 Find Names of All Employees by First Name
 SELECT first_name, last_name
 FROM employees
 WHERE 
	LOWER(first_name) LIKE 'sa%'
 ORDER BY employee_id;
 
 -- 2 Find Names of All Employees by Last Name
SELECT first_name, last_name
FROM employees
WHERE 
	LOWER(last_name) LIKE '%ei%'
ORDER BY employee_id;

-- 3 Find First Names of All Employees
SELECT first_name
FROM employees
WHERE
	department_id IN (3,10)
	AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;

-- 4 Find All Employees Except Engineers
SELECT first_name, last_name
FROM employees
WHERE
	LOWER(job_title) NOT LIKE '%engineer%'
ORDER BY employee_id;