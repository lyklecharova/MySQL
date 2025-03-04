CREATE DATABASE `foods_friends`;

USE `foods_friends`;

-- restaurants
CREATE TABLE
    `restaurants` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(40) NOT NULL UNIQUE,
        `type` VARCHAR(20) NOT NULL,
        `non_stop` TINYINT (1) NOT NULL
    );

-- offerings
CREATE TABLE
    `offerings` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(40) NOT NULL UNIQUE,
        `price` DECIMAL(19, 2) NOT NULL,
        `vegan` TINYINT (1) NOT NULL,
        `restaurant_id` INT NOT NULL,
        CONSTRAINT `fk_offerings_restaurants` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`)
    );

-- customers
CREATE TABLE
    `customers` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `first_name` VARCHAR(40) NOT NULL,
        `last_name` VARCHAR(40) NOT NULL,
        `phone_number` VARCHAR(20) NOT NULL UNIQUE,
        `regular` TINYINT (1) NOT NULL,
        CONSTRAINT `unique_name` UNIQUE (`first_name`, `last_name`)
    );

-- orders
CREATE TABLE
    `orders` (
        `id` INT PRIMARY KEY AUTO_INCREMENT,
        `number` VARCHAR(10) NOT NULL UNIQUE,
        `priority` VARCHAR(10) NOT NULL,
        `customer_id` INT NOT NULL,
        `restaurant_id` INT NOT NULL,
        CONSTRAINT `fk_orders_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
        CONSTRAINT `fk_orders_restaurants` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`)
    );

-- orders_offerings
CREATE TABLE
    `orders_offerings` (
        `order_id` INT NOT NULL,
        `offering_id` INT NOT NULL,
        `restaurant_id` INT NOT NULL,
        CONSTRAINT `fk_orders_offerings_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
        CONSTRAINT `fk_orders_offerings_offerings` FOREIGN KEY (`offering_id`) REFERENCES `offerings` (`id`),
        CONSTRAINT `fk_orders_offerings_restaurants` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`),
        CONSTRAINT `pk_orders_offerings` PRIMARY KEY (`order_id`, `offering_id`)
    );

-- 02 Insert
INSERT INTO
    `offerings` (`name`, `price`, `vegan`, `restaurant_id`)
SELECT
    CONCAT (`name`, " costs:"),
    `price`,
    `vegan`,
    `restaurant_id`
FROM
    `offerings`
WHERE
    name LIKE "Grill%";

-- 03 Update
UPDATE `offerings`
SET
    `name` = UPPER(`name`)
WHERE
    `name` LIKE '%Pizza%';

-- 04 DELETE
DELETE FROM `restaurants`
WHERE
    `name` LIKE '%fast%'
    OR `type` LIKE '%fast%';

-- 05 Get all offerings from restaurant
SELECT
    `o`.`name`,
    `o`.`price`
FROM
    `offerings` AS `o`
    JOIN `restaurants` AS `r` ON `o`.`restaurant_id` = `r`.`id`
WHERE
    `r`.`name` = "Burger Haven"
ORDER BY
    `o`.`id` ASC;

-- 06 Get all customers without orders
SELECT
    `c`.`id`,
    `c`.`first_name`,
    `c`.`last_name`
FROM
    `customers` AS `c`
    LEFT JOIN `orders` AS `o` ON `c`.`id` = `o`.`customer_id`
WHERE
    `o`.`id` IS NULL
ORDER BY
    `c`.`id` ASC;

-- 07 Get all offerings from orders of the customer
SELECT
    `o`.`id`,
    `o`.`name`
FROM
    `offerings` AS `o`
    JOIN `orders_offerings` AS `oof` ON `o`.`id` = `oof`.`offering_id`
    JOIN `orders` AS `orders` ON `oof`.`order_id` = `orders`.`id`
    JOIN `customers` AS `c` ON `orders`.`customer_id` = `c`.`id`
WHERE
    `c`.`first_name` = "Sofia"
    AND `c`.`last_name` = "Sanchez"
    AND `o`.`vegan` = 0
ORDER BY
    `o`.`id` ASC;

-- 08 Get all restaurants with regular customers
SELECT DISTINCT
    `r`.`id`,
    `r`.`name`
FROM
    `restaurants` AS `r`
    JOIN `offerings` AS `of` ON `r`.`id` = `of`.`restaurant_id`
    JOIN `orders_offerings` AS `oof` ON `of`.`id` = `oof`.`offering_id`
    JOIN `orders` AS `o` ON `oof`.`order_id` = `o`.`id`
    JOIN `customers` AS `c` ON `o`.`customer_id` = `c`.`id`
WHERE
    `c`.`regular` = 1
    AND `of`.`vegan` = 1
    AND `o`.`priority` = 'high'
ORDER BY
    r.id ASC;

-- 09 Offering price categories
SELECT
    `name` AS `offering_name`,
    CASE
        WHEN `price` <= 10 THEN 'cheap'
        WHEN `price` > 10
        AND `price` <= 25 THEN 'affordable'
        WHEN `price` > 25 THEN 'expensive'
    END AS `price_category`
FROM
    `offerings`
ORDER BY
    `price` DESC,
    `name` ASC;