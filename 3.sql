select p1.Pitcher_Id, p2.Name AS Pitcher ,round(sum(IP), 1) as tol_innings from pitchers p1  
left join players p2 on p1.Pitcher_Id = p2.Id  
where p1.Game in(select Game from games where Date between '2021-04-01' and '2021-11-30') 
group by Pitcher_Id order by tol_innings DESC limit 3;
