use [PoSHDemo];
declare @boundaries_to_add int = 200, @sql nvarchar(max), @partition_function sysname = 'Id_PF_Left';
declare @boundary int = 
(
	select max( cast(prv.value as int) )
	from sys.partition_functions as pf
	join sys.partition_range_values as prv
		on pf.function_id = prv.function_id
	where pf.name = @partition_function

);

while(@boundaries_to_add > 0)
begin
	alter partition scheme [Id_PS_Left] next used [USER_DATA]
	set @boundary += 1;
	set @sql = 'alter partition function ' + quotename(@partition_function) + '() split range (' + cast(@boundary as varchar) + ')'
	exec(@sql)
	set @boundaries_to_add -= 1;
end