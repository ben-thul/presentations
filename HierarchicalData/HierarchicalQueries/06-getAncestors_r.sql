use [HierarchyDB];
go
if object_id('[dbo].[getAncestors_r]') is not null
	set noexec on;
go
create function [dbo].[getAncestors_r]()
returns table
as return
select 'not implemented' as [message];
go
set noexec off;
go
alter function dbo.[getAncestors_r](@EmployeeID int)
returns table as
return
	with ancestors as (

		select EmployeeID, ManagerID, employeedata, 0 as [level]
		from dbo.EmployeeHierarchyWide
		where EmployeeID = @employeeID

		union all

		-- get descendants
		select parent.EmployeeID, parent.ManagerID, parent.employeedata, child.[level] - 1 as [level]
		from dbo.EmployeeHierarchyWide as parent
		join ancestors as child
			on child.ManagerID = parent.EmployeeID

	)

	select EmployeeID, ManagerID, employeedata, [level]
	from ancestors
go
set statistics io, time, xml on;
go
select *
from dbo.getAncestors_r(12345)
order by [level];