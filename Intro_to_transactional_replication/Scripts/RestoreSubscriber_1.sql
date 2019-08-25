restore database [AdventureWorks_Backup_Subscriber] from disk='c:\adventureworks.bak' with 

move 'AdventureWorks_Data' to 'C:\Program Files\Microsoft SQL Server\MSSQL10.SUBSCRIBER\MSSQL\DATA\AdventureWorks_Data.mdf',
move 'AdventureWorks_Log' to 'C:\Program Files\Microsoft SQL Server\MSSQL10.SUBSCRIBER\MSSQL\DATA\AdventureWorks_Log.ldf'
go
alter database [AdventureWorks_Backup_Subscriber] set recovery simple
go
use [AdventureWorks_Backup_Subscriber]
go
exec sp_removedbreplication
go
declare trigs cursor for
	select schema_id, name from sys.objects
	where type = 'TR'
open trigs
declare @schema_id int, @name sysname, @sql varchar(max)
while(1=1)
begin
	fetch next from trigs into @schema_id, @name
	if (@@FETCH_STATUS <> 0)
		break
	else
	begin
		set @sql = 'drop trigger ' + quotename(schema_name(@schema_id)) + '.' + QUOTENAME(@name)
		exec(@sql)
	end
end
close trigs
deallocate trigs