import duckdb
import os
from pathlib import Path

# Assuming scripts/load_data.py, this gets the project root
BASE_DIR = Path(__file__).resolve().parent.parent

# Define Absolute Paths
DB_DIR = BASE_DIR / "data" / "warehouse"
DB_PATH = str(DB_DIR / "heymax.duckdb")
CSV_PATH = str(BASE_DIR / "data" / "raw" / "event_stream.csv")

# Ensure Directory Exists
os.makedirs(DB_DIR, exist_ok=True)

print(f"Connecting to: {DB_PATH}")
print(f"Reading from: {CSV_PATH}")

conn = duckdb.connect(DB_PATH)

conn.execute("CREATE SCHEMA IF NOT EXISTS raw;")

conn.execute(f"""
    CREATE OR REPLACE TABLE raw.events_stream AS
    SELECT *
    FROM read_csv_auto('{CSV_PATH}')
""")

conn.close()

print("Data loaded successfully")
