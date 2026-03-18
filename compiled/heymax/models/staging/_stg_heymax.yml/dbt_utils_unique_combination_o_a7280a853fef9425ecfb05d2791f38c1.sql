





with validation_errors as (

    select
        user_id, event_time
    from "heymax"."staging"."stg_events_stream"
    group by user_id, event_time
    having count(*) > 1

)

select *
from validation_errors


