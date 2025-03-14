
/*
===============================================================================
						Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.
	- Formula : ([Measure]/Total [Measure])* 100 by [Dimension]

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
--Formula: 
-- Task 5: Which categories contribute the most to overall sales and find the quantity of each categories and its percent_sold

With Category_sales as (
select 
category,
SUM(sales) as total_sales,
sum(quantity) as total_quantity
from gold.fact_sales F
left join gold.dim_products P 
on P.product_key = F.product_key
group by P.category )

select 
	category,
	total_sales,
	total_quantity,
	sum(total_sales) over () as overall_sales,
	sum(total_quantity) over () as overall_quantity,
	sum(total_quantity) over () as overall_quantity,
	concat(round((cast (total_sales as float)/sum(total_sales) over ()) *100,2),'%') as percent_of_totalsales,
	concat(round((cast (total_quantity as float)/sum(total_quantity) over ()) *100,2),'%') as percent_of_sold
from Category_sales
order by percent_of_totalsales desc

 ---------------------------------------------------------------------------------------------




