use HierarchyDB;
go
if object_id('[dbo].[getSiblings]') is not null
	set noexec on;
go
create function [dbo].[getSiblings]()
returns table as return
	select 'not implemented' as [message];
go
set noexec off;
go
alter function dbo.getSiblings( @employeeID int, @level tinyint)
returns table
as return

	select [child].[EmployeeID], [child].[tree].ToString() as [tree]
	from dbo.EmployeeHierarchyWide as e
	join dbo.EmployeeHierarchyWide as [parent]
		on [parent].[tree] = [e].[tree].GetAncestor(@level)
	join dbo.EmployeeHierarchyWide as [child]
		on [child].[tree].IsDescendantOf([parent].[tree]) = 1
		and [child].[level] = [e].[level]
		and [child].[EmployeeID] <> @employeeID
	where [e].[EmployeeID] = @employeeID
go

set statistics io, time, xml on;
go
declare @employeeid int = 12345;

select tree.ToString()
from dbo.EmployeeHierarchyWide
where EmployeeID = @employeeid;

select *
from dbo.getSiblings(@employeeid, 2);