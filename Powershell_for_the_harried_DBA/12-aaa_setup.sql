use [PoSHDemo];
go
create user fn_user without login;
go
create function dbo.fn_a()
returns table as
return
	select 1 as [message]
go
grant select, view definition on dbo.fn_a to fn_user;
go
create function dbo.fn_b()
returns table as
return
	select 1 as [message]
go
create function dbo.fn_c()
returns table as
return
	select 1 as [message]
go
create function dbo.fn_d()
returns datetime as
begin
	declare @d datetime
	select @d = getdate();
	return @d;
end
go
select object_name(major_id), user_name(grantee_principal_id), permission_name, state_desc, o.type_desc
from sys.database_permissions as dp
join sys.objects as o
	on dp.major_id = o.object_id
where o.type_desc like '%function%'