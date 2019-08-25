declare tablez cursor for
    select schema_name([schema_id]), t.name 
    from sys.tables t
    left join sysarticles a
       on t.[object_id] = a.[objid] 
    where OBJECTPROPERTY([object_id], 'IsMSShipped') = 0  --no system objects
       and OBJECTPROPERTY([object_id], 'TableHasPrimaryKey') = 1 --only give me tables that can be replicated, please
       and a.[objid] is null --not already an article
open tablez
declare @schema sysname, @table sysname, @fullname sysname
while (1=1)
begin
    fetch next from tablez into @schema, @table
    if (@@FETCH_STATUS <> 0)
        break
    set @fullname = @schema + '.' + @table
    exec sp_addarticle
		@publication = 'Adventureworks_Publication',
        @article = @fullname,
        @source_object = @table,
        @destination_table = @table,
        @type = 'logbased',
        @schema_option = 0x000000000803509F,
        @destination_owner = @schema,
        @status = 16, 
        @source_owner = @schema,
        @identityrangemanagementoption='manual'

end
close tablez
deallocate tablez
