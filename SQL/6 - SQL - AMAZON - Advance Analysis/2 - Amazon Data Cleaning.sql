-- ----------------------------------------------------------------------------------------------------------
-- DATA CLEANING
-- ----------------------------------------------------------------------------------------------------------
SELECT * FROM category;
SELECT * FROM Customers;
SELECT * FROM Inventory;
SELECT * FROM Order_items;
SELECT * FROM Orders;
SELECT * FROM Payments;
SELECT * FROM products;
SELECT * FROM Sellers;
SELECT * FROM Shipping;

-- CHECK DATE TYPE 
SET SQL_SAFE_UPDATES = 0;

-- Modify Datatype inventory
UPDATE inventory
SET last_stock_date = STR_TO_DATE(last_stock_date, '%Y-%m-%d');

ALTER TABLE inventory
modify last_stock_date DATE;

-- Modify Datatype Orders date
UPDATE orders
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d');

ALTER TABLE orders
modify orders DATE;

-- Modify Datatype Orders date
ALTER TABLE Payments
CHANGE COLUMN Paymente_date payment_date VARCHAR(200);

UPDATE Payments
SET payment_date = STR_TO_DATE(payment_date, '%Y-%m-%d');

ALTER TABLE Payments
modify payment_date DATE;

-- Modify Datatype Shipping
UPDATE shipping
SET shipping_date = STR_TO_DATE(shipping_date, '%Y-%m-%d');

ALTER TABLE shipping
modify shipping DATE;

--  Checking data  integrity 
SELECT count(*) FROM Shipping WHERE return_date;
SELECT count(*) FROM Shipping WHERE return_date IS NOT NULL;
-- Out of a total of 21,141 shipments, 2,840 products were returned.

SELECT delivery_status,COUNT(*) FROM Shipping WHERE RETURN_DATE IS not NULL 
GROUP BY delivery_status;

-- Status
SELECT DISTINCT payment_status FROM  Payments;
SELECT DISTINCT order_status FROM  Orders;
SELECT  DISTINCT delivery_status FROM Shipping;



