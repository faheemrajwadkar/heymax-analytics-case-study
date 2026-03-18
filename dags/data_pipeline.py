from datetime import datetime
from pathlib import Path
from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig
from cosmos.profiles import DuckDBUserPasswordProfileMapping
from cosmos.constants import LoadMode
import os

# Give DBT Project Path and DB Path
DBT_PROJECT_PATH = f"{os.environ['AIRFLOW_HOME']}/dbt/heymax"
DB_PATH = f"{os.environ['AIRFLOW_HOME']}/data/warehouse/heymax.duckdb"

profile_config=ProfileConfig(
    profile_name="heymax",
    target_name="prod",
    profile_mapping=DuckDBUserPasswordProfileMapping(
        conn_id="duckdb_default",
        profile_args={"path": DB_PATH},
    )
)

with DAG(
    dag_id='heymax_data_pipeline',
    start_date=datetime(2026, 3, 1),
    schedule='@daily',
    catchup=False,
    max_active_runs=1,
) as dag:

    # 1. Ingest Data
    ingest_data = BashOperator(
        task_id='ingest_raw_events',
        bash_command=f'python /usr/local/airflow/scripts/load_data.py'
    )

    # 2. The Main Build (Everything EXCEPT post_build_tests)
    dbt_main_build = DbtTaskGroup(
        group_id="dbt_main_build",
        project_config=ProjectConfig(DBT_PROJECT_PATH),
        profile_config=profile_config,
        execution_config=ExecutionConfig(dbt_executable_path="/usr/local/bin/dbt"),
        operator_args={
            "install_deps": True,
            "exclude": ["tag:post_build_tests"],
        },
        render_config=RenderConfig(
            load_method=LoadMode.DBT_LS,
            exclude=["tag:post_build_tests"]
        )
    )

    # 3. The Post-Build Tests (ONLY post_build_tests)
    dbt_post_tests = BashOperator(
        task_id="dbt_post_tests",
        bash_command="""
        cd /usr/local/airflow/dbt/heymax &&
        dbt test --select tag:post_build_tests --profiles-dir .
        """
    )

    ingest_data >> dbt_main_build >> dbt_post_tests
