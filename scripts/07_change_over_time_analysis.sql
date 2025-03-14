
/* 
===============================================================================
						change over time analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.
	- Formula: Sum(Measure) by [date dimension]
SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
	
	- Task 1 : Analyze Sales performance over time.
*/ 
 
select 
	year(order_date) as Order_year,  --Year wise data 
	sum(sales)  as Total_sales
from gold.fact_sales
where order_date is not null
group by year(order_date)
order by sum(sales)  --sorted based on the sum(sales)

select 
	YEAR(order_date) as Order_year,  --Year wise date
	month(order_date) as Order_month, --Month wise data 
	sum(sales) as Total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
from gold.fact_sales
where order_date is not null
group by YEAR(order_date),month(order_date)
order by YEAR(order_date),month(order_date) --Sorted based on year and month wise


use Datawarehouse
-- FORMAT()
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
