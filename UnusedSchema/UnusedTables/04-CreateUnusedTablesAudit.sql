USE master;

IF NOT EXISTS (SELECT 1 FROM sys.[server_audits] AS sa WHERE [name] = 'UnusedTablesAudit')
BEGIN
    CREATE SERVER AUDIT [UnusedTablesAudit]
    TO FILE (
        FILEPATH = 'c:\temp', 
        MAXSIZE = 10MB, 
        MAX_ROLLOVER_FILES = UNLIMITED, 
        RESERVE_DISK_SPACE = OFF
    )
    WITH (
        QUEUE_DELAY = 10000,
        ON_FAILURE = CONTINUE
    )
END

USE [AdventureWorks];

IF NOT EXISTS (SELECT 1 FROM sys.[database_audit_specifications] AS das WHERE name = 'UnusedTablesSpecification')
BEGIN
	CREATE TABLE #tables (SchemaName sysname, TableName sysname);
    INSERT  INTO [#tables]
            SELECT  QUOTENAME(OBJECT_SCHEMA_NAME([object_id])) ,
                    QUOTENAME([name])
            FROM    sys.[tables] AS t
            WHERE   [is_ms_shipped] = 0;
            
    CREATE UNIQUE CLUSTERED INDEX [CI_tables] ON [#tables] ([SchemaName], [TableName])

    CREATE TABLE #UsedTables (SchemaName sysname, TableName sysname);


    WITH xmlnamespaces (
        DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
    ),
    cte AS (
        SELECT --TOP 5
                deqp.[query_plan]
        FROM    sys.[dm_exec_cached_plans] AS decp
        CROSS APPLY sys.[dm_exec_query_plan](decp.[plan_handle]) AS deqp
    )
    INSERT INTO [#UsedTables]
    SELECT DISTINCT
        qp.[ColumnReference].value('@Schema', 'nvarchar(max)') AS [SchemaName],
        qp.[ColumnReference].value('@Table', 'nvarchar(max)') AS [TableName]
    FROM cte AS c
    CROSS APPLY c.query_plan.nodes('//ColumnReference') AS qp([ColumnReference])
    WHERE 1=1
    AND qp.[ColumnReference].exist('@Database') = 1
    AND qp.[ColumnReference].value('@Database', 'nvarchar(max)') = QUOTENAME(DB_NAME())
    AND qp.[ColumnReference].value('@Schema', 'nvarchar(max)') is NOT NULL
    AND qp.[ColumnReference].value('@Table', 'nvarchar(max)') is NOT NULL

    CREATE UNIQUE CLUSTERED INDEX [CI_tables] ON [#UsedTables] ([SchemaName], [TableName])

    DELETE a
    FROM [#tables] AS a
    INNER JOIN [#UsedTables] AS b
        ON [a].[SchemaName] = [b].[SchemaName]
        AND [a].[TableName] = [b].[TableName]
	DECLARE @sql NVARCHAR(MAX)
    SELECT @sql = 'CREATE DATABASE AUDIT SPECIFICATION [UnusedTablesSpecification]' +
        'FOR SERVER AUDIT [UnusedTablesAudit]' +
        STUFF((
            SELECT ', ADD (SELECT ON ' + [SchemaName] + '.' + [TableName] + ' BY [public])'
            FROM [#tables] AS t
            FOR XML PATH('')
        ), 1, 2, '') +
        'WITH (STATE=ON)'
        
    EXEC(@sql)
END