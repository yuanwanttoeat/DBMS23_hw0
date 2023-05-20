SELECT t1.team as Team, t2.hitter as Hitter, ROUND(t2.avg_hit_rate,4) as avg_hit_rate, t2.tol_hit, t1.win_rate
FROM 
(
    SELECT team,count(*)/  (SELECT COUNT(*) FROM games WHERE YEAR(Date) = 2021 AND (away = team OR home = team)) AS win_rate 
    FROM (
        SELECT 
            CASE
                WHEN away_score > home_score THEN away
                WHEN home_score > away_score THEN home
            END AS team
        FROM games
        WHERE YEAR(Date) = 2021
    ) AS winners
    WHERE team IS NOT NULL
    GROUP BY team
    ORDER BY win_rate DESC
    LIMIT 5
) AS t1
JOIN (
    SELECT Team, p.Name AS hitter, AVG(H/AB) AS avg_hit_rate, SUM(AB) AS tol_hit,
        ROW_NUMBER() OVER (PARTITION BY Team ORDER BY AVG(H/AB) DESC, SUM(AB) DESC) AS rn
    FROM hitters h
    JOIN players p ON p.Id = h.Hitter_Id
    WHERE h.Team IN (
        SELECT * FROM (
            SELECT team
            FROM (
                SELECT 
                    CASE
                        WHEN away_score > home_score THEN away
                        WHEN home_score > away_score THEN home
                    END AS team
                FROM games
                WHERE YEAR(Date) = 2021
            ) AS winners
            WHERE team IS NOT NULL
            GROUP BY team
            ORDER BY count(*) / (SELECT COUNT(*) FROM games WHERE YEAR(Date) = 2021 AND (away = team OR home = team)) DESC
            LIMIT 5
        ) AS temp
    )
        AND AB <> 0 AND Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)
    GROUP BY h.Team, Hitter_Id
    HAVING SUM(AB) > 100
) AS t2
ON t1.team = t2.Team
WHERE t2.rn = 1;
