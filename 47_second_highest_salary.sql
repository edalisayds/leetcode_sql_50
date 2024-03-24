-------------------------------------------------------------------------------------------------
--------------------------------------- PROBLEM STATEMENT ---------------------------------------
-------------------------------------------------------------------------------------------------
/*
Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
 

Write a solution to find the second highest salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
*/


-------------------------------------------------------------------------------------------------
------------------------------------------- SQL CODE --------------------------------------------
-------------------------------------------------------------------------------------------------


-- MySQL, PostgreSQL
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;



-- Oracle SQL
-- LIMIT doesn't work with Oracle SQL, FETCH FIRST 1 ROW ONLY cannot work with OFFSET syntaxm long query below to handle the problem set for Oracle
WITH SalaryRanking AS (
    SELECT DENSE_RANK() OVER (ORDER BY salary DESC) AS rank_no, COUNT(id) OVER () AS count_items, e.* 
    FROM Employee e
), 
AllRankings AS (
    SELECT CAST(2 AS NUMBER) AS rank_no, NULL AS salary FROM DUAL
)

SELECT DISTINCT CASE WHEN EXISTS (SELECT salary FROM SalaryRanking WHERE rank_no = 2) THEN s.salary ELSE a.salary END AS SecondHighestSalary
FROM SalaryRanking s
JOIN AllRankings a ON 1 = 1
WHERE 2 = CASE WHEN EXISTS (SELECT salary FROM SalaryRanking WHERE rank_no = 2) THEN s.rank_no ELSE a.rank_no END;