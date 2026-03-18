
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select user_gender
from "heymax"."marts"."fct_events"
where user_gender is null



  
  
      
    ) dbt_internal_test