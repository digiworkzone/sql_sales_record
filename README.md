# Retail Sales Analysis SQL Project

**Project Title**: retail_project  
**Database**: `retail_project`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_project`.
- **Table Creation**: A table named `sales_record` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_project;

CREATE TABLE sales_record
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **number of total sales 
- **number of customer 

- **Number of categorie 
- **select distinct category from sales_record;

```sql

select count(*) as All_Sales from sales_record;
select count(distinct customer_id) as Number_Of_All_Customers from sales_record;
select count(distinct customer_id) as Number_Of_All_Customers from sales_record;

```

###    BUSINESS PROBLEMS (some errors had me confused! lol) the date format was wrong so i imorted the data again specified date-time formatfor the column 
###    Now had to trim the new date time column to show only date 

```sql
ALTER TABLE sales_record
MODIFY sale_date DATE;
```

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select count(quantity) as All_Clothing_sold_In_november2022
from sales_record
where category = "clothing" 
			AND
            year(sale_date) = '2022'
            and
            month(sale_date ) = '11'
            and 
            quantity >= 3;
```

3. **total sale and orders from each category  .**:
```sql
select  category, 
			sum(total_sale) as net_sale,
            count(*) as total_orders
from sales_record
group by 1;
```

4. **averae age of customer who purchase from Clothing category .**:
```sql
select  round(avg(age), 2) 
			from sales_record
where category = 'Clothing';
```

5. **Write a SQL query to find all transactions in male and female where the total_sale is greater than 1000.**:
```sql
select gender, sum(total_sale) as Total_sale_by_gender
			from sales_record
where total_sale > '1000'
group by 1;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select category, gender,
            count(*) as total_transaction
from sales_record
group by category, gender
order by 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
select 
			year, 
            month, 
            Avg_sale

 from 
(
select  year(sale_date) as year,
			month(sale_date) as month, 
            avg(total_sale) as Avg_sale,
            rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranks
from sales_record
group by 1, 2
) as t1
where ranks = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id, sum(total_sale) as total_sale
from sales_record
group by 1
order by 2 desc limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select 
			category,
			count(distinct(customer_id))
from sales_record
group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
DROP TEMPORARY TABLE IF EXISTS new_shift;
CREATE TEMPORARY TABLE Time_slot AS 
SELECT *,  
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shifts
FROM sales_record;
select  
		shifts as shift_of_day,
        count(*) total_orders
from time_slot
group by shifts;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

Business needs will ultimately determine what data segment is required to make the right decision.

## Enjoy
