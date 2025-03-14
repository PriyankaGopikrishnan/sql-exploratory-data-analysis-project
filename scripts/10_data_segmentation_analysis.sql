 /*
 
--Data Segmentation Analysis
	Purpose:
	- Group the data based on a specific range.
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.
	- Formula: [Measure] by [Measure]

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
Task 6:Segment products into cost range and count how many products falls into each segment 

*/
with product_segment as (
select
	product_key,
	product_name,
	product_cost,
	case when product_cost < 100 then 'Below 100'
		 when product_cost between 100 and 500 then '100-500'
		 when product_cost between 500 and 1000 then '500-1000'
		 else 'Above 1000'
	end as cost_range
from gold.dim_products )

select 
cost_range,
COUNT(product_key) as total_product
from product_segment
group by cost_range
order by total_product desc


----------------------------------------------------------------------------------------------


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than �5,000.
	- Regular: Customers with at least 12 months of history but spending �5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

with customer_spending as(
select 
	c.customer_key,
	sum(f.sales) as total_spending,
	MIN(f.order_date) as first_order,
	MAX(f.order_date) as last_order,
	DATEDIFF(month,MIN(f.order_date),MAX(f.order_date)) as life_span
from gold.fact_sales F
left join gold.dim_customers C
on F.customer_key = C.customer_key
group by c.customer_key )



select	
	customer_segment,
	COUNT(customer_key) as total_customers
from (
select 
	customer_key,
	total_spending,
	life_span,
	CASE WHEN life_span >= 12 and total_spending > 5000 then 'VIP'
	     WHEN life_span >= 12 and total_spending <  5000 then 'REGULAR'
	     ELSE 'NEW'
    END as customer_segment
from customer_spending
) t 
group by customer_segment 
order by total_customers desc
