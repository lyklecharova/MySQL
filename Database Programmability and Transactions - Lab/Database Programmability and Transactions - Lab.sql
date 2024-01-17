USE `soft_uni`;

-- 1 Count Employees by Town
DELIMITER $$
CREATE FUNCTION `ufn_count_employees_by_town`(`town_name` VARCHAR(50))
	RETURNS INT
    DETERMINISTIC
BEGIN
	RETURN(
    SELECT COUNT(*) 
        FROM `employees` AS `e`
        JOIN `addresses` AS `a` ON `e`. `address_id` = `a`. `address_id` 
        JOIN `towns` AS `t` ON `a`. `town_id` = `t`. `town_id`
        WHERE `t`. `name` = `town_name`
        );
END$$

DELIMITER ;
;

SELECT `ufn_count_employees_by_town`('Sofia') AS 'count';

-- 2 Employees Promotion
DELIMITER $$
CREATE PROCEDURE `usp_raise_salaries`(`department_name` VARCHAR(50))
BEGIN
	UPDATE `employees` AS `e`
    JOIN `departments` AS `d` ON `e`. `department_id`= `d`. `department_id`
    SET `e`. `salary` = `e`. `salary` * 1.05
    WHERE `d`. `name` = `department_name`;
END$$

DELIMITER ;
;

-- 3 Employees Promotion by ID
DELIMITER $$
CREATE PROCEDURE `usp_raise_salary_by_id`(`id` INT)
BEGIN 
	DECLARE `employee_id_count` INT;
    SET `employee_id_count` := (
		SELECT COUNT(*)
        FROM `employees`
        WHERE `employee_id` = `id`
    );
    IF(`employee_id_count` = 1)
    THEN
     UPDATE `employees`
        SET `salary` = `salary` * 1.05
        WHERE `employee_id` = `id`;
        END IF;
END $$

DELIMITER ;
;