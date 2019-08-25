USE WorldWideImporters
GO
IF SUSER_ID('OliverTwist') IS NULL
    CREATE LOGIN OliverTwist WITH PASSWORD = 'PleaseSirIWantSomeMore!';
IF SUSER_ID('ApplicationLogins') IS NULL
    CREATE SERVER ROLE ApplicationLogins AUTHORIZATION sa;
ALTER SERVER ROLE ApplicationLogins ADD MEMBER OliverTwist;

IF USER_ID('OliverTwist') IS NOT NULL
    DROP USER OliverTwist;
CREATE USER OliverTwist FOR LOGIN OliverTwist;
GO
IF USER_ID('ApplicationUsers') IS NOT NULL
    DROP ROLE ApplicationUsers
CREATE ROLE ApplicationUsers AUTHORIZATION dbo;
ALTER ROLE ApplicationUsers ADD MEMBER OliverTwist;
GO

EXECUTE AS LOGIN = 'OliverTwist'
GO
SELECT
     lt.name ,
     lt.type ,
     lt.usage
FROM sys.login_token AS lt;

SELECT
     ut.name ,
     ut.type ,
     ut.usage
FROM sys.user_token AS ut;
GO

REVERT