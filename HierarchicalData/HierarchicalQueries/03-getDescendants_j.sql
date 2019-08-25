use [HierarchyDB];
go
if object_id('[dbo].[getDescendants_j]') is not null
	set noexec on;
go
create function [dbo].[getDescendants_j]()
returns table
as return
select 'not implemented' as [message];
go
set noexec off;
go

alter function dbo.[getDescendants_j](@employeeID int)
returns table as
return
	select EmployeeID, ManagerID, employeedata, level
	from dbo.vw_EmployeeHierarchyWide
	where @employeeID in (
		EmployeeID, 
		l1_manager, 
		l2_manager, 
		l3_manager, 
		l4_manager, 
		l5_manager, 
		l6_manager
	);

go
set statistics io, time on;
go
select *
from dbo.[getDescendants_j](12345)
