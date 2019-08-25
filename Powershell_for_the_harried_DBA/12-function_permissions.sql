declare @obj sysname, @schema sysname, @sql nvarchar(max);

declare c cursor for
	select schema_name(schema_id), object_name(object_id)
	from sys.objects as o
	where o.type_desc like '%function%'
	and o.type_desc not like '%scalar%';

open c
while(1=1)
begin
	fetch next from c into @schema, @obj
	if(@@FETCH_STATUS<> 0)
		break;

	set @sql = 'grant select on ' + quotename(@schema) + '.' + quotename(@obj) + ' to fn_user'
	exec(@sql);
end

close c
deallocate c