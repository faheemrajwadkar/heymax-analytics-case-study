

    
        
        
    


    

with cumulative as (
    select 
        date_trunc('week', uad.dt) as calendar_week,
        uad.user_id,
        max(uad.user_activated_flag) as user_activated_flag,
        count(fe.event_sk) as user_events
    from "heymax"."marts"."inter_user_activity_daily" uad 
    left join "heymax"."marts"."fct_events" fe 
        on date_trunc('week', uad.dt) = date_trunc('week', fe.event_date)
        and uad.user_id = fe.user_id 
    group by 1,2
),
historical as (
    select 
        calendar_week,
        user_id,
        user_activated_flag,
        user_events,
        lag(user_events) over (partition by user_id order by calendar_week) as user_events_last_week,
        sum(user_events) over (partition by user_id order by calendar_week rows between UNBOUNDED PRECEDING and 2 PRECEDING) as user_events_before_last_week
    from cumulative
),
flags as (
    select 
        calendar_week,
        user_id,
        user_activated_flag,
        user_events,
        user_events_last_week,
        user_events_before_last_week,
        case when user_activated_flag = 1 then 1 else 0 end as new_user_flag,
        case when user_activated_flag = 0 and user_events > 0 and user_events_last_week > 0 then 1 else 0 end as retained_user_flag,
        case when user_activated_flag = 0 and user_events > 0 and user_events_last_week = 0 and user_events_before_last_week > 0 then 1 else 0 end as resurrected_user_flag,
        case when user_activated_flag = 0 and user_events = 0 and user_events_last_week > 0 then 1 else 0 end as churned_user_flag
    from historical
)
select 
    date(calendar_week) as dt,
    'weekly' as period,
    count(distinct case when new_user_flag = 1 then user_id end) as new_users,
    count(distinct case when retained_user_flag = 1 then user_id end) as retained_users,
    count(distinct case when resurrected_user_flag = 1 then user_id end) as resurrected_users,
    count(distinct case when churned_user_flag = 1 then user_id end) as churned_users
from flags
group by 1


