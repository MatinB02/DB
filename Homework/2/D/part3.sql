CREATE VIEW top_team_pitchers AS

SELECT 
    t.year,
    t.div_id,
    t.league_id,
    t.team_id,
    t.name AS team_name,
    p.player_id,
    p.name_first,
    p.name_last,
    p.name_given
FROM 
    team t
JOIN
    pitching g
    ON t.team_id = g.team_id AND t.year = g.year
NATURAL JOIN
    player p
WHERE
    t.rank = 1;

	
	
SELECT 
    v.year,
    v.div_id,
    v.league_id,
    v.team_id,
    v.team_name AS name,
    v.player_id,
	v.name_first,
	v.name_last,
	v.name_given,
    a.award_id
FROM 
    top_team_pitchers v
NATURAL JOIN 
    player_award a
ORDER BY 
    v.year ASC;
