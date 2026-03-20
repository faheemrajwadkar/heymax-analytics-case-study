#!/bin/bash
# setup_airflow.sh - Airflow/Astro CLI orchestration setup

echo "🌌 Initializing Astronomer/Airflow Stack..."

# 1. Check if Astro CLI is installed
if ! command -v astro &> /dev/null
then
    echo "⚠️ Astro CLI not found. Attempting to install..."
    
    # Check OS to use the correct install command
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install astro
        else
            echo "❌ Homebrew not found. Please install Astro CLI manually: https://www.astronomer.io/docs/astro/cli/install-cli"
            exit 1
        fi
    else
        # Linux/WSL
        curl -sSL install.astronomer.io | sudo sh
    fi
else
    echo "✅ Astro CLI is already installed."
fi

# 2. Initialize Astro project if .astro folder doesn't exist
if [ ! -d ".astro" ]; then
    echo "🏗️ Running 'astro dev init'..."
    astro dev init
fi

# 3. Configure requirements.txt for the Docker Container
# We use 'cat' to overwrite/create a clean file with only what's needed for the container
cat <<EOF > requirements.txt
astronomer-cosmos
dbt-duckdb
pandas
plotly
EOF

# 4. Start the stack
echo "🚀 Starting Airflow via Docker..."
# --wait ensures the script doesn't end until the webserver is actually up
astro dev start --wait 5m

echo "✨ Airflow is spinning up. Access it at http://localhost:8080"