// Restoring Data using Time Travel Features
// Setting up table
use role sysadmin;
use database our_first_db;
use warehouse compute_wh;
select current_role(), current_database(), current_warehouse();
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

// Use-case: Update data (by mistake)

// Mistake #1
-- Setting all last names to be Tyson
UPDATE OUR_FIRST_DB.public.test
SET LAST_NAME = 'Tyson';
-- Query ID - 01af8c36-0000-7714-0003-df4a0011d6aa

SELECT * FROM OUR_FIRST_DB.public.test;

// Mistake #2
-- Setting the job or all to Data Analyst
UPDATE OUR_FIRST_DB.public.test
SET JOB = 'Data Analyst';
-- Query ID - 01af8c36-0000-77d4-0003-df4a0011e6be

SELECT * FROM OUR_FIRST_DB.public.test;
-- Let's bring the Query IDs of the update statements
-- Before the last UPDATE statement - Second Mistake
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01af8c36-0000-77d4-0003-df4a0011e6be');
-- We can see that the job is correctly shown but the last name is not. 
-- Let us get the query Id of first update statement and see
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01af8c36-0000-7714-0003-df4a0011d6aa');
-- We can see the last names also correctly. 

-- Let us now try to restore
// // // Bad method
-- Let us mistakenly say did the restoration as below using the query id of the second mistake
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01af8c36-0000-77d4-0003-df4a0011e6be');

// Verifing the restoration
SELECT * FROM OUR_FIRST_DB.public.test;
-- We can see that we did not get the last name issue sorted. Now if we try to go back in time with the query id of the first mistake

// We see that we have used a wrong query id to restore the data
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01af8c36-0000-7714-0003-df4a0011d6aa');
-- We now cannot go back in time. 
-- This is because the key word CREATE OR REPLACE resets the time travel information
-- Therefore we cannot go back in time to restore the actual data

// // // Good method
// Step 1 : Create a Back up table and load the data into that using Time Travel
-- Before that let us go back and recreate the original table and do the same two mistakes 
-- Then bring the new query id of the 1st mistake 
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test_backup as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01af8c3f-0000-7714-0003-df4a0011d6e6');
-- Verify the data load into the backup table
select * from OUR_FIRST_DB.public.test_backup;
-- We can see that we now have the correct data set
// Truncate the Original Table
TRUNCATE OUR_FIRST_DB.public.test;

// Insert the data from the backup table
INSERT INTO OUR_FIRST_DB.public.test
SELECT * FROM OUR_FIRST_DB.public.test_backup;


// Verifying the Data
SELECT * FROM OUR_FIRST_DB.public.test;