use [Adventureworks]
go
exec sp_replicationdboption 
    @dbname='Adventureworks', 
    @optname = 'publish',
    @value = 'true'
exec sp_addpublication
    @publication = 'Adventureworks_Publication',
    --@taskid
    --@restricted
    @sync_method = 'database snapshot', --set to 'concurrent if not EE
    --@repl_freq
    --@description
    @status = 'active',
    --@independent_agent
    @immediate_sync = 'false', --set to 'true' if you want the generate a snapshot regardless of uninitialized subscribers
    --@enabled_for_internet
    @allow_push = 'true',
    @allow_pull = 'true',
    --@allow_anonymous 
    @allow_sync_tran = 'false',
    --@autogen_sync_procs
    @retention = 0, --set to number of hours if you want expired subscriptions to be deleted
    --@allow_queued_tran
    --@snapshot_in_defaultfolder
    --@alt_snapshot_folder
    --@pre_snapshot_script
    --@post_snapshot_script
    --@compress_snapshot
    --@ftp_address
    --@ftp_port
    --@ftp_subdirectory
    --@ftp_login
    --@ftp_password
    --@allow_dts
    --@allow_subscription_copy
    --@conflict_policy
    --@centralized_conflicts
    --@conflict_retention
    --@queue_type
    --@add_to_active_directory
    --@logreader_job_name
    --@qreader_job_name
    --@publisher
    @allow_initialize_from_backup = 'true',
    @replicate_ddl = 1
    --@enabled_for_p2p
    --@publish_local_changes_only
    --@enabled_for_het_sub
    --@p2p_conflictdetection
    --@p2p_originator_id
    --@p2p_continue_onconflict
    --@allow_partition_switch
    --@replicate_partition_switch
exec sp_addpublication_snapshot @publication = 'Adventureworks_Publication'