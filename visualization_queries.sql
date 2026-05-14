-- ============================================================
-- Day 4: SQL Queries for Python Visualizations
-- Project: Willy Wonka Chocolate Factory
-- Purpose: Extract aggregated business datasets for visualization
-- ============================================================

USE wonka_choc_factory;

-- ============================================================
-- 1. Top 10 Products by Revenue
-- Business question:
-- Which products generate the highest revenue?
-- ============================================================

SELECT
    p.product_name,
    ROUND(SUM(od.sales), 2) AS total_revenue,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    SUM(od.units) AS total_units_sold
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 2. Regional Sales and Profit Performance
-- Business question:
-- Which regions contribute most to sales and profitability?
-- ============================================================

SELECT
    l.region,
    ROUND(SUM(od.sales), 2) AS total_revenue,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    SUM(od.units) AS total_units_sold
FROM order_details od
JOIN orders o
    ON od.order_id = o.order_id
JOIN locations l
    ON o.location_id = l.location_id
GROUP BY l.region
ORDER BY total_revenue DESC;


-- ============================================================
-- 3. Factory Profitability Analysis
-- Business question:
-- Which factories generate the highest profit?
-- ============================================================

SELECT
    f.factory_name,
    ROUND(SUM(od.sales), 2) AS total_revenue,
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
-- 4. Monthly Revenue Trend
-- Business question:
-- How does revenue evolve over time?
-- ============================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    ROUND(SUM(od.sales), 2) AS monthly_revenue,
    ROUND(SUM(od.gross_profit), 2) AS monthly_profit,
    SUM(od.units) AS monthly_units_sold
FROM order_details od
JOIN orders o
    ON od.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY order_month;


-- ============================================================
-- 5. Product Profit Margin Analysis
-- Business question:
-- Which products are more profitable compared to their revenue?
-- ============================================================

SELECT
    p.product_name,
    ROUND(SUM(od.sales), 2) AS total_revenue,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    ROUND((SUM(od.gross_profit) / SUM(od.sales)) * 100, 2) AS profit_margin_percentage
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin_percentage DESC;


-- ============================================================
-- 6. Shipping Mode Performance
-- Business question:
-- Which shipping modes are associated with the highest revenue?
-- ============================================================

SELECT
    o.ship_mode,
    COUNT(o.order_id) AS number_of_orders,
    ROUND(SUM(od.sales), 2) AS total_revenue,
    ROUND(SUM(od.gross_profit), 2) AS total_profit,
    ROUND(AVG(od.sales), 2) AS avg_order_value
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY o.ship_mode
ORDER BY total_revenue DESC;