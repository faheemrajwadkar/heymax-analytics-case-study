



    
        
    

with events as (
	select 
		date_trunc('week', fe.event_date), 
		count(distinct user_id) as unique_users
	from "heymax"."marts"."fct_events" fe 
    where fe.event_date < date(current_date)
	group by 1
),
events_unique_users as (
	select 
		sum(unique_users) as total_unique_users
	from events 
),
growth_metrics_unique_users as (
	select 
		sum(new_users + retained_users + resurrected_users) as total_unique_users
	from "heymax"."marts"."fct_growth_metrics" gm
	where period = 'weekly'
    and gm.dt < date(current_date)
)
select 
	ev.total_unique_users, gm.total_unique_users 
from events_unique_users ev
cross join growth_metrics_unique_users gm
where ev.total_unique_users <> gm.total_unique_users 

