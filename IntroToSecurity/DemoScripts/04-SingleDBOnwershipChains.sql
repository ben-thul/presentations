USE WorldWideImporters;
GO

IF USER_ID('TinyTim') IS NOT NULL
    DROP USER TinyTim;
CREATE USER TinyTim WITHOUT LOGIN;
GO
-- let's create a procedure as dbo
CREATE OR ALTER PROCEDURE dbo.usp_getCities
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP(10) *
    FROM Application.Cities AS c;
END
GO
GRANT EXECUTE ON dbo.usp_getCities TO ApplicationUsers;
GO
EXECUTE AS LOGIN = 'OliverTwist';
GO
-- since the procedure and the table it references
-- are owned by the same user, the procedure works
EXECUTE dbo.usp_getCities;
GO
REVERT
GO

-- now lets's change the ownership of the procedure
-- this breaks the ownership chain as the table 
-- (owned by dbo) and the proc (now owned by ApplicationUsers)
-- have different owners
ALTER AUTHORIZATION ON OBJECT::dbo.usp_getCities TO ApplicationUsers;
GO
EXECUTE AS LOGIN = 'OliverTwist';
GO
-- as expected, this doesn't work because the ownership chain
-- is broken
EXECUTE dbo.usp_getCities 
GO
REVERT
GO

-- let's make a slightly more complex case
-- first, we set the ownership on the procedure back to dbo
ALTER AUTHORIZATION ON OBJECT::dbo.usp_getCities TO dbo;
-- we also have to re-grant permission on the proc
-- because of the ownership change
GRANT EXECUTE ON dbo.usp_getCities TO ApplicationUsers;
GO
CREATE OR ALTER FUNCTION dbo.getCitiesByStateProvinceCode(
    @StateProvinceCode NVARCHAR(10)
)
RETURNS TABLE 
AS
RETURN (
    SELECT StateProvinceID
    FROM Application.StateProvinces AS sp
    WHERE StateProvinceCode = @StateProvinceCode
);
GO

CREATE OR ALTER PROCEDURE dbo.usp_getCities (
    @StateProvinceCode NVARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP(10) c.*
    FROM Application.Cities AS c
    JOIN dbo.getCitiesByStateProvinceCode(@StateProvinceCode) AS gcbspc
        ON gcbspc.StateProvinceID = c.StateProvinceID;
END
GO

EXECUTE AS LOGIN = 'OliverTwist';
GO
EXECUTE dbo.usp_getCities @StateProvinceCode = 'MN'
-- because the procedure and everything it references
-- (recursively) is owned by dbo, only execute permission
-- is needed on the procedure

GO
REVERT
GO

-- let's change the ownership of some of the objects in the query
ALTER AUTHORIZATION ON dbo.getCitiesByStateProvinceCode TO TinyTim;
ALTER AUTHORIZATION ON Application.StateProvinces TO TinyTim;
GRANT SELECT ON dbo.getCitiesByStateProvinceCode TO ApplicationUsers;

-- here's what the ownership chain looks like right now:
-- (*) denotes that a permission has been explicitly granted 
--    to ApplicationUsers for that object
--
-- [dbo] dbo.usp_getCities (*)
--     [dbo] Application.Cities
--     [tim] dbo.getCitiesByStateProvinceCode (*)
--         [tim] Application.StateProvinces
EXECUTE AS LOGIN = 'OliverTwist';
GO
EXECUTE dbo.usp_getCities @StateProvinceCode = 'MN'
GO
REVERT
GO
-- this works! let's walk through the particulars
-- * OliverTwist tries to execute the procedure
-- * by membership in the ApplicationUsers role, he can
-- * a SELECT is called that references two objects
--    * permissions are not checked for Application.Cities since it
--      has the same owner as the calling procedure
--    * permissions are checked for dbo.getCitiesByStateProvinceCode
--      since ownership differs between it and the calling object
--        * permissions were GRANTed to ApplicationUsers, so we continue
--        * permissions aren't checked for Application.Cities because
--          both it and the function are owned by TinyTim
