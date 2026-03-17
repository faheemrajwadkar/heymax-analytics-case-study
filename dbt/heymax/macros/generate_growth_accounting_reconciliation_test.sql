{% macro generate_growth_accounting_reconciliation_test(period) %}

    {% if period == 'daily' %}
        {% set date_part = 'day' %}
    {% elif period == 'weekly' %}
        {% set date_part = 'week' %}
    {% elif period == 'monthly' %}
        {% set date_part = 'month' %}
    {% endif %}

with events as (
	select 
		date_trunc('{{ date_part }}', fe.event_date), 
		count(distinct user_id) as unique_users
	from {{ ref('fct_events') }} fe 
    where fe.event_date < date(current_date)
	group by 1
),
events_unique_users as (
	select 
		sum(unique_users) as total_unique_users
	from events 
),
growth_metrics_unique_users as (
	select 
		sum(new_users + retained_users + resurrected_users) as total_unique_users
	from {{ ref('fct_growth_metrics') }} gm
	where period = '{{ period }}'
    and gm.dt < date(current_date)
)
select 
	ev.total_unique_users, gm.total_unique_users 
from events_unique_users ev
cross join growth_metrics_unique_users gm
where ev.total_unique_users <> gm.total_unique_users 

{% endmacro %}