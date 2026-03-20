#!/bin/bash
# setup_dbt.sh - Local development environment setup

echo "🚀 Starting Local dbt Environment Setup..."

# 1. Setup Virtual Environment
python3 -m venv heymax
source heymax/bin/activate

# 2. Install Dependencies
pip install --upgrade pip
pip install -r pip_requirements.txt

# 3. Data Ingestion
echo "📥 Ingesting raw data into DuckDB..."
python3 scripts/load_data.py

# 4. dbt Operations
cd dbt/heymax/
dbt deps

echo "🏗️ Building dbt models (excluding post-build tests)..."
dbt build --exclude tag:post_build_tests
dbt test --select tag:post_build_tests

echo "✅ dbt setup complete. Virtual environment 'heymax' is ready."