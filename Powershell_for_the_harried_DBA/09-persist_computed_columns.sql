use [AdventureWorks2014];
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'
ALTER TABLE '
  + QUOTENAME(s.name) + '.' 
  + QUOTENAME(t.name) 
  + ' ALTER COLUMN '
  + QUOTENAME(c.name) 
  + ' ADD PERSISTED;' 
FROM sys.columns AS c
INNER JOIN sys.tables AS t
ON c.[object_id] = t.[object_id]
INNER JOIN sys.schemas AS s
ON t.[schema_id] = s.[schema_id]
WHERE COLUMNPROPERTY(t.[object_id], c.name, N'IsIndexable') = 1
AND COLUMNPROPERTY(t.[object_id], c.name, N'IsDeterministic') = 1
AND t.uses_ansi_nulls = 1
AND c.is_computed = 1
AND EXISTS 
(
  SELECT 1 FROM sys.computed_columns
  WHERE [object_id] = t.[object_id]
  AND column_id = c.column_id
  AND is_persisted = 0
);

PRINT @sql;
--EXEC sp_executesql @sql;
