Use project1;
create table products(
	ProductID int,
    ProductName varchar(50),
    Category varchar(50),
    Price decimal(10,2)
    );
    SHOW VARIABLES LIKE 'secure_file_priv';


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Blinkit_Dataset_product.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from products limit 5;
create table orders (
OrderID int,
OrderDate varchar(50),
CustomerID int,
ProductID int,
Quantity int,
TotalAmount decimal(10,2) ) ;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Blinkit_Dataset_orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table customers (
customer_id int,
customer_name varchar(50),
email varchar(50),
phone varchar(50),
address varchar(100),
area varchar(50),
pincode int,
registration_date varchar(50),
customer_segment varchar(50),
total_orders int,
avg_order_value decimal(10,2) );

alter table customers 
modify phone varchar(50);
alter table customers 
modify address varchar(100);

drop table customers;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Blinkit_Dataset_customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table feedback (
feedback_id int,
order_id int,
customer_id int,
rating int,
feedback_text varchar (100),
feedback_category varchar (100),
sentiment varchar (100),
feedback_date varchar (100)
);

alter table feedback
modify order_id varchar(50);
load data infile 'C://ProgramData//MySQL//MySQL Server 8.0//Uploads//Blinkit_Dataset_feedback.csv' 
into table feedback 
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows ;

-- Data analysis & Findings
-- 1. Top N Products by Sales
 -- Write a query to find the top 5 products with the highest total sales (quantity × price). 
SELECT 
  p.productName,
  SUM(o.quantity * p.price) AS total_sales
FROM 
  products p
JOIN 
  orders o ON p.ProductID = o.ProductID
GROUP BY 
  p.productName
ORDER BY 
  total_sales DESC
LIMIT 5;

-- 2. Monthly Revenue Trend
-- Show the total revenue for each month over the last 6 months.
SELECT 
  DATE_FORMAT(o.orderdate, '%Y-%m') AS order_month,
  SUM(o.quantity * p.price) AS total_revenue
FROM 
  orders o
JOIN 
  products p ON o.ProductID = p.ProductID
WHERE 
  o.orderdate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
  order_month
ORDER BY 
  order_month DESC;
  
  -- 3. Category-wise Revenue
  -- Find the total revenue per product category. Include only categories with revenue > ₹10,000.
SELECT 
  p.category,
  SUM(o.quantity * p.price) AS total_sales
FROM 
  products p
JOIN 
  orders o ON p.ProductID = o.ProductID
GROUP BY 
  p.category
  Having total_sales > 10000
  order by total_sales Desc ;
  -- Customer with Most Orders
-- Find the customer ID with the highest number of orders and their total spending.
SELECT
    CustomerID,
    COUNT(OrderID)  AS num_orders,
    SUM(TotalAmount) AS total_spending
FROM orders
GROUP BY CustomerID
ORDER BY num_orders DESC        
LIMIT 1;                        

-- 5. Average Order Value
-- Calculate the average total amount per order. Round the result to 2 decimal places.
SELECT
    SUM(TotalAmount) AS total_revenue,
    COUNT(OrderID) AS total_orders,
   Round( SUM(TotalAmount) / COUNT(OrderID) , 2) AS Average_total 
    From orders;
    -- . Top Selling Product per Category 
    -- For each category, find the product with the highest total quantity sold.
    with sales as ( 
   SELECT
        p.Category,
        p.ProductName,
        SUM(o.Quantity) AS total_quantity
    FROM orders o
  join products p on
  p.productID = o.productID
    GROUP BY Category, ProductName
),
    ranked_products AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Category ORDER BY total_quantity DESC) AS rn
    FROM sales
)
SELECT Category, ProductName, total_quantity
FROM ranked_products
WHERE rn = 1;
   
-- 7. Orders Without Matching Products
-- Write a query to find orders that do not have a matching product in the product table 
-- (simulate data integrity check using LEFT JOIN).
SELECT o.*
FROM orders o
LEFT JOIN products p ON o.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- 8. Running Total of Revenue by Date
-- Show daily revenue and a running total of revenue ordered by date.
 with cte as ( 
 select
 orderdate, 
 Sum(Totalamount) as Daily_revenue
 From orders 
  Group by orderdate 
  )
   select 
   orderdate,
   Daily_revenue,
SUM(Daily_revenue) OVER (ORDER BY OrderDate) AS running_total From cte 
  order by orderdate;
  
  -- 9. Most Popular Day of the Week for Orders
-- Determine the day of the week (e.g., Monday, Tuesday…) with the most orders placed.

select dayname(orderdate) as Day_Week,count(*) as order_count from orders 
group by Day_week 
order by order_count Desc limit 1;

-- 10. % Contribution of Each Category to Total Revenue
-- Show each product category’s percentage contribution to the total revenue.
 with cte as (
 select p.category, sum(o.totalamount) as category_revenue  from orders o
 join products p on 
 p.productid = o.productid
 Group by p.category 
 ) 
select category , category_revenue ,
Round (100 * category_revenue / sum(category_revenue) , 2) as percentage_total_revenue
from cte 
order by percentage_total_revenue Desc;

--------------------------------------------------------------------------------------
-- Key SQL Tasks:
-- 1.	Total sales and number of orders by month
	select monthname(orderdate) as Sales_month,
    count(orderid) as Num_of_orders,
    sum(totalamount) as Total_sales 
	from orders
    group by Sales_month order by Sales_month ;
    
-- 2.	Top 5 best-selling products
		Select 
-- 3.	Revenue by product category
-- 4.	Identify repeat customers vs one-time buyers
-- 5.	Find the most frequently ordered products






  
  
   
    
    











  
  
  



  
 
 
 




