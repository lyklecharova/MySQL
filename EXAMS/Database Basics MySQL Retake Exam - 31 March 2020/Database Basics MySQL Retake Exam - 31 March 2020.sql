CREATE DATABASE `instd`;
USE `instd`;

-- 1 Table Design
CREATE TABLE `users` (
	`id` INT PRIMARY KEY,
    `username` VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `gender` CHAR(1) NOT NULL,
    `age` INT NOT NULL,
    `job_title` VARCHAR(40) NOT NULL,
    `ip` VARCHAR(30) NOT NULL
);

CREATE TABLE `addresses` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(30) NOT NULL,
    `town` VARCHAR(30) NOT NULL,
    `country` VARCHAR(30) NOT NULL,
    `user_id` INT NOT NULL,
    
    CONSTRAINT `addresses_users`
		FOREIGN KEY(`user_id`)
			REFERENCES `users`(`id`)
);

CREATE TABLE `photos` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT NOT NULL,
    `date` DATETIME NOT NULL,
    `views` INT NOT NULL DEFAULT 0
);

CREATE TABLE `comments` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `comment` VARCHAR(255) NOT NULL,
    `date` DATETIME NOT NULL,
    `photo_id` INT NOT NULL,
    
    CONSTRAINT `comments_photos`
		FOREIGN KEY(`photo_id`)
			REFERENCES `photos`(`id`)
);

CREATE TABLE `users_photos` (
	`user_id` INT NOT NULL,
    `photo_id` INT NOT NULL,
    
    CONSTRAINT `users_photos_users`
		FOREIGN KEY(`user_id`)
			REFERENCES `users`(`id`),
    
    CONSTRAINT `users_photos`
		FOREIGN KEY(`photo_id`)
			REFERENCES `photos`(`id`)
);

CREATE TABLE `likes` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `photo_id` INT,
    `user_id` INT,
    
    CONSTRAINT `fk_likes_photos`
		FOREIGN KEY(`photo_id`)
			REFERENCES `photos`(`id`),
    
    CONSTRAINT `fk_likes_users`
		FOREIGN KEY(`user_id`)
			REFERENCES `users`(`id`)
);

-- 2 Insert
INSERT INTO `addresses`(`address`, `town`, `country`, `user_id`)
SELECT
	`username`,
    `password`,
    `ip`,
    `age`
FROM `users`
WHERE `gender` = 'm';

-- 3 Update
UPDATE `addresses`
SET `country` = (
		CASE
			WHEN `country` LIKE 'B%' 
				THEN 'Blocked'
			WHEN `country` LIKE 'T%' 
				THEN 'Test'
				
			WHEN `country` LIKE 'P%' 
				THEN 'In Progress'
		ELSE `country`
        END
	);

-- 4 Delete
DELETE `a`
FROM `addresses` AS `a`
WHERE `a`.`id` % 3 = 0 ;

-- 5 Users
SELECT
	`username`,
    `gender`,
    `age`
FROM `users`
ORDER BY  `age` DESC , `username` ASC ;

-- 6 Extract 5 Most Commented Photos
SELECT 
	`p`.`id`,
    `p`. `date` AS 'date_and_time',
    `p`. `description`,
    COUNT(`c`.`photo_id`) AS 'commentsCount'
FROM `photos` AS `p`
	JOIN `comments` AS `c` ON `p`.`id` = `c`.`photo_id`
GROUP BY `p`.`id`
ORDER BY `commentsCount` DESC, `p`.`id` ASC
LIMIT 5;

-- 7 Lucky Users
SELECT
	CONCAT(`u`.`id`, ' ', `u`.`username`) AS 'id_username',
    `u`.`email`
FROM `users` AS `u`
	JOIN `users_photos` AS `up` ON `u`.`id` = `up`.`user_id`
WHERE `photo_id` = `user_id`
ORDER BY `id` ASC;

-- 8 Count Likes and Comments
SELECT
	`p`.`id` AS 'photo_id',
    COUNT(DISTINCT `l`.`id`) AS 'likes_count',
    COUNT(DISTINCT `c`.`id`) AS 'comments_count'
FROM `photos` AS `p`
	LEFT JOIN `comments` AS `c` ON `p`.`id` = `c`.`photo_id`
    LEFT JOIN `likes` AS `l` ON `p`.`id` = `l`.`photo_id`
GROUP BY `p`.`id`
ORDER BY `likes_count` DESC, `comments_count` DESC, `p`.`id`;

-- 9 The Photo on the Tenth Day of the Month
SELECT
	CONCAT(SUBSTRING(`description`, 1,30), '...') AS 'summary',
    `date`
FROM `photos`
WHERE DAY(`date`) = 10
ORDER BY `date` DESC;

-- 10 Get User's Photos Count
DELIMITER $$
CREATE FUNCTION `udf_users_photos_count`(`username` VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT
        COUNT(`up`.`photo_id`)
        FROM `users` AS `u`
			JOIN `users_photos` AS `up` ON `u`.`id` = `up`.`user_id`
		WHERE `u`.`username` = `username`
    );
END $$
DELIMITER ;


-- 11 Increase User Age
DELIMITER $$
CREATE PROCEDURE `udp_modify_user` (`address` VARCHAR(30), `town` VARCHAR(30))
BEGIN
	UPDATE `users` AS `u`
		JOIN `addresses` AS `a` ON `u`.`id` = `a`.`user_id`
	SET `age` = `age` + 10
    WHERE 
		`a`.`address` = `address` 
        AND `a`.`town` = `town`;
END $$
DELIMITER ;
	