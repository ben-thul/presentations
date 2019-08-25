use msdb;

declare @job_id uniqueidentifier
	, @operator_id int
	, @operator_name sysname = 'DBA Team'

select @operator_id = (select id from sysoperators where name = @operator_name);
if (@operator_id is null)
begin
	exec sp_add_operator @name = @operator_name;
end
select @operator_id = (select id from sysoperators where name = @operator_name);

declare jobs cursor fast_forward for
	select job_id from sysjobs
	where notify_email_operator_id = 0

open jobs;
while(1=1)
begin
	fetch next from jobs into @job_id;
	if (@@FETCH_STATUS <> 0)
		break;
	exec sp_update_job @job_id = @job_id,
		@notify_email_operator_name = @operator_name,
		@notify_level_email = 2;
end

close jobs;
deallocate jobs;