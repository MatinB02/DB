SELECT 
	movie_id,
	title,
	director,
	TO_CHAR(budget, '999999999999') AS formatted_budget,
	summary,
	countary
FROM 
    movies
WHERE
    (
        (length(summary) - length(replace(summary, 'Batman', ''))) / length('Batman') +
        (length(title) - length(replace(title, 'Batman', ''))) / length('Batman') +
        (length(summary) - length(replace(summary, 'Gotham', ''))) / length('Gotham') +
        (length(title) - length(replace(title, 'Gotham', ''))) / length('Gotham')
    ) >= 2;
