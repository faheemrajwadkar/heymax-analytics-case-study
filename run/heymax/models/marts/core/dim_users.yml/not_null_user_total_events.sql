
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select user_total_events
from "heymax"."marts"."dim_users"
where user_total_events is null



  
  
      
    ) dbt_internal_test