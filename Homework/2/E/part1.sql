WITH genre_spending AS (
    SELECT
        c.CustomerId,
        c.FirstName,
        c.LastName,
        g.Name AS GenreName,
        SUM(il.UnitPrice * il.Quantity) AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.CustomerId, g.Name
),
ranked_genres AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY CustomerId ORDER BY TotalSpent DESC) AS rnk
    FROM genre_spending
),
filtered_genres AS (
    SELECT *
    FROM ranked_genres
    WHERE rnk = 1 AND GenreName <> 'TV Shows'
),
only_unique_favorites AS (
    SELECT CustomerId
    FROM filtered_genres
    GROUP BY CustomerId
    HAVING COUNT(*) = 1
)

SELECT 
    fg.CustomerId,
    fg.FirstName,
    fg.LastName,
    fg.GenreName AS favorite_genre,
    fg.TotalSpent AS total_spent_on_favorite
FROM 
    filtered_genres fg
JOIN 
    only_unique_favorites u ON fg.CustomerId = u.CustomerId
ORDER BY 
    total_spent_on_favorite DESC, customerid;
