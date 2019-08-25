use [PoSHDemo];
go
if exists (select 1 from sys.tables where object_id = object_id('dbo.a_Computed'))
begin
	drop table dbo.a_Computed;
end
create table dbo.a_Computed (
	a int,
	b int,
	c as a + b
);
if exists (select 1 from sys.tables where object_id = object_id('dbo.b_Computed'))
begin
	drop table dbo.b_Computed;
end
create table dbo.b_Computed (
	a int,
	b int,
	c as a + b
);
if exists (select 1 from sys.tables where object_id = object_id('dbo.c_Computed'))
begin
	drop table dbo.c_Computed;
end
create table dbo.c_Computed (
	a int,
	b int,
	c as a + b
);
if exists (select 1 from sys.tables where object_id = object_id('dbo.d_Computed'))
begin
	drop table dbo.d_Computed;
end
create table dbo.d_Computed (
	a int,
	b int,
	c as a + b
);
if exists (select 1 from sys.tables where object_id = object_id('dbo.e_Computed'))
begin
	drop table dbo.e_Computed;
end
create table dbo.e_Computed (
	a int,
	b int,
	c as a + b
);
select object_name(object_id), name, is_persisted
from sys.computed_columns