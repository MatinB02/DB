CREATE OR REPLACE FUNCTION count_countries_by_actor(a_id INT)
RETURNS INT AS $$
    SELECT COUNT(DISTINCT m.countary)
    FROM act a
    JOIN movies m ON a.movie_id = m.movie_id
    WHERE a.actor_id = a_id;
$$ LANGUAGE sql;

SELECT count_countries_by_actor(0);
-- result is 2, Brad Pitt has acted in 2 countries


