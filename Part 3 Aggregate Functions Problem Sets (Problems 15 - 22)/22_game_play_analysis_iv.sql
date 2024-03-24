-------------------------------------------------------------------------------------------------
--------------------------------------- PROBLEM STATEMENT ---------------------------------------
-------------------------------------------------------------------------------------------------
/*
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The result format is in the following example.

 

Example 1:

Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33
*/


-------------------------------------------------------------------------------------------------
------------------------------------------- SQL CODE --------------------------------------------
-------------------------------------------------------------------------------------------------


-- MySQL
WITH ActivityDetails AS (
    SELECT a.*,
        LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS previous_log_in_date,
        event_date - INTERVAL '1' DAY AS previous_date,
        CASE 
            WHEN LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date) = event_date - INTERVAL '1' DAY 
            THEN 1 
            ELSE 0 
        END AS is_loggedin_previous_day
    FROM Activity a
)

SELECT 
    ROUND((SUM(CASE 
        WHEN is_loggedin_previous_day = 1 
        AND previous_log_in_date = previous_date 
        AND previous_log_in_date = (SELECT MIN(event_date) FROM Activity WHERE player_id = ad.player_id)
        THEN 1 ELSE 0 
    END)/COUNT(DISTINCT player_id)), 2) AS fraction 
FROM ActivityDetails ad;



-- Oracle SQL
WITH ActivityDetails AS (
    SELECT a.*,
		ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rank,
        LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS previous_log_in_date,
        event_date - INTERVAL '1' DAY AS previous_date,
        CASE 
            WHEN LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date) = event_date - INTERVAL '1' DAY 
            THEN 1 
            ELSE 0 
        END AS is_loggedin_previous_day
    FROM Activity a
)

SELECT 
    ROUND((SUM(CASE WHEN rank = 2 AND previous_log_in_date = previous_date THEN 1 ELSE 0 END)/COUNT(DISTINCT player_id)), 2) AS fraction 
FROM ActivityDetails;



-- PostgreSQL
WITH ActivityDetails AS (
    SELECT a.*,
		ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rank,
        LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS previous_log_in_date,
        event_date - INTERVAL '1' DAY AS previous_date,
        CASE 
            WHEN LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date) = event_date - INTERVAL '1' DAY 
            THEN 1 
            ELSE 0 
        END AS is_loggedin_previous_day
    FROM Activity a
)

SELECT 
    ROUND((SUM(CASE WHEN rank = 2 AND previous_log_in_date = previous_date THEN 1 ELSE 0 END)::numeric/COUNT(DISTINCT player_id)), 2) AS fraction 
FROM ActivityDetails;