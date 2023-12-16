import snowflake.connector

# Establish a connection to the Snowflake server
conn = snowflake.connector.connect(
    user='your_username',
    password='your_password',
    account='your_account',
    warehouse='your_warehouse',
    database='your_database',
    schema='your_schema'
)

# Create a cursor object
cur = conn.cursor()

# Create a new database
cur.execute("CREATE DATABASE IF NOT EXISTS MY_NEW_DB")

# Use the new database
cur.execute("USE DATABASE MY_NEW_DB")

# Create a new table
cur.execute("""
    CREATE TABLE IF NOT EXISTS MY_NEW_TABLE (
        ID NUMBER,
        DATA STRING
    )
""")

# Create a new virtual warehouse
cur.execute("CREATE WAREHOUSE IF NOT EXISTS MY_NEW_WAREHOUSE")

# Close the cursor and connection
cur.close()
conn.close()
