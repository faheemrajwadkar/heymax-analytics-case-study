
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select country
from "heymax"."marts"."fct_events"
where country is null



  
  
      
    ) dbt_internal_test