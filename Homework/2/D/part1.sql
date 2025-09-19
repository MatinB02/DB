SELECT 
    t.year,
    t.div_id,
    t.league_id,
    t.team_id,
    t.name
FROM 
    team t
WHERE
	t.rank = 1
ORDER BY 
    t.year ASC;
