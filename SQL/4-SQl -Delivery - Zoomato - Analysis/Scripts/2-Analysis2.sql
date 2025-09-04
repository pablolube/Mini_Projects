/*ZOOMATO DATA ANALYSIS REPORT */

-- -------------------------------------------------------------------------------------------------------------------
-- 2. EXPLORATORY DATA ANALYSIS (EDA)
-- -------------------------------------------------------------------------------------------------------------------
use zomato;
-- The last order's date in the Orders table
SELECT * FROM ORDERS
order by order_date desc;

-- -------------------------------------------------------------------------------------------------------------------
-- 2.1 Review of NULL Values
-- -------------------------------------------------------------------------------------------------------------------

-- Customers Table
SELECT * FROM customers WHERE COALESCE(customer_id,customer_name,reg_date) IS NULL;

-- Deliveries Table
SELECT * FROM deliveries WHERE COALESCE(delivery_id,order_id,delivery_status,delivery_time,rider_id) IS NULL;
   
-- Orders Table
SELECT * FROM orders WHERE COALESCE(order_id,customer_id,restaurant_id,order_item,order_date,order_time,order_status,total_amount) IS NULL;
    
-- Restaurants Table
SELECT * FROM restaurants WHERE COALESCE(restaurant_id,restaurant_name,city,opening_hours) IS NULL;

-- Riders Table
SELECT * FROM riders WHERE COALESCE(rider_id,rider_name,sign_up) IS NULL;

-- ----------------------------------------------------
-- 3. Analysis and Reports
-- ---------------------------------------------------

-- 3.1 Top 5 Most Ordered Dishes by "Arjun Mehta" (Last 2 Years)
-- -------------------------------------------------------------------------------------------------------------------

ALTER TABLE ORDERS
MODIFY COLUMN order_date DATE;

-- Create variable today
set @today =(SELECT MAX(order_date) FROM ORDERS);

SELECT  order_item, count(order_id) 
FROM  orders o
INNER JOIN customers c
ON c.customer_id=o.customer_id
WHERE c.customer_name='Arjun Mehta' 
AND TIMESTAMPDIFF(day,order_Date,@today)<(365*2)
GROUP BY o.order_item
ORDER BY count(order_id) desc
LIMIT  5;

-- 3.2 Popular Time slot: The time Slots during which the most orders are placed, based on 2 hours interval
-- -------------------------------------------------------------------------------------------------------------------

SELECT 
FLOOR(HOUR(order_time) / 2) * 2  AS  start_time,
FLOOR(HOUR(order_time) / 2) * 2 + 2 AS end_time,
count(*) as total_orders
from orders
group by 1,2
order by total_orders desc;

-- 3.3 Order Value Analysis: Find the Average Order value per customer who has placed more than 750 orders
-- -------------------------------------------------------------------------------------------------------------------

SELECT C.CUSTOMER_name, ROUND(AVG(o.total_amount),2) FROM	orders o
INNER JOIN customers c
ON c.customer_id=o.customer_id
group by c.customer_name
HAVING COUNT(o.order_id)>750;


-- 3.4  High Value Customers: List the Customers who have spent more than 100K in total on food orders.
-- -------------------------------------------------------------------------------------------------------------------

SELECT C.CUSTOMER_ID,C.CUSTOMER_name, ROUND(sum(o.total_amount),2) as total_amount FROM	orders o
INNER JOIN customers c
ON c.customer_id=o.customer_id
group by 1,2
HAVING SUM(o.total_amount)>100000
order by total_amount desc;

-- 3.5 Orders without Delivery: Write query to find orders that were placed but not delivered.
-- -------------------------------------------------------------------------------------------------------------------

SELECT r.restaurant_name,r.city, count(o.order_id) as 'Total Not Delivered Orders' FROM ORDERS o
INNER JOIN restaurants r ON r.restaurant_id=o.restaurant_id
LEFT JOIN  deliveries d ON o.order_id=d.order_id
WHERE  o.ORDER_STATUS='Not Fulfilled' or  d.delivery_status='Not Delivered' 
GROUP BY 1,2
ORDER BY  count(o.order_id) DESC;

-- 3.6 Restaurant Revenue Ranking: Rank restaurants by their total revenue from the last year. 
-- (including their name, Total Revenue, and rank within their city)
-- -------------------------------------------------------------------------------------------------------------------

SELECT 
    r.restaurant_name, 
    r.city,
    SUM(o.total_amount) AS Total_Revenue,
    RANK() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS rank_within_city
FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
WHERE order_Date >= DATE_SUB(@TODAY, INTERVAL 1 YEAR)  -- Filtrar últimos 365 días
GROUP BY r.restaurant_id, r.restaurant_name, r.city
ORDER BY r.city, rank_within_city;

-- 3.7 Most popular dish by City:Identify the Most Popular dish in each city based on the number of orders
-- -------------------------------------------------------------------------------------------------------------------

SELECT * FROM
(
SELECT
r.city,
o.order_item as dish,
count(order_id) as total_orders,
RANK() OVER (PARTITION BY r.city ORDER BY COUNT(o.order_id) DESC) ranking
from orders as o 
join restaurants as r
on r.restaurant_id=o.restaurant_id
group by r.city,o.order_item) as t1
where ranking=1;


-- 3.8 Customer Churn: Customers who haven't placed an order in 2024 but did in 2023
-- -------------------------------------------------------------------------------------------------------------------

SELECT * FROM CUSTOMERS
WHERE CUSTOMER_ID IN (
(SELECT DISTINCT CUSTOMER_ID FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE)=2023
AND 
CUSTOMER_ID NOT IN( SELECT DISTINCT CUSTOMER_ID FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE)=2024)));

-- Q9 Cancelled Rate Comparison:Compare the order Cancellation rate for each restaurant between the currrent year 
-- and previous year 
-- -------------------------------------------------------------------------------------------------------------------
 
-- SOLUTION 1
SELECT 
    r.restaurant_name,

    -- Tasa de cancelación para 2024 (usando 'Cancelled' o el estado adecuado)
    (COUNT(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2024 AND o.order_status = 'Not Fulfilled' THEN o.order_id END) / COUNT(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2024 THEN o.order_id END))*100 AS 'Cancelled Rate 2024',

    -- Tasa de cancelación para 2023
    (COUNT(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2023 AND o.order_status = 'Not Fulfilled' THEN o.order_id END) / COUNT(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2023 THEN o.order_id END))*100 AS 'Cancelled Rate 2023'

FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;

-- Solution 2 : Ctes

-- CTE 1
WITH CANCEL_RATIO2023 AS
(SELECT 
    o.restaurant_id,
    COUNT(o.order_id) as total_orders,
    COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) as not_delivered
FROM orders o
LEFT JOIN deliveries d ON d.order_id = o.order_id
WHERE o.order_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY o.restaurant_id) , 

-- CTE 2
CANCEL_RATIO2024 AS
(SELECT 
    o.restaurant_id,
    COUNT(o.order_id) as total_orders,
    COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) as not_delivered
FROM orders o
LEFT JOIN deliveries d ON d.order_id = o.order_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY o.restaurant_id),

-- CTE 3
ratio2023
as(
SELECT restaurant_id,
total_orders,
not_delivered,
round((not_delivered/total_orders*100),2) as cancel_ratio
FROM CANCEL_RATIO2023),

-- CTE 4
ratio2024 as 
(SELECT restaurant_id,
total_orders,
not_delivered,
round((not_delivered/total_orders*100),2) as cancel_ratio
FROM CANCEL_RATIO2024)

-- FINAL SELECT
SELECT 
cy.restaurant_id as 'Restaurant ID',
ly.cancel_ratio as 'Cancel Ratio 2023',
cy.cancel_ratio'Cancel Ratio 2024'
from ratio2023 ly
join ratio2024 cy
on ly.restaurant_id=cy.restaurant_id
order by cy.restaurant_id;

-- 3.10 Rider Average Delivery Time
-- -------------------------------------------------------------------------------------------------------------------

DESCRIBE orders;
DESCRIBE deliveries;

ALTER TABLE orders
MODIFY order_time TIME;

WITH Riders_Avg_Delivery_Time AS (
    SELECT
        r.rider_id,
        r.rider_name,
        o.order_time,
        d.delivery_time,
        CAST(CASE
            WHEN d.delivery_time < o.order_time THEN (1440 - ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time)))
            ELSE ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time))
        END AS decimal(10,2)) AS Time_Taken_to_deliver
    FROM Orders o
    LEFT JOIN Deliveries d ON o.order_id = d.order_id
    LEFT JOIN Riders r ON d.rider_id = r.rider_id
    WHERE d.delivery_status = 'Delivered'
)
SELECT
    rider_id,
    rider_name,
    CAST(ROUND(AVG(Time_Taken_to_deliver), 2) AS decimal(10,2)) AS Avg_Time_By_Riders_in_MINs
FROM Riders_Avg_Delivery_Time
GROUP BY rider_id, rider_name
ORDER BY rider_id;


-- 3.11 Monthly Restaurant Growth Ratio: Each restaurant's growth ratio based on the total number of delivered orders since its joining
-- -------------------------------------------------------------------------------------------------------------------

WITH growth as(
SELECT 
    r.restaurant_name, 
    YEAR(o.order_date) years, -- Se muestra como texto, pero no se usa para ordenar
	MONTH(o.order_date) months, 
    COUNT(o.order_id) AS total_current_month,
LAG(COUNT(o.order_id), 1) OVER (PARTITION BY r.restaurant_name ORDER BY  YEAR(o.order_date) ASC , MONTH(o.order_date) ASC) as total_prev_month
FROM restaurants r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
INNER JOIN deliveries d ON d.order_id = o.order_id
WHERE d.delivery_status = 'Delivered'
GROUP BY r.restaurant_name, YEAR(o.order_date), MONTH(o.order_date)
ORDER BY   r.restaurant_name, YEAR(o.order_date) ASC , MONTH(o.order_date) ASC)
SELECT 
    restaurant_name, 
    years, 
    months,
    total_prev_month as "Order prev Month",
	total_current_month as "Order current Month",
    ((total_current_month - total_prev_month) / total_prev_month) * 100 AS '%Ratio'
FROM growth;

-- 3.12 Customer Segmentations:
-- (1) Segment Customers into "Gold" or "Silver" groups based on their total spending
-- (2) Compare to the Average Order Value (AOV) If Customer's total spending  exceeds AOV Label them with gold other wise label them as  silver
-- Write a Query to Determine each segment's total number of orders and total revenue
-- -------------------------------------------------------------------------------------------------------------------

SET @AOV = (SELECT AVG(total_amount) FROM  orders);

SELECT s.Category,sum(s.total_order),sum(Total_spent)
FROM 
(SELECT  
c.customer_id as 'ID',
c.customer_name as 'Customer Name',
count(o.order_id) as total_order,
SUM(o.total_amount) as Total_spent,
@aov as 'Average Order Value',
CASE WHEN (sum(o.total_amount)> @AOV) THEN 'GOLD' ELSE 'SILVER' END AS Category
FROM orders o
INNER JOIN customers c on o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
) as  s
group by s.Category;

-- Q13 Rider Monthly Earning:Calculate each rider's total monthly earnings, assuming they earn 8% of the Delivered Order Amount
-- -------------------------------------------------------------------------------------------------------------------

SELECT
r.rider_id,
r.rider_name,
YEAR(o.order_date),
MONTH(o.order_date),
cast(sum(total_amount*0.08) as decimal(10,2)) as 'Rider Earning'
from riders as r
INNER JOIN deliveries d on  d.rider_id=r.rider_id
INNER JOIN orders o on  o.order_id=d.order_id
where delivery_status='Delivered'
group by 1,2,3,4
order by 1;

-- Q 14 Rider Rating Analysis:
-- Find the number of 5 Star. 4 star, and 3 star rating Each riders has. Riders recieve this rating based on delivery time
-- IF orders are delivered less than 15 Minutes of order recieved time the rider get 5 star rating.
-- IF they delivery is 15 to 20 Minute then they get a 4 star rating
-- IF they deliver after 20 Minute they get 3 star rating.
-- -------------------------------------------------------------------------------------------------------------------

WITH Riders_Avg_Delivery_Time AS (
    SELECT
        r.rider_id,
        r.rider_name,
        o.order_time,
        d.delivery_time,
        CAST(CASE
            WHEN d.delivery_time < o.order_time THEN (1440 - ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time)))
            ELSE ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time))
        END AS decimal(10,2)) AS Time_Taken_to_deliver
    FROM Orders o
    LEFT JOIN Deliveries d ON o.order_id = d.order_id
    LEFT JOIN Riders r ON d.rider_id = r.rider_id
    WHERE d.delivery_status = 'Delivered'
), 


-- IF orders are delivered less than 15 Minutes of order recieved time the rider get 5 star rating.
-- IF they delivery is 15 to 20 Minute then they get a 4 star rating
-- IF they deliver after 20 Minute they get 3 star rating.
stars as
(SELECT ri.rider_id,
CASE 
WHEN ri.Time_Taken_to_deliver< 15 THEN  5
WHEN  ri.Time_Taken_to_deliver >= 15 AND  ri.Time_Taken_to_deliver< 20 THEN  4
WHEN  ri.Time_Taken_to_deliver>= 20 THEN  3
END as Total_Stars
FROM Riders_Avg_Delivery_Time as ri)
SELECT st.rider_id, st.Total_Stars,count(st.Total_Stars) as 'Count of Stars' from stars st
GROUP BY  st.rider_id, st.Total_Stars;


-- Q 15 Order Frequency by Day:
-- Analyze order frequency per day of the week and identify the peak day for each restaurant
-- -------------------------------------------------------------------------------------------------------------------
WITH Peak_day_for_Restaurant AS (
    SELECT
        o.restaurant_id,
        r.restaurant_name AS Restaurant,
        WEEKDAY(o.order_date) AS Week_number,
        DAYNAME(o.order_date) AS Weekday_name, 
        COUNT(o.order_id) AS Nr_of_Orders,
        DENSE_RANK() OVER (
            PARTITION BY o.restaurant_id 
            ORDER BY COUNT(o.order_id) DESC
        ) AS Rank_of_Week_Day
    FROM Orders o 
    LEFT JOIN Restaurants r
        ON r.restaurant_id = o.restaurant_id
    GROUP BY o.restaurant_id, r.restaurant_name, Weekday_name, Week_number
) 
SELECT Restaurant, Weekday_name, Nr_of_Orders, Rank_of_Week_Day 
FROM Peak_day_for_Restaurant
WHERE Rank_of_Week_Day = 1
ORDER BY Nr_of_Orders DESC;



-- Q16 Customer Lifetime value(CLV)
-- Calculate the Total Revenue Generated by each customer over all their orders
-- -------------------------------------------------------------------------------------------------------------------

SELECT c.customer_id, c.customer_name, sum(o.total_amount)  Customer_Lifetime_Value FROM orders o
INNER JOIN customers  c
ON o.customer_id= c.customer_id
GROUP BY 1,2
ORDER BY 3 DESC;


-- Q 17 Monthly Sales Trends:
-- Identify Sales Trends by Comparing each month's total Sales to the previous months
-- -------------------------------------------------------------------------------------------------------------------

WITH trend as(
SELECT 
    YEAR(o.order_date) years,
	MONTH(o.order_date) months, 
	SUM(o.total_amount) AS total_current_month,
LAG(SUM(o.total_amount), 1) OVER (ORDER BY YEAR(o.order_date) ASC , MONTH(o.order_date) ASC) as total_prev_month
FROM orders o
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY YEAR(o.order_date) ASC , MONTH(o.order_date) ASC)
SELECT 
    years, 
    months,
    	total_current_month as "Order current Month",
    total_prev_month as "Order prev Month",
    ((total_current_month - total_prev_month) / total_prev_month) * 100 AS '%Ratio'
FROM trend;
 
-- Q 18 Rider Efficiency
-- Evaluate rider Efficiency by determining Average Delivery times and Identifying those with lowest 
-- And highest Average Delivery time
-- -------------------------------------------------------------------------------------------------------------------

    SET @avg_dev_time=(SELECT
          avg(CAST(CASE
            WHEN d.delivery_time < o.order_time THEN (1440 - ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time)))
            ELSE ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time))
        END AS decimal(10,2))) AS Time_Taken_to_deliver
    FROM Orders o
    LEFT JOIN Deliveries d ON o.order_id = d.order_id
    LEFT JOIN Riders r ON d.rider_id = r.rider_id
    WHERE d.delivery_status = 'Delivered');
   
   WITH  riders_times as( SELECT r.rider_id,r.rider_name,avg(CAST(CASE
            WHEN d.delivery_time < o.order_time THEN (1440 - ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time)))
            ELSE ABS(TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time))
           END AS decimal(10,2))) AS Avg_time_rider,
           @avg_dev_time as AVG_time from Orders o
    LEFT JOIN Deliveries d ON o.order_id = d.order_id
    LEFT JOIN Riders r ON d.rider_id = r.rider_id
    WHERE d.delivery_status = 'Delivered'
    group by 1,2)
    
    SELECT ra.*, case WHEN Avg_time_rider > AVG_time then  'Slow' else 'Fast' end as Rider_category  FROM riders_times ra;




-- Q19 Order Item Popularity:
-- Track the Popularity of specific order items over time and identify seasonal demand spikes
-- -------------------------------------------------------------------------------------------------------------------
SELECT o.order_item,
CASE 
WHEN MONTH(o.order_date) BETWEEN 6 AND 9  THEN 'Monsoon' 
WHEN MONTH(o.order_date) BETWEEN 3 AND  5  THEN 'Summer' 
WHEN MONTH(o.order_date) BETWEEN 10 AND 11  THEN 'Autumn' 
WHEN MONTH(o.order_date) in (11,12,1,2)  THEN 'Winter' 
END AS 'Season',
count(o.order_id)
FROM orders o 
group by o.order_item, Season
ORDER BY  o.order_item,count(o.order_id) desc ;

-- Q 20 Rank each City based on the Total revenue for last year 2023
-- -------------------------------------------------------------------------------------------------------------------

SELECT 
r.city,
sum(o.total_amount),
rank() over(order by sum(o.total_amount)desc ) as 'Rank'
FROM  restaurants r
inner join orders o
on r.restaurant_id=o.restaurant_id
where YEAR(o.order_date)=2023
group by 1;
