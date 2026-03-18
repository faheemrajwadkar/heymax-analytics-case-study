select 
    date_day as date,
    

    CAST(REPLACE(CAST(DATE(date_day) as VARCHAR(10)), '-', '') as INT)

 as date_day_sk,
    dayname(date_day) as day_name,
    monthname(date_day) as month_name,
    date_trunc('year', date_day) as year,
    date_trunc('quarter', date_day) as quarter,
    date_trunc('month', date_day) as month,
    date_trunc('week', date_day) as week,
    case when dayname(date_day) in ('Sun', 'Sat') then 1 else 0 end as is_weekend
from (
    





with rawdata as (

    

    

    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (

    select

    
    p0.generated_number * power(2, 0)
     + 
    
    p1.generated_number * power(2, 1)
     + 
    
    p2.generated_number * power(2, 2)
     + 
    
    p3.generated_number * power(2, 3)
     + 
    
    p4.generated_number * power(2, 4)
     + 
    
    p5.generated_number * power(2, 5)
     + 
    
    p6.generated_number * power(2, 6)
     + 
    
    p7.generated_number * power(2, 7)
     + 
    
    p8.generated_number * power(2, 8)
    
    
    + 1
    as generated_number

    from

    
    p as p0
     cross join 
    
    p as p1
     cross join 
    
    p as p2
     cross join 
    
    p as p3
     cross join 
    
    p as p4
     cross join 
    
    p as p5
     cross join 
    
    p as p6
     cross join 
    
    p as p7
     cross join 
    
    p as p8
    
    

    )

    select *
    from unioned
    where generated_number <= 442
    order by generated_number



),

all_periods as (

    select (
        

    (cast('2025-01-01' as date) + cast(row_number() over (order by generated_number) - 1 as bigint) * interval 1 day)
    ) as date_day
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_day <= cast(current_date + interval '1 day' as date)

)

select * from filtered


) a