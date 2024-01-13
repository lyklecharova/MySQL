 USE `soft_uni`;
-- 1 Managers
SELECT *
FROM `employees`;

SELECT *
FROM `departments`;	

SELECT 
    `e`.`employee_id`,
    CONCAT(`first_name`, ' ', `last_name`) AS 'full_name',
    `d`.`department_id`,
    `d`.`name` AS 'department_name'
FROM
    `departments` AS `d`
        JOIN
    `employees` AS `e` ON `d`.`manager_id` = `e`.`employee_id`
ORDER BY `e`.`employee_id`
LIMIT 5;
    
-- 2 Towns Addresses
SELECT *
FROM `addresses`;

SELECT *
FROM `towns`;

SELECT 
    `t`.`town_id`, `t`.`name` AS 'town_name', `a`.`address_text`
FROM
    `towns` AS `t`
        JOIN
    `addresses` AS `a` ON `t`.`town_id` = `a`.`town_id`
WHERE
    `t`.`town_id` IN (9 , 15, 32)
ORDER BY `t`.`town_id` , `a`.`address_id`;
    
    
-- 3 Employees Without Managers
SELECT 
    `employee_id`,
    `first_name`,
    `last_name`,
    `department_id`,
    `salary`
FROM
    `employees`
WHERE
    `manager_id` IS NULL;

-- 4 Higher Salary
SELECT 
    COUNT(*) AS 'count'
FROM
    `employees`
WHERE
    `salary` > (SELECT 
            AVG(`salary`)
        FROM
            `employees`);