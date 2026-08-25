CREATE DATABASE Amazon_Ecommerce;

USE Amazon_Ecommerce;
CREATE TABLE Orders(
Order_Date DATE,
Order_ID INT,
Delivery_Date DATE,
Customer_ID INT,
Location VARCHAR(30),
Zone VARCHAR(25),
Delivery_Type VARCHAR(30),
Product_Category VARCHAR(100),
SubCategory VARCHAR(100),
Product VARCHAR(255),
Unit_Price DECIMAL(10,2),
Shipping_Fee DECIMAL(10,2),
Order_Quantity INT,
Sale_Price DECIMAL(10,2),
Status VARCHAR(50),
Reason VARCHAR(250),
Rating INT);
select * from amazon_ecommerce.orders;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Ecommerce Dataset-Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Order_Date,Order_id,@Delivery_Date,Customer_id,Location,Zone,Delivery_Type,Product_Category,SubCategory,Product,@Unit_Price,Shipping_Fee,
@Order_Quantity,@Sale_Price,Status,Reason,Rating)
SET 
Order_Date=
case 
when trim(@Order_Date) LIKE '%/%'
THEN str_to_date(trim(@Order_Date),'%d/%m/%Y')
ELSE str_to_date(trim(@Order_Date),'%d-%m-%Y')
END,
Delivery_date=
CASE 
WHEN TRIM(@Delivery_Date) LIKE '%/%'
THEN str_to_date(trim(@Delivery_Date),'%d/%m/%Y')
ELSE str_to_date(trim(@Delivery_Date),'%d-%m-%Y')
END,
Sale_Price=REPLACE(TRIM(@Sale_Price),',',''),
Unit_Price = NULLIF(REPLACE(TRIM(@Unit_Price), ',', ''), ''),
Order_Quantity=NULLIF(TRIM(@Order_Quantity),'');

SELECT * FROM Orders LIMIT 10;

CREATE TABLE Customer(
CustomerID INT,
CustomerAge INT,
CustomerGender VARCHAR(10));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Ecommerce Dataset-Customers.csv'
INTO TABLE customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from customer LIMIT 10;







