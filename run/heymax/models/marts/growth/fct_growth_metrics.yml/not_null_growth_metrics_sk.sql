
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select growth_metrics_sk
from "heymax"."marts"."fct_growth_metrics"
where growth_metrics_sk is null



  
  
      
    ) dbt_internal_test