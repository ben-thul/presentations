use [distribution]
go
declare @now datetime
set @now=getdate()
;with cte as (
    select 
        row_number() 
            over (
                partition by publisher,publisher_db,publication,subscriber,subscriber_db
                order by coalesce(subscriber_commit, '1900-01-01') desc, publisher_commit
        ) as [rn1]
        --,row_number()
        --    over (
        --        partition by publisher,publisher_db,publication,subscriber,subscriber_db
        --        order by publisher_commit desc
        --) as [rn2]
        ,publisher
        ,publisher_db
        ,publication
        ,subscriber
        ,subscriber_db
        ,publisher_commit 
        ,subscriber_commit    
    from
        tokens with (nolock)

)
select 
    publisher
    ,publisher_db
    ,publication
    ,subscriber
    ,subscriber_db
    ,publisher_commit
    ,subscriber_commit
    ,datediff(minute, a.publisher_commit, a.subscriber_commit) as [lag]
    --,datediff(minute, a.publisher_commit, a.subscriber_commit) as [lag2]
from
    cte a
where
    [rn1] = 1
    and (
        datediff(minute, a.publisher_commit, @now) > 30
        --or datediff(minute, a.publisher_commit, a.subscriber_commit) > 30
    )
order by [lag] desc
    
