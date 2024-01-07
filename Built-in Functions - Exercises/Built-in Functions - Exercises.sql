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

-- 5 Find Towns with Name Length
SELECT `name`
FROM `towns`
WHERE 
	CHAR_LENGTH(`name`) IN (5,6)
ORDER BY `name` ASC;

-- 6 Find Towns Starting With
SELECT `town_id`, `name`
FROM `towns`
WHERE
	LOWER(`name`) LIKE 'm%'
    OR LOWER(`name`) LIKE 'k%'
    OR LOWER(`name`) LIKE 'b%'
    OR LOWER(`name`) LIKE 'e%'
ORDER BY `name`ASC;

-- 7 Find Towns Not Starting With
SELECT `town_id`, `name`
FROM `towns`
WHERE
	/*  
    LOWER(name) NOT LIKE 'r%'
    AND LOWER(name) NOT LIKE 'b%'
    AND LOWER(name) NOT LIKE 'd%'
    */
	`name` REGEXP '^[^RrBbDd]'
ORDER BY `name`ASC;

-- 8 Create View Employees Hired After 2000 Year
CREATE VIEW v_employees_hired_after_2000 AS
	SELECT first_name, last_name
    FROM employees
    WHERE YEAR(hire_date) > 2000;

-- 9 Length of Last Name
SELECT first_name, last_name
FROM employees
WHERE
	LENGTH(`last_name`) = 5;