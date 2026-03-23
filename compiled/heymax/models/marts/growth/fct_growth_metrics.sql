select md5(cast(coalesce(cast(dt as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(period as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as growth_metrics_sk, * from "heymax"."marts"."inter_daily_growth_metrics"
union all 
select md5(cast(coalesce(cast(dt as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(period as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as growth_metrics_sk, * from "heymax"."marts"."inter_weekly_growth_metrics"
union all
select md5(cast(coalesce(cast(dt as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(period as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as growth_metrics_sk, * from "heymax"."marts"."inter_monthly_growth_metrics"