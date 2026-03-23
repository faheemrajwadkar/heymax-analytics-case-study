
    
    

select
    event_sk as unique_field,
    count(*) as n_records

from "heymax"."marts"."fct_events"
where event_sk is not null
group by event_sk
having count(*) > 1


