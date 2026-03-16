import duckdb

DB_PATH = "./data/warehouse/heymax.duckdb"
CSV_PATH = "./data/raw/event_stream.csv"

conn = duckdb.connect(DB_PATH)

conn.execute(f"""
    CREATE OR REPLACE TABLE raw_events_stream AS
    SELECT *
    FROM read_csv_auto('{CSV_PATH}')
""")

with open(CSV_PATH, 'r') as f:
    print(f.read(10))

print("Data loaded successfully")
