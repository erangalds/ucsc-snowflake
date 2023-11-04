// Time Travel - Retention Period Setting
// Looking at the Current Time Travel Setting for a Table
use role sysadmin;
use database our_first_db;
use warehouse compute_wh;
select current_role(),current_database(),current_warehouse();
-- Creating a test table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  job string,
  phone string);

SHOW TABLES like '%CUSTOMERS%';
-- We can see that the retention time is 1
-- Let's make the retention time 2 days for the table
ALTER TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS
SET DATA_RETENTION_TIME_IN_DAYS = 2;

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.ret_example (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  job string,
  phone string)
  DATA_RETENTION_TIME_IN_DAYS = 3;

-- above we straight away made retention time 3 days during the table creation with the create command
SHOW TABLES like '%EX%';
-- we can see that the retention time is 3 days
-- let's now reduce it to 0
ALTER TABLE OUR_FIRST_DB.PUBLIC.ret_example
SET DATA_RETENTION_TIME_IN_DAYS = 0;
SHOW TABLES like '%EX%';
-- We can see now the data retention time has reduced to 0 now. 



DROP TABLE OUR_FIRST_DB.public.ret_example;
UNDROP TABLE OUR_FIRST_DB.public.ret_example;
--  We can't use UNDROP command as the retention time was reduced to 0

-- Time Travel is a feature unique to Snowflake and it uses Storage to provide that fascility
-- Therefore, longer the time travel we configure, more will be the storage cost. 
// Looking at the Time Travel Cost
use role accountadmin;
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE ORDER BY USAGE_DATE DESC;

// Table Level Aggregation of the Time Travel Storage Usage
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;

// Query time travel storage converted into GigaBytes
SELECT 	ID, 
		TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES / (1024*1024*1024) AS STORAGE_USED_GB,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
ORDER BY STORAGE_USED_GB DESC,TIME_TRAVEL_STORAGE_USED_GB DESC;

