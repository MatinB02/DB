CREATE OR REPLACE FUNCTION count_countries_by_actor(a_id INT)
RETURNS INT AS $$
    SELECT COUNT(DISTINCT m.countary)
    FROM act a
    JOIN movies m ON a.movie_id = m.movie_id
    WHERE a.actor_id = a_id;
$$ LANGUAGE sql;


SELECT 
    a.actor_id,
    a.name,
    count_countries_by_actor(a.actor_id) AS country_count
FROM 
    actors a
ORDER BY 
    country_count DESC;
