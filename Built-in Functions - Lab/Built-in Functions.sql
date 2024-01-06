use book_library;
-- 1 Find Book Titles
 SELECT title 
	AS `title`
 FROM books
 WHERE SUBSTRING(title,1, 3) = 'The'
 ORDER BY id;
 
 -- 2 Replace Titles
SELECT REPLACE(title, 'The', '***') 
	AS `title`
FROM books
WHERE SUBSTRING(title, 1,3) = 'The'
ORDER BY id;


-- 3 Sum Cost of All Books 
SELECT SUM(cost)
FROM books;

-- 4 Days Lived
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Full Name',
    DATEDIFF(died, born) AS 'Days Lived'
FROM
    authors;

-- 5 Harry Potter Books
SELECT title
FROM books
/* starts with 'Harry' and ends with 'Potter' */
WHERE title LIKE '%Harry Potter%'
ORDER BY id;