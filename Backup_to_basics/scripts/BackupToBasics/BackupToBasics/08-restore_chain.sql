USE [dbadmin];
IF EXISTS (SELECT 1 from sys.objects WHERE [object_id] = OBJECT_ID('dbo.restore_chain'))
    SET NOEXEC ON
GO
CREATE FUNCTION dbo.restore_chain()
RETURNS TABLE AS RETURN SELECT 'not implemented' AS a
GO
SET NOEXEC OFF
GO
ALTER FUNCTION [dbo].[restore_chain](
    @db sysname,
    @include_logs BIT
)
RETURNS TABLE
AS RETURN

with fulls as (

    select bs.*
        , row_number() over (partition by bs.database_guid order by bs.backup_start_date desc) as [f_rn]
        , null as [d_rn]
        , null as [l_rn]
    from msdb.dbo.backupset as bs
    inner join sys.database_recovery_status as rs
        on bs.last_recovery_fork_guid = rs.recovery_fork_guid
    inner join sys.databases as d
        on rs.database_id = d.database_id
    where d.name = @db 
        and bs.type = 'D' --is a full database backup
        and bs.is_copy_only = 0

)
, diffs as (

    select bs.*
        , f.f_rn
        , row_number() over (partition by bs.database_guid order by bs.backup_start_date desc) as [d_rn]
        , null as [l_rn]
    from msdb.dbo.backupset as bs
    inner join fulls as f
        on f.family_guid = bs.family_guid
        and f.checkpoint_lsn = bs.database_backup_lsn
    where f.f_rn = 1
        and bs.type = 'I' --is a differential database backup
        and bs.is_copy_only = 0

)
,first_log as (
    SELECT  top 1 
	        bs.*
            , f.f_rn
            , d.d_rn
            , 1 as [l_rn]
    FROM    msdb.dbo.backupset AS [bs]
    INNER JOIN fulls AS f
            ON bs.family_guid = f.family_guid
            and bs.database_backup_lsn = f.checkpoint_lsn
    LEFT JOIN diffs AS d
            ON bs.family_guid = d.family_guid
            AND f.[checkpoint_lsn] = d.[database_backup_lsn]
    WHERE   @include_logs = 1
            AND bs.type = 'L' --is a log backup
            AND [f].[f_rn] = 1 --belongs to the backup chain started by the latest full backup
            AND COALESCE(d.[d_rn], f.[f_rn]) = 1 --use the latest differential backup since the latest full, if one exists
            --AND bs.first_lsn >= COALESCE(d.first_lsn, f.first_lsn)
            AND bs.first_lsn <= coalesce(d.last_lsn, f.last_lsn)
            AND bs.last_lsn >= coalesce(d.last_lsn, f.last_lsn)
	ORDER BY bs.first_lsn
)

, all_logs as (
    select bs.*
        , fl.f_rn
        , fl.d_rn
        , 1 + row_number() over (order by bs.first_lsn) as [l_rn]
    from msdb.dbo.backupset as bs
    inner join first_log as fl
        on fl.database_backup_lsn = bs.database_backup_lsn
        and bs.[first_lsn] >= fl.[first_lsn]
		and bs.backup_set_id <> fl.backup_set_id
    where bs.type = 'L'
)
, logs as (

    select *
    from first_log

    union all

    select * 
    from [all_logs]
)
, alls as (
    select @db as database_name,
        media_set_id,
        backup_start_date,
        'D' AS [type],
        [f_rn],
        [d_rn],
        [l_rn]
    from fulls
    where [f_rn] = 1

    union all

    select @db,
        media_set_id,
        backup_start_date,
        'I' AS [type],
        [f_rn],
        [d_rn],
        [l_rn]
    from diffs
    where [d_rn] = 1

    union all

    select @db,
        media_set_id,
        backup_start_date,
        'L' AS [type],
        [f_rn],
        [d_rn],
        [l_rn]
    from logs 
), moves AS (
    SELECT name, (
        SELECT ', move ''' + name + ''' to ''' + [physical_name] + ''''
        FROM sys.[master_files] AS mf
        WHERE mf.[database_id] = d.[database_id]
        FOR XML PATH ('')
    ) AS [move_clause]
    FROM sys.[databases] AS d
)

select @db AS [database_name], [type], f_rn, d_rn, l_rn, 'restore database ' + quotename(database_name) 
    + ' from ' + 
    case bmf.family_sequence_number 
    when 1 then 
        stuff((
            select ', disk = ''' + physical_device_name + ''''
            from msdb.dbo.backupmediafamily as bmf
            where bmf.media_set_id = alls.media_set_id
            for xml path('')
        ), 1, 2, '')
    else null
    END
    + ' with stats = 10, norecovery'
    + CASE WHEN alls.[type] = 'D' THEN m.[move_clause] ELSE '' END AS [restore_statement] ,
    dense_rank() over (order by f_rn, d_rn, l_rn) as [restore_sequence],
    bmf.family_sequence_number ,
    bmf.physical_device_name
from alls
inner join msdb.dbo.backupmediafamily bmf
    on bmf.media_set_id = alls.media_set_id
INNER JOIN [moves] AS m
    ON m.name = alls.[database_name]
where database_name = @db
GO
SELECT * FROM dbo.restore_chain('AdventureWorks2014', 1)