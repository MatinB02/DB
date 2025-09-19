WITH customer_spending AS (
    SELECT 
        c.CustomerId,
        SUM(il.UnitPrice * il.Quantity) AS total_spent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    GROUP BY c.CustomerId
),
above_average_customers AS (
    SELECT 
        CustomerId
    FROM customer_spending
    WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spending)
),
track_purchases AS (
    SELECT 
        t.TrackId,
        t.Name,
        il.UnitPrice * il.Quantity AS purchase_value,
        i.CustomerId
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    WHERE i.CustomerId IN (SELECT CustomerId FROM above_average_customers)
),
aggregated_tracks AS (
    SELECT 
        TrackId,
        Name,
        COUNT(DISTINCT CustomerId) AS num_customers,
        SUM(purchase_value) AS total_revenue
    FROM track_purchases
    GROUP BY TrackId, Name
)

SELECT * FROM aggregated_tracks
ORDER BY num_customers DESC, trackid;
