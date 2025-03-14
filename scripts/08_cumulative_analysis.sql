/*
===============================================================================
								Cumulative Analysis
===============================================================================

	Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.
	- Formula: (Aggregated Measure) by [Date Dimension]

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
*/

--Granularity : Month wise
--- Task 2: Calculate the total sales per month and the running total of sales over time
select 
	Order_date,
	Total_sales,
	sum(Total_sales) over(Partition by year(order_date) order by order_date) as running_total
from (
select 
	Datetrunc(month,order_date) as order_date,
	sum(sales) as Total_sales
from gold.fact_sales
where order_date is not null
group by Datetrunc(month,order_date)
) t

--Granularity : Year wise
--- Task 3: Calculate the total sales per month and the running total of sales and moving average price over time
select 
	Order_date,
	Total_sales,
	sum(Total_sales) over(order by order_date) as running_total,
	avg(Avg_price) over(order by order_date) as moving_avg
from (
select 
	Datetrunc(YEAR,order_date) as order_date,
	sum(sales) as Total_sales,
	avg(price) as Avg_price
from gold.fact_sales
where order_date is not null
group by Datetrunc(YEAR,order_date)
) t
