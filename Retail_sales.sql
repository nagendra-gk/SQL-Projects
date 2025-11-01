-- MySQL Retail Sales analyze Project --
CREATE DATABASE sql_project_1;

-- Create Table --
CREATE TABLE RETAIL_SALES
      (
           transactions_id INT PRIMARY KEY,
           sale_date DATE,	
           sale_time TIME,	
           customer_id INT,
           gender VARCHAR(30),	
           age	INT,
           category	VARCHAR(30),
           quantiy INT,
           price_per_unit FLOAT,	
           cogs	FLOAT,
           total_sale FLOAT
       ); 

SELECT * FROM retail_sales
limit 100;

select count(*)
from retail_sales;

-- Data Cleaning --
SELECT * 
FROM retail_sales
WHERE  
     quantiy is null
     OR
     price_per_unit is null
     OR
     cogs is null
     OR
     total_sale is null;
     
DELETE FROM retail_sales
WHERE
      quantiy is null
     OR
     price_per_unit is null
     OR
     cogs is null
     OR
     total_sale is null;
     
SET SQL_SAFE_UPDATES = 0;

-- Data Exploration --

-- How many Sales we have? --
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How many Unique customers we have? --
SELECT COUNT(DISTINCT(customer_id)) as total_customers FROM retail_sales;       

-- category --
SELECT DISTINCT category from retail_sales;

-- Data Analysis & Business Key Problems & Answers --
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	DATE_FORMAT(sale_date,'%b-%Y') = 'Nov-2022'
    AND
    quantiy >= 4;
    

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
       SUM(total_sale) as sales_by_category
FROM retail_sales
GROUP BY 1; -- the first column in the select lis


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
ROUND(AVG(age),2)
FROM retail_sales
WHERE
category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,
       gender,
       COUNT(transactions_id)
FROM retail_sales
GROUP BY category,
       gender
ORDER BY 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
     year,
     month,
     avg_sale
FROM (
  SELECT
        YEAR(sale_date) as year,
        MONTH(sale_date) as month,
        ROUND(AVG(total_sale),2) as avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) as rnk
        FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
 ) as sales_rank
WHERE rnk = 1;

      
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id,
       SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY sales_by_customer DESC
LIMIT 5;    
       

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
       COUNT(DISTINCT(customer_id)) as unique_cost
FROM retail_sales
GROUP BY category;       


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH sales_by_shift 
AS
  (
   SELECT *,
      CASE
          WHEN HOUR(sale_time) < 12 THEN 'Morning'
          WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
          ELSE 'Evening'
      END as shift
   FROM retail_sales 
   )
SELECT shift,
       count(*)
FROM sales_by_shift
GROUP BY shift;

 -- --