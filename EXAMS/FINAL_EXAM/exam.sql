CREATE DATABASE `preserves_db`;
USE `preserve`;

-- 1 Table Design
CREATE TABLE `continents` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `countries` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `country_code` VARCHAR(10) NOT NULL UNIQUE,
    `continent_id` INT NOT NULL,
    
    CONSTRAINT `fk_countries_continents`
        FOREIGN KEY(`continent_id`)
            REFERENCES `continents`(`id`)
);

CREATE TABLE `preserves` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `latitude` DECIMAL(9,6),
    `longitude` DECIMAL(9,6),
    `area` INT,
    `type` VARCHAR(20),
    `established_on` DATE
);

CREATE TABLE `positions` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `description` TEXT,
    `is_dangerous` TINYINT(1) NOT NULL
);

CREATE TABLE `workers` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `age` INT,
    `personal_number` VARCHAR(20) NOT NULL UNIQUE,
    `salary` DECIMAL(19,2),
    `is_armed` TINYINT(1) NOT NULL,
    `start_date` DATE,
    `preserve_id` INT,
    `position_id` INT,
    
    CONSTRAINT `fk_workers_preserves`
        FOREIGN KEY(`preserve_id`)
            REFERENCES `preserves`(`id`),
    
       
    CONSTRAINT `fk_workers_positions`
        FOREIGN KEY(`position_id`)
            REFERENCES `positions`(`id`)
);

CREATE TABLE `countries_preserves` (
	`country_id` INT,
    `preserve_id` INT,
    
    CONSTRAINT `fk_countries_preserves_countries`
        FOREIGN KEY(`country_id`)
            REFERENCES `countries`(`id`),
    
    CONSTRAINT `fk_countries_preserves_preserves`
        FOREIGN KEY(`preserve_id`)
            REFERENCES `preserves`(`id`)
);

-- 2 Insert
INSERT INTO `preserves`(`name`,`latitude`,`longitude`,`area`,`type`,`established_on`)
SELECT
	CONCAT(`name`, ' ', 'is in South Hemisphere'),
    `latitude`,
    `longitude`,
    `area` * `id`,
    LOWER(`type`),
    `established_on`
FROM `preserves`
WHERE `latitude` < 0 ;

-- 3 Update
UPDATE `workers` 
SET 
    `salary` = `salary` + 500
WHERE
    `position_id` IN (5 , 8, 11, 13);
    
-- 4 Delete
DELETE FROM `preserves` 
WHERE
    `established_on` IS NULL;
    
-- 5 Most experienced workers
SELECT
	CONCAT(`first_name`, ' ', `last_name`) AS 'full_name',
    DATEDIFF('2024-01-01', `start_date`) AS 'days_of_experience'
FROM `workers`
WHERE DATEDIFF('2024-01-01', `start_date`) > 1825
ORDER BY `days_of_experience` DESC
LIMIT 10;

-- 6 Worker's salary
SELECT `w`.`id`   AS 'worker_id',
       `w`.`first_name`,
       `w`.`last_name`,
       `p`.`name` AS 'preserve_name',
       `c`.`country_code`
FROM `workers` AS `w`
         JOIN `preserves` AS `p` ON `w`.`preserve_id` = `p`.`id`
         JOIN `countries_preserves` `cp` ON `p`.`id` = `cp`.`preserve_id`
         JOIN `countries` AS `c` ON `cp`.`country_id` = `c`.`id`
WHERE `w`.`salary` > 5000
  AND `w`.`age` < 50
ORDER BY `c`.`country_code`;

-- 7 
SELECT `p`.`name`,
       COUNT(`w`.`is_armed`) AS 'armed_workers'
FROM `preserves` AS `p`
         JOIN `workers` AS `w` ON `p`.`id` = `w`.`preserve_id`
where `w`.`is_armed` = 1
GROUP BY `p`.`name`
ORDER BY `armed_workers` DESC, `p`.`name`;

-- 8 Oldest preserves
SELECT
	`p`.`name`,
    `c`.`country_code`,
    YEAR(`p`.`established_on`) AS 'founded_in'
FROM `preserves` AS `p`
	JOIN `countries_preserves` AS `cp` ON `p`.`id` = `cp`.`preserve_id`
    JOIN `countries` AS `c` ON `cp`.`country_id`= `c`.`id`
WHERE MONTH(`p`.`established_on`) = 5
ORDER BY `p`.`established_on` ASC
LIMIT 5;

-- 9 Preserve categories
SELECT
	`id`,
    `name`,
    CASE
		WHEN `area` <= 100 THEN 'very small'
        WHEN `area` > 100 AND `area` <= 1000 THEN 'small'
        WHEN `area` > 1000 AND `area` <= 10000 THEN 'medium'
        WHEN `area` > 10000 AND `area` <= 50000 THEN 'large'
       ELSE 'very large'
	END AS 'category'
FROM `preserves`
ORDER BY `area` DESC;

-- 10 Extract average salary
DELIMITER $$
CREATE FUNCTION `udf_average_salary_by_position_name`(`name` VARCHAR(40))
RETURNS DECIMAL(19,2)
DETERMINISTIC
BEGIN 
	RETURN(
		SELECT AVG(`w`.`salary`)
        FROM `positions` AS `p`
			JOIN `workers` AS `w` ON `p`.`id` = `w`.`position_id`
		WHERE `p`.`name` = `name`
    );
END $$
DELIMITER ;

-- 11 Improving the standard of living
DELIMITER $$
CREATE PROCEDURE `udp_increase_salaries_by_country`(`country_name` VARCHAR(40))
BEGIN
	UPDATE `workers` AS `w`
        JOIN `preserves` AS `p` ON `w`.`preserve_id` = `p`.`id`
        JOIN `countries_preserves` AS `cp` ON `p`.`id` = `cp`.`preserve_id`
        JOIN `countries` AS `c` ON `cp`.`country_id` = `c`.`id`
    SET `w`.`salary` = `w`.`salary` * 1.05
    WHERE `c`.`name` = `country_name`;
END $$
DELIMITER ;