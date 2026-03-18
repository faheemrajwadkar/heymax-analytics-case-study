
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        event_type as value_field,
        count(*) as n_records

    from "heymax"."marts"."fct_events"
    group by event_type

)

select *
from all_values
where value_field not in (
    'miles_redeemed','miles_earned','like','share','reward_search'
)



  
  
      
    ) dbt_internal_test