// Restoring Data using Time Travel Features
// Setting up table
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
UPDATE OUR_FIRST_DB.public.test
SET LAST_NAME = 'Tyson';

SELECT * FROM OUR_FIRST_DB.public.test;

// Mistake #2
UPDATE OUR_FIRST_DB.public.test
SET JOB = 'Data Analyst';

SELECT * FROM OUR_FIRST_DB.public.test;

SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a5c4e2-0000-31b6-0003-a5560003b41a');



// // // Bad method

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01a5c4e3-0000-318c-0003-a5560003d086');

// Verifing the restoration
SELECT * FROM OUR_FIRST_DB.public.test

// We see that we have used a wrong query id to restore the data
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '019b9eea-0500-8473-0043-4d830007307a');
// CREATE OR REPLACE resets the time travel information

// // // Good method
// Step 1 : Create a Back up table and load the data into that using Time Travel
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test_backup as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '019b9ef0-0500-8473-0043-4d830007309a')

// Truncate the Original Table
TRUNCATE OUR_FIRST_DB.public.test

// Insert the data from the backup table
INSERT INTO OUR_FIRST_DB.public.test
SELECT * FROM OUR_FIRST_DB.public.test_backup;


// Verifying the Data
SELECT * FROM OUR_FIRST_DB.public.test;