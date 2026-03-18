import duckdb

con = duckdb.connect('data/warehouse/heymax.duckdb')

# Export the 3 specific datasets we need for our 3 modules
con.execute("""
    COPY (
        SELECT * FROM marts.fct_growth_metrics
        WHERE dt <= DATE '2025-12-31' 
    ) TO 'modules/data_growth.csv' (HEADER, DELIMITER ',')
""")
con.execute("""
    COPY (
        SELECT 
            date_trunc('month', u.user_activated_at) as signup_month,
            date_diff('month', date_trunc('month', u.user_activated_at), date_trunc('month', e.event_date)) AS months_since_signup,
            COUNT(DISTINCT e.user_id) AS active_users
        FROM marts.fct_events e
        JOIN marts.dim_users u ON e.user_id = u.user_id
        GROUP BY 1, 2
    ) TO 'modules/data_retention.csv' (HEADER, DELIMITER ',')
""")
con.execute("""
    COPY (
        WITH daily_events AS (
            SELECT 
                date_trunc('day', u.user_activated_at) as signup_day,
                date_diff('day', date_trunc('day', u.user_activated_at), date_trunc('day', e.event_date)) AS days_since_signup,
                COUNT(*) * 1.0 / COUNT(DISTINCT e.user_id) as events_per_user
            FROM marts.fct_events e
            LEFT JOIN marts.dim_users u ON e.user_id = u.user_id
            GROUP BY 1, 2
        )
        SELECT 
            signup_day,
            days_since_signup,
            events_per_user 
        FROM daily_events
        ORDER BY 1, 2
    ) TO 'modules/data_engagement.csv' (HEADER, DELIMITER ',')
""")