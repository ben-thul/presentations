USE WorldWideImporters;
GO

-- let's check the ownership of some objects
SELECT TOP (50)
       SCHEMA_NAME( o.schema_id )  AS [schema_name] ,
       o.name ,
       o.type_desc ,
       USER_NAME( o.principal_id ) AS [owner]
FROM   sys.objects AS o
WHERE  o.is_ms_shipped = 0;

-- what's going on here? unless an object's owner differs
-- from the schema's owner, it's recorded as NULL

-- so let's get the schema owner

SELECT TOP (50)
       s.name AS [schema_name],
       o.name ,
       o.type_desc ,
       USER_NAME( COALESCE( o.principal_id, s.principal_id )) AS [owner]
FROM   sys.objects AS o
JOIN   sys.schemas AS s
    ON s.schema_id = o.schema_id
WHERE  o.is_ms_shipped = 0;

-- alternatively, the OwnerId is available through objectpropertyex
-- I'd use this personally
SELECT TOP (50)
       SCHEMA_NAME( o.schema_id ) AS [schema_name] ,
       o.name ,
       o.type_desc ,
       USER_NAME(CAST(OBJECTPROPERTYEX(o.object_id, 'OwnerId') AS INT)) AS [owner]
FROM   sys.objects AS o
WHERE  o.is_ms_shipped = 0;