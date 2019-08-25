SET STATISTICS IO, TIME ON;
go
SELECT m.[EmployeeID], SUM(e.[Salary])
FROM [dbo].[vw_EmployeeHierarchyWide] AS [m]
JOIN [dbo].[vw_EmployeeHierarchyWide] AS [e]
    ON e.l6_manager = m.employeeid
WHERE [m].[level] = 6
GROUP BY m.[EmployeeID]
ORDER BY SUM(e.[Salary]) DESC;

PRINT REPLICATE('-', 40);

SELECT [m].[EmployeeID], SUM(e.[Salary])
FROM dbo.[EmployeeHierarchyWide] AS [m]
CROSS APPLY dbo.[getDescendants_r]([m].[EmployeeID]) AS [d]
JOIN [dbo].[EmployeeHierarchyWide] AS [e]
    ON d.[EmployeeID] = e.[EmployeeID]
    AND d.[EmployeeID] <> m.[EmployeeID]
WHERE m.[level] = 6
GROUP BY [m].[EmployeeID]
ORDER BY SUM(e.[Salary]) desc;

PRINT REPLICATE('-', 40);

SELECT [m].[EmployeeID], SUM(e.[Salary])
FROM dbo.[EmployeeHierarchyWide] AS [m]
CROSS APPLY dbo.[getDescendants_h]([m].[EmployeeID]) AS [d]
JOIN [dbo].[EmployeeHierarchyWide] AS [e]
    ON d.[EmployeeID] = e.[EmployeeID]
    AND d.[EmployeeID] <> m.[EmployeeID]
WHERE m.[level] = 6
GROUP BY [m].[EmployeeID]
ORDER BY SUM(e.[Salary]) desc;