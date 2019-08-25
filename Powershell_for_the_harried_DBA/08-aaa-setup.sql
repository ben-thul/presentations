use [PoSHDemo];
go
create function dbo.myGetDate()
returns datetime2
as
begin
	return getdate()
end
go
create table a_Default (
	a int,
	TS datetime2 not null
		constraint [DF_a_TS] default dbo.myGetDate()
)
create table b_Default (
	a int,
	TS datetime2 not null
		constraint [DF_b_TS] default dbo.myGetDate()
);
create table c_Default (
	a int,
	TS datetime2 not null
		constraint [DF_c_TS] default dbo.myGetDate()
);
create table d_Default (
	a int,
	TS datetime2 not null
		constraint [DF_d_TS] default dbo.myGetDate()
);
create table e_Default (
	a int,
	TS datetime2 not null
		constraint [DF_e_TS] default dbo.myGetDate()
);
