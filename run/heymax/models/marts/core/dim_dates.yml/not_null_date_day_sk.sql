
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select date_day_sk
from "heymax"."marts"."dim_dates"
where date_day_sk is null



  
  
      
    ) dbt_internal_test