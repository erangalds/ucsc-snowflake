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

-- Let's try to load the data again into the our orders_ex table
truncate table OUR_FIRST_DB.PUBLIC.ORDERS_EX;

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
-- We can see that we were able to partially load the table, where the two error records were not loaded.
    
// Creating table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));    
    
// Creating schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

// Creating file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;

// See properties of file format object
DESC file format MANAGE_DB.file_formats.my_file_format;
-- We can see below all the available parameters to configure a FILEFORMAT Object

// Using file format object in Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
-- We can see that the same file didn't get loaded now.
-- Now its saying that we have 3 errors, and total line count has increased to 1501. 
-- The problem is that earlier we asked to skip the header row, but in the file format object we have not mentioned that. 

// Altering file format object
ALTER file format MANAGE_DB.file_formats.my_file_format
    SET SKIP_HEADER = 1;

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
-- That worked. 
-- validate
select * from OUR_FIRST_DB.PUBLIC.ORDERS_EX;

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

// Altering the type of a file format is not possible
ALTER file format MANAGE_DB.file_formats.my_file_format
SET TYPE = CSV;
-- We can't change the TYPE of a FILEFORMAT Object after creating
-- We have do drop the FILEFORMAT object and recreate it

// Recreate file format (default = CSV)
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;

// See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   

// Truncate table
TRUNCATE table OUR_FIRST_DB.PUBLIC.ORDERS_EX;

// Overwriting properties of file format object      
-- IF required we can override some settings in the fileformat object
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM  @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (FORMAT_NAME= MANAGE_DB.file_formats.my_file_format  field_delimiter = ',' skip_header=1 )
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

DESC STAGE MANAGE_DB.external_stages.aws_stage_errorex;
-- We can see that we have not mentioned the field_delimiter parameter
