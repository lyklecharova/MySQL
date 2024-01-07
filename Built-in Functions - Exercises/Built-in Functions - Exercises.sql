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

use geography;

-- 10 Countries Holding 'A' 3 or More Times
SELECT country_name, iso_code
FROM countries
WHERE 
	(CHAR_LENGTH(`country_name`) - CHAR_LENGTH(REPLACE(LOWER(`country_name`), 'a', ''))) >=3
ORDER BY iso_code;

-- 11 Mix of Peak and River Names
SELECT 
    p.peak_name,
    r.river_name,
    LOWER(CONCAT(LEFT(p.peak_name,
	LENGTH(p.peak_name) - 1),
	r.river_name)) AS mix
FROM
    peaks AS p,
    rivers AS r
WHERE
    LOWER(RIGHT(p.peak_name, 1)) = LOWER(LEFT(r.river_name, 1))
ORDER BY mix ASC;


use diablo;

-- 12 Games from 2011 and 2012 Year
SELECT `name`,
	DATE_FORMAT(`start`, '%Y-%m-%d') AS `start`
FROM `games`
WHERE
	YEAR(`start`) IN (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;

-- 13 User Email Providers
SELECT user_name,
	  SUBSTRING_INDEX(email, '@', - 1) AS `email provider`
      /*
       REGEXP_REPLACE(email, '.*@', '') AS `email provider`
      */
FROM users
ORDER BY `email provider`, user_name;

-- 14 Get Users with IP Address Like Pattern
SELECT user_name, ip_address
FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name ASC;

-- 15 Show All Games with Duration and Part of the Day
SELECT 
    `name` AS games,
    CASE
        WHEN HOUR(start) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(start) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS 'Part of the Day',
    CASE
        WHEN duration <= 3 THEN 'Extra Short'
        WHEN duration BETWEEN 4 AND 6 THEN 'Short'
        WHEN duration BETWEEN 7 AND 10 THEN 'Long'
        ELSE 'Extra Long'
    END AS 'Duration'
FROM games;


use orders;

-- 16 Orders Table
SELECT 
	product_name, order_date,
    DATE_ADD(order_date, INTERVAL 3 DAY) AS pay_due,
    DATE_ADD(order_date, INTERVAL 1 MONTH) AS deliver_due
FROM orders;