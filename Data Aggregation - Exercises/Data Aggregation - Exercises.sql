use gringotts;

-- 1 Records' Count
SELECT  COUNT(*) AS 'count'
FROM `wizzard_deposits`;

-- 2 Longest Magic Wand
SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`;

-- 3 Longest Magic Wand Per Deposit Groups
SELECT `deposit_group`, MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand` ASC , `deposit_group` ASC;

-- 4 Smallest Deposit Group Per Magic Wand Size*
SELECT `deposit_group`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
HAVING AVG(`magic_wand_size`)
ORDER BY AVG(`magic_wand_size`)
LIMIT 1; 

-- 5 Deposits Sum
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum`;

-- 6 Deposits Sum for Ollivander Family
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE 
	`magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

-- 7 Deposits Filter
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE
	`magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000 
ORDER BY `total_sum` DESC;

-- 8 Deposit Charge
SELECT
	 `deposit_group`,
     `magic_wand_creator`,
     MIN(`deposit_charge`) AS 'min_deposit_charge'
FROM `wizzard_deposits`
GROUP BY  `deposit_group`,  `magic_wand_creator`
ORDER BY  `magic_wand_creator` ASC, `deposit_group` ASC;

-- 9 Age Groups
SELECT 
	CASE
		WHEN `age` BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN `age` >= 61 THEN '[61+]'
	END AS 'age_group',
    COUNT(`first_name`) AS 'wizard_count'
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `age_group`;

-- 10 First Letter
SELECT LEFT(`first_name`,1) AS 'first_letter'
FROM `wizzard_deposits`
WHERE
	`deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter` ASC;

-- 11 Average Interest
SELECT  
	`deposit_group`,
    `is_deposit_expired`,
    AVG(`deposit_interest`) AS 'average_interest'
FROM `wizzard_deposits`
WHERE
	`deposit_start_date` > '1985/01/01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY  `deposit_group` DESC, `is_deposit_expired` ASC;

-- 12 Employees Minimum Salaries
SELECT `department_id`, MIN(`salary`) AS 'minimum_salary'
FROM `employees`
WHERE
	`hire_date` > '2000/01/01'
GROUP BY `department_id`
HAVING `department_id` IN (2,5,7)
ORDER BY `department_id`;

-- 13 Employees Average Salaries
CREATE TABLE `salary_more_than_30000` AS
SELECT *
FROM `employees`
WHERE
	`salary` > 30000;

DELETE FROM `salary_more_than_30000`
WHERE
	`manager_id` = 42;
    
UPDATE `salary_more_than_30000` 
SET
	`salary` = `salary` + 5000
WHERE
	`department_id` = 1;

SELECT `department_id`, AVG(`salary`) AS 'avg_salary'
FROM `salary_more_than_30000`
GROUP BY `department_id`
ORDER BY `department_id` ASC;

-- 14 Employees Maximum Salaries
SELECT `department_id`, MAX(`salary`) AS 'max_salary'
FROM `employees`
GROUP BY   `department_id`
HAVING 
	`max_salary` < 30000
    OR `max_salary` > 70000
ORDER BY `department_id` ASC;

-- 15 Employees Count Salaries
SELECT
	COUNT(*) AS 'count'
FROM `employees`
WHERE
	`manager_id` IS NULL;

-- 16 3rd Highest Salary*
SELECT DISTINCT
    `department_id`,
    (SELECT DISTINCT
            `salary`
        FROM
            `employees` AS `e1`
        WHERE
            `e1`.`department_id` = `employees`.`department_id`
        ORDER BY `salary` DESC
        LIMIT 1 OFFSET 2) AS `third_highest_salary`
FROM
    `employees`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY `department_id`;

-- 17 Salary Challenge**
SELECT
	`first_name`,
    `last_name`,
    `department_id`
FROM `employees` AS `emp1`
WHERE
	`salary` > (
			SELECT AVG(`salary`)
            FROM `employees` AS `emp2`
            WHERE `emp1`. `department_id` = `emp2`. `department_id`
    )
ORDER BY `department_id`, `employee_id`
LIMIT 10;


