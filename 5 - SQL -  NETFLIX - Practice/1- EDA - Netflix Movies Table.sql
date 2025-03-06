-- SCHEMAS of Netflix
CREATE DATABASE Netflix_Analysis;
use Netflix_Analysis;
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

LOAD DATA LOCAL INFILE 'C:\\Users\\PC\\Documents\\0) Trabajos\\1) Proyectos\\SQL\\netflix_sql_project'
INTO TABLE netflix
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows 
SELECT type, COUNT(*) 
FROM  netflix
GROUP BY  type;

-- 2. Find the most common rating for movies and TV shows

WITH RankedNetflix AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS total,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
)
SELECT *
FROM RankedNetflix
WHERE ranking = 1;



--  3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
where 
release_year = '2020';


-- 4. Find the top 5 countries with the most content on Netflix
SELECT country as 'Country', count(*) AS 'Total Movies Produced' FROM netflix
WHERE COUNTRY != ('')
GROUP BY country
ORDER BY COUNT(*) desc
LIMIT 5;


-- 5. Identify the longest movie
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS SIGNED) DESC
LIMIT 1;




-- 6. Find content added in the last 5 years

SET SQL_SAFE_UPDATES = 0;
UPDATE netflix 
SET date_added = STR_TO_DATE(date_added, '%M %d, %Y');

ALTER TABLE netflix 
MODIFY COLUMN date_added DATE;

SELECT * 
FROM netflix
WHERE release_year > ((SELECT MAX(YEAR(date_added)) FROM netflix) - 5);



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * 
FROM netflix 
WHERE show_id='s424';


SELECT *
FROM netflix
WHERE director_name like '$Rajiv Chilaka$';

-- 8. List all TV shows with more than 5 seasons

select * 
from netflix
where type='TV Show' and CAST(SUBSTRING_INDEX(duration, ' ', 1) AS SIGNED)>5 ;

-- 9. Count the number of content items in each genre

SELECT genre, COUNT(*) AS total_content
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
    FROM netflix
    JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
              UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 
              UNION ALL SELECT 8 UNION ALL SELECT 9) n 
        ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
) AS genres
GROUP BY genre
ORDER BY total_content DESC;


-- 10.Find each year and the average numbers of content release in India on netflix.
-- return top 5 year with highest avg content release!

SELECT 
county,
release_year, 
count(show_id),
round (count(show_id)/(select count(show_id) from NETFLIX WHERE country = 'India') *100,2)
FROM  netflix
WHERE country = 'India'
group by country,release_year
limit 5;

-- 11. List all movies that are documentaries
SELECT *
FROM netflix
where listed_in like '%Documentaries%';


-- 12. Find all content without a director
SELECT *
FROM netflix
where director = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * 
FROM netflix
where casts LIKE '%Salman Khan%' AND release_year>(SELECT max(release_year) from netflix)-10; 

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT casts, COUNT(*) AS total_actors
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(CASTS, ',', n.n), ',', -1)) AS casts
    FROM netflix
    JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
              UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 
              UNION ALL SELECT 8 UNION ALL SELECT 9) n 
        ON CHAR_LENGTH(CASTS) - CHAR_LENGTH(REPLACE(CASTS, ',', '')) >= n.n - 1
WHERE COUNTRY='India') AS actores
WHERE casts != ''
GROUP BY casts
ORDER BY total_ACTORS DESC
LIMIT 10;


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field. Label content containing these keywords as 'Bad' and all other  content as 'Good'. Count how many items fall into each category.
SELECT 
    category,
    TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
        *,
        CASE 
            WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category, TYPE
ORDER BY TYPE;







