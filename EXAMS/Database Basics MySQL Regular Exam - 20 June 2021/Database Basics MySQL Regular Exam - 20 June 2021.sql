CREATE DATABASE `stc`;
USE `stc`;

-- 1 Table Design
CREATE TABLE `addresses` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL
);

CREATE TABLE `categories` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL
);

CREATE TABLE `clients` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `full_name` VARCHAR(50) NOT NULL,
    `phone_number` VARCHAR(20) NOT NULL
);

CREATE TABLE `drivers` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `age` INT NOT NULL,
    `rating` FLOAT DEFAULT 5.5
);

CREATE TABLE `cars` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `make` VARCHAR(20) NOT NULL,
    `model` VARCHAR(20),
    `year` INT DEFAULT 0 NOT NULL,
    `mileage` INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    `category_id` INT NOT NULL,
    
    CONSTRAINT `fk_cars_categories`
		FOREIGN KEY (`category_id`)
			REFERENCES `categories`(`id`)
);

CREATE TABLE `courses` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `from_address_id` INT NOT NULL,
    `start` DATETIME NOT NULL,
    `bill` DECIMAL(10,2) DEFAULT 10,
    `car_id` INT,
    `client_id` INT,
    
    CONSTRAINT `fk_courses_addresses`
		FOREIGN KEY (`from_address_id`)
			REFERENCES `addresses`(`id`),
    
    CONSTRAINT `fk_courses_cars`
		FOREIGN KEY (`car_id`)
			REFERENCES `cars`(`id`),
    
    CONSTRAINT `fk_courses_clients`
		FOREIGN KEY (`client_id`)
			REFERENCES `clients`(`id`)
);

CREATE TABLE `cars_drivers` (
	`car_id`    INT NOT NULL,
    `driver_id` INT NOT NULL,
    
    PRIMARY KEY (`car_id`, `driver_id`),
    
    CONSTRAINT `fk_car_driver_car`
		FOREIGN KEY (`car_id`)
			REFERENCES `cars` (`id`),
    
    CONSTRAINT `fk_car_driver_driver` 
		FOREIGN KEY (`driver_id`) 
			REFERENCES `drivers` (`id`)
);


-- 2 Insert
INSERT INTO `clients` (`full_name`, `phone_number`)
SELECT
	CONCAT(`first_name`, ' ' ,`last_name`),
    CONCAT(' (088) 9999', `id` *2)
FROM `drivers`
WHERE `id` BETWEEN 10 AND 20;

-- 3 Update
UPDATE `cars`
SET `condition` = 'C'
WHERE 
	`make` != 'Mercedes-Benz'
    AND (`mileage` >= 800000 || `cars`.`mileage` IS NULL)
    AND `year` <= 2010;

-- 4 Delete
DELETE `c`
FROM `clients` AS `c`
LEFT JOIN `courses` AS `co` ON `c`.`id` = `co`.`client_id`
WHERE 
	CHAR_LENGTH(`full_name`) > 3
    AND `co`.`client_id` IS NULL;

-- 5 Cars
SELECT
	`make`,
    `model`,
    `condition`
FROM `cars`
ORDER BY `id`;

-- 6 Drivers and Cars
SELECT 
	`d`.`first_name`,
    `d`.`last_name`,
    `c`.`make`,
    `c`.`model`,
    `c`.`mileage`
FROM `drivers` AS `d`
	JOIN `cars_drivers` AS `cd` ON `d`.`id` = `cd`.`driver_id`
	JOIN `cars` AS `c` ON `cd`.`car_id` = `c`.`id`
WHERE `c`.`mileage` IS NOT NULL
ORDER BY   `c`.`mileage` DESC, `d`.`first_name` ASC;

-- 7 Number of courses for each car
SELECT
	`c`.`id`,
    `c`.`make`,
    `c`.`mileage`,
    COUNT(`co`.`bill`) AS 'count_of_courses',
    ROUND(AVG(`co`.`bill`),2) AS 'avg_bill'
FROM `cars` AS `c`
	LEFT JOIN `courses` AS `co` ON `c`.`id` = `co`.`car_id`
GROUP BY `c`.`id`
HAVING `count_of_courses` != 2
ORDER BY `count_of_courses` DESC, `c`.`id`;

-- 8 Regular clients
SELECT `cl`.`full_name`,
       COUNT(`co`.`car_id`) AS 'count_of_cars',
       SUM(`co`.`bill`) AS 'total_sum'

FROM `clients` AS `cl`
         JOIN `courses` AS `co` ON `cl`.`id` = `co`.`client_id`
WHERE 
	SUBSTRING(`cl`.`full_name`, 2, 1) = 'a'
GROUP BY `cl`.`full_name`
HAVING COUNT(`co`.`car_id`) > 1
ORDER BY `full_name`;

-- 9 Full information on courses
SELECT
	`a`.`name`,
    IF(HOUR(`co`.`start`) BETWEEN 6 AND 20, 'Day', 'Night') AS 'day_time',
    `co`.`bill`,
    `cl`.`full_name`,
    `ca`.`make`,
    `ca`.`model`,
    `cat`.`name` AS 'category_name'
FROM `courses` AS `co`
	JOIN `addresses` AS `a` ON `co`.`from_address_id` = `a`.`id`
    JOIN `clients` AS `cl` ON `co`.`client_id` = `cl`.`id`
    JOIN `cars` AS `ca` ON `co`.`car_id` = `ca`.`id`
    JOIN `categories` AS `cat` ON `ca`.`category_id` = `cat`.`id`
ORDER BY `co`.`id`;

-- 10 Find all courses by client's phone number
DELIMITER $$
CREATE FUNCTION `udf_courses_by_client` (`phone_num` VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT COUNT(*)
		  FROM `courses` AS `co`
			 JOIN `clients` AS `cl` ON `co`.`client_id` = `cl`.`id`
		WHERE `cl`.`phone_number` = `phone_num`
    );
END $$
DELIMITER ;

-- 11 Full info for address
DELIMITER $$
CREATE PROCEDURE `udp_courses_by_address`(`address_name` VARCHAR(100))
BEGIN
	  SELECT `ad`.`name`,
           `cl`.`full_name`,
           CASE
               WHEN `co`.`bill` <= 20 THEN 'Low'
               WHEN `co`.`bill` <= 30 THEN 'Medium'
               ELSE 'High'
               END AS 'level_of_bill',
           `ca`.`make`,
           `ca`.`condition`,
           cat.`name`
    FROM `addresses` AS `ad`
             JOIN `courses` AS `co` ON `ad`.`id` = `co`.`from_address_id`
             JOIN `clients` AS `cl` ON `co`.`client_id` = `cl`.`id`
             JOIN `cars` AS `ca` ON `co`.`car_id` = `ca`.`id`
             JOIN `categories` AS `cat` ON `ca`.`category_id` = `cat`.`id`
    where ad.`name` = `address_name`
    ORDER BY ca.`make`, `cl`.`full_name`;
END $$
DELIMITER ;
CALL udp_courses_by_address('66 Thompson Drive');