use retail_project;

SELECT * FROM retail_project.sales_record;

-- rename table new_test to sales_record;

create table new_test 
		(
				transactions_id int primary key,
				sale_date DATE,
				sale_time	TIME,
                customer_id INT,
				gender	varchar(20),
                age	int,
				category	varchar(20),
				quantiy int,
				price_per_unit	float,
				cogs float,
				total_sale float
);

-- IMPORTED THE DATA FROM A EXTERNAL SOURCE IN A CSV FORMAT INTO THE TABLE  


select * from sales_record;

select count(*) from sales_record;


-- CLEANING THE DATA  

select * from sales_record
where 
			transactions_id IS NULL
            or
            sale_date IS NULL
            or 
            sale_time IS NULL
            or
            customer_id IS NULL
            or 
            gender IS NULL
            or 
            age IS NULL 
            or 
            category IS NULL 
            or 
            quantiy IS NULL 
            or 
            price_per_unit IS NULL
            or 
            cogs IS NULL
            or 
            total_sale IS NULL;
            
            

delete from sales_record 
where 
			transactions_id IS NULL
            or
            sale_date IS NULL
            or 
            sale_time IS NULL
            or
            customer_id IS NULL
            or 
            gender IS NULL
            or 
            age IS NULL 
            or 
            category IS NULL 
            or 
            quantiy IS NULL 
            or 
            price_per_unit IS NULL
            or 
            cogs IS NULL
            or 
            total_sale IS NULL;
            
	-- DATA EXPLORATION 
    -- number of total sales 
    select count(*) as All_Sales from sales_record;
	--  number of customer 
    select count(distinct customer_id) as Number_Of_All_Customers from sales_record;
    -- Number of categorie 
	select distinct category from sales_record;
   
   
   -- 	BUSINESS PROBLEMS (some errors had be confused! lol)
   -- Select sale from a particular day  
   select * from sales_record
   where sale_date = '2022-11-05';
   
   -- tried trim it didnt work  
 --   select * from new_test;
--    SELECT trim("00.00.00") AS trimmed_date FROM sales_record;
--    select * from sales_record;

-- Finally figured out how to format the column to show only date and not date and time.  
ALTER TABLE sales_record
MODIFY sale_date DATE;


   select * from sales_record;

-- Had to drop the my initial table as there were errors in date format 
drop table sales_rec;


select * from sales_record;

-- fixed an error in the column name  
alter table sales_record rename column quantiy to quantity;


-- select all sales made in november 2022 
select count(quantity) as All_Clothing_sold_In_november2022
from sales_record
where category = "clothing" 
			AND
            year(sale_date) = '2022'
            and
            month(sale_date ) = '11'
            and 
            quantity >= 3;


-- total sale and orders from each category  
select  category, 
			sum(total_sale) as net_sale,
            count(*) as total_orders
from sales_record
group by 1;


--  averae age of customer who purchase from Beauty 
select  round(avg(age), 2) 
			from sales_record
where category = 'Clothing';


-- all transaction where total sale is greater than 1000 seperated by gender 
select gender, sum(total_sale) as Total_sale_by_gender
			from sales_record
where total_sale > '1000'
group by 1;


--  total number of transaction made by each category and gender 
select category, gender,
            count(*) as total_transaction
from sales_record
group by category, gender
order by 1;

-- average month with the highest sale each year 
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
		

-- top 5 customers based on total sale 
select customer_id, sum(total_sale) as total_sale
from sales_record
group by 1
order by 2 desc limit 5;


-- unique customers who purchased from each category 
select 
			category,
			count(distinct(customer_id))
from sales_record
group by category;


-- Each shift and their total orders. Tried to use cte but it was giving me a hard time so i used temp table
				-- with new_shift 
				-- as 
				-- (
				-- select * ,  
				-- 			case 
				-- 					when hour(sale_time) < 12 Then 'Morning'
				--                     when hour(sale_time)  between 12 and  17 Then 'Afternoon'
				--                     Else 'Evening'
				-- 			End as shifts
				-- from sales_record;
				-- ); 

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

 







