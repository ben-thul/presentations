use master;
go
if exists (select 1 from sys.databases where name = 'HierarchyDB')
begin
	alter database [HierarchyDB] set offline with rollback immediate;
	alter database [HierarchyDB] set online;
	drop database [HierarchyDB];
end
create database [HierarchyDB];
alter database [HierarchyDB] set recovery simple;
go