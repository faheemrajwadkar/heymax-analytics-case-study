
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        is_weekend as value_field,
        count(*) as n_records

    from "heymax"."marts"."dim_dates"
    group by is_weekend

)

select *
from all_values
where value_field not in (
    '0','1'
)



  
  
      
    ) dbt_internal_test