CREATE DATABASE `ruk_database`;
USE `ruk_database`;

-- 1 Table Design
CREATE TABLE `branches` (
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE `employees` (
    `id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `salary` DECIMAL(10 , 2 ) NOT NULL,
    `started_on` DATE NOT NULL,
    `branch_id` INT(11) NOT NULL,
    
    CONSTRAINT `fk_employees_branches` 
		FOREIGN KEY (`branch_id`)
			REFERENCES `branches` (`id`)
);

CREATE TABLE `clients` (
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `full_name` VARCHAR(50) NOT NULL,
    `age` INT(11) NOT NULL
);

CREATE TABLE `employees_clients` (
	`employee_id` INT(11),
    `client_id` INT(11),
    
    CONSTRAINT `fk_employees_clients_employees`
		FOREIGN KEY(`employee_id`)
			REFERENCES `employees`(`id`),
    
      CONSTRAINT `fk_employees_clients_clients`
		FOREIGN KEY(`client_id`)
			REFERENCES `clients`(`id`)
);

CREATE TABLE `bank_accounts` (
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `account_number` VARCHAR(10) NOT NULL,
    `balance` DECIMAL(10,2) NOT NULL,
    `client_id` INT(11) NOT NULL UNIQUE,
    
    CONSTRAINT `fk_bank_accounts_clients`
		FOREIGN KEY(`client_id`)
			REFERENCES `clients`(`id`)
);

CREATE TABLE `cards` (
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `card_number` VARCHAR(19) NOT NULL,
    `card_status` VARCHAR(7) NOT NULL,
    `bank_account_id` INT(11) NOT NULL,
    
    CONSTRAINT `fk_cards_bank_accounts`
		FOREIGN KEY(`bank_account_id`)
			REFERENCES `bank_accounts`(`id`)
);