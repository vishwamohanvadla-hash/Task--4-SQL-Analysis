# Task--4-SQL-Analysis
This project uses the Superstore dataset to practice and demonstrate SQL for data analysis. The dataset contains sales, profit, customer, and regional data for a fictional retail company. Using SQL queries, we explore business insights such as top-performing categories, sales trends, and regional performance.
# 🛒 Superstore Dataset - SQL for Data Analysis

## 📌 Overview
This project demonstrates how to use *SQL* for data analysis with the popular *Superstore dataset*.  
The dataset contains details about sales, profits, customers, shipping, and regions for a fictional retail store.  
By writing SQL queries, we uncover valuable business insights and answer analytical questions.  

---

## 📂 Dataset
The Superstore dataset includes the following key columns:
- *Order Details:* Order ID, Order Date, Ship Date, Ship Mode  
- *Customer Details:* Customer ID, Customer Name, Segment  
- *Geography:* Country, Region, State, City  
- *Product Details:* Category, Sub-Category, Product Name  
- *Sales Performance:* Sales, Quantity, Discount, Profit  

---

## 🛠 SQL Tasks & Queries
Here are some example analysis tasks performed using SQL:
1. Find the total sales and profit by region.  
2. Identify the top 10 customers by total sales.  
3. Calculate monthly sales trends over time.  
4. Find the most profitable product categories.  
5. Determine the average discount given per category.  
6. Identify the least profitable sub-categories.  
7. Compare sales performance between customer segments.  
8. Find the top 5 states by profit margin.  

---

## ⚙ Tools & Technologies
- *SQL* (MySQL / PostgreSQL / SQLite – depending on your setup)  
- Dataset: Superstore (CSV/Excel format)  

---

## 🚀 How to Use
1. Import the Superstore dataset into your SQL database.  
   - Example (MySQL):
     sql
     LOAD DATA INFILE 'superstore.csv'
     INTO TABLE superstore
     FIELDS TERMINATED BY ','
     IGNORE 1 ROWS;
     
2. Run the SQL queries provided in the scripts folder (queries.sql).  
3. Modify queries as needed to explore additional insights.  

---

## 📊 Example Query
```sql
-- Find total sales and profit by region
SELECT 
    Region, 
    ROUND(SUM(Sales),2) AS Total_Sales, 
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Profit DESC;
