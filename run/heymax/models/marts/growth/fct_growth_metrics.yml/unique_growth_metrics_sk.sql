
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    growth_metrics_sk as unique_field,
    count(*) as n_records

from "heymax"."marts"."fct_growth_metrics"
where growth_metrics_sk is not null
group by growth_metrics_sk
having count(*) > 1



  
  
      
    ) dbt_internal_test