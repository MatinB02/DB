SELECT
    "matchid",
    "year",
    "stage",
    "Home_Team_Name",
    "Away_Team_Name"
FROM
    world_cup_matches
WHERE
    "year" BETWEEN 1938 AND 2006
	AND "win_conditions" is not null
    AND (
        "win_conditions" LIKE '%extra time%' OR
        "win_conditions" LIKE '%penalties%' OR
	    "win_conditions" LIKE '%Golden Goal %'
    )
ORDER BY
    "year" ASC;
