// Cool Features of Snowflake - UNDROP Database Objects
use role sysadmin;
use database our_first_db;
use warehouse compute_wh;
select current_role(), current_database(), current_warehouse();
// Setting up table
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
drop table if exists our_first_db.public.customers;
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
--validate data load
SELECT * FROM OUR_FIRST_DB.public.customers;

// UNDROP command - for Tables
-- Let us now make a mistake by dropping the customers table
DROP TABLE OUR_FIRST_DB.public.customers;
-- validate
SELECT * FROM OUR_FIRST_DB.public.customers;
-- we get an error 

UNDROP TABLE OUR_FIRST_DB.public.customers;
-- validate
SELECT * FROM OUR_FIRST_DB.public.customers;
-- We can see that we were able to get the table restored using the UNDROP command


// UNDROP command - for Schemas
-- Let us now make another mistake by dropping the schema
DROP SCHEMA OUR_FIRST_DB.public;
-- validate
show schemas;
SELECT * FROM OUR_FIRST_DB.public.customers;
-- we get an erro as expected
-- Using UNDROP to restore a schema
UNDROP SCHEMA OUR_FIRST_DB.public;
-- validate
show schemas;
-- we can see the public schema again
SELECT * FROM OUR_FIRST_DB.public.customers;


// UNDROP command -  for Database
-- let us now make the bigger mistake by dropping a database
DROP DATABASE OUR_FIRST_DB;
-- validate
show databases;
-- our_first_db is no longer available
SELECT * FROM OUR_FIRST_DB.public.customers;
-- we get an error as expected
-- Using UNDROP to recover a database
UNDROP DATABASE OUR_FIRST_DB;
-- validate
show databases;
-- we can see the our_first_db again now
SELECT * FROM OUR_FIRST_DB.public.customers;


-- Let us now see how we can Restore a replaced table 
SELECT * FROM OUR_FIRST_DB.public.customers;
UPDATE OUR_FIRST_DB.public.customers
SET LAST_NAME = 'Tyson';
UPDATE OUR_FIRST_DB.public.customers
SET JOB = 'Data Analyst';
-- We have make two mistakes now
SELECT * FROM OUR_FIRST_DB.public.customers;

// Undroping with a name that already exists
// Making a mistake while restoring (using a wrong query id)
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers as
SELECT * FROM OUR_FIRST_DB.public.customers before (statement => '01af8caf-0000-77d4-0003-df4a0011e812');

// verifying the 
SELECT * FROM OUR_FIRST_DB.public.customers;
-- We can see that we have the wrong last names
// CREATE OR REPLACE make the current table to DROP
// Therefore trying to use UNDROP 
UNDROP table OUR_FIRST_DB.public.customers;
-- But we get an error because the table was dropped and created as new using the create or replace statement earlier
-- let us rename the table
show tables;
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
--validate data load
SELECT * FROM OUR_FIRST_DB.public.customers;
-- Making the Mistake again
UPDATE OUR_FIRST_DB.public.customers
SET LAST_NAME = 'Tyson'; // 01b74f00-0000-bc9b-0003-df4a002f0a9a
UPDATE OUR_FIRST_DB.public.customers
SET JOB = 'Data Analyst'; // 01b74f00-0000-bc9d-0003-df4a002f1296
-- We have make two mistakes now
SELECT * FROM OUR_FIRST_DB.public.customers;
-- Renaming the Original Table to with a New Name

ALTER TABLE OUR_FIRST_DB.public.customers
RENAME TO OUR_FIRST_DB.public.customers_wrong;

show tables;
DESC table OUR_FIRST_DB.public.customers;
// Correcting the mistake by using the correct query id
-- We restore the customer table from the customer_wrong table's time travel details
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers as
SELECT * FROM OUR_FIRST_DB.public.customers_wrong before (statement => '01b74f00-0000-bc9b-0003-df4a002f0a9a');

DESC table OUR_FIRST_DB.public.customers;

SELECT * FROM OUR_FIRST_DB.public.customers;
--  Therefore its always better to either follow this was by renaming original table and recreating the previous table with the renamed table
-- Or restore the data to a new table then truncate the original able and re-insert data. 
-- The reason is as soon as we issue a create or replace the time travel information gets reset.     