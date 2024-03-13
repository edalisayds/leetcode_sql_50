-------------------------------------------------------------------------------------------------
--------------------------------------- PROBLEM STATEMENT ---------------------------------------
-------------------------------------------------------------------------------------------------
/*
Table: Prices

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

Table: UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the date, units, and product_id of each product sold. 
 

Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Prices table:
+------------+------------+------------+--------+
| product_id | start_date | end_date   | price  |
+------------+------------+------------+--------+
| 1          | 2019-02-17 | 2019-02-28 | 5      |
| 1          | 2019-03-01 | 2019-03-22 | 20     |
| 2          | 2019-02-01 | 2019-02-20 | 15     |
| 2          | 2019-02-21 | 2019-03-31 | 30     |
+------------+------------+------------+--------+
UnitsSold table:
+------------+---------------+-------+
| product_id | purchase_date | units |
+------------+---------------+-------+
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |
+------------+---------------+-------+
Output: 
+------------+---------------+
| product_id | average_price |
+------------+---------------+
| 1          | 6.96          |
| 2          | 16.96         |
+------------+---------------+
Explanation: 
Average selling price = Total Price of Product / Number of products sold.
Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96
*/


-------------------------------------------------------------------------------------------------
------------------------------------------- SQL CODE --------------------------------------------
-------------------------------------------------------------------------------------------------


-- MySQL
WITH TransactionsFullData AS (
    SELECT COALESCE(s.product_id, p.product_id) AS product_id, start_date, end_date, price, purchase_date, units
    FROM Prices AS p
    LEFT JOIN UnitsSold AS s ON p.product_id = s.product_id AND s.purchase_date BETWEEN p.start_date AND p.end_date
    UNION
    SELECT COALESCE(s.product_id, p.product_id) AS product_id, start_date, end_date, price, purchase_date, units
    FROM Prices AS p
    RIGHT JOIN UnitsSold AS s ON p.product_id = s.product_id AND s.purchase_date BETWEEN p.start_date AND p.end_date
),
Transactions AS (
    SELECT DISTINCT 
        purchase_date,
        product_id, 
        COALESCE(price, 0) AS price,
        COALESCE(units, 0) AS units, 
        COALESCE(price*units, 0) AS total_price
    FROM TransactionsFullData
)

SELECT product_id, 
    CASE 
        WHEN SUM(units) = 0 THEN 0
        ELSE ROUND((SUM(total_price)/SUM(units)), 2) 
    END AS average_price
FROM Transactions
GROUP BY product_id;



-- Oracle SQL
WITH Transactions AS (
    SELECT DISTINCT 
        s.purchase_date,
        COALESCE(s.product_id, p.product_id) AS product_id, 
        NVL(p.price, 0) AS price,
        NVL(s.units, 0) AS units, 
        NVL(p.price*s.units, 0) AS total_price
    FROM Prices p
    FULL OUTER JOIN UnitsSold s 
        ON p.product_id = s.product_id 
        AND s.purchase_date BETWEEN p.start_date AND p.end_date
)

SELECT product_id, 
    CASE 
        WHEN SUM(units) = 0 THEN 0
        ELSE ROUND((SUM(total_price)/SUM(units)), 2) 
    END AS average_price
FROM Transactions
GROUP BY product_id;



-- PostgreSQL
WITH Transactions AS (
    SELECT DISTINCT 
        s.purchase_date,
        COALESCE(s.product_id, p.product_id) AS product_id, 
        COALESCE(p.price, 0) AS price,
        COALESCE(s.units, 0) AS units, 
        COALESCE(p.price*s.units, 0) AS total_price
    FROM Prices p
    FULL OUTER JOIN UnitsSold s 
        ON p.product_id = s.product_id 
        AND s.purchase_date BETWEEN p.start_date AND p.end_date
)

SELECT product_id, 
    CASE 
        WHEN SUM(units) = 0 THEN 0
        ELSE ROUND((SUM(total_price::numeric)/SUM(units::numeric)), 2)
    END AS average_price
FROM Transactions
GROUP BY product_id;