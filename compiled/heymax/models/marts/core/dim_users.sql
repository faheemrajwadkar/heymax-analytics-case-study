with user_events as (
    select
        user_id,
        user_gender,
        row_number() over (partition by user_id order by event_time desc) as rn,
        min(event_time) over (partition by user_id) as user_activated_at,
		max(event_time) over (partition by user_id) as user_last_activity_at,
		sum(1)  over (partition by user_id) as user_total_events
    from "heymax"."staging"."stg_events_stream"
    where user_gender is not null
)
select distinct 
    user_id,
    user_gender,
    user_activated_at,
    user_last_activity_at,
    user_total_events
from user_events
where rn = 1