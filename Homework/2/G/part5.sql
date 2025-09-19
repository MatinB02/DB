SELECT 
    director,
    AVG(budget) AS avg_budget
FROM 
    movies
GROUP BY 
    director
ORDER BY 
    avg_budget DESC;
