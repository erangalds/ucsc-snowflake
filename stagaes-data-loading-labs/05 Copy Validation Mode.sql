---- VALIDATION_MODE ----
-- Now when we have large source files to load, its important to find out errors in them before the actual load. 
-- Otherwise we will end up wasting a lot of compute power just to findout that few records in the source file are errorneous. 
-- Snowflkae provide a Validation Option for this kind of requirements. 
select current_role();
use role sysadmin;
use database our_first_db;
select current_database();
show schemas;
use schema public;
select current_schema();
show tables;

-- Creating a new database for the lab
// Prepare database & table
CREATE OR REPLACE DATABASE COPY_DB;
-- Let's create a table as well
CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

// Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';
-- Listing the Stage to see what's available in the stage location
LIST @COPY_DB.PUBLIC.aws_stage_copy;
  
-- Let's see whether we have data in the table
select * from copy_db.public.orders;
 //Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;
-- Query doesn't fail. Which means the file doesn't have any error records    
-- let's check whether it loaded any data into the table
select * from copy_db.public.orders;
-- The validation_mode does not load data. Its purpose is to validate the file format and source file against the target table
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
   VALIDATION_MODE = RETURN_5_ROWS;
-- The query returns 5 records
-- Let's check whether it loaded any data into the table
select * from copy_db.public.orders;
-- it doesn't load any records. 
   
   
// Getting the ERROR Lines
-- Now, we encountered files with error records. They only came in the error message. We didn't get a change to view them
// Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/returnfailed/';
  
LIST @COPY_DB.PUBLIC.aws_stage_copy;
  
    
 //Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;
-- This time the VALIDATION_MODE returns the error lines, which is quite useful because now we can get back to the source
-- We can see that the below query throws out an error, because the file has some error records. 
-- Therefore, have these two options for VALIDATION_MODE is very handy to identify what are the error records.
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
   VALIDATION_MODE = RETURN_5_ROWS
   
