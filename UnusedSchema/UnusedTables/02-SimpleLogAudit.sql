USE master;
CREATE SERVER AUDIT [TableInProc_AppLog]
TO APPLICATION_LOG;

ALTER SERVER AUDIT [TableInProc_AppLog] WITH (STATE = ON);

USE [AdventureWorks];

CREATE DATABASE AUDIT SPECIFICATION [BillOfMaterials]
FOR SERVER AUDIT [TableInProc_AppLog]
ADD (SELECT ON [Production].[BillOfMaterials] BY [public])
WITH (STATE = ON);

EXEC dbo.uspGetWhereUsedProductID @StartProductID = 1000, @CheckDate = '2012-09-05';

ALTER DATABASE AUDIT SPECIFICATION [BillOfMaterials]
WITH (STATE = OFF);

DROP DATABASE AUDIT SPECIFICATION [BillOfMaterials];

USE master;
ALTER SERVER AUDIT [TableInProc_AppLog] WITH (STATE = OFF);
DROP SERVER AUDIT [TableInProc_AppLog];