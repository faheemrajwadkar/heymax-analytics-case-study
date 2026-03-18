
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        period as value_field,
        count(*) as n_records

    from "heymax"."marts"."fct_growth_metrics"
    group by period

)

select *
from all_values
where value_field not in (
    'daily','weekly','monthly'
)



  
  
      
    ) dbt_internal_test