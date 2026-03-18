{% macro cleanup_schema(schema_name) %}

    {# Safety check: prevent dropping production (empty string in your case) or main #}
    {% if schema_name | lower in ['', 'main', 'prod'] %}
        {{ log("Skipping cleanup: Target schema '" ~ schema_name ~ "' is protected.", info=True) }}
    {% else %}
        {{ log("Cleaning up schema: " ~ schema_name, info=True) }}
        
        {% set drop_query %}
            DROP SCHEMA IF EXISTS {{ schema_name }} CASCADE;
        {% endset %}

        {% do run_query(drop_query) %}
        
        {{ log("Schema '" ~ schema_name ~ "' dropped successfully.", info=True) }}
    {% endif %}

{% endmacro %}