
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select platform
from "heymax"."staging"."stg_events_stream"
where platform is null



  
  
      
    ) dbt_internal_test