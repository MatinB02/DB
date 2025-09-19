SELECT 
    first_name,
    hire_date,
    department,
    salary,
    SUM(salary) OVER (
        PARTITION BY department 
        ORDER BY hire_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM 
    employees
ORDER BY 
    department, hire_date;
