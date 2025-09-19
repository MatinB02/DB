SELECT 
    c.customer_id,
    c.customer_name,
    top_category.category,
    top_category.purchase_count
FROM 
    customers c
JOIN LATERAL (
    SELECT 
        category,
        COUNT(*) AS purchase_count
    FROM 
        sales s
    WHERE 
        s.customer_id = c.customer_id
    GROUP BY 
        category
    ORDER BY 
        purchase_count DESC
    LIMIT 1
) AS top_category ON TRUE
ORDER BY 
    top_category.purchase_count DESC;

