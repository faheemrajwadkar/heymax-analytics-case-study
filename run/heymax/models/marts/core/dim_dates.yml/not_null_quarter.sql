
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select quarter
from "heymax"."marts"."dim_dates"
where quarter is null



  
  
      
    ) dbt_internal_test