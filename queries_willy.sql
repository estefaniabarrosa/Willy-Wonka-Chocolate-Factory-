/* Total Revenue */
SELECT 
    SUM(sales) AS total_revenue
FROM order_details;

/* Total Profit */
SELECT 
    SUM(gross_profit) AS total_profit
FROM order_details;

/* Average*/
SELECT
    AVG(sales) AS avg_sales,
    MAX(sales) AS max_sales,
    MIN(sales) AS min_sales,
    STDDEV(sales) AS std_sales
FROM order_details;

SELECT
    p.product_name,
    SUM(od.sales) AS total_sales

/*Top Selling Products using JOIN,GROUP bY,ORDER BY*/


FROM order_details od
JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

/*Most PROFITABLE PRODUCT*/
SELECT
    p.product_name,
    SUM(od.gross_profit) AS total_profit
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;

/*Revenue by Regions using Multiple JOINs*/
SELECT
    l.region,
    SUM(od.sales) AS regional_sales
FROM order_details od
JOIN orders o
ON od.order_id = o.order_id
JOIN locations l
ON o.location_id = l.location_id
GROUP BY l.region
ORDER BY regional_sales DESC;

/*Factory Performance*/
SELECT
    f.factory_name,
    SUM(od.sales) AS total_sales,
    SUM(od.gross_profit) AS total_profit
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
JOIN factories f
ON p.factory_id = f.factory_id
GROUP BY f.factory_name
ORDER BY total_profit DESC;

/*Categorize products by profitability by using Case Statement*/

SELECT
    p.product_name,
    SUM(od.gross_profit) AS total_profit,

    CASE
        WHEN SUM(od.gross_profit) > 5000 THEN 'High Profit'
        WHEN SUM(od.gross_profit) > 2000 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS profit_category

FROM order_details od
JOIN products p
ON od.product_id = p.product_id

GROUP BY p.product_name
ORDER BY total_profit DESC;

/*Most Expensive Product*/
SELECT
    product_name,
    unit_cost
FROM products
ORDER BY unit_cost DESC
LIMIT 10;

/*Average Profit By Division*/
SELECT
    p.division,
    AVG(od.gross_profit) AS avg_profit
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
GROUP BY p.division
ORDER BY avg_profit DESC;

/*Products with sales above average using Subqueries*/


SELECT
    p.product_name,
    SUM(od.sales) AS total_sales
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_name
HAVING total_sales > (
    SELECT AVG(sales)
    FROM order_details
);

/*Shipping Analysis*/
SELECT
    ship_mode,
    COUNT(*) AS total_orders
FROM orders
GROUP BY ship_mode
ORDER BY total_orders DESC;