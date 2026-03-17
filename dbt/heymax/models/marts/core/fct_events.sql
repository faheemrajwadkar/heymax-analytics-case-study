with events as (
    select * from {{ ref('stg_events_stream') }}
),

final as (
    select
        -- surrogate key for event
        {{ dbt_utils.generate_surrogate_key(['user_id','event_time']) }} as event_sk,
        user_id,
        event_time,
        date_trunc('day', event_time) as event_date,
        {{ generate_date_key("date_trunc('day', event_time)") }} as date_day_sk,
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