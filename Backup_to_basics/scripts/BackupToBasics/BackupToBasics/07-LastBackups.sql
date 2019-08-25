use [msdb]
go
set transaction isolation level read uncommitted;

with databases as (
    select name
    from sys.databases where state_desc <> 'OFFLINE'
), backups as
(
    select 
        bs.database_name,
        bs.type,
        bmf.physical_device_name,
        bs.backup_size,
        --bs.compressed_backup_size,
        CONVERT(BIGINT, LOG(bs.backup_size)/LOG(1024)) AS [backup_size_magnitude],
        --CONVERT(BIGINT, LOG(bs.compressed_backup_size)/LOG(1024)) AS [compressed_backup_size_magnitude],
        backup_start_date,
        backup_finish_date,
        rank() over (partition by bs.database_name, bs.type order by bs.backup_start_date desc) as [rank]
    from backupmediafamily bmf
    inner join backupset bs
        on bmf.media_set_id = bs.media_set_id
    inner join sys.databases d 
        on bs.database_name = d.name
    where (bs.type = 'L' and d.recovery_model_desc <> 'SIMPLE')
        or bs.type <> 'L'
        and is_copy_only = 0
)
select d.name
    , type
    , physical_device_name
    , backup_size
    , CONVERT(DECIMAL(17,2), backup_size/POWER(cast(1024 as bigint), [backup_size_magnitude]) ) AS [backup_size]
	, CASE [backup_size_magnitude] 
        WHEN 0 THEN 'B' 
        WHEN 1 THEN 'KiB' 
        WHEN 2 THEN 'MiB'
        WHEN 3 THEN 'GiB'
        WHEN 4 then 'TiB'
    END AS [backup_size_unit]
	--, CONVERT(DECIMAL(17,2), compressed_backup_size/POWER(cast(1024 as bigint), [compressed_backup_size_magnitude])) AS [compressed_backup_size]
	--, CASE [compressed_backup_size_magnitude] 
 --       WHEN 0 THEN 'B' 
 --       WHEN 1 THEN 'KiB' 
 --       WHEN 2 THEN 'MiB'
 --       WHEN 3 THEN 'GiB' 
 --   END AS [compressed_backup_size_unit]
	--, 1 - 1.0*([compressed_backup_size]/[backup_size]) AS [compression_rate]
    , DATEDIFF(HOUR, [backup_start_date], GETDATE()) AS [hours_since_backup]	
    , backup_start_date
    , backup_finish_date
    , getdate() as [now]
    , datediff(minute, backup_start_date, backup_finish_date) as [elapsed_time (min)]
from databases as d
left join backups as b
    on d.name = b.database_name
where [rank] = 1
order by database_name, backup_start_date