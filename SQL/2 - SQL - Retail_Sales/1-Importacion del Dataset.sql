-- PROJECT #2 SQL RETAIL SALES ANALYSIS

-- CREATE DATABASE
DROP DATABASE IF EXISTS sqL_project_p1;
CREATE database sqL_project_p1;

-- SELECT MY DATABASE
USE sql_project_p1;

-- CREATE  TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
transactions_id	 INT PRIMARY KEY ,
sale_date	VARCHAR(30),
sale_time	TIME,
customer_id INT,
gender VARCHAR(15),
age INT (3),
category VARCHAR(20),
quantiy	INT,
price_per_unit FLOAT,
cogs	FLOAT,
total_sale FLOAT);

-- IMPORTAR DATASET


