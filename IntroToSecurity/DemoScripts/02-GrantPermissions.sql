USE WorldWideImporters
GO
-- let's look at the permissions for a couple of objects
EXECUTE AS LOGIN = 'OliverTwist';
GO
SELECT fmp.*
FROM sys.objects AS o
CROSS APPLY sys.fn_my_permissions(
    CONCAT(
        QUOTENAME(OBJECT_SCHEMA_NAME(object_id)), '.',
        QUOTENAME(OBJECT_NAME(object_id))
    )
, 'OBJECT') AS fmp
WHERE o.object_id IN (
    OBJECT_ID('Application.StateProvinces'),
    OBJECT_ID('Integration.GetStockHoldingUpdates')
)
GO
REVERT
GO

-- hmm… no permissions. let's grant some

GRANT SELECT ON Application.StateProvinces TO ApplicationUsers
GRANT EXECUTE ON Integration.GetStockHoldingUpdates TO ApplicationUsers

-- ah… that's better
EXECUTE AS LOGIN = 'OliverTwist';
GO
SELECT fmp.*
FROM sys.objects AS o
CROSS APPLY sys.fn_my_permissions(
    CONCAT(
        QUOTENAME(OBJECT_SCHEMA_NAME(object_id)), '.',
        QUOTENAME(OBJECT_NAME(object_id))
    )
, 'OBJECT') AS fmp
WHERE o.object_id IN (
    OBJECT_ID('Application.StateProvinces'),
    OBJECT_ID('Integration.GetStockHoldingUpdates')
)
GO
REVERT
GO

DENY SELECT ON Application.StateProvinces(Border) TO OliverTwist
GO
EXECUTE AS LOGIN = 'OliverTwist'
GO

-- that last DENY prevents us from selecting the Border column
SELECT *
FROM Application.StateProvinces;

-- but if we remove that from the SELECT list, it's fine
SELECT StateProvinceID ,
       StateProvinceCode ,
       StateProvinceName ,
       CountryID ,
       SalesTerritory ,
       --Border ,
       LatestRecordedPopulation ,
       LastEditedBy ,
       ValidFrom ,
       ValidTo
FROM Application.StateProvinces

-- the updated permissions query reflects that Border
-- isn't in the list
SELECT fmp.*
FROM sys.objects AS o
CROSS APPLY sys.fn_my_permissions(
    CONCAT(
        QUOTENAME(OBJECT_SCHEMA_NAME(object_id)), '.',
        QUOTENAME(OBJECT_NAME(object_id))
    )
, 'OBJECT') AS fmp
WHERE o.object_id IN (
    OBJECT_ID('Application.StateProvinces'),
    OBJECT_ID('Integration.GetStockHoldingUpdates')
)
GO
REVERT
GO