SELECT 
    a.athlete_id,
    a.firstname,
    a.lastname,
    COUNT(DISTINCT en.discipline) AS unique_disciplines
FROM 
    entries en
NATURAL JOIN 
    athletes a
WHERE 
    en.final_rank = 1
GROUP BY 
    a.athlete_id
HAVING 
    COUNT(DISTINCT en.discipline) > 1
ORDER BY 
    athlete_id;