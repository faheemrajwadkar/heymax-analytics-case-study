
    
    

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


