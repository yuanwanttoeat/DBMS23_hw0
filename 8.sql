SELECT 
    'Changed' AS Pitcher, 
    t1.cnt,
	a1.`2020_avg_K/9`,
	a2.`2021_avg_K/9`,
	a3.`2020_PC-ST`,
	a4.`2021_PC-ST`
FROM (
SELECT 'Changed' AS Pitcher, SUM(CASE WHEN t0.num > 1 THEN 1 ELSE 0 END) AS cnt from
(
    SELECT 
        Pitcher_Id, 
        COUNT(DISTINCT Team) AS num
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
    ) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
    GROUP BY Pitcher_Id
) AS t0 ) AS t1
JOIN
(SELECT 
    'Changed' AS Pitcher, 
    ROUND(AVG(2020_Changed),4) AS `2020_avg_K/9`
FROM (
select Pitcher_Id,AVG(K/IP)*9 as 2020_Changed from pitchers
where Pitcher_Id in 
(
    SELECT 
        Pitcher_Id
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
    ) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
    GROUP BY Pitcher_Id
	having COUNT(distinct Team)>1
) 
and Game in (select Game from games where YEAR(Date)=2020)
group by Pitcher_Id
)as tt) as a1
ON t1.Pitcher = a1.Pitcher
JOIN
(SELECT 
    'Changed' AS Pitcher, 
	ROUND(AVG(2021_Changed),4) AS `2021_avg_K/9`
FROM (
select AVG(K/IP)*9 as 2021_Changed from pitchers
where Pitcher_Id in 
(
    SELECT 
        Pitcher_Id
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
    ) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
    GROUP BY Pitcher_Id
	having COUNT(distinct Team)>1
) 
and Game in (select Game from games where YEAR(Date)=2021)
group by Pitcher_Id
)as t2)as a2
ON a1.Pitcher = a2.Pitcher
JOIN 
(
SELECT 'Changed' AS Pitcher, CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2020_Unchanged`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2020_Unchanged`, '-', -1)), 4) ) AS `2020_PC-ST` FROM
(
SELECT CONCAT( ROUND(AVG(CASE WHEN Game in (SELECT Game from games WHERE YEAR(Date) = 2020) THEN SUBSTRING_INDEX(`PC_ST`, '-', 1) END), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`PC_ST`, '-', -1)), 4) ) AS `2020_Changed`, FROM pitchers
where Pitcher_Id in
(
    SELECT 
        Pitcher_Id
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
    ) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
    GROUP BY Pitcher_Id
	having COUNT(distinct Team)>1
) 
and Game in (select Game from games where YEAR(Date)=2020)
and ip<>0
group by Pitcher_Id
)as t3) AS a3
ON a2.Pitcher = a3.Pitcher
JOIN
(
SELECT 'Changed' AS Pitcher, CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2021_Unchanged`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2021_Unchanged`, '-', -1)), 4) ) AS `2021_PC-ST` FROM
(
SELECT CONCAT( ROUND(AVG(SUBSTRING_INDEX(`PC_ST`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`PC_ST`, '-', -1)), 4) ) AS `2021_Unchanged` FROM pitchers
where Pitcher_Id in
(
    SELECT 
        Pitcher_Id
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
    ) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
    GROUP BY Pitcher_Id
	having COUNT(distinct Team)>1
) 
and Game in (select Game from games where YEAR(Date)=2021)
and ip<>0
group by Pitcher_Id
)as t4) AS a4
ON a3.Pitcher = a4.Pitcher
UNION ALL 
SELECT 
	'Unchanged' AS Pitcher, 
    b1.cnt ,
	b2.`2020_avg_K/9`,
	b3.`2021_avg_K/9`,
	b4.`2020_PC-ST`,
	b5.`2021_PC-ST`
from (
	SELECT 
		'Unchanged' AS Pitcher, 
		SUM(CASE WHEN num = 1 THEN 1 ELSE 0 END) AS cnt 
	FROM (
		SELECT 
			Pitcher_Id, 
			COUNT(DISTINCT Team) AS num
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
		) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
		GROUP BY Pitcher_Id
	) AS t1
) AS b1
JOIN 
(
	select 'Unchanged' AS Pitcher,
	ROUND(AVG(2020_Unchanged),4) AS `2020_avg_K/9` from
	(
	select Pitcher_Id,AVG(K/IP)*9 as 2020_Unchanged from pitchers
	where Pitcher_Id in 
	(
		SELECT 
			Pitcher_Id
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
		) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
		GROUP BY Pitcher_Id
		having COUNT(distinct Team)=1
	) 
	and Game in (select Game from games where YEAR(Date)=2020)
	group by Pitcher_Id
	)as tt
)as b2
ON b1.Pitcher = b2.Pitcher
JOIN 
(
	select 'Unchanged' AS Pitcher,
	ROUND(AVG(2020_Unchanged),4) AS `2021_avg_K/9` from
	(
	select Pitcher_Id,AVG(K/IP)*9 as 2020_Unchanged from pitchers
	where Pitcher_Id in 
	(
		SELECT 
			Pitcher_Id
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
		) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
		GROUP BY Pitcher_Id
		having COUNT(distinct Team)=1
	) 
	and Game in (select Game from games where YEAR(Date)=2021)
	group by Pitcher_Id
	)as ttt
)as b3
ON b2.Pitcher = b3.Pitcher
JOIN
(
	SELECT 'Unchanged' AS Pitcher, CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2020_Unchanged`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2020_Unchanged`, '-', -1)), 4) ) AS `2020_PC-ST` FROM
	(
	SELECT CONCAT( ROUND(AVG(SUBSTRING_INDEX(`PC_ST`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`PC_ST`, '-', -1)), 4) ) AS `2020_Unchanged` FROM pitchers
	where Pitcher_Id in
	(
		SELECT 
			Pitcher_Id
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
		) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
		GROUP BY Pitcher_Id
		having COUNT(distinct Team)=1
	) 
	and Game in (select Game from games where YEAR(Date)=2020)
	and ip<>0
	group by Pitcher_Id
	)as t4
)AS b4
ON b3.Pitcher = b4.Pitcher
JOIN
(
	SELECT 'Unchanged' AS Pitcher, CONCAT( ROUND(AVG(SUBSTRING_INDEX(`2021_Unchanged`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`2021_Unchanged`, '-', -1)), 4) ) AS `2021_PC-ST` FROM
	(
	SELECT CONCAT( ROUND(AVG(SUBSTRING_INDEX(`PC_ST`, '-', 1)), 4), '-', ROUND(AVG(SUBSTRING_INDEX(`PC_ST`, '-', -1)), 4) ) AS `2021_Unchanged` FROM pitchers
	where Pitcher_Id in
	(
		SELECT 
			Pitcher_Id
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
		) AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021) 
		GROUP BY Pitcher_Id
		having COUNT(distinct Team)=1
	) 
	and Game in (select Game from games where YEAR(Date)=2021)
	and ip<>0
	group by Pitcher_Id
	)as t5
)AS b5
ON b4.Pitcher = b5.Pitcher;
