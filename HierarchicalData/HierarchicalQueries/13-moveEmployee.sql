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

	declare @newManagerTree hierarchyid, @Tree hierarchyid;
	set @newManagerTree = (
		select tree from dbo.EmployeeHierarchyWide
		where EmployeeID = @newManagerID
	);

	set @Tree = (
		select tree
		from dbo.EmployeeHierarchyWide
		where EmployeeID = @employeeID
	);

	if (@Tree is not null and @newManagerID is not null)
	begin

		begin tran;

			with cte as (
				select tree, 
					newTree = tree.GetReparentedValue(@Tree.GetAncestor(1), @newManagerTree)
				from dbo.EmployeeHierarchyWide
				where tree.IsDescendantOf(@Tree) = 1
			)

			update cte
			set tree = newTree;

		commit
	end
end
go