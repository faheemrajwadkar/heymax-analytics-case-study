
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "heymax"."marts"."dim_users"

where not(user_total_events > 0)


  
  
      
    ) dbt_internal_test