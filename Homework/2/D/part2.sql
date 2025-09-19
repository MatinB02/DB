SELECT 
    t.year,
    t.div_id,
    t.league_id,
    t.team_id,
    t.name,
	p.player_id,
	p.name_first,
	p.name_last,
	p.name_given
FROM 
    team t
JOIN
	pitching g
ON
	t.team_id = g.team_id AND
	t.year = g.year
NATURAL JOIN
	player p
WHERE
	t.rank = 1
ORDER BY 
    t.year ASC;
