use gringotts;

-- 1 Records' Count
SELECT  COUNT(*) AS 'count'
FROM `wizzard_deposits`;

-- 2 Longest Magic Wand
SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`;