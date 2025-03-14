/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.
	- Formula : current(Measure) - Target[Measure]

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
*/ 

use Datawarehouse
/*Task 4 : Analyze the yearly performance of products by comparing each product's sales to both
 its average sales performance and the previous year's sales. */

 With yearly_product_sales as(
 select 
 YEAR(f.order_date) as order_year,
 p.product_name as product_name,
 sum(f.sales) as current_sales
 from gold.fact_sales f
 left join gold.dim_products p
 on f.product_key = p.product_key
 where order_date is not null
 group by YEAR(f.order_date), p.product_name )
 
 select 
 order_year,
 product_name,
 current_sales,
 avg(current_sales) over( Partition by Product_name) avg_sales,
 current_sales - avg(current_sales) over( Partition by Product_name) as diff_avg,
 Case when current_sales - avg(current_sales) over( Partition by Product_name)  > 0 then 'Above Avg'
	  when current_sales - avg(current_sales) over( Partition by Product_name)  < 0 then 'Below Avg'
	  Else 'Avg'
 End as avg_change,
 Lag(current_sales) over ( Partition by Product_name order by order_year) as py,
 current_sales -  Lag(current_sales) over ( Partition by Product_name order by order_year) as diff_py,
 Case when  current_sales -  Lag(current_sales) over ( Partition by Product_name order by order_year)  > 0 then 'Increase'
	  when  current_sales -  Lag(current_sales) over ( Partition by Product_name order by order_year)  < 0 then 'Decrease'
	  Else 'No Change'
 End as py_change
 from yearly_product_sales
 order by product_name,order_year
