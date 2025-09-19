SELECT
    division,
    department,
    FIRST_VALUE(department) OVER (
        PARTITION BY division 
        ORDER BY department
    ) AS first_department_in_division,
    LAST_VALUE(department) OVER (
        PARTITION BY division 
        ORDER BY department
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_department_in_division
FROM 
    departments
ORDER BY 
    division, department;
