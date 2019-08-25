use PoSHDemo;
declare @schema sysname
	, @table sysname
	, @prefix char(3) = 'tbl' --what we want to replace
	, @newname sysname
	, @fullname sysname;

declare tables cursor for
	select schema_name(schema_id), name
	from sys.tables
	where name like @prefix + '%'

open tables;
while(1=1)
begin
	fetch next from tables
	into @schema, @table

	if(@@FETCH_STATUS <> 0)
		break;
		
	select @newname = stuff(@table, 1, len(@prefix), ''),
		@fullname = quotename(@schema) + '.' + quotename(@table)

	exec sp_rename @fullname, @newname, 'object'
end

close tables;
deallocate tables;
