// Using FILEFORMAT Objects
// Specifying file_format in Copy command
// What we are trying to do is taking that FILE_FORMAT options into a separate definition for easy re-usability
select current_role();
use role sysadmin;
use database our_first_db;
select current_database();
show schemas;
use schema public;
select current_schema();
show tables;

-- Since we careated this orders_ex table in our last lab,let's see whether we have data loaded already.
select * from our_first_db.public.orders_ex;
-- If the table is present let's truncate the data
truncate table if exists our_first_db.public.orders_ex;
-- validate the truncate
select * from our_first_db.public.orders_ex;
-- Loading Some data
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
-- 1498 rows loaded, 2 records had errors. 
-- Let's recreate the table 
// Creating table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));    
    
// Creating schema to keep things organized
-- creating a separate schema in the managed db to keep all the file formats
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

// Creating file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;

// See properties of file format object
DESC file format MANAGE_DB.file_formats.my_file_format;
-- The default file format type is CSV. Therefore if not specified the file type will be CSV
-- We can all the different settings which are available to be adjusted to suit our requirements

// Now using file format object in Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
-- Nothing got loaded as now the number of errors are 3, which is equal to the error limit.
-- We can see now snowflake is trying to load 1501 rows, which is one higher than the before for the same source data file
-- Looks like snowflake is trying to load the header row as well. Therefore let's skip the header row. 
-- Let's do that adjustment to the fileformat object
// Altering file format object
ALTER file format MANAGE_DB.file_formats.my_file_format
    SET SKIP_HEADER = 1;
-- Now let's check the data loading again
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
--validated
select * from our_first_db.public.orders_ex;
-- Now let's create another file format object. But this time the file is of a JSON
// Defining properties on creation of file format object   
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format
    TYPE=JSON,
    TIME_FORMAT=AUTO;    
    
// See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   

// Using file format object in Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
-- The data load fails as the fileformat was of a JSON, and we used the same csv source file. 
// Altering the type of a file format is not possible
-- Let's try to change the file type to CSV now
ALTER file format MANAGE_DB.file_formats.my_file_format
SET TYPE = CSV;
-- We get an error, which means we can't change the file type of the fileformat object after its been created.
-- only option is that we drop and recreate the file format object
// Recreate file format (default = CSV)
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;

// See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   
-- Recreating the fileformat object had reset that to its defaults, where skip header is 0. 

// Truncate table
TRUNCATE table OUR_FIRST_DB.PUBLIC.ORDERS_EX;

// Overwriting properties of file format object      
-- Since the fileformat object has the skip header with default setting which is 0, we need to now override
-- We can override as below. 
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM  @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (FORMAT_NAME= MANAGE_DB.file_formats.my_file_format  field_delimiter = ',' skip_header=1 )
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

DESC STAGE MANAGE_DB.external_stages.aws_stage_errorex;

--validate the data load
select * from our_first_db.public.orders_ex;