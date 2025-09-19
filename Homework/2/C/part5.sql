SELECT 
    a.athlete_id,
    a.firstname,
    a.lastname,
    ev.start_date - a.birthday AS youngest_age
FROM 
    entries AS en
    NATURAL JOIN athletes AS a
    NATURAL JOIN events AS ev
WHERE
    a.birthday IS NOT NULL AND
    en.final_rank = 1
ORDER BY 
    youngest_age, a.athlete_id
LIMIT 1;
