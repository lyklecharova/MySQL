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
	