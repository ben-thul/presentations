use [Adventureworks]
go
exec sp_addsubscription
    @publication = 'Adventureworks_Publication',
    @article = 'all',
    @subscriber = 'VIRTUALBOX\SUBSCRIBER',
    @destination_db = 'Adventureworks_Backup_Subscriber',
    @sync_type = 'initialize with backup',
    --@status
    @subscription_type = 'push',
    --@update_mode
    --@loopback_detection
    --@frequency_type
    --@frequency_interval
    --@frequency_relative_interval
    --@frequency_recurrence_factor
    --@frequency_subday
    --@frequency_subday_interval
    --@active_start_time_of_day
    --@active_end_time_of_day
    --@active_start_date
    --@active_end_date
    --@optional_command_line
    --@reserved
    --@enabled_for_syncmgr
    --@offloadagent
    --@offloadserver
    --@dts_package_name
    --@dts_package_password
    --@dts_package_location
    --@distribution_job_name
    --@publisher
    @backupdevicetype = 'disk',
    @backupdevicename = 'c:\adventureworks.bak'
    --@mediapassword
    --@password
    --@fileidhint
    --@unload
    --@subscriptionlsn
    --@subscriptionstreams
    --@subscriber_type