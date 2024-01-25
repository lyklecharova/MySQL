CREATE DATABASE `airlines_db`;
USE `airlines_db`;

-- 1 Table Design
CREATE TABLE `countries` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `description` TEXT,
    `currency` VARCHAR(5) NOT NULL
); 

CREATE TABLE `airplanes` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `model` VARCHAR(50) NOT NULL UNIQUE,
    `passengers_capacity` INT NOT NULL,
    `tank_capacity` DECIMAL(19,2) NOT NULL,
    `cost` DECIMAL(19,2) NOT NULL
);

CREATE TABLE `passengers` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `country_id` INT NOT NULL,
    
    CONSTRAINT `fk_passengers_countries`
		FOREIGN KEY(`country_id`)
			REFERENCES `countries`(`id`)
);

CREATE TABLE `flights` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `flight_code` VARCHAR(30) NOT NULL UNIQUE,
    `departure_country` INT NOT NULL,
    `destination_country` INT NOT NULL,
    `airplane_id` INT NOT NULL,
    `has_delay` TINYINT(1),
    `departure` DATETIME,
    
   CONSTRAINT `fk_flights_departure_countries`
		FOREIGN KEY (`departure_country`)
			REFERENCES `countries` (`id`),
    
    CONSTRAINT `fk_flights_destination_countries`
		FOREIGN KEY (`destination_country`)
			REFERENCES `countries` (`id`),
    
    CONSTRAINT `fk_flights_airplanes`
		FOREIGN KEY (`airplane_id`)
			REFERENCES `airplanes` (`id`)
);

CREATE TABLE `flights_passengers` (
	`flight_id` INT,
    `passenger_id` INT,
    
    CONSTRAINT `fk_flights_passengers_flights`
		FOREIGN KEY(`flight_id`)
			REFERENCES `flights`(`id`),
    
    CONSTRAINT `fk_flights_passengers_passengers`
		FOREIGN KEY(`passenger_id`)
			REFERENCES `passengers`(`id`)
);

-- 2 Insert
INSERT INTO `airplanes` (`model`, `passengers_capacity`, `tank_capacity`, `cost`)
SELECT
	CONCAT(REVERSE(`p`.`first_name`), '797') AS 'model',
    CHAR_LENGTH(`p`.`last_name`) * 17 AS 'passengers_capacity',
    `p`.`id` * 790 AS 'tank_capacity',
    CHAR_LENGTH(`p`.`first_name`) * 50.6 AS 'cost'
FROM `passengers` AS `p`
WHERE `p`.`id` <= 5;

-- 3 Update
UPDATE `flights`
SET `airplane_id` = `airplane_id` + 1
WHERE `departure_country` = (
	SELECT `id` 
    FROM `countries`
    WHERE `name` = 'Armenia'
    );

-- 4 Delete
DELETE 
FROM `flights` 
WHERE `id` NOT IN (
		SELECT DISTINCT `flight_id` 
		FROM `flights_passengers`
	);


-- 5 Airplanes
SELECT
	`id`,
    `model`,
    `passengers_capacity`,
    `tank_capacity`,
    `cost`
FROM `airplanes`
ORDER BY  `cost` DESC, `id` DESC;


-- 6 Flights from 2022
SELECT
	`flight_code`,
    `departure_country`,
    `airplane_id`,
    `departure`
FROM `flights`
WHERE YEAR(`departure`) = 2022
ORDER BY `airplane_id` ASC, `flight_code` ASC
LIMIT 20;

-- 7 Private flights
SELECT
	CONCAT(UPPER(SUBSTRING(`last_name`, 1,2)), `country_id`) AS 'flight_code',
    CONCAT_WS(' ', `first_name`, `last_name`) AS 'full_name',
    `country_id`
FROM `passengers`
WHERE
	`id` NOT IN (
		SELECT `passenger_id`
        FROM `flights_passengers`
    )
ORDER BY `country_id` ASC;

-- 8 Leading destinations
SELECT 
	`c`. `name` AS 'name',
    `c`. `currency` AS 'currency',
    COUNT(`fp`.`passenger_id`) AS 'booked_tickets'
FROM `countries` AS `c`
JOIN `flights` AS `f` ON `c`.`id` = `f`.`destination_country`
JOIN `flights_passengers` AS `fp` ON `f`.`id` = `fp`.`flight_id`
GROUP BY `c`.`id`
HAVING `booked_tickets` >= 20
ORDER BY `booked_tickets` DESC;

-- 9 Parts of the day
SELECT
	`flight_code`,
	`departure`,
    CASE
		WHEN HOUR(`departure`) BETWEEN 5 AND 11
			THEN 'Morning'
		WHEN HOUR(`departure`) BETWEEN 12 AND 16
			THEN 'Afternoon'
		WHEN HOUR(`departure`) BETWEEN 17 AND 20
			THEN 'Evening'
		ELSE 'Night'
	END AS 'day_part'
FROM `flights`
ORDER BY `flight_code` DESC;

-- 10 Number of flights
DELIMITER $$
CREATE FUNCTION `udf_count_flights_from_country`(`country` VARCHAR(50))
RETURNS INT
 DETERMINISTIC
BEGIN
	RETURN (
		SELECT
			COUNT(*)
        FROM `flights`
        WHERE `departure_country` = (
			SELECT
				`id`
			FROM `countries`
            WHERE `name` = `country`
        )
    );
END $$
DELIMITER ;

-- 11 Delay flight
DELIMITER $$
CREATE PROCEDURE `udp_delay_flight`(`code` VARCHAR(50))
BEGIN
	UPDATE `flights`
    SET `has_delay` = 1,
    `departure` = TIMESTAMPADD(MINUTE, 30, `departure`)
    WHERE `flight_code` = `code`;
END $$
 DELIMITER ;
 