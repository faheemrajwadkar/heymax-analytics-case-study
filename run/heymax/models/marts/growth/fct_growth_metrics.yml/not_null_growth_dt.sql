
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select dt
from "heymax"."marts"."fct_growth_metrics"
where dt is null



  
  
      
    ) dbt_internal_test