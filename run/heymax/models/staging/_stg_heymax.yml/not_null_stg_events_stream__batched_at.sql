
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select _batched_at
from "heymax"."staging"."stg_events_stream"
where _batched_at is null



  
  
      
    ) dbt_internal_test