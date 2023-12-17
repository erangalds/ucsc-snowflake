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

print(results)

for row in results:
    print(row)

step_1 = 'DROP DATABASE MY_NEW_DB;'
step_2 = 'DROP WAREHOUSE MY_NEW_WAREHOUSE;'

cleaning_steps = [
    step_1,
    step_2
]

for step in cleaning_steps:
    cur.execute(step)

