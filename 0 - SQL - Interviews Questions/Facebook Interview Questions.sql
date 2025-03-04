-- SCHEMA
DROP DATABASE IF EXISTS facebook_interview;
CREATE DATABASE IF NOT EXISTS facebook_interview;
USE facebook_interview;

-- Create pages table
CREATE TABLE pages (
    page_id INTEGER PRIMARY KEY,
    page_name VARCHAR(255)
);

-- Insert data into pages table
INSERT INTO pages (page_id, page_name) VALUES
(20002, 'Data Visualization Techniques'),
(20003, 'SQL Query Optimization'),
(20004, 'Machine Learning Basics'),
(20005, 'Introduction to Python'),
(20006, 'Data Science for Beginners'),
(20007, 'Big Data Insights'),
(20008, 'Power BI Dashboards'),
(20009, 'Advanced Excel Tips'),
(20010, 'Business Intelligence Trends'),
(20011, 'SQL Server Performance Tuning'),
(20012, 'Predictive Analytics Models'),
(20013, 'AI in Healthcare'),
(20014, 'Data Mining Strategies'),
(20015, 'Cloud Computing Essentials'),
(20016, 'R for Data Analysis'),
(20017, 'Database Security Best Practices'),
(20018, 'Time Series Analysis Techniques'),
(20019, 'Data Engineering Fundamentals'),
(20020, 'Advanced SQL Queries'),
(20021, 'Introduction to NoSQL'),
(20022, 'Data Warehousing Concepts'),
(20023, 'Natural Language Processing'),
(20024, 'SQL Server Integration Services'),
(20025, 'Data Cleaning Methods');

-- Create page_likes table
CREATE TABLE page_likes (
    user_id INTEGER,
    page_id INTEGER,
    liked_date DATETIME,
    FOREIGN KEY (page_id) REFERENCES pages(page_id)
);

-- Insert data into page_likes table
INSERT INTO page_likes (user_id, page_id, liked_date) VALUES
(4, 20004, '2020-09-25 17:40:02'),
(5, 20005, '2024-05-10 18:55:12'),
(1, 20005, '2023-11-22 10:20:33'),
(2, 20005, '2020-04-17 11:45:12'),
(3, 20006, '2022-09-29 14:50:27'),
(4, 20008, '2021-12-01 16:59:03'),
(5, 20008, '2024-01-13 19:06:45'),
(6, 20008, '2023-02-17 21:10:56'),
(1, 20009, '2020-11-30 10:40:51'),
(2, 20009, '2022-07-13 11:56:42'),
(3, 20009, '2023-03-20 14:41:30'),
(4, 20009, '2024-08-04 17:25:59'),
(1, 20010, '2021-02-06 10:50:13'),
(2, 20010, '2023-04-19 12:00:45'),
(3, 20010, '2020-01-10 14:45:17'),
(4, 20010, '2025-01-29 17:50:02'),
(5, 20010, '2021-07-22 19:30:14'),
(6, 20010, '2024-06-11 22:05:11'),
(7, 20010, '2023-12-05 23:00:18'),
(1, 20011, '2021-03-09 10:20:48'),
(2, 20011, '2020-10-14 11:45:56'),
(3, 20011, '2023-01-28 14:50:22'),
(4, 20011, '2024-02-11 17:30:15'),
(5, 20011, '2022-08-23 19:25:30'),
(6, 20011, '2025-02-25 20:57:38'),
(1, 20012, '2022-10-19 10:15:33'),
(2, 20012, '2021-05-12 11:35:11'),
(3, 20012, '2020-07-30 14:05:40'),
(4, 20012, '2024-03-16 16:55:17'),
(5, 20012, '2023-09-24 19:40:22'),
(6, 20012, '2022-12-11 21:20:57'),
(7, 20012, '2025-01-06 22:35:09'),
(1, 20013, '2024-11-02 10:25:04'),
(2, 20013, '2021-06-14 11:50:33'),
(3, 20013, '2020-12-22 14:30:10'),
(4, 20013, '2023-07-03 17:10:42'),
(5, 20013, '2025-03-01 19:15:01'),
(1, 20014, '2021-04-16 10:55:09'),
(2, 20014, '2023-10-09 12:10:26'),
(3, 20014, '2020-08-02 14:55:43'),
(4, 20014, '2024-11-15 17:20:12'),
(1, 20015, '2021-03-29 10:30:27'),
(2, 20015, '2022-01-18 11:40:52'),
(3, 20015, '2020-11-09 14:50:38'),
(4, 20015, '2025-02-07 17:45:21'),
(5, 20015, '2023-05-22 19:25:18'),
(6, 20015, '2021-06-01 22:05:05'),
(1, 20016, '2020-04-10 10:10:01'),
(2, 20016, '2024-09-28 11:30:14'),
(3, 20016, '2023-02-19 14:05:59'),
(4, 20016, '2025-03-02 17:25:47'),
(5, 20016, '2022-12-17 19:55:12'),
(1, 20017, '2023-05-23 10:20:43'),
(2, 20017, '2021-07-08 11:50:30'),
(3, 20017, '2024-08-05 14:35:14'),
(4, 20017, '2022-10-17 17:00:56'),
(1, 20018, '2025-02-15 10:15:32'),
(2, 20018, '2020-01-30 11:25:58'),
(3, 20018, '2023-11-10 14:45:11'),
(4, 20018, '2021-12-20 17:15:21'),
(5, 20018, '2022-07-25 19:40:14'),
(6, 20018, '2024-02-11 22:00:38'),
(1, 20019, '2023-04-04 10:50:28'),
(2, 20019, '2020-05-19 11:55:10'),
(3, 20019, '2022-11-28 14:20:17'),
(4, 20019, '2021-01-23 17:10:45'),
(5, 20019, '2025-03-04 19:30:27'),
(6, 20019, '2024-06-16 21:15:30'),




SELECT * FROM page_likes;
SELECT * FROM pages;
/*
Question 1:
Write a SQL query to retrieve the IDs of the Facebook pages that have zero likes. 
The output should be sorted in ascending order based on the page IDs.
*/


-- ------------------------------------------------------------------------------------------------------------------------------------
-- My Solution
-- ------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT p.page_id FROM pages p
left join page_likes pl
on  p.page_id=pl.page_id
WHERE pl.page_id  IS null;


-- ------------------------------------------------------------------------------------------------------------------------------------
-- Question 2 App Click-through Rate (CTR) 
-- ------------------------------------------------------------------------------------------------------------------------------------

-- Create the events table
CREATE TABLE events (
    app_id INTEGER,
    event_type VARCHAR(10),
    timestamp DATETIME
);

-- Insert records into the events table
INSERT INTO events (app_id, event_type, timestamp) VALUES
(123, 'impression', '2022-07-18 11:36:12'),
(123, 'impression', '2022-07-18 11:37:12'),
(123, 'click', '2022-07-18 11:37:42'),
(234, 'impression', '2022-07-18 14:15:12'),
(234, 'click', '2022-07-18 14:16:12');

/*

Question 2: 
Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.
Definition and note:
Expected Output Columns: app_id, ctr
*/

-- My observations 
-- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
-- To avoid integer division, multiply the CTR by 100.0, not 100.

-- ------------------------------------------------------------------------------------------------------------------------------------
-- My Solution 
-- ------------------------------------------------------------------------------------------------------------------------------------
select s.app_id, round((s.click/s.impresion)*100,2)
from(
select
app_id,
sum( CASE WHEN  event_type = 'impression' then 1 else 0 end) as impresion,
sum( CASE WHEN  event_type = 'click' then 1 else 0 end) as click
from events
where year(timestamp)=2022
group by app_id) as s;





