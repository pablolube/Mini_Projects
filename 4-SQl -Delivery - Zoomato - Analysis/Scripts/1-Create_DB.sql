-- Zomato  SQL Project

DROP DATABASE if exists zomato;
CREATE DATABASE  if not exists zomato;

USE zomato;

-- ---------------------------------------------------------------
-- Create table "Riders"
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS Riders;
CREATE TABLE Riders(
rider_id INT  PRIMARY KEY,
rider_name VARCHAR(100),
sign_up DATE
);

-- ---------------------------------------------------------------
-- Create table "Orders"
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS Orders;
CREATE TABLE  Orders(
order_id INT PRIMARY KEY,
customer_id INT,
restaurant_id INT,
order_item varchar(200),
order_date varchar(200),

order_time VARCHAR (40),
order_status varchar(20),
total_amount FLOAT (10,2));
-- ---------------------------------------------------------------
-- Create table "Restaurants"
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS Restaurants;
CREATE TABLE Restaurants
(
            restaurant_id INT PRIMARY KEY,
            restaurant_name VARCHAR(100),
			city VARCHAR(50),
            opening_hours VARCHAR(100)
);

-- PABLO DEL FUTURO TRABAJAR EL TIME - NORMALIZALO

-- ---------------------------------------------------------------
-- Create table "Deliveries"
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS Deliveries;
CREATE TABLE Deliveries(
delivery_id INT PRIMARY KEY,
order_id INT,
delivery_status VARCHAR(20),
delivery_time TIME,
rider_id INT 
);

-- ---------------------------------------------------------------
-- Create table "Customers"
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(200),
reg_date DATE
);

ALTER TABLE orders
ADD CONSTRAINT FK_restaurant_id
FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id);

ALTER TABLE orders
ADD CONSTRAINT FK_customer_id
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE deliveries
ADD CONSTRAINT FK_rider_id
FOREIGN KEY (rider_id) REFERENCES riders(rider_id);

ALTER TABLE deliveries
ADD CONSTRAINT FK_order_id
FOREIGN KEY (order_id) REFERENCES orders(order_id);

