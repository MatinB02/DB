WITH RECURSIVE managment_system AS (
    SELECT 
        e.EmployeeId AS ManagerId,
        e.FirstName || ' ' || e.LastName AS ManagerName,
        e2.EmployeeId AS ReporteeId
    FROM Employee e
    JOIN Employee e2 ON e.EmployeeId = e2.ReportsTo

    UNION ALL
	
    SELECT 
        m.ManagerId,
        m.ManagerName,
        e.EmployeeId AS ReporteeId
    FROM managment_system m
    JOIN Employee e ON m.ReporteeId = e.ReportsTo
)

SELECT 
    ManagerId AS EmployeeId,
    ManagerName,
    COUNT(DISTINCT ReporteeId) AS total_managed
FROM managment_system
GROUP BY ManagerId, ManagerName
ORDER BY total_managed DESC;
