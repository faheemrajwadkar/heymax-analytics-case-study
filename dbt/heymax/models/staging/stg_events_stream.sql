with source as (
    select * from {{ source('heymax', 'events_stream') }}
)

select 
	event_time,
	user_id,
	gender as user_gender,
	event_type,
	transaction_category,
	miles_amount,
	platform,
	utm_source,
	country,
	current_localtimestamp() as _batched_at
from source