



select
    1
from "heymax"."marts"."dim_users"

where not(user_total_events > 0)

