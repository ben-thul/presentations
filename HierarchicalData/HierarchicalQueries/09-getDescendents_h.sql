use [HierarchyDB];
go
if object_id('[dbo].[getDescendants_h]') is not null
	set noexec on;
go
create function [dbo].[getDescendants_h]()
returns table
as return
select 'not implemented' as [message];
go
set noexec off;
go
alter function dbo.getDescendants_h(@EmployeeID int)
returns table as
return

	select [child].*
	from dbo.EmployeeHierarchyWide as [child]
	join dbo.EmployeeHierarchyWide as [parent]
		on [child].tree.IsDescendantOf([parent].tree) = 1
	where [parent].EmployeeID = @EmployeeID;

go
set statistics io, time, xml on;
go
select *
from dbo.getDescendants_h(12345);