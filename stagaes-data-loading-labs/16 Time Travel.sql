// Some More Cool Features in Snowflakes - Time Travel 
// Setting up table
use role sysadmin;
select current_role();
use warehouse compute_wh;
use database our_first_db;
select current_role(), current_warehouse(), current_database();
// Creating a new temporary table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  job string,
  phone string
);
show databases;  
show tables;
// Creating a FILE FORMAT object
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1;
    
// Creating a new stage object for time travel
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
// Listing the files inside the stage object
LIST @MANAGE_DB.external_stages.time_travel_stage;

// Loading data from the stage to the temp tabale
COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');

// Verifying the data
SELECT * FROM OUR_FIRST_DB.public.test;

// Use-case: Update data (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET FIRST_NAME = 'Joyen';

SELECT * FROM OUR_FIRST_DB.public.test;
-- Now all the records contain Joyen as the first name
// Using time travel: Method 1 - 2 minutes back
SELECT * FROM OUR_FIRST_DB.public.test at (OFFSET => -60*1.75);

select current_timestamp();
//2024-09-27 02:46:35.699 -0700
// Using time travel: Method 2 - before timestamp
SELECT * FROM OUR_FIRST_DB.public.test before (timestamp => '2024-09-27 02:45:35.699 -0700'::timestamp);



-- Setting up table again
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  job string,
  phone string);

COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');


SELECT * FROM OUR_FIRST_DB.public.test;


-- Setting up UTC time for convenience
ALTER SESSION SET TIMEZONE ='UTC';
SELECT DATEADD(DAY, 1, CURRENT_TIMESTAMP);

// 2024-09-28 09:50:22.086 +0000
// Messing up the data deliberately to show time travel 
select current_timestamp; //2024-09-27 09:50:40.783 +0000
-- Keep the timestamp before the mistake
UPDATE OUR_FIRST_DB.public.test
SET Job = 'Data Scientist';

SELECT * FROM OUR_FIRST_DB.public.test;
select current_timestamp;
-- use the time stamp just before the mistake. You might have to adjust the minutes or seconds a little bit to get the results needed.
-- 01b74eef-0000-bc9d-0003-df4a002f11c2
-- 2024-09-27 09:51:20.867 +0000
SELECT * FROM OUR_FIRST_DB.public.test before (timestamp => '2024-09-27 09:50:20.867 +0000'::timestamp);

// Using time travel: Method 3 - before Query ID

// Preparing table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  phone string,
  job string);

COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');


SELECT * FROM OUR_FIRST_DB.public.test;


// Altering table (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET EMAIL = null;

SELECT * FROM OUR_FIRST_DB.public.test;
-- You have to select the Snoflake Icon on the VS Code, go to Query History pane on the left side below
-- Select the update sql statement which we executed. Then on the right hand side you will see the query details. 
-- There you will find the query id
-- That's what we need to use below to access the data before the mistake. 
-- This is the best and the easiest way to access the data before the mistake
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01b74ef1-0000-bc9d-0003-df4a002f11e2');
