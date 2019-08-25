use [HierarchyDB];
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

-- Breadth first search
	select top 1000 *, [tree].ToString(), ManagerTree.ToString() 
	from dbo.EmployeeHierarchyWide
	order by [level], [tree]

-- Depth first search
	select top 1000 *, [tree].ToString(), ManagerTree.ToString() 
	from dbo.EmployeeHierarchyWide
	order by [tree], [level]