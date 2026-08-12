-- ============================================================
-- E-COMMERCE CUSTOMER CHURN ANALYSIS
-- SQL ANALYSIS
-- ============================================================

-- ============================================================
-- 1. CHURN RATE BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    segment,
    COUNT(*) AS total_customers,
    SUM(CASE
            WHEN churn_status = 'Churned' THEN 1
            ELSE 0
        END) AS churned_customers,
    ROUND(
        SUM(CASE
                WHEN churn_status = 'Churned' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY segment
ORDER BY churn_rate DESC;


-- ============================================================
-- 2. CHURNED CUSTOMERS BY CITY
-- ============================================================

SELECT
    city,
    COUNT(*) AS churned_customers
FROM customer_churn
WHERE churn_status = 'Churned'
GROUP BY city
ORDER BY churned_customers DESC;


-- ============================================================
-- 3. AVERAGE DELIVERY DELAY BY CHURN STATUS
-- ============================================================

SELECT
    churn_status,
    ROUND(AVG(avg_delivery_delay_days), 2) AS average_delivery_delay
FROM customer_churn
GROUP BY churn_status;


-- ============================================================
-- 4. AVERAGE DISCOUNT BY CHURN STATUS
-- ============================================================

SELECT
    churn_status,
    ROUND(AVG(avg_discount), 2) AS average_discount
FROM customer_churn
GROUP BY churn_status;


-- ============================================================
-- 5. REVENUE BY PRODUCT CATEGORY
-- ============================================================

SELECT
    product_category,
    ROUND(SUM(order_value), 2) AS total_revenue
FROM orders
GROUP BY product_category
ORDER BY total_revenue DESC;


-- ============================================================
-- 6. TOP 10 HIGHEST-VALUE CUSTOMERS
-- ============================================================

SELECT
    customer_id,
    ROUND(SUM(order_value), 2) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 7. MONTHLY REVENUE TREND
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(order_value), 2) AS monthly_revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- ============================================================
-- 8. MONTHLY CHURN TREND
-- ============================================================

SELECT
    DATE_FORMAT(last_purchase_date, '%Y-%m') AS month,
    COUNT(*) AS churned_customers
FROM customer_churn
WHERE churn_status = 'Churned'
GROUP BY DATE_FORMAT(last_purchase_date, '%Y-%m')
ORDER BY month;


-- ============================================================
-- 9. REPEAT PURCHASE ANALYSIS
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;


-- ============================================================
-- 10. CUSTOMER LIFETIME VALUE (CLV)
-- ============================================================

SELECT
    customer_id,
    ROUND(SUM(order_value), 2) AS total_clv
FROM orders
GROUP BY customer_id
ORDER BY total_clv DESC;


-- ============================================================
-- 11. RFM ANALYSIS
-- ============================================================

SELECT
    customer_id,
    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        MAX(order_date)
    ) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    ROUND(SUM(order_value), 2) AS monetary
FROM orders
GROUP BY customer_id
ORDER BY monetary DESC;
