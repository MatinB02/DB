SELECT 
    ev.name AS event_name,
    a.lastname
FROM 
    entries en
NATURAL JOIN 
    athletes a
NATURAL JOIN
	events ev
WHERE 
	qualification_rank = 1
ORDER BY 
    event_id ASC;