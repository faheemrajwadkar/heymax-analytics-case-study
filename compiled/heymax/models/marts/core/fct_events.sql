with events as (
    select * from "heymax"."staging"."stg_events_stream"
),

final as (
    select
        -- surrogate key for event
        md5(cast(coalesce(cast(user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(event_time as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as event_sk,
        user_id,
        event_time,
        date_trunc('day', event_time) as event_date,
        

    CAST(REPLACE(CAST(DATE(date_trunc('day', event_time)) as VARCHAR(10)), '-', '') as INT)

 as date_day_sk,
        event_type,
        transaction_category,
        miles_amount,
        user_gender,
        platform,
        utm_source,
        country
    from events
)

select * from final