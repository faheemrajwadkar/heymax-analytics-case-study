



select
    1
from "heymax"."marts"."dim_users"

where not(user_activated_at <= user_last_activity_at)

