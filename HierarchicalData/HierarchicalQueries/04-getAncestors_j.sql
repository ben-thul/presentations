use [HierarchyDB];
go
if object_id('[dbo].[getAncestors_j]') is not null
	set noexec on;
go
create function [dbo].[getAncestors_j]()
returns table
as return
select 'not implemented' as [message];
go
set noexec off;
go

alter function dbo.getAncestors_j(@employeeID int)
returns table as
return

	with managers as (
		select ManagerID
		from (
			select EmployeeID, 
				l1_manager, 
				l2_manager, 
				l3_manager, 
				l4_manager, 
				l5_manager, 
				l6_manager 
			from dbo.vw_EmployeeHierarchyWide
		) as p
		unpivot (
			ManagerID
			for Level in (l1_manager, l2_manager, l3_manager, l4_manager, l5_manager, l6_manager)
		) as u
		where EmployeeID = @employeeid
	)
	select e.EmployeeID, e.ManagerID, e.employeedata
	from dbo.EmployeeHierarchyWide as e
	join managers as m
		on e.EmployeeID = m.ManagerID

	union all

	select EmployeeID, ManagerID, employeedata
	from dbo.EmployeeHierarchyWide
	where EmployeeID = @employeeID

go
set statistics io, time, xml on;
go
select *
from dbo.getAncestors_j(12345);