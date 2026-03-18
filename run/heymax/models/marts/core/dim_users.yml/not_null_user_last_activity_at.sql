
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select user_last_activity_at
from "heymax"."marts"."dim_users"
where user_last_activity_at is null



  
  
      
    ) dbt_internal_test