



select
    1
from "heymax"."marts"."dim_users"

where not(user_last_activity_at >= user_activated_at)

