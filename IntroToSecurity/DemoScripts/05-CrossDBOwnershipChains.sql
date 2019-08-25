USE master;
GO
ALTER DATABASE ChainTest SET OFFLINE WITH ROLLBACK IMMEDIATE;
ALTER DATABASE ChainTest SET ONLINE;

go
DROP DATABASE IF EXISTS ChainTest;
go
CREATE DATABASE ChainTest
GO
USE ChainTest;
GO
IF USER_ID('OliverTwist') IS NOT NULL
    DROP USER OliverTwist;
CREATE USER OliverTwist FOR LOGIN OliverTwist;
GO

-- back to the basic version of the procedure
CREATE OR ALTER PROCEDURE dbo.usp_getCities
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP(10) *
    FROM WorldWideImporters.Application.Cities AS c;
END
GO
GRANT EXECUTE ON dbo.usp_getCities TO OliverTwist;
GO

EXECUTE AS LOGIN = 'OliverTwist';
GO
-- as expected, this doesn't work (since by default
-- chainging doesn't cross db boundaries)
EXECUTE dbo.usp_getCities 
GO
REVERT
GO

-- so let's turn on database chaining for each
-- of the databases
ALTER DATABASE ChainTest SET DB_CHAINING ON;
ALTER DATABASE WorldWideImporters SET DB_CHAINING ON;

-- let's try again
EXECUTE AS LOGIN = 'OliverTwist';
GO
-- this didn't work either! hmm…
EXECUTE dbo.usp_getCities 
GO
REVERT
GO

-- let's check the database properties
SELECT name, d.is_db_chaining_on, SUSER_SNAME(d.owner_sid)
FROM sys.databases AS d
WHERE name IN ('ChainTest', 'WorldWideImporters')

ALTER AUTHORIZATION ON DATABASE::ChainTest TO [sa];

EXECUTE AS LOGIN = 'OliverTwist';
GO
-- as expected, this doesn't work
EXECUTE dbo.usp_getCities 
GO
REVERT
GO