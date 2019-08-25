USE master;
CREATE SERVER AUDIT [TableInProc_file]
TO FILE ( FILEPATH = 'c:\temp\' );

ALTER SERVER AUDIT [TableInProc_file] WITH (STATE = ON);

USE [AdventureWorks];

EXEC sp_helptext 'dbo.uspGetWhereUsedProductID';

CREATE DATABASE AUDIT SPECIFICATION [BillOfMaterials]
FOR SERVER AUDIT [TableInProc_file]
ADD (SELECT ON [Production].[BillOfMaterials] BY [public])
WITH (STATE = ON);

EXEC dbo.uspGetWhereUsedProductID @StartProductID = 1, @CheckDate = '2012-09-05';

SELECT * FROM [sys].[fn_get_audit_file]('c:\temp\TableInProc_file*.sqlaudit', DEFAULT, DEFAULT) AS fgaf;

SELECT * FROM sys.[dm_audit_actions] AS daa

ALTER DATABASE AUDIT SPECIFICATION [BillOfMaterials]
WITH (STATE = OFF);

DROP DATABASE AUDIT SPECIFICATION [BillOfMaterials];

USE master;
ALTER SERVER AUDIT [TableInProc_file] WITH (STATE = OFF);
DROP SERVER AUDIT [TableInProc_file];
