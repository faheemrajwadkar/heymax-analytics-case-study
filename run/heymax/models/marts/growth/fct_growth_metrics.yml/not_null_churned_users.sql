
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select churned_users
from "heymax"."marts"."fct_growth_metrics"
where churned_users is null



  
  
      
    ) dbt_internal_test