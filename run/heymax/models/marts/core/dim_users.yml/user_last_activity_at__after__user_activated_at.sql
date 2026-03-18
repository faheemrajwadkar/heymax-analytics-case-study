
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "heymax"."marts"."dim_users"

where not(user_last_activity_at >= user_activated_at)


  
  
      
    ) dbt_internal_test