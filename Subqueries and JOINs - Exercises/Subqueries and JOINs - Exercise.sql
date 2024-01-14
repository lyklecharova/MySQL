USE `soft_uni`;

-- 1 Employee Address
SELECT 
    `e`.`employee_id`,
    `e`.`job_title`,
    `a`.`address_id`,
    `a`.`address_text`
FROM
    `employees` AS `e`
        JOIN
    `addresses` AS `a` ON `e`.`address_id` = `a`.`address_id`
ORDER BY `a`.`address_id` ASC
LIMIT 5;

-- 2 Addresses with Towns
SELECT 
    `e`.`first_name`,
    `e`.`last_name`,
    `t`.`name` AS 'town',
    `a`.`address_text`
FROM
    `employees` AS `e`
        JOIN
    `addresses` AS `a` ON `e`.`address_id` = `a`.`address_id`
        JOIN
    `towns` AS `t` ON `a`.`town_id` = `t`.`town_id`
ORDER BY `e`.`first_name` , `e`.`last_name`
LIMIT 5;

-- 3 Sales Employee
SELECT 
    `e`.`employee_id`,
    `e`.`first_name`,
    `e`.`last_name`,
    `d`.`name` AS 'department_name'
FROM
    `employees` AS `e`
        JOIN
    `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
WHERE
    `d`.`name` = 'Sales'
ORDER BY `e`.`employee_id` DESC
LIMIT 5

-- 4 Employee Departments
SELECT 
    `e`.`employee_id`,
    `e`.`first_name`,
    `e`.`salary`,
    `d`.`name` AS 'department_name'
FROM
    `employees` AS `e`
        JOIN
    `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
WHERE
    `e`.`salary` > 15000
ORDER BY `d`.`department_id` DESC
LIMIT 5;

-- 5 Employees Without Project
SELECT 
    `e`.`employee_id`, `e`.`first_name`
FROM
    `employees` AS `e`
        LEFT JOIN
    `employees_projects` AS `ep` ON `e`.`employee_id` = `ep`.`employee_id`
WHERE
    `ep`.`employee_id` IS NULL
ORDER BY `e`.`employee_id` DESC
LIMIT 3;

-- 6 Employees Hired After
SELECT 
    `e`.`first_name`,
    `e`.`last_name`,
    `e`.`hire_date`,
    `d`.`name` AS 'dept_name'
FROM
    `employees` AS `e`
        JOIN
    `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
WHERE
    `e`.`hire_date` > 1 / 1 / 1999
        AND `d`.`name` = 'Sales'
        OR `d`.`name` = 'Finance'
ORDER BY `e`.`hire_date` ASC;ORDER BY `e`.`hire_date` ASC;

-- 7 Employees with Project
SELECT 
    `e`.`employee_id`,
    `e`.`first_name`,
    `p`.`name` AS 'project_name'
FROM
    `employees` AS `e`
        JOIN
    `employees_projects` AS `ep` ON `e`.`employee_id` = `ep`.`employee_id`
        JOIN
    `projects` AS `p` ON `ep`.`project_id` = `p`.`project_id`
WHERE
    DATE(`p`.`start_date`) > '2002-08-13'
        AND `p`.`end_date` IS NULL
ORDER BY `e`.`first_name` ASC , `p`.`name` ASC
LIMIT 5;

-- 8 Employee 24
SELECT 
    `e`.`employee_id`,
    `e`.`first_name`,
    IF(YEAR(`start_date`) >= 2005,
        NULL,
        `p`.`name`) AS 'project_name'
FROM
    `employees` AS `e`
        JOIN
    `employees_projects` AS `ep` ON `e`.`employee_id` = `ep`.`employee_id`
        JOIN
    `projects` AS `p` ON `ep`.`project_id` = `p`.`project_id`
WHERE
    `e`.`employee_id` = 24
ORDER BY `p`.`name` ASC;


-- 9 Employee Manager
SELECT 
    `e`.`employee_id`,
    `e`.`first_name`,
    `e`.`manager_id`,
    (
    SELECT
		`m`. `first_name`
        FROM `employees` AS `m`
        WHERE `m`. `employee_id` = `e`. `manager_id`
    ) AS  'manager_name'
FROM `employees` AS `e`
WHERE `e`. `manager_id` IN (3,7)
ORDER BY `e`.`first_name`;

