SELECT 
    a.country,
    COUNT(*) AS total_wins
FROM 
    entries en
NATURAL JOIN 
    athletes a
WHERE 
    en.final_rank = 1
GROUP BY 
    a.country
ORDER BY 
    total_wins DESC
LIMIT 1;