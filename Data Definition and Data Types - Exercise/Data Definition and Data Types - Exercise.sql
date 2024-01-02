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
