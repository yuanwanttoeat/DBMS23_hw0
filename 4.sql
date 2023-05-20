SELECT p.Name as Hitter,round(AVG(num_P /(AB + K + BB)),4) as 'avg_P/PA',
AVG(AB) as avg_AB,AVG(BB) as avg_BB,AVG(K) as avg_K , SUM(AB + K + BB) as tol_PA 
FROM hitters h  left join players p on h.Hitter_Id = p.Id  
where (AB + K + BB)<>0 GROUP BY Hitter_Id having `tol_PA`>=20  
ORDER BY AVG(num_P /(AB + K + BB)) DESC LIMIT 3;

 