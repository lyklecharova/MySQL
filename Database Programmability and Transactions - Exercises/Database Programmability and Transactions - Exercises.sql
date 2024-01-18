USE `soft_uni`;

-- 1 Employees with Salary Above 35000
DELIMITER $$ CREATE PROCEDURE `usp_get_employees_salary_above_35000`() BEGIN
SELECT `first_name`,
    `last_name`
FROM `employees`
WHERE `salary` > 35000
ORDER BY `first_name`,
    `last_name`,
    `employee_id`;
END $$ DELIMITER;

-- 2 Employees with Salary Above Number
DELIMITER $$ CREATE PROCEDURE `usp_get_employees_salary_above`(`number` DECIMAL(19, 4)) BEGIN
SELECT `first_name`,
    `last_name`
FROM `employees`
WHERE `salary` >= `number`
ORDER BY `first_name`,
    `last_name`,
    `employee_id`;
END $$ DELIMITER;

-- 3 Town Names Starting With
DELIMITER $$ CREATE PROCEDURE `usp_get_towns_starting_with` (IN `start_string` VARCHAR(50)) BEGIN
SELECT `name` AS 'town_name'
FROM `towns`
WHERE `name` LIKE CONCAT(`start_string`, '%')
ORDER BY `name` ASC;
END $$ DELIMITER;

-- 4 Employees from Town
DELIMITER $$ CREATE PROCEDURE `usp_get_employees_from_town` (`town_name` VARCHAR(50)) BEGIN
SELECT `first_name`,
    `last_name`
FROM `employees` AS `e`
    JOIN `addresses` AS `a` ON `e`.`address_id` = `a`.`address_id`
    JOIN `towns` AS `t` ON `a`.`town_id` = `t`.`town_id`
WHERE `t`.`name` = `town_name`
ORDER BY `e`.`first_name`,
    `e`.`last_name`,
    `e`.`employee_id`;
END $$ DELIMITER;