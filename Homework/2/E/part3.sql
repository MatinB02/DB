WITH customer_spending AS (
    SELECT 
        c.CustomerId,
        c.SupportRepId,
        SUM(il.UnitPrice * il.Quantity) AS total_spent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    GROUP BY c.CustomerId
),
avg1 AS (
    SELECT AVG(total_spent) AS avg_spending FROM customer_spending
),
emp AS (
    SELECT 
        e.EmployeeId,
        e.FirstName,
        e.LastName,
        COUNT(cs.CustomerId) AS num_customers,
        AVG(cs.total_spent) AS avg_customer_spending
    FROM customer_spending cs
    JOIN Employee e ON cs.SupportRepId = e.EmployeeId
    GROUP BY e.EmployeeId, e.FirstName, e.LastName
),
selected_emp AS (
    SELECT * FROM emp
    WHERE avg_customer_spending > (SELECT avg_spending FROM avg1)
)

SELECT * FROM selected_emp
ORDER BY avg_customer_spending DESC;
