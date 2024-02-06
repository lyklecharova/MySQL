CREATE DATABASE `real_estate_db`;
USE `real_estate_db`;

-- 1 Table Design
CREATE TABLE `cities` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE `property_types` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `type` VARCHAR(40) NOT NULL UNIQUE,
    `description` TEXT
);

CREATE TABLE `properties` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(80) NOT NULL UNIQUE,
    `price` DECIMAL(19,2) NOT NULL,
    `area` DECIMAL(19,2),
    `property_type_id` INT,
    `city_id` INT,
    
    CONSTRAINT `fk_properties_property_types`
		FOREIGN KEY(`property_type_id`)
			REFERENCES `property_types`(`id`),
    
	CONSTRAINT `fk_properties_cities`
		FOREIGN KEY(`city_id`)
			REFERENCES `cities`(`id`)
);

CREATE TABLE `agents` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(50) NOT NULL UNIQUE,
    `city_id` INT,
    
    CONSTRAINT `fk_agents_cities`
		FOREIGN KEY(`city_id`)
			REFERENCES `cities`(`id`)
);

CREATE TABLE `buyers` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(50) NOT NULL UNIQUE,
    `city_id` INT,
    
    CONSTRAINT `fk_buyers_cities`
		FOREIGN KEY(`city_id`)
			REFERENCES `cities`(`id`)
);

CREATE TABLE `property_offers` (
	`property_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    `price` DECIMAL(19,2) NOT NULL,
    `offer_datetime` DATETIME,
    
    CONSTRAINT `fk_property_offers_properties`
		FOREIGN KEY(`property_id`)
			REFERENCES `properties`(`id`),
    
     CONSTRAINT `fk_property_offers_agents`
		FOREIGN KEY(`agent_id`)
			REFERENCES `agents`(`id`)
);

CREATE TABLE `property_transactions` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `property_id` INT NOT NULL,
    `buyer_id` INT NOT NULL,
    `transaction_date` DATE,
    `bank_name` VARCHAR(30),
    `iban` VARCHAR(40) UNIQUE,
    `is_successful` TINYINT(1),
    
    CONSTRAINT `fk_property_transactions_properties`
		FOREIGN KEY(`property_id`)
			REFERENCES `properties`(`id`),
    
    CONSTRAINT `fk_property_transactions_buyers`
		FOREIGN KEY(`buyer_id`)
			REFERENCES `buyers`(`id`)
);

-- 2 Insert
INSERT INTO `property_transactions`(`property_id`, `buyer_id`, `transaction_date`, `bank_name`, `iban`, `is_successful`)
SELECT
	`po`.`agent_id` + DAY(`po`. `offer_datetime`) AS 'property_id',
    `po`.`agent_id` + MONTH(`po`. `offer_datetime`) AS 'buyer_id',
	DATE(`po`.`offer_datetime`) AS 'transaction_date',
   CONCAT('Bank ', `po`.`agent_id`) AS 'bank_name',
   CONCAT('BG', `po`. `price`, `po`.`agent_id`) 'iban',
   1 AS 'is_successful'
FROM `property_offers` AS  `po`
WHERE `po`.`agent_id` <= 2;

-- 3 Update
UPDATE `properties`
SET `price` = `price` - 50000
WHERE `price` >= 800000;

-- 4 Delete
DELETE
FROM `property_transactions`
WHERE `is_successful` = 0;

-- 5 Agents
SELECT *
	/*  `id`,
     `first_name`,
     `last_name`,
     `phone`,
     `email`,
     `city_id`
   */
FROM `agents`
ORDER BY `city_id` DESC, `phone` DESC;

-- 6 Offers from 2021
SELECT
	`property_id`,
    `agent_id`,
    `price`,
    `offer_datetime`
FROM `property_offers`
WHERE YEAR(`offer_datetime`) = 2021
ORDER BY `price` ASC
LIMIT 10;

-- 7 Properties without offers
SELECT
	LEFT(`p`.`address`,6) AS 'agent_name',
    LENGTH(`p`.`address`) * 5430 AS 'price'
FROM `properties` AS `p`
	LEFT JOIN `property_offers` AS `po` ON `p`.`id` = `po`.`property_id`
WHERE `po`.`property_id` IS NULL
ORDER BY `agent_name` DESC, `price` DESC;

-- 8 Best Banks
SELECT
	`bank_name`,
    COUNT(DISTINCT `iban`) AS 'count'
FROM `property_transactions`
GROUP BY `bank_name`
HAVING  COUNT(DISTINCT `iban`) >=9
ORDER BY `count` DESC, `bank_name` ASC;

-- 9 Size of the area
SELECT
	`address`,
    `area`,
    CASE
		WHEN `area` <=100
			THEN 'small'
		WHEN `area` <=200
			THEN 'medium'
		WHEN `area` <=500
			THEN 'large'
            ELSE 'extra large'
	END AS 'size'
FROM `properties`
ORDER BY `area` ASC, `address` DESC;

-- 10 Offers count in a city
DELIMITER $$
CREATE FUNCTION `udf_offers_from_city_name`(`cityName` VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT COUNT(*)
        FROM `property_offers` AS `po`
			JOIN `properties` AS `p` ON `po`.`property_id` = `p`.`id`
            JOIN `cities` AS `c` ON `p`.`city_id` = `c`.`id`
		WHERE `c`.`name` = `cityName`
    );
END $$
DELIMITER ;

-- 11 Special Offer
DELIMITER $$
CREATE PROCEDURE `udp_special_offer` (`first_name` VARCHAR(50))
BEGIN
	    UPDATE `property_offers` AS `po`
			JOIN `agents` AS `a` ON `po`.`agent_id`  = `a`.`id`
        SET `price` = `price` * 0.9
        WHERE `a`.`first_name` = `first_name`;
END $$
DELIMITER $$
