SELECT 
    p."Player Name",
    c."Year",
    p."Team Initials",
    c."Country",
    p."event"
FROM 
    "world_cup_players" p
JOIN 
    "world_cup_matches" m ON p."matchid" = m."matchid"
JOIN 
    "WorldCups" c ON m."year" = c."Year"
WHERE 
	(
		(p."Team Initials" = m."Home_Team_Initials" AND (
			REPLACE(c."Country", '/', '|') LIKE '%' || m."Home_Team_Name" || '%'
			OR 	(c."Country" LIKE '%Korea%' AND m."Home_Team_Name" LIKE '%Korea%')
			)
		) OR
	    (p."Team Initials" = m."Away_Team_Initials" AND (
			REPLACE(c."Country", '/', '|') LIKE '%' || m."Away_Team_Name" || '%' --OR
			OR (c."Country" LIKE '%Korea%' AND m."Away_Team_Name" LIKE '%Korea%')
			)
		)
	)
    AND (p."event" LIKE '%Y%' OR p."event" LIKE '%R%')
ORDER BY 
    c."Year";