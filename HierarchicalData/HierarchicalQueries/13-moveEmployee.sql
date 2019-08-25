use [HierarchyDB];
go
if object_id('[dbo].[moveEmployee]') is not null
	set noexec on;
go
create procedure [dbo].[moveEmployee]
as select 'not implemented' as [message];
go
set noexec off;
go
alter procedure [dbo].[moveEmployee] (
	@employeeID int,
	@newManagerID int
)
as
begin
	set nocount on;

	declare @newManagerTree hierarchyid, @oldTree hierarchyid;
	set @newManagerTree = (
		select tree from dbo.EmployeeHierarchyWide
		where EmployeeID = @newManagerID
	);

	set @oldTree = (
		select tree
		from dbo.EmployeeHierarchyWide
		where EmployeeID = @employeeID
	);

	if (@oldTree is not null and @newManagerID is not null)
	begin

		begin tran

			update dbo.EmployeeHierarchyWide
			set ManagerID = @newManagerID
			where EmployeeID = @employeeID;

			with cte as (
				select tree, tree.GetReparentedValue(@oldTree.GetAncestor(1), @newManagerTree) as newTree
				from dbo.EmployeeHierarchyWide
				where tree.IsDescendantOf(@oldTree) = 1
			)

			update cte
			set tree = newTree;

		commit
	end
end
go