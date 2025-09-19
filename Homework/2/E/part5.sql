WITH customer_avg_invoice AS (
    SELECT 
        c.CustomerId,
        c.Country,
        AVG(i.Total) AS customer_avg
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId, c.Country
),
global_avg AS (
    SELECT AVG(customer_avg) AS global_avg1
    FROM customer_avg_invoice
),
country_stats AS (
    SELECT 
        Country,
        COUNT(*) AS num_customers,
        AVG(customer_avg) AS country_avg
    FROM customer_avg_invoice
    GROUP BY Country
),
selected_countries AS (
    SELECT *
    FROM country_stats
    WHERE num_customers >= 2
      AND country_avg > (SELECT global_avg1 FROM global_avg)
)

SELECT 
    Country,
    num_customers,
    ROUND(country_avg, 3) AS country_avg
FROM 
    selected_countries
ORDER BY 
    country_avg DESC;
