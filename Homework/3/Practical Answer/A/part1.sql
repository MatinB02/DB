WITH ranked_employees AS (
    SELECT 
        employee_id,
        salary,
        NTILE(5) OVER (ORDER BY salary DESC) AS rank_of_salary
    FROM 
        employees
)

SELECT 
    rank_of_salary,
    AVG(salary) AS avg_salary
FROM 
    ranked_employees
GROUP BY 
    rank_of_salary
ORDER BY 
    rank_of_salary;