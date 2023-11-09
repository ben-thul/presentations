use [HierarchyDB];
go

if object_id('[dbo].[getDescendants_r]') is not null
	set noexec on;
go
create function [dbo].[getDescendants_r]()
returns table
as return
select 'not implemented' as [message];
go
set noexec off;
go
alter function dbo.[getDescendants_r](@EmployeeID int)
returns table as
return
	with descendants as (

		select EmployeeID, ManagerID, employeedata, 0 as [level]
		from dbo.EmployeeHierarchyWide
		where EmployeeID = @employeeID

		union all

		-- get descendants
		select child.EmployeeID, child.ManagerID, child.employeedata, parent.[level] + 1 as [level]
		from dbo.EmployeeHierarchyWide as child
		join descendants as parent
			on child.ManagerID = parent.EmployeeID

	)

	select EmployeeID, ManagerID, employeedata, [level]
	from descendants
go
set statistics io, time, xml on;
go
select *
from dbo.getDescendants_r(12345);