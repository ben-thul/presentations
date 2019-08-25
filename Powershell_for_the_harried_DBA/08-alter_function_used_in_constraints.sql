declare @schema sysname, @tbl sysname, @col sysname, @definition nvarchar(max), @df_name sysname, @full_tbl sysname;

if object_id('tempdb.dbo.#stmts') is not null
	drop table #stmts;

create table #stmts (
	[c] nvarchar(max), --holds the create statement
	[d] nvarchar(max)  --holds the drop statement
)

declare t cursor for
	select object_schema_name(parent_object_id)
		, object_name(parent_object_id)
		, col_name(parent_object_id, parent_column_id)
		, [definition]
		, name
	from sys.default_constraints
	where definition like '%myGetDate%'
open t
while (1=1)
begin
	fetch next from t into @schema, @tbl, @col, @definition, @df_name;
	if (@@FETCH_STATUS <> 0)
		break;
	set @full_tbl = quotename(@schema) + '.' + quotename(@tbl);
	insert into #stmts ([c], [d])
	select 'alter table ' + @full_tbl + ' add constraint ' + quotename(@df_name) + ' default ' + @definition + ' for ' + @col,
		'alter table ' + @full_tbl + ' drop constraint ' + quotename(@df_name);
end
close t
deallocate t

select * from #stmts