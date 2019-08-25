use [HierarchyDB];
go
declare @employeeid int = 12345;
set statistics io, time on;

select EmployeeID, ManagerID, employeedata
from dbo.getDescendants_j(@employeeid);

print replicate('-', 40);

select EmployeeID, ManagerID, employeedata
from dbo.getDescendants_r(@employeeid);

print replicate('-', 40);

select EmployeeID, ManagerID, employeedata
from dbo.getDescendants_h(@employeeid)