CREATE DATABASE `summer_olympics`;

-- countries
CREATE TABLE
    `countries` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(40) NOT NULL UNIQUE
    );

-- sports
CREATE TABLE
    `sports` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(20) NOT NULL UNIQUE
    );

-- disciplines
CREATE TABLE
    `disciplines` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(40) NOT NULL UNIQUE,
        `sport_id` INT NOT NULL,
        CONSTRAINT `fk_disciplines_sports` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`id`)
    );

-- athletes
CREATE TABLE
    `athletes` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `first_name` VARCHAR(40) NOT NULL,
        `last_name` VARCHAR(40) NOT NULL,
        `age` INT NOT NULL,
        `country_id` INT NOT NULL,
        CONSTRAINT `fk_athletes_countries` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`)
    );

-- medals
CREATE TABLE
    `medals` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `type` VARCHAR(10) NOT NULL UNIQUE
    );

-- disciplines_athletes_medals
CREATE TABLE
    `disciplines_athletes_medals` (
        `discipline_id` INT NOT NULL,
        `athlete_id` INT NOT NULL,
        `medal_id` INT NOT NULL,
        CONSTRAINT `fk_disciplines_athletes_medals_disciplines` FOREIGN KEY (`discipline_id`) REFERENCES `disciplines` (`id`),
        CONSTRAINT `fk_disciplines_athletes_medals_athletes` FOREIGN KEY (`athlete_id`) REFERENCES `athletes` (`id`),
        CONSTRAINT `fk_disciplines_athletes_medals_medals` FOREIGN KEY (`medal_id`) REFERENCES `medals` (`id`),
        CONSTRAINT `unique_discipline_medal` UNIQUE (`discipline_id`, `medal_id`)
    );