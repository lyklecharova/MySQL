CREATE DATABASE `FSD`;
USE `FSD`;

-- 1 Table Design
CREATE TABLE `countries` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `towns` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `country_id` INT NOT NULL,
    
    CONSTRAINT `fk_towns_countries`
		FOREIGN KEY(`country_id`)
			REFERENCES `countries`(`id`)
);

CREATE TABLE `stadiums` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `capacity` INT NOT NULL,
    `town_id` INT NOT NULL,
    
    CONSTRAINT `fk_stadiums_towns`
		FOREIGN KEY(`town_id`)
			REFERENCES `towns`(`id`)
);

CREATE TABLE `teams` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `established` DATE NOT NULL,
    `fan_base` BIGINT(20) NOT NULL DEFAULT 0,
    `stadium_id` INT NOT NULL,
    
    CONSTRAINT `fk_teams_stadiums`
		FOREIGN KEY(`stadium_id`)
			REFERENCES `stadiums`(`id`)
);

CREATE TABLE `skills_data` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `dribbling` INT DEFAULT 0,
    `pace` INT DEFAULT 0,
    `passing` INT DEFAULT 0,
    `shooting` INT DEFAULT 0,
    `speed` INT DEFAULT 0,
    `strength` INT DEFAULT 0
);

CREATE TABLE `coaches` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `salary` DECIMAL(10,2) NOT NULL DEFAULT 0,
    `coach_level` INT NOT NULL DEFAULT 0
);

CREATE TABLE `players` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `age` INT NOT NULL DEFAULT 0,
    `position` CHAR(1) NOT NULL,
    `salary` DECIMAL(10,2) NOT NULL DEFAULT 0,
    `hire_date` DATETIME,
    `skills_data_id` INT NOT NULL,
    `team_id` INT,
    
    CONSTRAINT `fk_players_skills_data`
		FOREIGN KEY(`skills_data_id`)
			REFERENCES `skills_data`(`id`),
    
    CONSTRAINT `fk_players_teams`
		FOREIGN KEY(`team_id`)
			REFERENCES `teams`(`id`)
);

CREATE TABLE `players_coaches` (
    `player_id` INT,
    `coach_id` INT,
    
    CONSTRAINT `fk_players_coaches_players`
		FOREIGN KEY(`player_id`)
			REFERENCES `players`(`id`),
    
    CONSTRAINT `fk_players_coaches_coaches`
		FOREIGN KEY(`coach_id`)
			REFERENCES `coaches`(`id`)
);

-- 2 Insert
INSERT INTO `coaches`(`first_name`, `last_name`, `salary`, `coach_level`)
SELECT
	`first_name`,
    `last_name`,
    `salary` * 2,
    CHAR_LENGTH(`first_name`)
FROM `players`
WHERE `age` >= 45;

-- 3 Update
UPDATE `coaches` AS `c`
	JOIN `players_coaches` AS `pc` ON `c`.`id` = `pc`.`coach_id`
SET `c`.`coach_level` = `c`.`coach_level` + 1
WHERE `c`.`first_name` LIKE 'A%';

-- 4 Delete
DELETE
FROM `players`
WHERE `age` >= 45;

-- 5 Players
SELECT
	`first_name`,
    `age`,
    `salary`
FROM `players`
ORDER BY  `salary` DESC;

-- 6 Young offense players without a contract
SELECT
	`p`.`id`,
    CONCAT(`p`.`first_name`, ' ', `p`.`last_name`) AS 'full_name',
     `age`,
	`position`,
	`hire_date`
FROM `players` AS `p`
	JOIN `skills_data` AS `sd` ON `p`.`skills_data_id` = `sd`.`id`
WHERE 
	`age` < 23
    AND `position` LIKE 'A'
    AND `hire_date` IS NULL
    AND `sd`.`strength` > 50
ORDER BY `salary` ASC, `age`;

-- 07. Detail info for all teams
SELECT `t`.`name`      AS `team_name`,
       `t`.`established`,
       `t`.`fan_base`,
       COUNT(`p`.`id`) AS 'players_count'
FROM `teams` AS `t`
         LEFT JOIN `players` AS `p` ON `t`.`id` = `p`.`team_id`
GROUP BY `t`.`name`, `t`.`established`, `t`.`fan_base`
ORDER BY `players_count` DESC, `fan_base` DESC;

-- 9 Total salaries and players by country
SELECT
	`c`.`name`,
    COUNT(`p`.`id`) AS 'total_count_of_players',
    SUM(DISTINCT `p`.`salary`) AS 'total_sum_of_salaries'
FROM `players` AS `p`
	RIGHT JOIN `skills_data` AS `sd` ON `p`.`skills_data_id` = `sd`.`id`
    RIGHT JOIN `teams` AS `t` ON `p`.`team_id` = `t`.`id`
    RIGHT JOIN `stadiums` AS `s` ON `t`.`stadium_id` = `s`.`id`
     RIGHT JOIN `towns` AS `ts` ON `s`.`town_id` = `ts`.`id`
	RIGHT JOIN `countries` AS `c` ON `ts`.`country_id` = `c`.`id`
GROUP BY `c`.`name`
ORDER BY `total_count_of_players` DESC, `c`.`name`;

-- 10 Find all players that play in the stadium
DELIMITER $$
CREATE FUNCTION `udf_stadium_players_count` (`stadium_name` VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT
			COUNT(`p`.`id`)
		FROM `players` AS `p`
			RIGHT JOIN `teams` AS `t` ON `p`.`team_id` = `t`.`id`
            RIGHT JOIN `stadiums` AS `s` ON `t`.`stadium_id` = `s`.`id`
            RIGHT JOIN `towns` AS `ts` ON `s`.`town_id` = `ts`.`id`
		WHERE `s`.`name` LIKE `stadium_name`
    );
END $$
DELIMITER ;

-- 11 Find good playmakers by teams
DELIMITER $$
CREATE PROCEDURE `udp_find_playmaker`(`min_dribble_points` INT, `team_name` VARCHAR(45))
BEGIN

    SELECT CONCAT(`p`.`first_name`, ' ', `p`.`last_name`) AS 'full_name',
           `age`,
           `salary`,
           `sd`.`dribbling`,
           `sd`.`speed`,
           `t`.`name`
    FROM `players` AS `p`
             JOIN `skills_data` AS `sd` ON `p`.`skills_data_id` = `sd`.`id`
             JOIN `teams` AS `t` ON `p`.`team_id` = `t`.`id`
    WHERE `sd`.`dribbling` > `min_dribble_points`
      AND `t`.`name` LIKE `team_name`
      AND `speed` > (SELECT AVG(`speed`)
                     FROM `skills_data`)
    ORDER BY `sd`.`speed` DESC
    LIMIT 1;

END $$
DELIMITER ;