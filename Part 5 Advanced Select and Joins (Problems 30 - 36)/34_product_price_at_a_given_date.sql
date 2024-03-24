-------------------------------------------------------------------------------------------------
--------------------------------------- PROBLEM STATEMENT ---------------------------------------
-------------------------------------------------------------------------------------------------
/*
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
This table may contain duplicates rows. 
customer_id is not NULL.
product_key is a foreign key (reference column) to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key (column with unique values) for this table.
 

Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: 
The customers who bought all the products (5 and 6) are customers with IDs 1 and 3.
*/


-------------------------------------------------------------------------------------------------
------------------------------------------- SQL CODE --------------------------------------------
-------------------------------------------------------------------------------------------------


-- MySQL, Oracle SQL, PostgreSQL
WITH PricingHistory AS (
    SELECT product_id, 
        new_price AS price, 
        change_date AS eff_date,
        CASE 
            WHEN LEAD(change_date - 1) OVER (PARTITION BY product_id ORDER BY change_date) IS NOT NULL 
            THEN LEAD(change_date - 1) OVER (PARTITION BY product_id ORDER BY change_date)
            ELSE DATE_FORMAT(STR_TO_DATE('39991231', '%Y%m%d'), '%Y%m%d') 
        END AS end_date
    FROM Products
    ORDER BY product_id, change_date
),
PricingHistory2 AS (
    SELECT * FROM PricingHistory
    UNION
    SELECT 
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > STR_TO_DATE('20190816', '%Y%m%d') THEN product_id END AS product_id,
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > STR_TO_DATE('20190816', '%Y%m%d') THEN 10 END AS PRICE,
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > STR_TO_DATE('20190816', '%Y%m%d') THEN STR_TO_DATE('20190816', '%Y%m%d') END AS eff_date,
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > STR_TO_DATE('20190816', '%Y%m%d') THEN (MIN(eff_date) OVER (PARTITION BY product_id))-1 END AS end_date
    FROM PricingHistory  
)

SELECT product_id, price
FROM PricingHistory2
WHERE STR_TO_DATE('20190816', '%Y%m%d') BETWEEN eff_date AND end_date;



-- Oracle SQL, PostgreSQL
WITH PricingHistory AS (
    SELECT product_id, 
        new_price AS price, 
        change_date AS eff_date,
        CASE 
            WHEN LEAD(change_date - 1) OVER (PARTITION BY product_id ORDER BY change_date) IS NOT NULL 
            THEN LEAD(change_date - 1) OVER (PARTITION BY product_id ORDER BY change_date)
            ELSE TO_DATE('39991231', 'YYYYMMDD') 
        END AS end_date
    FROM Products
    ORDER BY product_id, change_date
),
PricingHistory2 AS (
    SELECT * FROM PricingHistory
    UNION
    SELECT 
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > TO_DATE('20190816', 'YYYYMMDD') THEN product_id END AS product_id,
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > TO_DATE('20190816', 'YYYYMMDD') THEN 10 END AS PRICE,
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > TO_DATE('20190816', 'YYYYMMDD') THEN TO_DATE('20190816', 'YYYYMMDD') END AS eff_date,
        CASE WHEN MIN(eff_date) OVER (PARTITION BY product_id) > TO_DATE('20190816', 'YYYYMMDD') THEN (MIN(eff_date) OVER (PARTITION BY product_id))-1 END AS end_date
    FROM PricingHistory  
)

SELECT product_id, price
FROM PricingHistory2
WHERE TO_DATE('20190816', 'YYYYMMDD') BETWEEN eff_date AND end_date;