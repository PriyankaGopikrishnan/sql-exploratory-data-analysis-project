/*
===============================================================================
							Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
use Datawarehouse
-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country,gender,martial_status
FROM gold.dim_customers
ORDER BY country,gender,martial_status;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    sub_category, 
    product_name 
FROM gold.dim_products
ORDER BY category, sub_category, product_name;


