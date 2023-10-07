// Step 1 - Creating a separate Database to keep / manage all the 
// Database to manage stage objects, fileformats etc.
select current_role();
use role sysadmin;
-- Listing the current databases
show databases;
-- dropping the manage_db database if exists
drop database if exists manage_db;
show databases;
CREATE OR REPLACE DATABASE MANAGE_DB;
select current_database();
CREATE OR REPLACE SCHEMA external_stages;
select current_schema();



// Creating external stage

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3'
    credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');


// Description of external stage

DESC STAGE MANAGE_DB.external_stages.aws_stage; 

// Step 2 - Modifying the previously created Stage : external_stage.aws_stage
// Alter external stage   

ALTER STAGE aws_stage
    SET credentials=(aws_key_id='XYZ_DUMMY_ID' aws_secret_key='987xyz');
    
    
// Publicly accessible staging area    
select current_database();
select current_schema();
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

// Step 3 - Listing the loaded files in the stage
// List files in stage
LIST @aws_stage;

// Step 4 - Create a Table to load the data in the stage
drop database if exists our_first_db;
select current_database();

create or replace database our_first_db;
select current_database();
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;
   
// First copy command

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @aws_stage
    file_format = (type = csv field_delimiter=',' skip_header=1);
show stages;
select current_database();
-- The above loading COPY command fails becaue in the FROM statement we have given only the stage name, not the full name space.
-- Since we are in a different database (our_first_db) now, that database doesn't have a stage named aws_stage

// Step 5 - Different Syntax for using the COPY Command
// Copy command with fully qualified stage object

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1);
-- This copy command also fails. 
-- Here we have given the full namespace of the stage but, let's see why it failed by looking at what's inside the stage

// Step 6 - Different Syntax for using the COPY Command
// List files contained in stage

LIST @MANAGE_DB.external_stages.aws_stage;    
-- The list has three files but all three of them are different to each other, therefore the structure of the files are different. 
-- What we want is to load the oderdetails. Therefore we have to specify the name of the file which we want to load. Otherwise Snowflake tries to load all files. 

// Copy command with specified file(s)
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails.csv');
-- Copy command was successfull. 1500 rows got parsed and all of it got loaded. We didn't see any errors. 
-- Verify the copy of data
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;

// Copy command with pattern for file names
TRUNCATE OUR_FIRST_DB.PUBLIC.ORDERS;
-- verify truncate
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';
-- We gave a pattern to the file name which we want to load. We do this if there were multiple Orderdetail files for us to load in the stage. 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;

