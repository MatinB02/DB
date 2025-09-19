SELECT 
    year,
    COUNT(*) AS count
FROM 
    world_cup_matches
WHERE 
    (
        ("Half-time Home Goals" > "Half-time Away Goals") 
        AND ("Home_Team_Goals" < "Away_Team_Goals")
    )
    OR    (
        ("Half-time Home Goals" < "Half-time Away Goals") 
        AND ("Home_Team_Goals" > "Away_Team_Goals")
    )
    AND ("win_conditions" NOT LIKE '%penalties%' OR "win_conditions" IS NULL)
GROUP BY 
    year
ORDER BY 
    count DESC;