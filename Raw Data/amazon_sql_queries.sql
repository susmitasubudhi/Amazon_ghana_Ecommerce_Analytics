use amazon_ecommerce;
-- Objective  Questions
-- Identify the top 5 most valuable customers using a composite score that       combines three key metrics: (SQL)
select * from amazon_ecommerce.orders limit 10;

-- Total Revenue (50% weight): The total amount of money spent by the customer.
-- Order Frequency (30% weight): The number of orders placed by the customer, indicating their loyalty and engagement.
-- Average Order Value (20% weight): The average value of each order placed by the customer, reflecting the typical transaction size.

select Customer_ID,
SUM(Sale_Price) as `Total_Revenue`,
COUNT(Order_ID) as `Order_Frequency`,
AVG(Sale_Price) as `Avg_Order_Price`,
(SUM(Sale_Price)*0.5)+ (COUNT(Order_ID) *0.3) + (avg(Sale_Price)*0.2) as `Composite_Score`
from orders
group by Customer_ID
order by Composite_Score DESC
LIMIT 5; 

-- Calculate the month-over-month growth rate in total revenue across the entire dataset. (SQL)
with month_group as (
	select 
		left(Order_Date, 7) as "Month",
		SUM(Sale_Price) as "Total_revenue"
	from Orders
    group by left(Order_Date, 7)
),
prev_data as (
	select *,
    LAG(Total_revenue) over(order by Month) as Previous_month_revenue
    	from month_group
)

select *,
	round(((Total_revenue - Previous_month_revenue) * 100) / Previous_month_revenue, 2) as Growth_rate
from prev_data; 



-- Calculate the rolling 3-month average revenue for each product category. (SQL)
with category_data as
(
select Product_Category,
left(Order_Date,7) as "Month",
SUM(Sale_Price) as "Total_Revenue"
from Orders
group by Product_Category,left(Order_Date,7))
select *,
ROUND(AVG(Total_Revenue) over (Partition by Product_Category order by month
   rows between 2 PRECEDING and CURRENT ROW), 2) as Rolling_avg_3_month
   from category_data;


-- Update the orders table to apply a 15% discount on the `Sale Price` for orders placed by customers who have made at least 10 orders. (SQL)

with customer_list as(
SELECT Customer_ID from orders
group by Customer_ID
having count(*)>=10)
UPDATE orders
SET Sale_Price=Sale_Price*0.85
where Customer_ID in (select * from customer_list);

-- Calculate the average number of days between consecutive orders for customers who have placed at least five orders. (SQL)

with qualify as(
  select Customer_ID from Orders
  group by Customer_ID
  having count(*)>=5),
  Orders_data as
  (select Customer_ID,
  Order_Date,
  DATEDIFF(Order_Date,LAG(Order_Date) over(partition by Customer_ID order by Order_Date)) as day_diff
  from orders where Customer_ID in(select Customer_ID from qualify)),
  Average_data as( SELECT Customer_ID, AVG(day_diff) as avg_diff from orders_data group by Customer_ID)
  SELECT AVG(avg_diff) as avg_days_between_orders
  from Average_data;
  
  
  --  Identify customers who have generated revenue that is more than 30% higher than the average revenue per customer. (SQL)
  
with Customer_data as(
select Customer_ID,
SUM(Sale_Price) as Total_Revenue
from Orders
GROUP BY Customer_ID)
select * 
from Customer_data
where Total_Revenue>( select avg(Total_Revenue)*1.3 from Customer_data)
order by Total_Revenue desc;

  
 -- Determine the top 3 product categories that have shown the highest increase in sales over the past year compared to the previous year. (SQL)
with year_sales as
(select Product_Category,
YEAR(Order_Date) as Order_Year,
SUM(Sale_Price) as Total_Sales
from Orders
group by Product_Category ,YEAR(Order_Date)),
sales_growth as ( select *,
 LAG( Total_Sales) OVER (partition by Product_Category order by Order_Year) as Previous_Sales 
 from year_sales)
 select *,
 (Total_Sales-Previous_Sales) as Sales_Increases
 from sales_growth
 order by sales_increases desc
 limit 3;
 
 
  


