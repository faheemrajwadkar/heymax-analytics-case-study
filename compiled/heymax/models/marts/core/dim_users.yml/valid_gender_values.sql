
    
    

with all_values as (

    select
        user_gender as value_field,
        count(*) as n_records

    from "heymax"."marts"."dim_users"
    group by user_gender

)

select *
from all_values
where value_field not in (
    'Male','Female','Prefer not to say','Non-binary'
)


