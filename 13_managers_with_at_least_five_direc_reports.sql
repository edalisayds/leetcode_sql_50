-------------------------------------------------------------------------------------------------
--------------------------------------- PROBLEM STATEMENT ---------------------------------------
-------------------------------------------------------------------------------------------------
/*
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

Write a solution to find managers with at least five direct reports.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+
*/


-------------------------------------------------------------------------------------------------
------------------------------------------- SQL CODE --------------------------------------------
-------------------------------------------------------------------------------------------------


-- MySQL
WITH Directs AS (
    SELECT e2.id, e2.name, COUNT(e1.id) AS direct_report_count
    FROM Employee AS e1
    JOIN Employee AS e2 ON e1.managerId = e2.id
    WHERE e1.managerId is not null
    GROUP BY e2.id, e2.name
)

SELECT name 
FROM Directs
WHERE direct_report_count >= 5;



-- Oracle SQL & PostgreSQL
WITH Directs AS (
    SELECT e2.id, e2.name, COUNT(e1.id) AS direct_report_count
    FROM Employee e1
    JOIN Employee e2 ON e1.managerId = e2.id
    WHERE e1.managerId is not null
    GROUP BY e2.id, e2.name
)

SELECT name 
FROM Directs
WHERE direct_report_count >= 5;