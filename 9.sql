select 0.12 as hit_rate_diff,COUNT(CASE WHEN hit_rate_diff >= 0.12 THEN 1 END)/ COUNT(CASE WHEN ABS(hit_rate_diff) >=0.12 THEN 1 END) AS win_rate from
(
SELECT
    Game,
	home,
	away,
	res,
	batting_rate1,
	batting_rate2,
	FLOOR(CASE
		when res = team1 then batting_rate1 - batting_rate2
		when res = team2 then batting_rate2 - batting_rate1
	END*100)/100 AS hit_rate_diff
 FROM (
SELECT 
	*,
	CASE 
		WHEN home_score > away_score THEN home
		WHEN away_score > home_score THEN away
		ELSE 'Tie'
	END AS res
FROM games
JOIN (
    SELECT DISTINCT 
        Game as game1,
        Team as team1,
        SUM(H)/SUM(AB) AS `batting_rate1`
    FROM hitters
    GROUP BY Game, Team
) AS t1 ON games.Game = t1.game1 AND games.home = t1.team1
JOIN (
    SELECT DISTINCT 
        Game as game2,
        Team as team2,
        SUM(H)/SUM(AB) AS `batting_rate2`
    FROM hitters
    GROUP BY Game, Team
) AS t2 ON games.Game = t2.game2 AND games.away = t2.team2
where YEAR(Date)=2021 
) t0
ORDER BY hit_rate_diff DESC
)as tt;



