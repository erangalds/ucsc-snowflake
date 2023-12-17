import snowflake.connector
from dotenv import load_dotenv

# Load the .env file
load_dotenv()

# Now you can access the variables using os.getenv
import os
user = os.getenv("user")
password = os.getenv("password")
account = os.getenv('account')
warehouse = os.getenv('warehouse')

print(account)

# Establish a connection to the Snowflake server
conn = snowflake.connector.connect(
    user=user,
    password=password,
    account=account,
    warehouse=warehouse,
    #database='your_database',
    #schema='your_schema'
)

# Create a cursor object
cur = conn.cursor()

cur.execute('select current_user(), current_role()')

results = cur.fetchall()

#print(results)
print('Currently Logged in User and his Current Role: ')
for row in results:
    print(row)
# Create a new database
step_1 = "CREATE DATABASE IF NOT EXISTS MY_NEW_DB"
step_2 = "USE DATABASE MY_NEW_DB"
step_3 = """
     CREATE TABLE IF NOT EXISTS MY_NEW_TABLE (
         ID NUMBER,
         DATA STRING
     )
"""
step_4 = "CREATE WAREHOUSE IF NOT EXISTS MY_NEW_WAREHOUSE"

steps = [
    step_1,
    step_2,
    step_3,
    step_4
]

for step in steps:
    try:
        print('Running Step')
        cur.execute(step)
        print('Completed Step : ')
        print(step)
    except Exception as e:
        print('Could not completed step: ')
        print(step)
        print(e)
    
# Close the cursor and connection
cur.close()
conn.close()
