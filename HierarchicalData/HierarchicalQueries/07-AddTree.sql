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
	on c.EmployeeID = e.EmployeeID;
go
alter table dbo.EmployeeHierarchyWide add [level] as [tree].GetLevel() persisted
create unique index [UIX_EmployeeHierarchyWide__tree] on dbo.EmployeeHierarchyWide (tree);
create unique index [UIX_EmployeeHierarchyWide__level_tree] on dbo.EmployeeHierarchyWide (level, tree);

alter table dbo.EmployeeHierarchyWide add [ManagerTree] as case 
	when [ManagerID] is null then cast(null as hierarchyid) 
	else [tree].GetAncestor(1) end persisted
create index [IX_EmployeeHierarchyWide__ManagerTree] on dbo.EmployeeHierarchyWide (ManagerTree);
alter table dbo.EmployeeHierarchyWide add constraint [FK_EmployeeHierarchyWide__ManagerTree] 
	foreign key ([ManagerTree]) references dbo.EmployeeHierarchyWide ([tree]);
