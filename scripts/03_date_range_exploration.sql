use Datawarehouse;

/*
===============================================================================
					Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the youngest and oldest customer based on birthdate

select max(birthdate) as max_date,
	min(birthdate) as min_date,
	datediff(YEAR,min(birthdate),GETDATE()) as oldest_age,
	datediff(YEAR,max(birthdate),GETDATE()) as youngest_age
	from gold.dim_customers
	
-- Determine the first and last order date and the total duration in months

select MIN(order_date) as first_order_date,
MAX(order_date) as last_order_date,
datediff(year,MIN(order_date),MAX(order_date))  as order_range_years,
datediff(MONTH,MIN(order_date),MAX(order_date))  as order_range_months
from gold.fact_sales
