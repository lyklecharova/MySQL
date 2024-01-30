CREATE DATABASE `sgd`;
USE `sgd`;

-- 1 Table Design
CREATE TABLE `addresses` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `categories` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL
);

CREATE TABLE `offices` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `workspace_capacity` INT NOT NULL,
    `website` VARCHAR(50),
    `address_id` INT NOT NULL,
    
    CONSTRAINT `fk_offices_addresses`
		FOREIGN KEY(`address_id`)
			REFERENCES `addresses`(`id`)
);

CREATE TABLE `employees` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `age` INT NOT NULL,
    `salary` DECIMAL(10 , 2 ) NOT NULL,
    `job_title` VARCHAR(20) NOT NULL,
    `happiness_level` CHAR(1) NOT NULL
);

CREATE TABLE `teams` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,
    `office_id` INT NOT NULL,
    `leader_id` INT NOT NULL UNIQUE,
    
    CONSTRAINT `fk_teams_offices`
		FOREIGN KEY(`office_id`)
			REFERENCES `offices`(`id`),
    
    CONSTRAINT `fk_teams_employees`
		FOREIGN KEY(`leader_id`)
			REFERENCES `employees`(`id`)
);

CREATE TABLE `games` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `description` TEXT,
    `rating` FLOAT NOT NULL DEFAULT 5,
    `budget` DECIMAL(10,2) NOT NULL,
    `release_date` DATE,
    `team_id` INT NOT NULL,
    
    CONSTRAINT `fk_games_teams`
		FOREIGN KEY(`team_id`)
			REFERENCES `teams`(`id`)
);

CREATE TABLE `games_categories` (
    `game_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    PRIMARY KEY (`game_id` , `category_id`),
    
    CONSTRAINT `fk_games_categories_games`
		FOREIGN KEY (`game_id`)
			REFERENCES `games` (`id`),
        
    CONSTRAINT `fk_games_categories_categories`
		FOREIGN KEY (`category_id`)
			REFERENCES `categories` (`id`)
);

-- 2 Insert
INSERT INTO `games` (`name`, `rating`, `budget`, `team_id`)
SELECT
	REVERSE(LOWER(SUBSTRING(`name`, 2))),
    `id`,
    `leader_id` * 1000,
    `id`
FROM `teams`
WHERE `id` BETWEEN 1 AND 9;

-- 3 Update
UPDATE `employees` AS `e`
	JOIN `teams` AS `t` ON `e`.`id` = `t`.`leader_id`
SET `e`.`salary` = `e`.`salary` + 1000
WHERE 
	`e`.`age` <= 40
    AND `e`.`salary` <= 5000;
    
-- 4 Delete
DELETE `g`
FROM `games` AS `g`
	LEFT JOIN `games_categories` AS `gc` ON `g`.`id` = `gc`.`game_id`
WHERE  
	`g`.`release_date` IS NULL
    AND `gc`.`category_id` IS NULL;
    
-- 5 Employees
SELECT
	`first_name`,
    `last_name`,
    `age`,
    `salary`,
    `happiness_level`
FROM `employees`
ORDER BY  `salary`, `id`;

-- 6 Addresses of the teams
SELECT
	`t`. `name` AS 'team_name',
    `a`. `name` AS 'address_name',
    CHAR_LENGTH( `a`. `name`) AS 'count_of_characters'
FROM `teams` AS `t`
JOIN `offices` AS `o` ON `t`.`office_id` = `o`.`id`
JOIN `addresses` AS `a` ON `o`.`address_id` = `a`.`id`
WHERE `o`.`website` IS NOT NULL
ORDER BY `t`. `name`,  `a`. `name`;

-- 7 Categories Info
SELECT
	`c`.`name`,
    COUNT(`g`.`name`) AS 'games_count',
    ROUND(AVG(`g`.`budget`),2) AS 'avg_budget',
    MAX(`g`.`rating`) AS 'max_rating'
FROM `games_categories` AS `gc`
	JOIN `games` AS `g` ON `gc`.`game_id` = `g`.`id`
    JOIN `categories` AS `c` ON `gc`.`category_id` = `c`.`id`
GROUP BY `category_id`, `c`.`name`
HAVING `max_rating` >= 9.5
ORDER BY `games_count` DESC, `c`.`name`;

-- 8 Games of 2022
SELECT
	`g`.`name`,
    `g`.`release_date`,
    CONCAT(SUBSTRING(`g`.`description`,1,10), '...') AS 'summary',
    CASE
		WHEN MONTH(`g`.`release_date`) IN (1,2,3)
			THEN 'Q1'
		WHEN MONTH(`g`.`release_date`) IN (4,5,6)
			THEN 'Q2'
		WHEN MONTH(`g`.`release_date`) IN (7,8,9)
			THEN 'Q3'
		WHEN MONTH(`g`.`release_date`) IN (10,11,12)
			THEN 'Q4'
		END AS 'quarter', `t`.`name` AS 'team_name'
FROM `games` AS `g`
	JOIN `teams` AS `t` ON `g`.`team_id` = `t`.`id`
WHERE 
	`g`.`name` LIKE '%2'
    AND MONTH(`g`.`release_date`) %2 = 0
    AND `g`.`release_date` LIKE '2022%'
ORDER BY `quarter`;

-- 9 Full info for games
SELECT
	`g`.`name`,
    IF(`g`.`budget`< 50000, 'Normal budget', 'Insufficient budget') AS 'budget_level',
    `t`.`name` AS 'team_name',
    `a`.`name` AS 'address_name'
FROM `categories` AS `c`
	RIGHT JOIN `games_categories` AS `gc` ON `c`.`id` = `gc`.`category_id`
    RIGHT JOIN `games` AS `g` ON `gc`.`game_id` = `g`.`id`
    JOIN `teams` AS `t` ON `g`.`team_id` = `t`.`id`
    JOIN `offices` AS `o` ON `t`.`office_id` = `o`.`id`
    JOIN `addresses` AS `a` ON `o`.`address_id` = `a`.`id`
WHERE 
	`g`.`release_date` IS NULL
    AND `c`.`name` IS NULL
ORDER BY `g`.`name`;

-- 10 Find all basic information for a game
DELIMITER $$
CREATE FUNCTION `udf_game_info_by_name`(`game_name` VARCHAR(20))
RETURNS TEXT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT
			CONCAT_WS(' ', 'The', `g`.`name`, 'is developed by a', `t`.`name`, 'in an office with an address', `a`.`name`)
		FROM `games` AS `g`
			JOIN `teams` AS `t` ON `g`.`team_id` = `t`.`id`
            JOIN `offices` AS `o` ON `t`.`office_id` = `o`.`id`
            JOIN `addresses` AS `a` ON `o`.`address_id` = `a`.`id`
		WHERE `g`.`name` = `game_name`
    );
END $$
DELIMITER ;

-- 11 Update the budget of the games 
DELIMITER $$
CREATE PROCEDURE `udp_update_budget`(`min_game_rating` FLOAT)
BEGIN 
	UPDATE `games` AS `g`
		LEFT JOIN `games_categories` AS `gc` ON `g`.`id` = `gc`.`game_id`
        LEFT JOIN `categories` AS `c` ON `gc`.`category_id` = `c`.`id`
	SET 
		`g`.`budget` = `g`.`budget` + 100000,
        `g`.`release_date` = DATE_ADD(`g`.`release_date`, INTERVAL 1 YEAR)
	WHERE 
		`c`.`id` IS NULL
        AND `release_date` IS NOT NULL
        AND `g`.`rating` > `min_game_rating`;
END $$
DELIMITER ;