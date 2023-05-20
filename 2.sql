SELECT Game, MAX(temp_innings) AS num_innings
FROM (
    SELECT 
        Game, 
        MAX(
            CASE
                WHEN Inning REGEXP '^B[0-2][0-9]$' THEN SUBSTRING(Inning, 2)
                WHEN Inning REGEXP '^T[0-2][0-9]$' THEN SUBSTRING(Inning, 2)
                ELSE NULL
            END
        ) AS temp_innings 
    FROM inning
    GROUP BY Game
) AS num_innings_table
GROUP BY Game
HAVING num_innings = (
    SELECT MAX(temp_innings) FROM (
        SELECT 
            Game, 
            MAX(
                CASE
                    WHEN Inning REGEXP '^B[0-2][0-9]$' THEN SUBSTRING(Inning, 2)
                    WHEN Inning REGEXP '^T[0-2][0-9]$' THEN SUBSTRING(Inning, 2)
                    ELSE NULL
                END
            ) AS temp_innings 
        FROM inning
        GROUP BY Game, Inning
    ) AS num_innings_table_inner
)
ORDER BY Game;
