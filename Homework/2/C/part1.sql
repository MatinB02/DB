SELECT 
    a.athlete_id,
    a.lastname,
    COUNT(*) AS gold_medals_count
FROM entries en
JOIN athletes a ON en.athlete_id = a.athlete_id
WHERE en.rank = 1
GROUP BY a.athlete_id, a.lastname
ORDER BY gold_medals_count DESC
LIMIT 1;
