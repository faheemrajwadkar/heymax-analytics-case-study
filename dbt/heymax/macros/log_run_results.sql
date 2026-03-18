{% macro log_run_results(results) %}
  {% if execute %}
    {% set items = [] %}
    {% for res in results %}
      {% do items.append({
        "node_id": res.node.unique_id,
        "status": res.status,
        "execution_time": res.execution_time,
        "rows_affected": res.adapter_response.get('rows_affected', 0)
      }) %}
    {% endfor %}

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

    {% for item in items %}
      INSERT INTO monitoring.dbt_run_log VALUES (
        '{{ invocation_id }}',
        CURRENT_TIMESTAMP,
        '{{ item.node_id }}',
        '{{ item.status }}',
        {{ item.execution_time }},
        {{ item.rows_affected }}
      );
    {% endfor %}
  {% endif %}
{% endmacro %}