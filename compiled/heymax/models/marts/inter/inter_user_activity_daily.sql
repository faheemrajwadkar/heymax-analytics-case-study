with user_date_cascade as (
	select 
		dd."date" as dt,
		du.user_id,
        case when dd."date" = date(du.user_activated_at) then 1 else 0 end as user_activated_flag
	from "heymax"."marts"."dim_dates" dd
    cross join "heymax"."marts"."dim_users" du 
	where dd."date" >= date(du.user_activated_at)
)
select * from user_date_cascade