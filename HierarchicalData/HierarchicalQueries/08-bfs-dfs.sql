use [HierarchyDB];
go

-- Breadth first search
	select top 1000 *, [tree].ToString(), ManagerTree.ToString() 
	from dbo.EmployeeHierarchyWide
	order by [level], [tree]

-- Depth first search
	select top 1000 *, [tree].ToString(), ManagerTree.ToString() 
	from dbo.EmployeeHierarchyWide
	order by [tree], [level]