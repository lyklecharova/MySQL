CREATE DATABASE minions;

use minions;

-- 1 Create Tables
CREATE TABLE minions(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

ALTER TABLE towns
RENAME COLUMN town_id TO id;

-- 2 Alter Minions Table
-- The ALTER TABLE statement is used to add, delete, or modify columns in an existing table.
--The ALTER TABLE statement is also used to add and drop various constraints on an existing table.
ALTER TABLE minions
ADD COLUMN town_id INT;

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY minions(town_id)
REFERENCES towns(id);

-- 3 Insert Records in Both Tables
INSERT INTO minions(id, name, age, town_id)
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

INSERT INTO towns(id, name)
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

-- 4 Truncate Table Minions
TRUNCATE TABLE minions;

-- 5 Drop All Tables
DROP TABLE minions;
DROP TABLE towns;

-- 6 Create Table People
CREATE TABLE people(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(10,2),
    weight DOUBLE(10,2),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people(name, gender, birthdate)
VALUES
('asd', 'm', DATE(NOW())),
('asd', 'm', DATE(NOW())),
('asd',  'f', DATE(NOW())),
('asd', 'm', DATE(NOW())),
('asd', 'f', DATE(NOW()));

-- 7 Create Table Users
CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(26) UNIQUE NOT NULL,
    profile_picture BLOB,
    last_login_time TIMESTAMP,
    is_deleted BOOLEAN
);

INSERT INTO users(username, password)
VALUES
('asd1' , 'asd1'),
('asd2' , 'asd2'),
('asd3' , 'asd3'),
('asd4' , 'asd4'),
('asd5' , 'asd5');

-- 8 Change Primary Key
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users2
PRIMARY KEY users(id, username);

CREATE DATABASE minions;

use minions;

-- 1 Create Tables
CREATE TABLE minions(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

ALTER TABLE towns
RENAME COLUMN town_id TO id;

-- 2 Alter Minions Table
ALTER TABLE minions
ADD COLUMN town_id INT;

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY minions(town_id)
REFERENCES towns(id);

-- 3 Insert Records in Both Tables
INSERT INTO towns(id, name)
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO minions(id, name, age, town_id)
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

-- 4 Truncate Table Minions
TRUNCATE TABLE minions;

-- 5 Drop All Tables
DROP TABLE minions;
DROP TABLE towns;

-- 6 Create Table People
CREATE TABLE people(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(10,2),
    weight DOUBLE(10,2),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people(name, gender, birthdate)
VALUES
('asd', 'm', DATE(NOW())),
('asd', 'm', DATE(NOW())),
('asd',  'f', DATE(NOW())),
('asd', 'm', DATE(NOW())),
('asd', 'f', DATE(NOW()));
-- 7 Create Table Users
CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(26) UNIQUE NOT NULL,
    profile_picture BLOB,
    last_login_time TIMESTAMP,
    is_deleted BOOLEAN
);

INSERT INTO users(username, password)
VALUES
('asd1' , 'asd1'),
('asd2' , 'asd2'),
('asd3' , 'asd3'),
('asd4' , 'asd4'),
('asd5' , 'asd5');

-- 8 Change Primary Key
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users2
PRIMARY KEY users(id, username);

