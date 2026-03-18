
  
    
    
      
    

    create  table
      "heymax"."marts"."fct_growth_metrics__dbt_tmp"
  
  (
    growth_metrics_sk VARCHAR,
    dt DATE,
    period VARCHAR,
    new_users BIGINT,
    retained_users BIGINT,
    resurrected_users BIGINT,
    churned_users BIGINT
    
    )
 ;
    insert into "heymax"."marts"."fct_growth_metrics__dbt_tmp" 
  (
    
      
      growth_metrics_sk ,
    
      
      dt ,
    
      
      period ,
    
      
      new_users ,
    
      
      retained_users ,
    
      
      resurrected_users ,
    
      
      churned_users 
    
  )
 (
      
    select growth_metrics_sk, dt, period, new_users, retained_users, resurrected_users, churned_users
    from (
        select md5(cast(coalesce(cast(dt as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(period as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as growth_metrics_sk, * from "heymax"."marts"."inter_daily_growth_metrics"
union all 
select md5(cast(coalesce(cast(dt as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(period as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as growth_metrics_sk, * from "heymax"."marts"."inter_weekly_growth_metrics"
union all
select md5(cast(coalesce(cast(dt as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(period as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as growth_metrics_sk, * from "heymax"."marts"."inter_monthly_growth_metrics"
    ) as model_subq
    );
  
  