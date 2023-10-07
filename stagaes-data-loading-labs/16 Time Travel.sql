// Some More Cool Features in Snowflakes - Time Travel 
// Setting up table

// Creating a new temporary table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  job string,
  phone string);
    
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

// Using time travel: Method 1 - 2 minutes back
SELECT * FROM OUR_FIRST_DB.public.test at (OFFSET => -60*3.5);

select current_timestamp();

// Using time travel: Method 2 - before timestamp
SELECT * FROM OUR_FIRST_DB.public.test before (timestamp => '2022-07-22 03:48:50.581'::timestamp);



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

// 2022-07-23 04:04:48.149 +0000
// Messing up the data deliberately to show time travel 
UPDATE OUR_FIRST_DB.public.test
SET Job = 'Data Scientist';

SELECT * FROM OUR_FIRST_DB.public.test;

SELECT * FROM OUR_FIRST_DB.public.test before (timestamp => '2022-07-23 04:04:35.149'::timestamp);

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

SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a5c4da-0000-318c-0003-a5560003d03e');
