import duckdb

DB_PATH = "./data/warehouse/heymax.duckdb"
CSV_PATH = "./data/raw/event_stream.csv"

conn = duckdb.connect(DB_PATH)

conn.execute(f"""
    CREATE OR REPLACE TABLE raw_events_stream AS
    SELECT *
    FROM read_csv_auto('{CSV_PATH}')
""")

print("Data loaded successfully")
