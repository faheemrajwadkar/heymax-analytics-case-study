select {{ dbt_utils.generate_surrogate_key(['dt', 'period']) }} as growth_metrics_sk, * from {{ ref('inter_daily_growth_metrics') }}
union all 
select {{ dbt_utils.generate_surrogate_key(['dt', 'period']) }} as growth_metrics_sk, * from {{ ref('inter_weekly_growth_metrics') }}
union all
select {{ dbt_utils.generate_surrogate_key(['dt', 'period']) }} as growth_metrics_sk, * from {{ ref('inter_monthly_growth_metrics') }}