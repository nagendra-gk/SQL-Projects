# 🛒 Zepto Inventory Data Insights.
> 🧑‍💻 Beginner-level SQL project to practice data cleaning and analysis using real-world data.

## 🎯 Project Objective
This project shows how I used SQL to explore and clean Zepto’s inventory data.  
I analyzed the data to understand product prices, stock levels, and discounts, and to find useful patterns that can help in decision-making.


---

## 📘 Project Overview
This project explores and analyzes a sample **Zepto inventory dataset** using SQL.  
It includes **data exploration, cleaning, and analytical insights** to understand product pricing, stock levels, and category performance.

---

## 🧱 Database Creation

```sql
CREATE DATABASE zepto_sql_P2;

USE zepto_sql_P2;
```
👉 Creates a new database named `zepto_sql_P2` and selects it for analysis.

---

## 🧾 Data Import Note

I initially tried importing the dataset using the following SQL command:

```sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/zepto_Inventory.csv'
INTO TABLE _zepto_inventory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ID, Category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock, quantity);
```

However, the import failed due to **data formatting issues** (extra commas and mismatched columns).  
So, I imported the CSV file **manually using MySQL Workbench Import Wizard** to ensure correct data alignment.  

I kept the above query in the project to show that I attempted the SQL import method as part of the process.

---


## 🔍 Data Exploration

### 1️⃣ Total Records in Dataset
```sql
SELECT COUNT(*)
FROM _zepto_inventory;
```
👉 Counts the total number of rows (products) in the dataset.

---

### 2️⃣ View All Data
```sql
SELECT * 
FROM _zepto_inventory;
```
👉 Displays the complete dataset to understand its structure and available columns.

---

## 🚨 Null Values Check
```sql
SELECT COUNT(*) AS null_records 
FROM _zepto_inventory
WHERE id IS NULL
OR Category IS NULL
OR name IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR availableQuantity IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR outOfStock IS NULL
OR quantity IS NULL;
```
👉 Checks for missing or null values in any of the important columns.

---

## 🏷️ Distinct Product Categories
```sql
SELECT DISTINCT(Category) AS Category
FROM _zepto_inventory
ORDER BY Category ASC;
```
👉 Lists all unique product categories in the dataset in alphabetical order.

---

## 📦 Stock Availability Analysis
```sql
SELECT outOfStock, COUNT(outOfStock) AS stock_count
FROM _zepto_inventory
GROUP BY outOfStock;
```
👉 Shows how many products are **in stock** vs **out of stock**.

---

## 🧹 Data Cleaning

### 1️⃣ Identify invalid price records
```sql
SELECT * 
FROM _zepto_inventory
WHERE mrp = 0
OR discountedSellingPrice = 0;
```
👉 Finds all records with missing or invalid price values (zero).

---

### 2️⃣ Remove invalid price records
```sql
DELETE FROM _zepto_inventory
WHERE mrp = 0
OR discountedSellingPrice = 0;
```
👉 Deletes rows that contain invalid price data to maintain accuracy.

---

### 3️⃣ Disable safe updates for data cleaning
```sql
SET SQL_SAFE_UPDATES = 0;
```
👉 Allows updates or deletions without using a primary key condition.

---

### 4️⃣ Convert Paise to Rupees
```sql
UPDATE _zepto_inventory
SET mrp = mrp/100.0,
    discountedSellingPrice = discountedSellingPrice/100.0;
```
👉 Converts price values from **paise to rupees** for proper currency format.

---

## 📊 Data Analysis

### Q1️⃣: Find the Top 10 Best-Value Products Based on Discount Percentage
```sql
SELECT DISTINCT name, mrp, discountPercent
FROM _zepto_inventory
ORDER BY discountPercent DESC
LIMIT 10;
```
👉 Displays the 10 products offering the highest discount percentages.

---

### Q2️⃣: What Are the Products with High MRP but Out of Stock?
```sql
SELECT DISTINCT name, mrp
FROM _zepto_inventory
WHERE outOfStock = 'TRUE' AND mrp > 300
ORDER BY mrp DESC;
```
👉 Identifies expensive products (MRP > ₹300) that are currently unavailable.

---

### Q3️⃣: Calculate Estimated Revenue for Each Category
```sql
SELECT Category, SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM _zepto_inventory
GROUP BY Category
ORDER BY total_revenue DESC;
```
👉 Calculates the potential revenue for each product category.

---

### Q4️⃣: Find Products Where MRP > ₹500 and Discount < 10%
```sql
SELECT DISTINCT name, mrp, discountPercent
FROM _zepto_inventory
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;
```
👉 Finds premium products that offer minimal discounts.

---

### Q5️⃣: Identify the Top 5 Categories Offering the Highest Average Discount Percentage
```sql
SELECT Category,
AVG(discountPercent) AS avg_dis
FROM _zepto_inventory
GROUP BY Category
ORDER BY avg_dis DESC
LIMIT 5;
```
👉 Finds which categories provide the highest average discounts.

---

### Q6️⃣: Find Price Per Gram for Products Above 100g and Sort by Best Value
```sql
SELECT DISTINCT name, weightInGms, discountedSellingPrice, 
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM _zepto_inventory
WHERE weightInGms >= 100
ORDER BY price_per_gram;
```
👉 Calculates cost efficiency by showing the **price per gram** for larger products.

---

### Q7️⃣: Group Products into Weight Categories — Low, Medium, Bulk
```sql
SELECT DISTINCT name, weightInGms,
CASE 
    WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
END AS whight_category
FROM _zepto_inventory;
```
👉 Categorizes products into groups based on their weight (Low, Medium, Bulk).

---

### Q8️⃣: Calculate Total Inventory Weight Per Category
```sql
SELECT category, SUM(weightInGms * availableQuantity) AS total_whight
FROM _zepto_inventory
GROUP BY category
ORDER BY total_whight DESC;
```
👉 Calculates the total stock weight available for each product category.

---

## 📈 Project Summary

| Step | Objective | SQL Concept Used |
|------|------------|------------------|
| Database Setup | Created and used new database | `CREATE DATABASE`, `USE` |
| Data Exploration | Checked records and structure | `SELECT`, `COUNT`, `DISTINCT` |
| Data Cleaning | Removed invalid values | `DELETE`, `UPDATE`, `CASE` |
| Analysis | Derived insights | `GROUP BY`, `ORDER BY`, `AVG`, `SUM`, `CASE` |

---

## 🧰 Tools Used
- **MySQL Workbench** – for data import and SQL execution  
- **CSV Dataset (Zepto Inventory)** – source data file  
- **Excel** – for basic data review and formatting  

---

## 🧠 Key Insights
- Identified **top discounted products** and **high MRP out-of-stock items**.  
- Calculated **revenue by category** to determine business contribution.  
- Segmented products by **weight category** for better logistics decisions.  
- Computed **price per gram** to find best-value products for customers.

---

## 💼 Skills Highlighted
- SQL Query Writing  
- Data Cleaning and Transformation  
- Aggregate Functions & Case Statements  
- Real-World Data Analysis Workflow

---


