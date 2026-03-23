
    
    

select
    date_day_sk as unique_field,
    count(*) as n_records

from "heymax"."marts"."dim_dates"
where date_day_sk is not null
group by date_day_sk
having count(*) > 1


