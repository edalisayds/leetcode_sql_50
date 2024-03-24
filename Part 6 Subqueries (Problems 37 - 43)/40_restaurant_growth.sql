-------------------------------------------------------------------------------------------------
--------------------------------------- PROBLEM STATEMENT ---------------------------------------
-------------------------------------------------------------------------------------------------
/*
Table: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
In SQL,(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.

Return the result table ordered by visited_on in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+
Explanation: 
1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86
*/


-------------------------------------------------------------------------------------------------
------------------------------------------- SQL CODE --------------------------------------------
-------------------------------------------------------------------------------------------------


-- MySQL
WITH CustomersHistory AS (
	SELECT DISTINCT DATE_FORMAT(c1.visited_on, '%Y-%m-%d') AS base_visited_on, c2.*
	FROM Customer c1
	JOIN Customer c2 ON c2.visited_on BETWEEN DATE_SUB(c1.visited_on, INTERVAL 6 DAY) AND c1.visited_on
	ORDER BY 1 DESC
), MA_DateStats AS (
	SELECT base_visited_on AS visited_on, 
		COUNT(DISTINCT visited_on) AS count_days, 
		SUM(amount) AS amount, 
		ROUND((SUM(amount)/7), 2) AS average_amount
	FROM CustomersHistory
	GROUP BY base_visited_on
	ORDER BY base_visited_on
)

SELECT visited_on, amount, average_amount 
FROM MA_DateStats
WHERE count_days >= 7;



-- Oracle SQL
WITH CustomersHistory AS (
	SELECT DISTINCT TO_CHAR(c1.visited_on, 'YYYY-MM-DD') AS base_visited_on, c2.*
	FROM leetcode.Customer c1
	JOIN leetcode.Customer c2 ON c2.visited_on BETWEEN c1.visited_on - 6 AND c1.visited_on 
	ORDER BY 1 DESC
), MA_DateStats AS (
	SELECT base_visited_on AS visited_on, 
		COUNT(DISTINCT visited_on) AS count_days, 
		SUM(amount) AS amount, 
		ROUND((SUM(amount::numeric)/7), 2) AS average_amount
	FROM CustomersHistory
	GROUP BY base_visited_on
	ORDER BY base_visited_on
)

SELECT visited_on, amount, average_amount 
FROM MA_DateStats
WHERE count_days >= 7;



-- PostgreSQL
WITH CustomersHistory AS (
	SELECT DISTINCT TO_CHAR(c1.visited_on, 'YYYY-MM-DD') AS base_visited_on, c2.*
	FROM leetcode.Customer c1
	JOIN leetcode.Customer c2 ON c2.visited_on BETWEEN c1.visited_on - 6 AND c1.visited_on 
	ORDER BY 1 DESC
), MA_DateStats AS (
	SELECT base_visited_on AS visited_on, 
		COUNT(DISTINCT visited_on) AS count_days, 
		SUM(amount) AS amount, 
		ROUND((SUM(amount::numeric)/7), 2) AS average_amount
	FROM CustomersHistory
	GROUP BY base_visited_on
	ORDER BY base_visited_on
)

SELECT visited_on, amount, average_amount 
FROM MA_DateStats
WHERE count_days >= 7;