CREATE DATABASE `go_roadie_driving_schools_in_the_UK`;

-- cities
CREATE TABLE `cities`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

-- cars
CREATE TABLE `cars`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `brand` VARCHAR(20) NOT NULL,
    `model` VARCHAR(20) NOT NULL UNIQUE
);

-- instructors
CREATE TABLE `instructors`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL UNIQUE,
    `has_a_license_from` DATE NOT NULL
);

-- driving_schools
CREATE TABLE `driving_schools`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `night_time_driving` TINYINT(1) NOT NULL,
    `average_lesson_price` DECIMAL(10, 2),
    `car_id` INT NOT NULL,
    `city_id` INT NOT NULL,

    CONSTRAINT `fk_driving_schools_cars`
    FOREIGN KEY (`car_id`)
    REFERENCES `cars`(`id`),

    CONSTRAINT `fk_driving_schools_cities`
    FOREIGN KEY (`city_id`) 
    REFERENCES `cities`(`id`)
);

-- students
CREATE TABLE `students`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL UNIQUE,
    `age` INT,
    `phone_number` VARCHAR(20) UNIQUE
);

-- instructors_driving_schools
CREATE TABLE `instructors_driving_schools`(
    `instructor_id` INT,
    `driving_school_id` INT NOT NULL,

    CONSTRAINT `fk_instructors_driving_schools_instructors` 
    FOREIGN KEY (`instructor_id`) 
    REFERENCES `instructors`(`id`),

    CONSTRAINT `fk_instructors_driving_schools_driving_schools` 
    FOREIGN KEY (`driving_school_id`) 
    REFERENCES `driving_schools`(`id`)
);

-- instructors_students
CREATE TABLE `instructors_students`(
    `instructor_id` INT NOT NULL,
    `student_id` INT NOT NULL,

    CONSTRAINT `fk_instructors_students_instructors` 
    FOREIGN KEY (`instructor_id`) 
    REFERENCES `instructors`(`id`),

    CONSTRAINT `fk_instructors_instructors_students_students` 
    FOREIGN KEY (`student_id`) 
    REFERENCES `students`(`id`)
);

-- 02 Insert
INSERT INTO `students`(
        `first_name`,
        `last_name`,
        `age`,
        `phone_number`
    )
SELECT LOWER(REVERSE(`first_name`)),
    LOWER(REVERSE(`last_name`)),
    `age` + CAST(SUBSTRING(`phone_number`, 1, 1) AS UNSIGNED),
    CONCAT('1+', `phone_number`)
FROM `students`
WHERE `age` < 20;

-- 03 Update
UPDATE `driving_schools`
SET `average_lesson_price` = `average_lesson_price` + 30
WHERE `city_id` = (
        SELECT `id`
        FROM `cities`
        WHERE `name` = 'London'
    )
    AND `night_time_driving` = 1;

-- 04 Delete
DELETE FROM `driving_schools`
WHERE `night_time_driving` = 0;