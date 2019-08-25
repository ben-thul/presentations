USE [AdventureWorks];

SELECT * FROM sys.[database_audit_specifications] AS das

SELECT  OBJECT_SCHEMA_NAME(dasd.[major_id]) AS [schema_name] ,
        OBJECT_NAME(dasd.[major_id]) AS [object_name]
FROM    sys.[database_audit_specification_details] AS dasd
INNER JOIN sys.[database_audit_specifications] AS das
        ON [dasd].[database_specification_id] = [das].[database_specification_id]
WHERE   [das].[name] = 'UnusedTablesSpecification'

ALTER DATABASE AUDIT SPECIFICATION [UnusedTablesSpecification]
WITH (STATE = OFF)

ALTER DATABASE AUDIT SPECIFICATION [UnusedTablesSpecification]
DROP (SELECT on Production.ProductInventory BY public)

ALTER DATABASE AUDIT SPECIFICATION [UnusedTablesSpecification]
WITH (STATE = ON)