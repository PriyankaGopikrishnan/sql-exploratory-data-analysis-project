/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


--Which 5 Products generate the highest revenue
use Datawarehouse;

--Using Top keyword
-- Simple Ranking
select top 5
	dp.product_name,
	sum(fs.sales) as total_revenue 
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name
order by total_revenue desc

-- Complex but Flexibly Ranking Using Window Functions
select * from (
select 	
	dp.product_name,
	sum(fs.sales) as total_revenue,
	ROW_NUMBER() OVER(ORDER BY sum(fs.sales) desc) as rank_number
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name) t where rank_number < 6;

--What are the 5 worst-performing products in terms of sales?

select top 5
	dp.product_name,
	sum(fs.sales) as total_revenue 
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name
order by total_revenue asc

--Find the top 10 customers who have generated the highest revenue

select top 10
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	sum(fs.sales) as total_revenue
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by 
	dc.customer_key,
	dc.first_name,
	dc.last_name
order by total_revenue desc


--The 3 customers with the fewest orders placed.

select top 3
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	COUNT( distinct order_number) as total_orders
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by 
	dc.customer_key,
	dc.first_name,
	dc.last_name
order by total_orders 
