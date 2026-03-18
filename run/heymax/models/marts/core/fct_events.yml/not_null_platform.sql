
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select platform
from "heymax"."marts"."fct_events"
where platform is null



  
  
      
    ) dbt_internal_test