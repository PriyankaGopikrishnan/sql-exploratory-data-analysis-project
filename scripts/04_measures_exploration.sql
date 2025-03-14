/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

--Find the total number of sales
select sum(sales) as total_sales from gold.fact_sales

--Find how many items are sold
select sum(quantity)as total_quantity from gold.fact_sales

--Find average selling price
select avg(price) as avg_price from gold.fact_sales

--Find the total number of products
select COUNT(product_key) as total_products from gold.dim_products
select COUNT(distinct product_key) as total_products from gold.dim_products

--Find the total number of orders
select COUNT(order_number) as total_orders from gold.fact_sales
select COUNT(distinct order_number) as total_orders from gold.fact_sales

--Find the total number of customers
select count(customer_key) as total_customers from gold.dim_customers

--Find the total number of customers that has placed an order

select count(customer_key) as total_customers from gold.fact_sales
select count(distinct customer_key) as total_customers from gold.fact_sales



--Generate a report that shows all key metrics of the business

select 'Total Sales' as measure_name,sum(sales) as measure_value from gold.fact_sales
UNION ALL
select 'Total Quantity' ,sum(quantity) from gold.fact_sales
UNION ALL
select 'Average Price',avg(price) from gold.fact_sales
UNION ALL
select 'Total Nr.of Orders',COUNT(distinct order_number) from gold.fact_sales
UNION ALL
select 'Total Nr.of Products',COUNT(distinct product_key) from gold.dim_products
UNION ALL
select 'Total Nr.of Customers',count(customer_key) from gold.dim_customers
