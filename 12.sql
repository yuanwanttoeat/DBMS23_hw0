SELECT DISTINCT p.Pitcher_Id, pl.Name AS start_num, 
       (SUM(p.H)+SUM(p.BB))/SUM(p.IP) AS `WHIP`, 
       9*SUM(p.K)/SUM(p.IP) AS `K/9`, 
       9*SUM(p.BB)/SUM(p.IP) AS `BB/9`,
	   SUM(p.IP) AS `total_IP`,
	   ( SUM(BB)*3 + SUM(HR)*13 - SUM(K)*2 )/sum(IP) + 3 AS `FIP`
FROM pitchers p
JOIN players pl ON p.Pitcher_Id = pl.Id
WHERE SUBSTR(pl.Name, INSTR(pl.Name, ' ') + 1) NOT IN
      (SELECT Pitcher 
       FROM (SELECT Pitcher, COUNT(DISTINCT Game) AS game_count
             FROM pitches
             WHERE Inning IN ('T1', 'B1')	/* not being first_pitcher over ten times */
             GROUP BY Pitcher
             HAVING game_count >= 10) AS first_pitcher)
      AND p.Game IN (SELECT Game FROM games WHERE YEAR(Date)=2021 )
      AND p.IP <> 0
GROUP BY p.Pitcher_Id, pl.Name
HAVING `WHIP` < 1.5  	/* WHIP < 1.5 (大聯盟平均)*/
       AND `K/9` > 7 
       AND `BB/9` < 3
	   AND `total_IP`>=40 /* 假設上場一次投一局的話，1/4的賽季球賽都有上場  */
order by FIP;
