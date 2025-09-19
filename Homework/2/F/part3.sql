SELECT
    m."referee",
    COUNT(p."event") AS totalcards
FROM
    world_cup_matches m
LEFT JOIN
    world_cup_players p 
    ON m."matchid" = p."matchid"
    AND p."event" LIKE '%R%'
GROUP BY
    m."referee"
ORDER BY
    totalcards DESC, m."referee" DESC;
