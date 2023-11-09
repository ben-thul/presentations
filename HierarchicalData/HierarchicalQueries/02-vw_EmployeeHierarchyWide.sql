use HierarchyDB;
go

if (object_id('dbo.vw_EmployeeHierarchyWide') is not null)
set noexec on;
go
create view dbo.vw_EmployeeHierarchyWide
as
    select 'not implemented' as [message];
go
set noexec off;
go
alter view dbo.vw_EmployeeHierarchyWide
as
    select l1.EmployeeID, l1.ManagerID, l1.employeedata, [l1].[Salary],
        1 as [level], 
        null as [l1_manager],
        null as [l2_manager],
        null as [l3_manager],
        null as [l4_manager],
        null as [l5_manager],
        null as [l6_manager]
    from dbo.EmployeeHierarchyWide as l1
    where l1.ManagerID is null

    union all

    select l2.EmployeeID, l2.ManagerID, l2.employeedata, l2.[Salary],
        2 as [level], 
        l1.EmployeeID as [l1_manager],
        null as [l2_manager],
        null as [l3_manager],
        null as [l4_manager],
        null as [l5_manager],
        null as [l6_manager]
    from dbo.EmployeeHierarchyWide as l1
    join dbo.EmployeeHierarchyWide as l2
        on l2.ManagerID = l1.EmployeeID
    where l1.ManagerID is null

    union all

    select l3.EmployeeID, l3.ManagerID, l3.employeedata, [l3].[Salary],
        3 as [level], 
        l1.EmployeeID as [l1_manager],
        l2.EmployeeID as [l2_manager],
        null as [l3_manager],
        null as [l4_manager],
        null as [l5_manager],
        null as [l6_manager]
    from dbo.EmployeeHierarchyWide as l1
    join dbo.EmployeeHierarchyWide as l2
        on l2.ManagerID = l1.EmployeeID
    join dbo.EmployeeHierarchyWide as l3
        on l3.ManagerID = l2.EmployeeID
    where l1.ManagerID is null

    union all

    select l4.EmployeeID, l4.ManagerID, l4.employeedata, l4.[Salary],
        4 as [level], 
        l1.EmployeeID as [l1_manager],
        l2.EmployeeID as [l2_manager],
        l3.EmployeeID as [l3_manager],
        null as [l4_manager],
        null as [l5_manager],
        null as [l6_manager]
    from dbo.EmployeeHierarchyWide as l1
    join dbo.EmployeeHierarchyWide as l2
        on l2.ManagerID = l1.EmployeeID
    join dbo.EmployeeHierarchyWide as l3
        on l3.ManagerID = l2.EmployeeID
    join dbo.EmployeeHierarchyWide as l4
        on l4.ManagerID = l3.EmployeeID
    where l1.ManagerID is null

    union all

    select l5.EmployeeID, l5.ManagerID, l5.employeedata, l5.[Salary],
        5 as [level], 
        l1.EmployeeID as [l1_manager],
        l2.EmployeeID as [l2_manager],
        l3.EmployeeID as [l3_manager],
        l4.EmployeeID as [l4_manager],
        null as [l5_manager],
        null as [l6_manager]
    from dbo.EmployeeHierarchyWide as l1
    join dbo.EmployeeHierarchyWide as l2
        on l2.ManagerID = l1.EmployeeID
    join dbo.EmployeeHierarchyWide as l3
        on l3.ManagerID = l2.EmployeeID
    join dbo.EmployeeHierarchyWide as l4
        on l4.ManagerID = l3.EmployeeID
    join dbo.EmployeeHierarchyWide as l5
        on l5.ManagerID = l4.EmployeeID
    where l1.ManagerID is null

    union all

    select l6.EmployeeID, l6.ManagerID, l6.employeedata, l6.[Salary],
        6 as [level], 
        l1.EmployeeID as [l1_manager],
        l2.EmployeeID as [l2_manager],
        l3.EmployeeID as [l3_manager],
        l4.EmployeeID as [l4_manager],
        l5.EmployeeID as [l5_manager],
        null as [l6_manager]
    from dbo.EmployeeHierarchyWide as l1
    join dbo.EmployeeHierarchyWide as l2
        on l2.ManagerID = l1.EmployeeID
    join dbo.EmployeeHierarchyWide as l3
        on l3.ManagerID = l2.EmployeeID
    join dbo.EmployeeHierarchyWide as l4
        on l4.ManagerID = l3.EmployeeID
    join dbo.EmployeeHierarchyWide as l5
        on l5.ManagerID = l4.EmployeeID
    join dbo.EmployeeHierarchyWide as l6
        on l6.ManagerID = l5.EmployeeID
    where l1.ManagerID is null

    union all

    select l7.EmployeeID, l7.ManagerID, l7.employeedata, l7.[Salary],
        7 as [level], 
        l1.EmployeeID as [l1_manager],
        l2.EmployeeID as [l2_manager],
        l3.EmployeeID as [l3_manager],
        l4.EmployeeID as [l4_manager],
        l5.EmployeeID as [l5_manager],
        l6.EmployeeID as [l6_manager]
    from dbo.EmployeeHierarchyWide as l1
    join dbo.EmployeeHierarchyWide as l2
        on l2.ManagerID = l1.EmployeeID
    join dbo.EmployeeHierarchyWide as l3
        on l3.ManagerID = l2.EmployeeID
    join dbo.EmployeeHierarchyWide as l4
        on l4.ManagerID = l3.EmployeeID
    join dbo.EmployeeHierarchyWide as l5
        on l5.ManagerID = l4.EmployeeID
    join dbo.EmployeeHierarchyWide as l6
        on l6.ManagerID = l5.EmployeeID
    join dbo.EmployeeHierarchyWide as l7
        on l7.ManagerID = l6.EmployeeID
    where l1.ManagerID is null
go

set statistics io, time on;
set statistics xml on;
go
select * 
from dbo.vw_EmployeeHierarchyWide
where EmployeeID = 123456;