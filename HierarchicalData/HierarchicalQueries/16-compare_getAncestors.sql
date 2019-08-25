use [HierarchyDB];
go
declare @employeeid int = 12345;
set statistics io, time on;

select EmployeeID, ManagerID, employeedata
from dbo.getAncestors_j(@employeeid);

print replicate('-', 40);

select EmployeeID, ManagerID, employeedata
from dbo.getAncestors_r(@employeeid);

print replicate('-', 40);

select EmployeeID, ManagerID, employeedata
from dbo.getAncestors_h(@employeeid)