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

for row in results:
    print(row)

# Validate Database
step_1 = 'SHOW DATABASES'

cur.execute(step_1)
results = cur.fetchall()

#print(results)

db_names = []
for result in results:
    db_names.append(result[1])

print(db_names)

if 'MY_NEW_DB' in db_names:
    print('Database Exists. Database Creation Step Successfull')
else:
    print('Database not in. Step had failed')

# Validate Table
step_2 = 'USE DATABASE MY_NEW_DB;'
cur.execute(step_2)

step_3 = 'USE SCHEMA PUBLIC;'
cur.execute(step_3)

step_4 = 'SHOW TABLES'
cur.execute(step_4)

results = cur.fetchall()

#print(results)

table_names = []
for result in results:
    table_names.append(result[1])

print(table_names)

if 'MY_NEW_TABLE' in table_names:
    print('Table Exists. Table Creation Step Successfull')
else:
    print('Table not in. Step had failed')

# Validate Warehouse
step_5 = 'SHOW WAREHOUSES;'
cur.execute(step_5)

results = cur.fetchall()

#print(results)

warehouse_names = []
for result in results:
    warehouse_names.append(result[0])

print(warehouse_names)

if 'MY_NEW_WAREHOUSE' in warehouse_names:
    print('Warehouse Exists. Warehouse Creation Step Successfull')
else:
    print('Warehouse not in. Step had failed')
