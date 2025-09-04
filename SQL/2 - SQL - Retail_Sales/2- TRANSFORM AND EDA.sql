USE sql_project_p1;
-- IMPORTAR DATASET

-- CONSULTA DE LOS DATOS DE MI DATASET 
SET SQL_SAFE_UPDATES = 0;

-- CONSULTO TABLA
SELECT * FROM retail_sales;

-- MODIFICO EL FORMATO DE LA FECHA A DATE
SET SQL_SAFE_UPDATES = 0;
UPDATE retail_sales
SET sale_date = STR_TO_DATE(sale_date, '%d/%m/%Y');

-- CONSULTO TABLA
SELECT * FROM retail_sales;

ALTER TABLE  sql_project_p1.retail_sales
MODIFY COLUMN sale_date DATE;

-- EDA
SELECT * FROM retail_sales;

-- EDA
-- Consulto dateset
USE sql_project_p1;
SELECT * FROM retail_sales;

SELECT COUNT(transactions_id)  AS 'TOTAL DE TRANSACCIONES' FROM retail_sales;

SELECT  COUNT(distinct transactions_id )  AS 'TOTAL DE TRANSACCIONES' FROM retail_sales;


SELECT COUNT(transactions_id)  AS 'TOTAL DE TRANSACCIONES' FROM retail_sales
WHERE transactions_id IS NULL;

SELECT count(*)
FROM retail_sales
WHERE transactions_id IS NULL 
   OR customer_id IS NULL
   OR gender IS NULL
     OR age IS NULL 
   OR category IS NULL
     OR quantiy IS NULL 
   OR price_per_unit IS NULL
     OR cogs IS NULL 
   OR total_sale IS NULL;  

SELECT *   FROM retail_sales
WHERE retail_sales IS NULL;

-- Muestro nulos
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL
     OR age IS NULL 
   OR category IS NULL
     OR quantiy IS NULL 
   OR price_per_unit IS NULL
     OR cogs IS NULL 
   OR total_sale IS NULL;  

-- **Informe de Análisis de Ventas - Retail Sales**

-- **Fecha de Generación:
SELECT CURDATE() AS today;



-- ### **1. Verificación y Manejo de Valores Nulos**
-- Para garantizar la integridad de los datos, se realizaron consultas para detectar valores nulos en la base de datos `retail_sales`. Se encontraron registros con valores nulos y se eliminaron con la siguiente consulta:


DELETE r FROM retail_sales AS r
JOIN (SELECT transactions_id
FROM retail_sales
WHERE transactions_id IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL) AS temp
ON r.transactions_id = temp.transactions_id;


-- ### **2. Estadísticas Generales**

-- **Total de Ventas:**

SELECT COUNT(*) AS Total_Sales FROM retail_sales;


-- **Total de Clientes:**

SELECT COUNT(distinct customer_id) AS Total_Customer FROM retail_sales;


-- **Total de Categorías de Productos:**

SELECT COUNT(distinct category) AS Total_Category FROM retail_sales;

-- **Venta Total en USD:**

SELECT CONCAT('USD ', FORMAT(SUM(total_sale), 2, 'es_ES')) AS "Total Sales" FROM retail_sales;

-- ### **3. Análisis Específico de Ventas**

-- #### **3.1 Ventas realizadas el 5 de noviembre de 2022**

SELECT DATE_FORMAT(MAX(sale_date), '%d/%m/%Y') AS Date,
       CONCAT('USD ', FORMAT(SUM(total_sale), 2, 'es_ES')) AS "Total Sales"
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- #### **3.2 Transacciones con Categoría 'Clothing' y cantidad mayor a 4 en noviembre de 2022**

SELECT * FROM retail_sales
WHERE category='Clothing'
AND quantiy >= 4
AND EXTRACT(YEAR FROM sale_date) = 2022
AND EXTRACT(MONTH FROM sale_date) = 11;

-- #### **3.3 Ventas totales por categoría**

SELECT category, CONCAT('USD ', FORMAT(SUM(total_sale), 2, 'es_ES')) as "Total Sales"
FROM retail_sales
GROUP BY category;

-- #### **3.4 Edad promedio de clientes en la categoría 'Beauty'**

SELECT ROUND(AVG(age),0) AS "Average Age"
FROM retail_sales
WHERE category='Beauty';

-- #### **3.5 Transacciones con ventas mayores a USD 1000**

SELECT * FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- #### **3.6 Número total de transacciones por género y categoría**

SELECT category, gender, COUNT(transactions_id) AS "Total Transaction"
FROM retail_sales
GROUP BY category, gender
ORDER BY category ASC, gender DESC;


-- #### **3.7 Mes con mejores ventas por año**

SELECT year, month, avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank_per_year
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS ranked_sales
WHERE rank_per_year = 1;


-- #### **3.8 Top 5 clientes con mayor volumen de ventas**

SELECT customer_id AS Customer, CONCAT("USD ", FORMAT(SUM(total_sale), 2, 'es_ES')) AS "Total Sales"
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- #### **3.9 Clientes únicos por categoría de producto**

SELECT category, COUNT(DISTINCT customer_id) AS "Unique Customers"
FROM retail_sales
GROUP BY category;

-- #### **3.10 Cantidad de órdenes por turno**


WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

SELECT
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY EXTRACT(YEAR FROM sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank_per_year
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS ranked_sales
WHERE rank_per_year = 1;
