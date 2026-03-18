
  
    
    
      
    

    create  table
      "heymax"."marts"."dim_users__dbt_tmp"
  
  (
    user_id VARCHAR,
    user_gender VARCHAR,
    user_activated_at TIMESTAMP,
    user_last_activity_at TIMESTAMP,
    user_total_events HUGEINT
    
    )
 ;
    insert into "heymax"."marts"."dim_users__dbt_tmp" 
  (
    
      
      user_id ,
    
      
      user_gender ,
    
      
      user_activated_at ,
    
      
      user_last_activity_at ,
    
      
      user_total_events 
    
  )
 (
      
    select user_id, user_gender, user_activated_at, user_last_activity_at, user_total_events
    from (
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
    ) as model_subq
    );
  
  