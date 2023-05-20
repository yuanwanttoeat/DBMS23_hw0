SELECT t1.Team, DATE_FORMAT(t1.Date, '%Y-%m') AS `The_month`, TIME_FORMAT(MIN(TIMEDIFF(t2.`Date`, t1.`Date`)), '%H:%i') AS time_interval
FROM (
  SELECT home AS team, `Date` FROM games WHERE home in (select distinct home from games) and DATE_FORMAT(Date, '%Y-%m')= ( select `year_month` from ( SELECT `year_month`,sum(`num_games`) AS `sum_num_games` FROM ( SELECT team, CONCAT(YEAR(date), '-', LPAD(MONTH(date), 2, '0')) AS `year_month`, COUNT(*) AS `num_games` FROM (SELECT home AS team, date FROM games UNION ALL SELECT away AS team, date FROM games) AS `all_games` GROUP BY team, `year_month` ) AS team_month_stats group by `year_month` )as t0 order by `sum_num_games` DESC limit 1 )
  UNION ALL
  SELECT away AS team, `Date` FROM games WHERE away in ( select distinct home from games ) and DATE_FORMAT(Date, '%Y-%m')= ( select `year_month` from ( SELECT `year_month`,sum(`num_games`) AS `sum_num_games` FROM ( SELECT team, CONCAT(YEAR(date), '-', LPAD(MONTH(date), 2, '0')) AS `year_month`, COUNT(*) AS `num_games` FROM (SELECT home AS team, date FROM games UNION ALL SELECT away AS team, date FROM games) AS `all_games` GROUP BY team, `year_month` ) AS team_month_stats group by `year_month` )as t0 order by `sum_num_games` DESC limit 1 )
) AS t1
JOIN (
  SELECT home AS team, `Date` FROM games WHERE home in ( select distinct home from games ) and DATE_FORMAT(Date, '%Y-%m')= ( select `year_month` from ( SELECT `year_month`,sum(`num_games`) AS `sum_num_games` FROM ( SELECT team, CONCAT(YEAR(date), '-', LPAD(MONTH(date), 2, '0')) AS `year_month`, COUNT(*) AS `num_games` FROM (SELECT home AS team, date FROM games UNION ALL SELECT away AS team, date FROM games) AS `all_games` GROUP BY team, `year_month` ) AS team_month_stats group by `year_month` )as t0 order by `sum_num_games` DESC limit 1 )
  UNION ALL
  SELECT away AS team, `Date` FROM games WHERE away in ( select distinct home from games ) and DATE_FORMAT(Date, '%Y-%m')= ( select `year_month` from ( SELECT `year_month`,sum(`num_games`) AS `sum_num_games` FROM ( SELECT team, CONCAT(YEAR(date), '-', LPAD(MONTH(date), 2, '0')) AS `year_month`, COUNT(*) AS `num_games` FROM (SELECT home AS team, date FROM games UNION ALL SELECT away AS team, date FROM games) AS `all_games` GROUP BY team, `year_month` ) AS team_month_stats group by `year_month` )as t0 order by `sum_num_games` DESC limit 1 )
) AS t2
ON t1.team = t2.team AND t1.`Date` < t2.`Date`
GROUP BY `The_month`, t1.team;

