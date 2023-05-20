SELECT 
    hitting_rate_diff, 
    ROUND(
        COUNT(CASE 
            WHEN (game_stats.away_hitting_rate > game_stats.home_hitting_rate + hitting_rate_diff 
                AND game_stats.away_score > game_stats.home_score) 
            OR (game_stats.home_hitting_rate > game_stats.away_hitting_rate + hitting_rate_diff 
                AND game_stats.home_score > game_stats.away_score) 
            THEN 1 
        END) / 
        COUNT(CASE WHEN ABS(game_stats.away_hitting_rate - game_stats.home_hitting_rate) > hitting_rate_diff THEN 1 END), 
        3
    ) AS win_rate
FROM (
    SELECT 
        g.Game, 
        g.away, 
        g.home, 
        g.away_score, 
        g.home_score,
        ROUND(
            SUM(CASE WHEN t1.Team = g.away THEN t1.H ELSE 0 END) / 
            SUM(CASE WHEN t1.Team = g.away THEN t1.AB ELSE 0 END), 
            3
        ) AS away_hitting_rate,
        ROUND(
            SUM(CASE WHEN t1.Team = g.home THEN t1.H ELSE 0 END) / 
            SUM(CASE WHEN t1.Team = g.home THEN t1.AB ELSE 0 END), 
            3
        ) AS home_hitting_rate
    FROM games g
    JOIN (
        SELECT 
            h.*, 
            g1.Date 
        FROM hitters h 
        JOIN games g1 ON h.Game = g1.Game
    ) AS t1
    ON t1.Date BETWEEN DATE_SUB(g.Date, INTERVAL 3 DAY) AND g.Date
    GROUP BY g.Game, g.away, g.home
) AS game_stats
CROSS JOIN (
    SELECT 0.00 AS hitting_rate_diff UNION ALL
    SELECT 0.01 UNION ALL
    SELECT 0.02 UNION ALL
    SELECT 0.03 UNION ALL
    SELECT 0.04 UNION ALL
    SELECT 0.05 UNION ALL
    SELECT 0.06 UNION ALL
    SELECT 0.07 UNION ALL
    SELECT 0.08 UNION ALL
    SELECT 0.09
) AS diff_values
GROUP BY hitting_rate_diff
UNION ALL
select 'Win_Rate_of_home_Team' AS `hitting_rate_diff`,COUNT(CASE WHEN home_score > away_score THEN 1 END)/COUNT(*) AS win_rate
from games;


