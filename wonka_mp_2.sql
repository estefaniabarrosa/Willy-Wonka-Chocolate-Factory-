SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

-- ============================================================
-- SQL Queries & Business Analysis
-- Project: Willy Wonka Chocolate Factory
-- Goal: Generate business insights using SQL queries
-- ============================================================

USE wonka_choc_factory;

-- ============================================================
-- 1. Database Integrity Check
-- Purpose: Confirm that all normalized tables were loaded correctly.
-- ============================================================

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_locations
FROM locations;

SELECT COUNT(*) AS total_factories
FROM factories;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_order_details
FROM order_details;


-- ============================================================
-- 2. Full Relational Join Validation
-- Purpose: Validate that all foreign key relationships work correctly.
-- ============================================================

SELECT
    od.order_detail_id,
    o.order_id,
    c.customer_id,
    p.product_name,
    l.region,
    l.city,
    f.factory_name,
    od.sales,
    od.units,
    od.gross_profit
FROM order_details od
JOIN orders o
    ON od.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON od.product_id = p.product_id
JOIN locations l
    ON o.location_id = l.location_id
JOIN factories f
    ON p.factory_id = f.factory_id
LIMIT 10;


-- ============================================================
-- 3. Overall Business KPIs
-- Purpose: Summarize total revenue, total profit, total units sold,
-- average sale value, and average profit per transaction.
-- ============================================================

SELECT
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(gross_profit), 2) AS total_gross_profit,
    SUM(units) AS total_units_sold,
    ROUND(AVG(sales), 2) AS average_sale_value,
    ROUND(AVG(gross_profit), 2) AS average_profit_per_transaction
FROM order_details;


-- ============================================================
-- 4. Statistical Sales Summary
-- Purpose: Use SQL functions to calculate mean, max, min, and
-- standard deviation for sales and gross profit.
-- ============================================================

SELECT
    ROUND(AVG(sales), 2) AS mean_sales,
    ROUND(MAX(sales), 2) AS max_sales,
    ROUND(MIN(sales), 2) AS min_sales,
    ROUND(STDDEV(sales), 2) AS sales_std_dev,
    ROUND(AVG(gross_profit), 2) AS mean_gross_profit,
    ROUND(MAX(gross_profit), 2) AS max_gross_profit,
    ROUND(MIN(gross_profit), 2) AS min_gross_profit,
    ROUND(STDDEV(gross_profit), 2) AS gross_profit_std_dev
FROM order_details;


-- ============================================================
-- 5. Top Revenue Products
-- Research Question:
-- Which chocolate products generate the highest revenue and profit?
-- ============================================================

SELECT
    p.product_name,
    ROUND(SUM(od.sales), 2) AS total_sales,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    SUM(od.units) AS total_units_sold
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 6. Product Profit Margin Analysis
-- Purpose: Identify which products generate the strongest profit
-- compared to their revenue.
-- ============================================================

SELECT
    p.product_name,
    ROUND(SUM(od.sales), 2) AS total_sales,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    ROUND((SUM(od.gross_profit) / SUM(od.sales)) * 100, 2) AS profit_margin_percentage
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin_percentage DESC;


-- ============================================================
-- 7. Product Profitability Category using CASE
-- Purpose: Classify products as High, Medium, or Low Profit.
-- This satisfies the requirement to use CASE logic.
-- ============================================================

SELECT
    p.product_name,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    CASE
        WHEN SUM(od.gross_profit) >= 15000 THEN 'High Profit'
        WHEN SUM(od.gross_profit) BETWEEN 8000 AND 14999 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS profitability_category
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;


-- ============================================================
-- 8. Regional Sales Performance
-- Research Question:
-- Which regions contribute most to overall sales performance?
-- ============================================================

SELECT
    l.region,
    ROUND(SUM(od.sales), 2) AS total_sales,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    SUM(od.units) AS total_units_sold
FROM order_details od
JOIN orders o
    ON od.order_id = o.order_id
JOIN locations l
    ON o.location_id = l.location_id
GROUP BY l.region
ORDER BY total_sales DESC;


-- ============================================================
-- 9. City-Level Sales Performance
-- Purpose: Identify top-performing cities for market opportunities.
-- ============================================================

SELECT
    l.city,
    l.region,
    ROUND(SUM(od.sales), 2) AS total_sales,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    SUM(od.units) AS total_units_sold
FROM order_details od
JOIN orders o
    ON od.order_id = o.order_id
JOIN locations l
    ON o.location_id = l.location_id
GROUP BY l.city, l.region
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 10. Factory Profitability Analysis
-- Research Question:
-- Are some factories significantly less profitable than others?
-- ============================================================

SELECT
    f.factory_name,
    ROUND(SUM(od.sales), 2) AS total_sales,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    SUM(od.units) AS total_units_sold,
    ROUND(AVG(od.gross_profit), 2) AS avg_profit_per_transaction
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
JOIN factories f
    ON p.factory_id = f.factory_id
GROUP BY f.factory_name
ORDER BY total_profit DESC;


-- ============================================================
-- 11. Factory Efficiency Category using CASE
-- Purpose: Categorize factories based on profitability performance.
-- ============================================================

SELECT
    f.factory_name,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    CASE
        WHEN SUM(od.gross_profit) >= 30000 THEN 'High Performing Factory'
        WHEN SUM(od.gross_profit) BETWEEN 10000 AND 29999 THEN 'Medium Performing Factory'
        ELSE 'Low Performing Factory'
    END AS factory_performance_category
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
JOIN factories f
    ON p.factory_id = f.factory_id
GROUP BY f.factory_name
ORDER BY total_profit DESC;


-- ============================================================
-- 12. Shipping Mode Performance
-- Purpose: Analyze whether shipping methods relate to sales volume.
-- ============================================================

SELECT
    o.ship_mode,
    COUNT(o.order_id) AS number_of_orders,
    ROUND(SUM(od.sales), 2) AS total_sales,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    ROUND(AVG(od.sales), 2) AS avg_sale_value
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY o.ship_mode
ORDER BY total_sales DESC;


-- ============================================================
-- 13. Monthly Revenue Trend
-- Purpose: Analyze sales performance over time.
-- ============================================================

SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    ROUND(SUM(od.sales), 2) AS monthly_sales,
    ROUND(SUM(od.gross_profit), 2) AS monthly_profit,
    SUM(od.units) AS monthly_units_sold
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY order_year, order_month;


-- ============================================================
-- 14. Subquery: Products Above Average Sales
-- Purpose: Identify products whose total sales are above the
-- average total sales across all products.
-- ============================================================

SELECT
    product_name,
    total_sales
FROM (
    SELECT
        p.product_name,
        SUM(od.sales) AS total_sales
    FROM order_details od
    JOIN products p
        ON od.product_id = p.product_id
    GROUP BY p.product_name
) AS product_sales
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM (
        SELECT
            SUM(od.sales) AS total_sales
        FROM order_details od
        JOIN products p
            ON od.product_id = p.product_id
        GROUP BY p.product_name
    ) AS avg_product_sales
)
ORDER BY total_sales DESC;


-- ============================================================
-- 15. Subquery: Regions Above Average Profit
-- Purpose: Identify regions performing above the average regional profit.
-- ============================================================

SELECT
    region,
    total_profit
FROM (
    SELECT
        l.region,
        SUM(od.gross_profit) AS total_profit
    FROM order_details od
    JOIN orders o
        ON od.order_id = o.order_id
    JOIN locations l
        ON o.location_id = l.location_id
    GROUP BY l.region
) AS regional_profit
WHERE total_profit > (
    SELECT AVG(total_profit)
    FROM (
        SELECT
            SUM(od.gross_profit) AS total_profit
        FROM order_details od
        JOIN orders o
            ON od.order_id = o.order_id
        JOIN locations l
            ON o.location_id = l.location_id
        GROUP BY l.region
    ) AS avg_region_profit
)
ORDER BY total_profit DESC;


-- ============================================================
-- 16. Product Performance Summary for Reporting
-- Purpose: Final product-level summary combining sales, profit,
-- units, and margin for business recommendations.
-- ============================================================

SELECT
    p.product_name,
    f.factory_name,
    ROUND(SUM(od.sales), 2) AS total_sales,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    SUM(od.units) AS total_units_sold,
    ROUND((SUM(od.gross_profit) / SUM(od.sales)) * 100, 2) AS profit_margin_percentage,
    CASE
        WHEN SUM(od.gross_profit) >= 15000 THEN 'Prioritize'
        WHEN SUM(od.gross_profit) BETWEEN 8000 AND 14999 THEN 'Maintain'
        ELSE 'Review'
    END AS business_recommendation
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
JOIN factories f
    ON p.factory_id = f.factory_id
GROUP BY p.product_name, f.factory_name
ORDER BY total_profit DESC;