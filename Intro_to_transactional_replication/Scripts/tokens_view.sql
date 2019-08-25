USE [distribution]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[tokens]'))
    DROP VIEW [dbo].[tokens]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[tokens] as
select
	ps.name as [publisher],
	p.publisher_db,
	p.publication, 
	ss.name as [subscriber],
	da.subscriber_db,
	t.publisher_commit,
	t.distributor_commit,
	h.subscriber_commit,
	datediff(second, t.publisher_commit, t.distributor_commit) as [pub to dist (s)],
	datediff(second, t.distributor_commit ,h.subscriber_commit) as [dist to sub (s)],
	datediff(second, t.publisher_commit, h.subscriber_commit) as [total latency (s)]
from mstracer_tokens t
inner join MStracer_history h
    on t.tracer_id = h.parent_tracer_id
inner join mspublications p
    on p.publication_id = t.publication_id
inner join sys.servers ps
    on p.publisher_id = ps.server_id
inner join msdistribution_agents da
    on h.agent_id = da.id
inner join sys.servers ss
    on da.subscriber_id = ss.server_id
