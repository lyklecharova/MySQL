CREATE DATABASE `table_relation`;
use `table_relation`;

-- 1 Mountains and Peaks
CREATE TABLE `mountains` (
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50)
);

CREATE TABLE `peaks` (
    `id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50),
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountains` FOREIGN KEY (`mountain_id`)
        REFERENCES `mountains` (`id`)
);

-- 2 Trip Organization
SELECT *
FROM `campers`;
SELECT *
FROM `vehicles`;

SELECT 
    `driver_id`,
    `vehicle_type`,
    CONCAT(`first_name`, ' ', `last_name`) AS 'driver_name'
FROM
    `campers`
        JOIN
    `vehicles` ON `campers`.`id` = `vehicles`.`driver_id`;

-- 3 SoftUni Hiking
SELECT * FROM `routes`;

SELECT 
    `starting_point` AS 'route_starting_point',
    `end_point` AS 'route_ending_point',
    `leader_id`,
    CONCAT(`first_name`, ' ', `last_name`) AS 'leader_name'
FROM
    `routes`
        JOIN
    `campers` ON `routes`.`leader_id` = `campers`.`id`;

-- 4 Delete Mountains
use `table_relation`;

DROP TABLE `peaks`;
DROP TABLE `mountains`;

CREATE TABLE `mountains`(
    `id`   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50)
);

CREATE TABLE `peaks`
(
    `id`          INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(50),
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountains`
        FOREIGN KEY (`mountain_id`)
            REFERENCES `mountains` (`id`)
            on DELETE CASCADE
);

-- 5 Project Management DB*
CREATE DATABASE `project_management`;
use `project_management`;

CREATE TABLE `clients` (
	`id` INT PRIMARY KEY  AUTO_INCREMENT NOT NULL,
    `client_name` VARCHAR(100)
);

CREATE TABLE `projects` (
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `client_id` INT,
    `project_lead_id` INT,
    CONSTRAINT `fk_projects_client_id_clients_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `clients` (`id`)
);

CREATE TABLE `employees` (
    `id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `project_id` INT,
    CONSTRAINT `fk_employees_project_id_projects_id` FOREIGN KEY (`project_id`)
        REFERENCES `projects` (`id`)
);

ALTER TABLE `projects`
ADD CONSTRAINT `fk_projects_project_lead_id_employees_id`
FOREIGN KEY (`project_lead_id`)
REFERENCES `employees` (`id`);


