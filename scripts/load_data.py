import duckdb

DB_PATH = "./data/warehouse/heymax.duckdb"
CSV_PATH = "./data/raw/event_stream.csv"

conn = duckdb.connect(DB_PATH)

# Creating Schemas for each layer
conn.execute(f"""
    CREATE SCHEMA raw;
    CREATE SCHEMA staging;
    CREATE SCHEMA marts;
""")

# Loading CSV into RAW schema (ingestion layer)
conn.execute(f"""
    CREATE OR REPLACE TABLE RAW.events_stream AS
    SELECT *
    FROM read_csv_auto('{CSV_PATH}')
""")

with open(CSV_PATH, 'r') as f:
    print(f.read(10))

print("Data loaded successfully")
