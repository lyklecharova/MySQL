CREATE DATABASE `softuni_imdb`;
USE  `softuni_imdb`;

-- 1 Table Design
CREATE TABLE `countries` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `continent` VARCHAR(30) NOT NULL,
    `currency` VARCHAR(5) NOT NULL
);

CREATE TABLE `genres` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `actors` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `birthdate` DATE NOT NULL,
    `height` INT,
    `awards` INT,
    `country_id` INT NOT NULL,

    CONSTRAINT `fk_actors_countries` 
        FOREIGN KEY (`country_id`)
            REFERENCES `countries` (`id`)
);

CREATE TABLE `movies_additional_info` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `rating` DECIMAL(10 , 2 ) NOT NULL,
    `runtime` INT NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `budget` DECIMAL(10 , 2 ),
    `release_date` DATE NOT NULL,
    `has_subtitles` TINYINT(1),
    `description` TEXT
);

CREATE TABLE `movies` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(70) NOT NULL UNIQUE,
    `country_id` INT NOT NULL,
    `movie_info_id` INT NOT NULL UNIQUE,

    CONSTRAINT `fk_movies_countries` 
        FOREIGN KEY (`country_id`)
        REFERENCES `countries` (`id`),

    CONSTRAINT `fk_movies_movie_info` 
        FOREIGN KEY (`movie_info_id`)
            REFERENCES `movies_additional_info` (`id`)
);

CREATE TABLE `movies_actors` (
    `movie_id` INT,
    `actor_id` INT,

    CONSTRAINT `fk_movies_actors_movies` 
        FOREIGN KEY (`movie_id`)
            REFERENCES `movies` (`id`),

    CONSTRAINT `fk_movies_actors_actors` 
        FOREIGN KEY (`actor_id`)
            REFERENCES `actors` (`id`)
);

CREATE TABLE `genres_movies` (
    `genre_id` INT,
    `movie_id` INT,

    CONSTRAINT `fk_genres_movies_genres` 
        FOREIGN KEY (`genre_id`)
            REFERENCES `genres` (`id`),

    CONSTRAINT `fk_genres_movies_movies` 
        FOREIGN KEY (`movie_id`)
        REFERENCES `movies` (`id`)
);

-- 2 Insert
SELECT 
    REVERSE(`first_name`),
    REVERSE(`last_name`),
    DATE_ADD(`birthdate`, INTERVAL - 2 DAY),
    `height` - 10,
    `country_id`,
    (SELECT 
            `id`
        FROM
            `countries`
        WHERE
            `name` = 'Armenia')
FROM
    `actors` AS `a`
        JOIN
    `countries` AS `c` ON `a`.`country_id` = `c`.`id`
WHERE
    `a`.`id` <= 10;

INSERT INTO `actors` (`first_name`, `last_name`, `birthdate`, `height`, `awards`, `country_id`)
    (SELECT REVERSE(`first_name`),
            REVERSE(`last_name`),
            DATE_ADD(`birthdate`, INTERVAL -2 DAY),
            `height` + 10,
            `country_id`,
            (SELECT `id` FROM `countries` WHERE `name` = 'Armenia')

     FROM `actors` AS `a`
              JOIN `countries` AS `c` ON `a`.`country_id` = `c`.`id`
     WHERE `a`.`id` <= 10);

-- 3 Update
UPDATE `movies_additional_info`
SET `runtime` = `runtime` - 10
WHERE `id` BETWEEN 15 AND 25;

-- 4 Delete
DELETE `c` FROM `countries` AS `c`
        LEFT JOIN
    `movies` AS `m` ON `c`.`id` = `m`.`country_id` 
WHERE
    `country_id` IS NULL;

-- 5 Countries
SELECT 
    `id`, `name`, `continent`, `currency`
FROM
    `countries`
ORDER BY `currency` DESC , `id`;

-- 6 Old movies
SELECT 
    `mai`.`id`, `m`.`title`, `runtime`, `budget`, `release_date`
FROM
    `movies_additional_info` AS `mai`
        JOIN
    `movies` AS `m` ON `mai`.`id` = `m`.`movie_info_id`
WHERE
    YEAR(`release_date`) BETWEEN 1996 AND 1999
ORDER BY `runtime` , `id`
LIMIT 20;

-- 7 Movie casting
SELECT 
    CONCAT_WS(' ', `first_name`, `last_name`) AS 'full_name',
    CONCAT(REVERSE(`last_name`),
            CHAR_LENGTH(`last_name`),
            '@cast.com') AS 'email',
    2022 - YEAR(`birthdate`) AS 'age',
    `height`
FROM
    `actors` AS `a`
        LEFT JOIN
    `movies_actors` AS `ma` ON `a`.`id` = `ma`.`actor_id`
WHERE
    `movie_id` IS NULL
ORDER BY `height` ASC;

-- 8 International Festival
SELECT 
    `c`.`name`, COUNT(`c`.`id`) AS 'movies_count'
FROM
    `countries` AS `c`
        JOIN
    `movies` AS `m` ON `c`.`id` = `m`.`country_id`
GROUP BY `c`.`name`
HAVING `movies_count` >= 7
ORDER BY `c`.`name` DESC;

-- 9 Rating system
SELECT 
    `title`,
    CASE
        WHEN `rating` <= 4 THEN 'poor'
        WHEN `rating` > 4 AND `rating` <= 7 THEN 'good'
        WHEN `rating` > 7 THEN 'excellent'
    END AS `rating`,
    IF(`has_subtitles` = 1, 'english', '-') AS `subtitles`,
    `budget`
FROM
    `movies` AS `m`
        JOIN
    `movies_additional_info` AS `mai` ON `m`.`movie_info_id` = `mai`.`id`
ORDER BY `budget` DESC;

-- 10 History movies
DELIMITER $$
CREATE FUNCTION `udf_actor_history_movies_count`(`full_name` VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM actors AS a
            JOIN movies_actors AS ma ON a.id = ma.actor_id
            JOIN movies AS m ON ma.movie_id = m.id
            JOIN genres_movies AS gm ON m.id = gm.movie_id
            JOIN genres AS g ON gm.genre_id = g.id
        WHERE a.first_name = SUBSTRING(full_name, 1, LOCATE(' ', full_name) - 1)
            AND a.last_name = SUBSTRING(full_name, LOCATE(' ', full_name) + 1)
            AND g.name = 'History'
    );
END $$
DELIMITER ;

-- 11 Movie awards
DELIMITER $$
CREATE PROCEDURE `udp_award_movie` (`movie_title` VARCHAR(50))
BEGIN
	UPDATE `actors` AS `a`
    JOIN `movies_actors` AS `ma` ON `a`.`id` = `ma`.`actor_id`
    JOIN `movies` AS `m` ON `ma`. `movie_id` = `m`.`id`
     SET `a`.`awards` = `a`.`awards` + 1
    WHERE `m`.`title` = `movie_title`;
END $$
DELIMITER ;
CALL udp_award_movie('Tea For Two');