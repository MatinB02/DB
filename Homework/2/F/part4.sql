SELECT 
    c."Country",
    c."Year",
    AVG(m.attendance) AS avgparticipantspermatch
FROM 
    "WorldCups" c
JOIN 
    "world_cup_matches" m ON c."Year" = m."year"
WHERE 
    (REPLACE(c."Country", '/', '|') LIKE '%' || m."Home_Team_Name" || '%' OR
    REPLACE(c."Country", '/', '|') LIKE '%' || m."Away_Team_Name" || '%')
    -- OR
    -- (c."Country" = m."Home_Team_Name" OR c."Country" = m."Away_Team_Name")
GROUP BY 
    c."Country", c."Year"
ORDER BY 
    avgparticipantspermatch DESC;