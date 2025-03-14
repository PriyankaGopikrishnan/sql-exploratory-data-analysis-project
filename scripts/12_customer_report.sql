/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

IF OBJECT_ID('gold_report_customers','V') IS NOT NULL
	DROP VIEW  gold_report_customers;
GO
CREATE VIEW gold_report_customers as
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/

With base_query as(
select 
	f.order_date,
	f.order_number,
	f.product_key,
	f.sales,
	f.quantity,
	f.price,
	c.customer_key,
	c.customer_number,
	c.first_name,
	CONCAT(c.first_name,' ',c.last_name) as customer_name,
	DATEDIFF(YEAR,c.birthdate,getdate()) as age
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
where order_date is not null)

, customer_aggregation as (
/*---------------------------------------------------------------------------
2)Customer Aggregations: Summarizes key metrics at customer level
---------------------------------------------------------------------------*/
select
customer_key,
customer_number,
customer_name,
age,
COUNT(distinct order_date) as total_orders,
sum(sales) as total_sales,
sum(quantity) as total_quantity,
COUNT(distinct product_key) as total_products,
min(order_date) as first_order_date,
max(order_date) as last_order_date,
DATEDIFF(month,min(order_date),max(order_date)) as life_span
from base_query
group by 
customer_key,
customer_number,
customer_name,
age )

/*---------------------------------------------------------------------------
  3) Final Query: Combines all customer results into one output
---------------------------------------------------------------------------*/

select 
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 then'Under 20'
		 WHEN age between 20 and 29 then '20-29'
		 WHEN age between 30 and 39 then '30-39'
		 WHEN age between 40 and 49 then '40-49'
		 ELSE 'Above 50'
	END as age_group,
	CASE WHEN life_span >= 12 and total_sales > 5000 then 'VIP'
	     WHEN life_span >= 12 and total_sales <  5000 then 'REGULAR'
	     ELSE 'NEW'
    END as customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	first_order_date,
	last_order_date,
	DATEDIFF(month,last_order_date,getdate()) as recency, --- difference between the last order date and current date by months
	--Average Order Value(AVO = total_sales/total_nr_of_orders )
	CASE WHEN total_orders = 0 then 0
		 ELSE total_sales/ total_orders 
	END as avg_order_value ,
	--Average monthly spend(total_sales/Nr. of months)
	CASE WHEN life_span = 0 then 0
		 ELSE total_sales/ life_span 
	END as avg_monthly_spend 
from customer_aggregation
