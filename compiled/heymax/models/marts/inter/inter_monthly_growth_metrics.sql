

    
        
        
    


    

with cumulative as (
    select 
        date_trunc('month', uad.dt) as calendar_month,
        uad.user_id,
        max(uad.user_activated_flag) as user_activated_flag,
        count(fe.event_sk) as user_events
    from "heymax"."marts"."inter_user_activity_daily" uad 
    left join "heymax"."marts"."fct_events" fe 
        on date_trunc('month', uad.dt) = date_trunc('month', fe.event_date)
        and uad.user_id = fe.user_id 
    group by 1,2
),
historical as (
    select 
        calendar_month,
        user_id,
        user_activated_flag,
        user_events,
        lag(user_events) over (partition by user_id order by calendar_month) as user_events_last_month,
        sum(user_events) over (partition by user_id order by calendar_month rows between UNBOUNDED PRECEDING and 2 PRECEDING) as user_events_before_last_month
    from cumulative
),
flags as (
    select 
        calendar_month,
        user_id,
        user_activated_flag,
        user_events,
        user_events_last_month,
        user_events_before_last_month,
        case when user_activated_flag = 1 then 1 else 0 end as new_user_flag,
        case when user_activated_flag = 0 and user_events > 0 and user_events_last_month > 0 then 1 else 0 end as retained_user_flag,
        case when user_activated_flag = 0 and user_events > 0 and user_events_last_month = 0 and user_events_before_last_month > 0 then 1 else 0 end as resurrected_user_flag,
        case when user_activated_flag = 0 and user_events = 0 and user_events_last_month > 0 then 1 else 0 end as churned_user_flag
    from historical
)
select 
    date(calendar_month) as dt,
    'monthly' as period,
    count(distinct case when new_user_flag = 1 then user_id end) as new_users,
    count(distinct case when retained_user_flag = 1 then user_id end) as retained_users,
    count(distinct case when resurrected_user_flag = 1 then user_id end) as resurrected_users,
    count(distinct case when churned_user_flag = 1 then user_id end) as churned_users
from flags
group by 1


