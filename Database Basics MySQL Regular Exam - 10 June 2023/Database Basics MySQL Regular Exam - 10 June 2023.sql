CREATE DATABASE `universities_db`;
USE `universities_db`;

-- 1 Table Design
CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name`VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `cities` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name`VARCHAR(40) NOT NULL UNIQUE,
    `population` INT,
    `country_id` INT NOT NULL,
    
    CONSTRAINT `fk_cities_countries`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries`(`id`)
);

CREATE TABLE `universities` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL UNIQUE,
    `address` VARCHAR(80) NOT NULL UNIQUE,
    `tuition_fee` DECIMAL(19,2) NOT NULL,
    `number_of_staff` INT,
    `city_id` INT,
    
    CONSTRAINT `fk_universities_cities`
		FOREIGN KEY (`city_id`)
			REFERENCES `cities`(`id`)
);

CREATE TABLE `students` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `age` INT,
    `phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `is_graduated` TINYINT(1) NOT NULL,
    `city_id` INT,
    
    CONSTRAINT `fk_students_cities`
		FOREIGN KEY (`city_id`)
			REFERENCES `cities`(`id`)
);

CREATE TABLE `courses` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `duration_hours` DECIMAL(19,2),
    `start_date` DATE,
    `teacher_name` VARCHAR(60) NOT NULL UNIQUE,
    `description` TEXT,
    `university_id` INT,
    
    CONSTRAINT `fk_courses_universities`
		FOREIGN KEY(`university_id`)
			REFERENCES `universities`(`id`)
);

CREATE TABLE `students_courses` (
	`grade` DECIMAL(19,2) NOT NULL,
    `student_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    
    CONSTRAINT `fk_students_courses_students`
		FOREIGN KEY (`student_id`)
			REFERENCES `students`(`id`),
    
    CONSTRAINT `fk_students_courses_courses`
		FOREIGN KEY (`course_id`)
			REFERENCES `courses`(`id`)
);

-- 2 INSERT 
INSERT INTO `courses`(`name`, `duration_hours`, `start_date`, `teacher_name`, `description`, `university_id`)
SELECT 
	CONCAT(`teacher_name`, ' ','course'),
    CHAR_LENGTH(`name`) / 10,
    DATE_ADD(`start_date`, INTERVAL 5 DAY),
    REVERSE(`teacher_name`),
    CONCAT('Course', ' ' , `teacher_name`, REVERSE(`description`)),
    DAY(`start_date`)
FROM `courses`
WHERE `id` <= 5;

-- 3 Update
UPDATE `universities`
SET `tuition_fee` = `tuition_fee` + 300
WHERE `id` BETWEEN 5 AND 12;

-- 4 Delete
DELETE `universities`
FROM `universities`
WHERE `number_of_staff` IS NULL;

-- 5 Cities
SELECT
	`id`,
    `name`,
    `population`,
    `country_id`
FROM `cities`
ORDER BY `population` DESC;

-- 6 Students age
SELECT
	`first_name`,
    `last_name`,
    `age`,
    `phone`,
    `email`
FROM `students`
WHERE `age` >= 21
ORDER BY `first_name` DESC, `email` ASC, `id` ASC
LIMIT 10;

-- 7 New students
SELECT
	CONCAT_WS(' ', `s`.`first_name`, `s`.`last_name`) AS 'full_name',
    SUBSTRING(`s`.`email`, 2,10) AS 'username',
    REVERSE(`s`.`phone`) AS 'password'
FROM `students` AS `s`
LEFT JOIN `students_courses` AS `sc` ON `s`.`id` = `sc`.`student_id`
WHERE `sc`.`course_id` IS NULL
ORDER BY `password` DESC;

-- 8 Students count
SELECT
	COUNT(`s`.`id`) AS 'students_count',
    `u`.`name` AS 'university_name'
FROM `students` AS `s`
	JOIN `students_courses` AS `sc` ON `s`.`id` = `sc`.`student_id`
	JOIN `courses` AS `c` ON `sc`.`course_id` = `c`.`id`
	JOIN `universities` AS `u` ON `c`.`university_id` = `u`.`id`
GROUP BY  `u`.`name`
HAVING `students_count` >= 8
ORDER BY `students_count` DESC, `u`.`name` DESC;

-- 9 Price rankings
SELECT
	`u`.`name` AS 'university_name',
    `c`. `name` AS 'city_name',
    `u`.`address`,
    CASE
		WHEN `u`.`tuition_fee` < 800
			THEN 'cheap'
		WHEN `u`.`tuition_fee` >= 800 AND `u`.`tuition_fee` < 1200
			THEN 'normal'
		WHEN `u`.`tuition_fee` >= 1200 AND `u`.`tuition_fee` < 2500 
			THEN 'high'
		ELSE 'expensive'
	END AS 'price_rank' ,  `u`.`tuition_fee`
FROM `universities` AS `u`
JOIN `cities` AS `c` ON `u`.`city_id` = `c`.`id`
ORDER BY `u`.`tuition_fee` ASC;

-- 10 Average grades
DELIMITER $$
CREATE FUNCTION `udf_average_alumni_grade_by_course_name`(`course_name` VARCHAR(60))
    RETURNS DECIMAL(19, 2)
    DETERMINISTIC
BEGIN
    RETURN (SELECT (AVG(`grade`))
            FROM `courses` AS `c`
                     JOIN `students_courses` AS `sc` ON `c`.`id` = `sc`.`course_id`
                     JOIN `students` AS `s` ON `sc`.`student_id` = `s`.`id`
            WHERE `s`.`is_graduated` = 1
              AND `c`.`name` = `course_name`
            GROUP BY `course_id`);
END $$
DELIMITER ;

-- 11 Graduate students
DELIMITER $$
CREATE PROCEDURE `udp_graduate_all_students_by_year`(`year_started`INT)
BEGIN
	UPDATE `courses` AS `c`
		JOIN `students_courses` AS `sc` ON `c`.`id` = `sc`.`course_id`
        JOIN `students` AS `s` ON `sc`.`student_id` = `s`.`id`
	SET `s`.`is_graduated` = 1
    WHERE YEAR(`c`.`start_date`) = `year_started`;
END $$
DELIMITER ;

CALL udp_graduate_all_students_by_year(2017); 