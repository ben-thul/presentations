use [HierarchyDB];

select EmployeeID, tree.ToString()
from dbo.GetDescendants_h(12345)
order by tree;

exec dbo.moveEmployee 
	@employeeID = 12345, 
	@newManagerID = 8390;

select EmployeeID, tree.ToString()
from dbo.GetDescendants_h(12345)
order by tree;
