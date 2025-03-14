/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products as
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_query as(
select 
	p.product_id,
	p.product_name,
	p.category,
	p.sub_category,
	p.product_cost,
	f.sales,
	f.order_date,
	f.customer_key,
	f.quantity
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
where order_date is not null) --Only consider valid dates
/*---------------------------------------------------------------------------
2)Product Aggregations: Summarizes key metrics at Product level
---------------------------------------------------------------------------*/
, product_aggregation as (
select 
	product_id,
	product_name,
	category,
	sub_category,
	product_cost,
	sum(sales) as total_sales,
	count(distinct order_date) as total_orders,
	count(distinct customer_key) as total_customers,
	sum(quantity) as total_quantity,
	min(order_date) as first_sale_date,
	max(order_date) as last_sale_date,
	DATEDIFF(month,min(order_date),max(order_date)) as life_span,
	--Average selling price(sales/quantity)
	round(Avg(cast(sales as float)/nullif(quantity,0)),2) as avg_selling_price
from base_query
group by 
	product_id,
	product_name,
	category,
	sub_category,
	product_cost )

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
select 
	product_id,
	product_name,
	category,
	sub_category,
	product_cost,
	total_sales,
	total_orders,
	total_customers,
	total_quantity,
	first_sale_date,
	last_sale_date,
	DATEDIFF(month,last_sale_date,getdate()) as recency,
	CASE WHEN  total_sales > 50000 then 'High Performer'
	     WHEN  total_sales >= 10000 then 'Mid-Range Performer'
	     ELSE 'Low-Performer'
    END as product_segment,
	life_span,
	avg_selling_price,
	--Average Order revenue(AOR = total_sales/total_nr_of_orders )
	CASE WHEN total_orders = 0 then 0
		 ELSE total_sales/ total_orders 
	END as avg_order_revenue ,
	--Average monthly revenue(total_sales/Nr. of months)
	CASE WHEN life_span = 0 then 0
		 ELSE total_sales/ life_span 
	END as avg_monthly_revenue 
from product_aggregation
	
