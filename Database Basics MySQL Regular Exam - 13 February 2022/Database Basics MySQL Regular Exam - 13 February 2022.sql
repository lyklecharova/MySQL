CREATE DATABASE `online_stores`;
USE `online_stores`;

-- 1 Table Design
CREATE TABLE `brands` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `categories` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `reviews` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `content` TEXT,
    `rating` DECIMAL(10, 2) NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `published_at` DATETIME
);
CREATE TABLE `products` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,
    `price` DECIMAL(19, 2) NOT NULL,
    `quantity_in_stock` INT,
    `description` TEXT,
    `brand_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `review_id` INT,
    CONSTRAINT `fk_products_brands` FOREIGN KEY (`brand_id`) REFERENCES `brands`(`id`),
    CONSTRAINT `fk_products_categories` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`),
    CONSTRAINT `fk_products_reviews` FOREIGN KEY (`review_id`) REFERENCES `reviews`(`id`)
);
CREATE TABLE `customers` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `phone` VARCHAR(30) NOT NULL UNIQUE,
    `address` VARCHAR(60) NOT NULL,
    `discount_card` BIT (1) NOT NULL DEFAULT FALSE
);
CREATE TABLE `orders` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `order_datetime` DATETIME NOT NULL,
    `customer_id` INT NOT NULL,
    CONSTRAINT `fk_orders_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`)
);
CREATE TABLE `orders_products` (
    `order_id` INT,
    `product_id` INT,
    CONSTRAINT `fk_orders_products_orders` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`),
    CONSTRAINT `fk_orders_products_products` FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
);

-- 2 Insert
INSERT INTO`reviews`(`content`, `picture_url`, `published_at`, `rating`)
SELECT
SUBSTRING(`description`, 1, 15),
    REVERSE(`name`),
    DATE('2010-10-10'),
    `price` / 8
FROM`products`
WHERE`id` >= 5;

-- 3 Update
UPDATE`products`
SET`quantity_in_stock` = `quantity_in_stock` - 5
WHERE `quantity_in_stock` BETWEEN 60 AND 70;

-- 4 Delete
DELETE`c`
FROM `customers` AS`c`
LEFT JOIN `orders` AS `o` ON`c`.`id` = `o`.`customer_id`
WHERE`o`.`id` IS NULL;

-- 5 Categories
SELECT
	`id`,
    `name`
FROM `categories`
ORDER BY `name` DESC;

-- 6 Quantity
SELECT
	`id`,
    `brand_id`,
    `name`,
    `quantity_in_stock`
FROM `products`
WHERE 
	`price` > 1000 
    AND `quantity_in_stock` < 30
ORDER BY `quantity_in_stock` ASC, `id`;