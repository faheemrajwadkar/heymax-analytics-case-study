
  
    
    

    -- Lead move: Logging to a dedicated monitoring table
    CREATE SCHEMA IF NOT EXISTS monitoring;
    CREATE TABLE IF NOT EXISTS monitoring.dbt_run_log (
        run_id VARCHAR,
        run_at TIMESTAMP,
        node_id VARCHAR,
        status VARCHAR,
        execution_time FLOAT,
        rows_affected INT
    );

    
  
