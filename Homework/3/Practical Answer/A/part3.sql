SELECT 
    e.employee_id,
    e.first_name,
    e.department,
    e.salary,
    d.avg_salary
FROM 
    employees e
JOIN (
    SELECT 
        department,
        AVG(salary) AS avg_salary
    FROM 
        employees
    GROUP BY 
        department
) d ON e.department = d.department
WHERE 
    e.salary > d.avg_salary
ORDER BY 
    d.avg_salary DESC;
