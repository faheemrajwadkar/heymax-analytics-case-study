import duckdb
import os

# Define paths
DB_DIR = "./data/warehouse"
DB_PATH = os.path.join(DB_DIR, "heymax.duckdb")
CSV_PATH = "./data/raw/event_stream.csv"

# Dynamic paths by ensuring it exists, or creating a new one
if not os.path.exists(DB_DIR):
    os.makedirs(DB_DIR)
    print(f"Created directory: {DB_DIR}")

conn = duckdb.connect(DB_PATH)

conn.execute(f"""
    CREATE OR REPLACE TABLE raw_events_stream AS
    SELECT *
    FROM read_csv_auto('{CSV_PATH}')
""")

print("Data loaded successfully")
