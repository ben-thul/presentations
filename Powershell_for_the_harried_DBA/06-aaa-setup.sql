use master;
if exists (select 1 from sys.databases where name = 'PoSHDemo')
begin
	alter database PoSHDemo set offline with rollback immediate;
	alter database PoSHDemo set online;
	drop database PoSHDemo;
end
create database PoSHDemo;
use PoSHDemo;

create table dbo.tbla (a int)
create table dbo.tblb (a int)
create table dbo.tblc (a int)
create table dbo.tbld (a int)
create table dbo.tble (a int)
go
create schema rename authorization dbo;
go
create table rename.tbla (a int)
create table rename.tblb (a int)
create table rename.tblc (a int)
create table rename.tbld (a int)
create table rename.tble (a int)
create table rename.Bootblacks (a int) --here's a table that contains "tbl" in the middle, so a naive replace won't do
go

select schema_name(schema_id) as [schema], name 
from sys.tables
