// Cool Features of Snowflake - UNDROP Database Objects
// Setting up table
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
// Create a temporary table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  job string,
  phone string);
    
// Loading Data
COPY INTO OUR_FIRST_DB.public.customers
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');

SELECT * FROM OUR_FIRST_DB.public.customers;

// UNDROP command - Tables

DROP TABLE OUR_FIRST_DB.public.customers;

SELECT * FROM OUR_FIRST_DB.public.customers;

UNDROP TABLE OUR_FIRST_DB.public.customers;


// UNDROP command - Schemas

DROP SCHEMA OUR_FIRST_DB.public;

SELECT * FROM OUR_FIRST_DB.public.customers;

UNDROP SCHEMA OUR_FIRST_DB.public;

SELECT * FROM OUR_FIRST_DB.public.customers;


// UNDROP command - Database

DROP DATABASE OUR_FIRST_DB;

SELECT * FROM OUR_FIRST_DB.public.customers;

UNDROP DATABASE OUR_FIRST_DB;

SELECT * FROM OUR_FIRST_DB.public.customers;


// Restore replaced table 
UPDATE OUR_FIRST_DB.public.customers
SET LAST_NAME = 'Tyson';


UPDATE OUR_FIRST_DB.public.customers
SET JOB = 'Data Analyst';

SELECT * FROM OUR_FIRST_DB.public.customers;

// // // Undroping a with a name that already exists
// Making a mistake while restoring (using a wrong query id)
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers as
SELECT * FROM OUR_FIRST_DB.public.customers before (statement => '01a5c4ef-0000-31bb-0003-a55600039276');

// verifying the 
SELECT * FROM OUR_FIRST_DB.public.customers;
// CREATE OR REPLACE make the current table to DROP
// Therefore using UNDROP 
UNDROP table OUR_FIRST_DB.public.customers;

ALTER TABLE OUR_FIRST_DB.public.customers
RENAME TO OUR_FIRST_DB.public.customers_wrong;

DESC table OUR_FIRST_DB.public.customers;
// Correcting the mistake by using the correct query id
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers as
SELECT * FROM OUR_FIRST_DB.public.customers before (statement => '01a5c4ef-0000-31bb-0003-a55600039276');

DESC table OUR_FIRST_DB.public.customers;

SELECT * FROM OUR_FIRST_DB.public.customers;
    