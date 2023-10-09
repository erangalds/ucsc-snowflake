// We are going to talk about how to handle the ERROR records / Rejected Records
---- Use files with errors ----
select current_role();
use role sysadmin;
use database our_first_db;
select current_database();
show schemas;
use schema public;
select current_schema();
show tables;

CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/returnfailed/';

LIST @COPY_DB.PUBLIC.aws_stage_copy;    

//Trying to load the data into a table
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @COPY_DB.PUBLIC.aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;
-- For each failed record we can see from which file the error record was found as well as the actual error record
-- We can't any valid records out
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @COPY_DB.PUBLIC.aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_1_rows;
    

-- Let's say that we want to captuer the rejected records / error records into a separate table for future actions
-------------- Working with error results -----------

---- 1) Saving rejected files after VALIDATION_MODE ---- 

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @COPY_DB.PUBLIC.aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;

select * from table(result_scan(last_query_id()));
SET qid = LAST_QUERY_ID();

CREATE OR REPLACE TABLE rejected AS 
SELECT rejected_record 
FROM TABLE (RESULT_SCAN ($qid));


// Storing rejected /failed results in a table
CREATE OR REPLACE TABLE rejected AS 
select rejected_record from table(result_scan(last_query_id()));



SELECT * FROM rejected;

INSERT INTO rejected
select rejected_record from table(result_scan(last_query_id()));

SELECT * FROM rejected;

---- 2) Saving rejected files without VALIDATION_MODE ---- 

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    ON_ERROR=CONTINUE;
  
  
select * from table(validate(orders, job_id => '_last'));


---- 3) Working with rejected records ---- 

SELECT REJECTED_RECORD FROM rejected;

CREATE OR REPLACE TABLE rejected_values as
SELECT 
SPLIT_PART(rejected_record,',',1) as ORDER_ID, 
SPLIT_PART(rejected_record,',',2) as AMOUNT, 
SPLIT_PART(rejected_record,',',3) as PROFIT, 
SPLIT_PART(rejected_record,',',4) as QUATNTITY, 
SPLIT_PART(rejected_record,',',5) as CATEGORY, 
SPLIT_PART(rejected_record,',',6) as SUBCATEGORY
FROM rejected; 


SELECT * FROM rejected_values;