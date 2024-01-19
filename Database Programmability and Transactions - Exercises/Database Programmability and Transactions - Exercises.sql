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

-- 5 Salary Level Function
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level`(`salary` DECIMAL(19,4))
RETURNS VARCHAR(7)
DETERMINISTIC
BEGIN
    IF (`salary` < 30000) THEN
        RETURN 'Low';
    ELSEIF (`salary` >= 30000 AND `salary` <= 50000) THEN
        RETURN 'Average';
    ELSE
        RETURN 'High';
    END IF;
END $$
DELIMITER ;

-- 6 Employees by Salary Level
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_by_salary_level`(`salary_level` VARCHAR(7))
BEGIN
    SELECT `first_name`, `last_name`
    FROM `employees`
    WHERE (`salary` < 30000 AND `salary_level` = 'Low')
       OR (`salary` >= 30000 AND `salary` <= 50000 AND `salary_level` = 'Average')
       OR (`salary` > 50000 AND `salary_level` = 'High')
    ORDER BY `first_name` DESC, `last_name` DESC;
END $$
DELIMITER ;

-- 7 Define Function
DELIMITER $$
CREATE FUNCTION `ufn_is_word_comprised`(`set_of_letters` VARCHAR(50), `word` VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
     RETURN `word` REGEXP (CONCAT('^[', `set_of_letters`, ']+$'));
END $$
DELIMITER ;

-- 8 Find Full Name
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_full_name`()
BEGIN
    SELECT CONCAT(`first_name`, ' ', `last_name`) AS 'full_name'
    FROM `account_holders`
    ORDER BY `full_name`, `id`;
END $$
DELIMITER ;

-- 9 People with Balance Higher Than
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_with_balance_higher_than`(`number` DECIMAL(19,4))
BEGIN
    SELECT `ah`. `first_name`, `ah`. `last_name`
FROM `account_holders` AS `ah`
JOIN `accounts` AS `a` ON `ah`. `id` = `a`. `account_holder_id`
GROUP BY  `a`. `account_holder_id`
HAVING SUM(`a`. `balance`) > number
ORDER BY `a`. `account_holder_id`;
END $$
DELIMITER ;

SELECT 
    `ah`.`first_name`, `ah`.`last_name`
FROM
    `account_holders` AS `ah`
        JOIN
    `accounts` AS `a` ON `ah`.`id` = `a`.`account_holder_id`
GROUP BY `a`.`account_holder_id`
HAVING SUM(`a`.`balance`) > 7000
ORDER BY `a`.`account_holder_id`;

-- 10 Future Value Function
DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value`(
			`sum` DOUBLE(10,4), 
            `yearly_interest_rate` DOUBLE(19,4), 
            `number_of_years` INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
BEGIN
	 RETURN `sum` * (POW((1 + `yearly_interest_rate`), `number_of_years`));
END $$
DELIMITER ;

