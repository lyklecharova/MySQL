CREATE DATABASE minions;

use minions;

-- 1 Create Tables
CREATE TABLE minions(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    age INT
);

CREATE TABLE towns(
	town_id INT PRIMARY KEY AUTO_INCREMENT,
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

-- 9 Set Default Value of a Field
ALTER TABLE users
CHANGE COLUMN last_login_time last_login_time TIMESTAMP DEFAULT NOW();

-- 10 Set Unique Field
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id),
CHANGE COLUMN username
username VARCHAR(30) UNIQUE;

-- 11 Movies Database
CREATE DATABASE movies;

CREATE TABLE directors(
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(50) NOT NULL,
    notes TEXT
);


CREATE TABLE genres(
    id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(20) NOT NULL,
    notes TEXT
);

CREATE TABLE categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(20) NOT NULL,
    notes TEXT
);

CREATE TABLE movies(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR (50) NOT NULL,
    director_id INT ,
    copyright_year INT,
    length DOUBLE(10,2),
    genre_id INT,
    category_id INT,
    rating DOUBLE(3,2),
    notes TEXT
);

INSERT INTO directors(director_name)
VALUES
('test1'),
('test2'),
('test3'),
('test4'),
('test5');

INSERT INTO genres(genre_name)
VALUES
('test1'),
('test2'),
('test3'),
('test4'),
('test5');

INSERT INTO categories(category_name)
VALUES
('test1'),
('test2'),
('test3'),
('test4'),
('test5');

INSERT INTO movies(title)
VALUES
('test1'),
('test2'),
('test3'),
('test4'),
('test5');

-- 12 Car Rental Database
CREATE DATABASE car_rental;
use car_rental;
CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(30) NOT NULL,
    daily_rate DOUBLE,
    weekly_rate DOUBLE,
    monthly_rate DOUBLE,
    weekend_rate DOUBLE
);

INSERT INTO categories(category)
VALUES
('Audi'),
('Cintroen'),
('BMW');

CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(4),
    make VARCHAR(30),
    model VARCHAR(30),
    car_year INT,
    category_id INT,
    doors INT,
    picture BLOB,
    car_condition VARCHAR(20),
    available BOOLEAN NOT NULL
);

INSERT INTO cars(available)
VALUES
(true),
(true),
(false);

CREATE TABLE employees(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(30),
    notes TEXT
);

INSERT INTO employees(first_name, last_name)
VALUES
('test1', 'test testov1'),
('test2', 'test testov2'),
('test3', 'test testov3');

CREATE TABLE customers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number INT NOT NULL,
    full_name VARCHAR(20) NOT NULL,
    address VARCHAR(100),
    city VARCHAR(100),
    zip_code VARCHAR(10),
    notes TEXT
);

INSERT INTO customers(driver_licence_number, full_name)
VALUES
('1', 'test1'), 
('2', 'test2'), 
('3', 'test3');

CREATE TABLE rental_orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    card_id INT,
    car_condition VARCHAR(20),
    thank_level VARCHAR(20),
    kilometrage_start INT NOT NULL,
    kilometrage_end INT NOT NULL,
    total_kilometrage INT NOT NULL,
    start_date DATE,
    end_date DATE,
    total_days  INT,
	rate_applied VARCHAR(20),
	tax_rate VARCHAR(5),
    order_status VARCHAR(5),
    notes TEXT
);

INSERT INTO rental_orders(kilometrage_start,kilometrage_end,total_kilometrage)
VALUES
('1','10','10'),
('2','20','20'),
('3','30','30');('3','30','30');('3','30','30');
('3','30','30');('3','30','30');

-- 13 Basic Insert
CREATE DATABASE soft_uni;
use soft_uni;

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) 
);

CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    address_text VARCHAR(50),
    town_id INT,
     FOREIGN KEY (town_id)
        REFERENCES towns (id)
);

CREATE TABLE departments(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    job_title VARCHAR(50),
    department_id INT,
    hire_date VARCHAR(50),
    salary DOUBLE,
    address_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments (ID),
    FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);

INSERT INTO towns(name)
VALUES('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO departments(name)
VALUES ('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');


INSERT INTO employees(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES  
('Ivan', 'Ivanov',' Ivanov','.NET Developer','4','2013-02-01','3500.00'),
('Petar', 'Petrov ', 'Petrov','Senior Engineer','1','2004-03-02','4000.00'),
('Maria', 'Petrova ', 'Ivanova','Intern','5','2016-08-28','525.25'),
('Georgi', 'Terziev ','Ivanov','CEO','2','2007-12-09','3000.00'),
('Peter', 'Pan',' Pan','Intern','3','2016-08-28',' 599.88');

-- 14 Basic Select All Fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

-- 15 Basic Select All Fields and Order Them
SELECT * FROM towns
ORDER BY name ASC;

SELECT * FROM departments
ORDER BY name ASC;

SELECT * FROM employees
ORDER BY salary DESC;

-- 16 Basic Select Some Fields
SELECT name FROM towns 
ORDER BY name ASC;

SELECT name FROM departments 
ORDER BY name ASC;

SELECT 
	first_name, 
    last_name, 
    job_title, 
    salary
FROM employees 
ORDER BY salary DESC;

-- 17 Increase Employees Salary
UPDATE employees  SET salary = salary * 1.1 WHERE id >0;
SELECT salary FROM  employees;