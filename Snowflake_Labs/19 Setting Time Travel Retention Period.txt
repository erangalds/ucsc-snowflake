// Time Travel - Retention Period Setting
// Looking at the Current Time Travel Setting for a Table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  job string,
  phone string);

SHOW TABLES like '%CUSTOMERS%';

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

SHOW TABLES like '%EX%';

ALTER TABLE OUR_FIRST_DB.PUBLIC.ret_example
SET DATA_RETENTION_TIME_IN_DAYS = 0;

DROP TABLE OUR_FIRST_DB.public.ret_example;
UNDROP TABLE OUR_FIRST_DB.public.ret_example;


// Looking at the Time Travel Cost
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


