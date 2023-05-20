SELECT 
	'Changed' AS 'Pitcher',
    count(distinct Pitcher_Id) AS cnt,
	ROUND(AVG(2020_Changed_K),4) AS `2020_avg_K/9`,
	ROUND(AVG(2021_Changed_K),4) AS `2021_avg_K/9`,
	CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2020_Changed`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2020_Changed`, '-', -1)), 4) ) AS `2020_PC-ST`,
	CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2021_Changed`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2021_Changed`, '-', -1)), 4) ) AS `2021_PC-ST`
FROM (
    SELECT 
        Pitcher_Id,
        count(distinct Team) AS Team_Count,
		AVG(CASE WHEN Game in (SELECT Game from games WHERE YEAR(Date) = 2020) THEN K/IP END)*9 as 2020_Changed_K,
		AVG(CASE WHEN Game in (SELECT Game from games WHERE YEAR(Date) = 2021) THEN K/IP END)*9 as 2021_Changed_K,
		CONCAT( ROUND( AVG(CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2020) THEN SUBSTRING_INDEX(`PC_ST`, '-', 1) ELSE NULL END), 4 ), '-', ROUND( AVG( CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2020) THEN SUBSTRING_INDEX(`PC_ST`, '-', -1) ELSE NULL END ), 4 ) ) AS `2020_Changed`,
		CONCAT( ROUND( AVG(CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2021) THEN SUBSTRING_INDEX(`PC_ST`, '-', 1) ELSE NULL END), 4 ), '-', ROUND( AVG( CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2021) THEN SUBSTRING_INDEX(`PC_ST`, '-', -1) ELSE NULL END ), 4 ) ) AS `2021_Changed`
	FROM pitchers 
    WHERE Pitcher_Id IN (
        SELECT DISTINCT p1.Pitcher_Id 
        FROM (
            SELECT Pitcher_Id, SUM(IP) AS sum1 
            FROM pitchers 
            WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020) 
            GROUP BY Pitcher_Id
        ) AS p1 
        JOIN (
            SELECT Pitcher_Id, SUM(IP) AS sum2 
            FROM pitchers 
            WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021) 
            GROUP BY Pitcher_Id
        ) AS p2 ON p1.Pitcher_Id = p2.Pitcher_Id 
        WHERE sum1 + sum2 >= 50 
        GROUP BY p1.Pitcher_Id 
    ) 
    AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
    GROUP BY Pitcher_Id
	HAVING COUNT(DISTINCT Team) > 1
) AS T
WHERE Pitcher_Id IN (
    SELECT Pitcher_Id
    FROM pitchers 
    WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021) 
    AND IP <> 0
)
UNION ALL
SELECT 
	'Unchanged' AS 'Pitcher',
	count(distinct Pitcher_Id ) AS cnt,
	ROUND(AVG(2020_Unchanged_K),4) AS `2020_avg_K/9`,
	ROUND(AVG(2021_Unchanged_K),4) AS `2021_avg_K/9`,
	CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2020_Unchanged`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2020_Unchanged`, '-', -1)), 4) ) AS `2020_PC-ST`,
	CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2021_Unchanged`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2021_Unchanged`, '-', -1)), 4) ) AS `2021_PC-ST`
FROM (
    SELECT 
        Pitcher_Id,
        count(distinct Team) AS Team_Count,
		AVG(CASE WHEN Game in (SELECT Game from games WHERE YEAR(Date) = 2020 ) THEN K/IP END )*9 as 2020_Unchanged_K,
		AVG(CASE WHEN Game in (SELECT Game from games WHERE YEAR(Date) = 2021 ) THEN K/IP END )*9 as 2021_Unchanged_K,
		CONCAT( ROUND( AVG(CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2020) THEN SUBSTRING_INDEX(`PC_ST`, '-', 1) ELSE NULL END), 4 ), '-', ROUND( AVG( CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2020) THEN SUBSTRING_INDEX(`PC_ST`, '-', -1) ELSE NULL END ), 4 ) ) AS `2020_Unchanged`,
		CONCAT( ROUND( AVG(CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2021) THEN SUBSTRING_INDEX(`PC_ST`, '-', 1) ELSE NULL END), 4 ), '-', ROUND( AVG( CASE WHEN ip<>0 AND Game in (SELECT Game from games WHERE YEAR(Date) = 2021) THEN SUBSTRING_INDEX(`PC_ST`, '-', -1) ELSE NULL END ), 4 ) ) AS `2021_Unchanged`
    FROM pitchers 
    WHERE Pitcher_Id IN (
        SELECT DISTINCT p1.Pitcher_Id 
        FROM (
            SELECT Pitcher_Id, SUM(IP) AS sum1 
            FROM pitchers 
            WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020) 
            GROUP BY Pitcher_Id
        ) AS p1 
        JOIN (
            SELECT Pitcher_Id, SUM(IP) AS sum2 
            FROM pitchers 
            WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021) 
            GROUP BY Pitcher_Id
        ) AS p2 ON p1.Pitcher_Id = p2.Pitcher_Id 
        WHERE sum1 + sum2 >= 50 
        GROUP BY p1.Pitcher_Id 
    ) 
    AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
    GROUP BY Pitcher_Id
	HAVING COUNT(DISTINCT Team) = 1
) AS T
WHERE Pitcher_Id IN (
    SELECT Pitcher_Id
    FROM pitchers 
    WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021) 
    AND IP <> 0
)