--  -----------------------------------------------------------------------------------------------
-- DATA SCHEMA
--  -----------------------------------------------------------------------------------------------

CREATE DATABASE amazon;
USE amazon;
CREATE TABLE  Payments(
payment_id INT PRIMARY KEY,
order_id INT,
paymente_date VARCHAR (20),
payment_status VARCHAR (200)
);

CREATE TABLE Sellers
(seller_id INT PRIMARY KEY,
seller_name VARCHAR (200),
origin VARCHAR(100)
);

CREATE TABLE Orders
(Order_id INT PRIMARY KEY,
order_date VARCHAR(100),
customer_id INT,
seller_id INT,
order_status VARCHAR(100)
);

CREATE TABLE Customers
(customer_id INT PRIMARY KEY,
first_name VARCHAR(200),
last_name VARCHAR(200),
state VARCHAR(100)
);

CREATE TABLE Shipping(
shipping_id INT PRIMARY KEY,
order_id INT,
shipping_date VARCHAR(100),
return_date VARCHAR(100),
shipping_providers VARCHAR(100),
delivery_status VARCHAR(100)
);

CREATE TABLE Order_items(
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
price_per_unit FLOAT (10,2)
);

CREATE TABLE Products(
product_id INT PRIMARY KEY,
product_name VARCHAR(200),
price FLOAT (10,2),
cogs FLOAT (10,2),
category_id INT);

CREATE TABLE Inventory
(inventory_id INT PRIMARY KEY,
product_id INT,
stock INT,
warehouse_id INT,
last_stock_date VARCHAR(100));

CREATE TABLE Category
(category_id INT PRIMARY KEY,
category_name VARCHAR(100)
);

-- Adding Foreign Key constraint to Tables

ALTER TABLE Products
ADD CONSTRAINT fk_category_id 
FOREIGN KEY (category_id) 
REFERENCES Category (category_id);

ALTER TABLE Orders
ADD CONSTRAINT fk_customer_id 
FOREIGN KEY (customer_id) 
REFERENCES Customers (Customer_id);

ALTER TABLE Orders
ADD CONSTRAINT fk_seller_id 
FOREIGN KEY (seller_id) 
REFERENCES Sellers (seller_id);

ALTER TABLE Order_items
ADD CONSTRAINT fk_order_id 
FOREIGN KEY (order_id) 
REFERENCES Orders (order_id);

ALTER TABLE Order_items
ADD CONSTRAINT fk_Product_id 
FOREIGN KEY (product_id) 
REFERENCES Products (product_id);

ALTER TABLE Payments
ADD CONSTRAINT fk_order_id_payment
FOREIGN KEY (order_id) 
REFERENCES Orders (order_id);

ALTER TABLE Shipping
ADD CONSTRAINT fk_order_id_shipping
FOREIGN KEY (order_id) 
REFERENCES Orders (order_id);

ALTER TABLE Inventory
ADD CONSTRAINT fk_product_Inventory
FOREIGN KEY (product_id) 
REFERENCES Products (product_id);