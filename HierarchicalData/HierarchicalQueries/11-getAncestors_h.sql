use [HierarchyDB];
go
if object_id('[dbo].[getAncestors_h]') is not null
	set noexec on;
go
create function [dbo].[getAncestors_h]()
returns table
as return
select 'not implemented' as [message];
go
set noexec off;
go
alter function dbo.[getAncestors_h](@EmployeeID int)
returns table as
return

	select [parent].EmployeeID, [parent].ManagerID, [parent].employeedata, parent.[level]
	from dbo.EmployeeHierarchyWide as [child]
	cross apply clr.ListAncestors([child].[tree]) as [parent_tree]
	join dbo.EmployeeHierarchyWide as [parent]
		on [parent_tree].ancestor = [parent].tree
	where [child].EmployeeID = @EmployeeID;
go

set statistics io, time, xml on;
go
select *
from dbo.getAncestors_h(12345)
ORDER BY [level];