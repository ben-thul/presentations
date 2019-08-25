use HierarchyDB;
go

alter table dbo.EmployeeHierarchyWide add [tree] hierarchyid null;
go
with cte as (

	select *, cast(CONCAT('/', EmployeeID, '/') as varchar(max)) as [h]
	from dbo.EmployeeHierarchyWide
	where ManagerID is null

	union all

	select child.*, cast(concat(parent.[h], child.EmployeeID, '/') as varchar(max))
	from dbo.EmployeeHierarchyWide as child
	join cte as parent
		on child.ManagerID = parent.EmployeeID
)
update e
set [tree] = [h]
from cte as c
join dbo.EmployeeHierarchyWide as e
	on c.EmployeeID = e.EmployeeID