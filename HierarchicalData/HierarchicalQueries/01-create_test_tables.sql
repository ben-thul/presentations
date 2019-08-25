USE HierarchyDB;
GO

IF EXISTS (SELECT * FROM sys.tables WHERE object_id = object_id('dbo.EmployeeHierarchyWide'))
	DROP TABLE dbo.EmployeeHierarchyWide
GO

CREATE TABLE dbo.EmployeeHierarchyWide
(
	EmployeeID INT IDENTITY(1,1) NOT NULL,
		CONSTRAINT[PK_EmployeeHierarchyWide] PRIMARY KEY NONCLUSTERED (EmployeeID),
	ManagerID INT NULL REFERENCES dbo.EmployeeHierarchyWide (EmployeeID),
	employeedata VARCHAR(300) NOT NULL,
    Salary INT NOT NULL,
	CONSTRAINT [UQ_EmployeeHierarchyWide] UNIQUE CLUSTERED (ManagerID, EmployeeID)
)
GO

INSERT dbo.EmployeeHierarchyWide
(
	ManagerID, 
	employeedata,
    Salary
) 
SELECT
	NULL, 
	REPLICATE('x', (RAND(CHECKSUM(NEWID())) * 225) + 75),
    ABS(CHECKSUM(NEWID())) / 100
GO

INSERT dbo.EmployeeHierarchyWide
(
	ManagerID, 
	employeedata,
    Salary
) 
SELECT
	EmployeeID, 
	REPLICATE('x', (RAND(CHECKSUM(NEWID())) * 225) + 75),
    ABS(CHECKSUM(NEWID())) / 100
FROM dbo.EmployeeHierarchyWide AS e0
CROSS JOIN
(
	VALUES
		(1),
		(2),
		(3),
		(4),
		(5),
		(6),
		(7),
		(8),
		(9),
		(10)
) AS v(n)
WHERE 
	NOT EXISTS
	(
		SELECT
			*
		FROM dbo.EmployeeHierarchyWide AS e1
		WHERE
			e1.ManagerID = e0.EmployeeID
	)
GO 6


/*
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'dbo' AND name = 'EmployeeHierarchyDeep')
	DROP TABLE dbo.EmployeeHierarchyDeep
GO

CREATE TABLE dbo.EmployeeHierarchyDeep
(
	EmployeeID INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED,
	ManagerID INT NULL REFERENCES dbo.EmployeeHierarchyDeep (EmployeeID),
	employeedata VARCHAR(300) NOT NULL,
	UNIQUE CLUSTERED (ManagerID, EmployeeID)
)
GO

INSERT dbo.EmployeeHierarchyDeep
(
	ManagerID, 
	employeedata
) 
SELECT
	NULL, 
	REPLICATE('x', (RAND(CHECKSUM(NEWID())) * 225) + 75)
GO

INSERT dbo.EmployeeHierarchyDeep
(
	ManagerID, 
	employeedata
) 
SELECT
	EmployeeID, 
	REPLICATE('x', (RAND(CHECKSUM(NEWID())) * 225) + 75)
FROM dbo.EmployeeHierarchyDeep AS e0
CROSS JOIN
(
	VALUES
		(1),
		(2)
) AS v(n)
WHERE 
	NOT EXISTS
	(
		SELECT
			*
		FROM dbo.EmployeeHierarchyDeep AS e1
		WHERE
			e1.ManagerID = e0.EmployeeID
	)
GO 19
*/