CREATE MATERIALIZED VIEW mv_top_customers AS
SELECT
    customer_id,
    COUNT(*) AS total_purchases,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM
    sales
GROUP BY
    customer_id;



SELECT * FROM
    mv_top_customers
WHERE
    rank <= 3
ORDER BY
    rank;
