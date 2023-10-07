--Now let's see how we can handle errors in the data file while loading data using the COPY command
select current_role();
use role sysadmin;
use database our_first_db;
select current_database();
show schemas;
use schema public;
select current_schema();
show tables;
// Create new stage
 CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage_errorex
    url='s3://bucketsnowflakes4';
 
 // List files in stage
 LIST @MANAGE_DB.external_stages.aws_stage_errorex;
 -- We can see there are two csv files which we will use
 
 // Create example table
 CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
 -- Verify table creation
 show tables;
 // Demonstrating error message
 COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv');
 /*
  Numeric value 'one thousand' is not recognized
  File 'OrderDetails_error.csv', line 2, character 14
  Row 1, column "ORDERS_EX"["PROFIT":3]
  If you would like to continue loading when an error is encountered, use other values such as 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option. For more information on loading options, please run 'info loading_data' in a SQL client.
  */
  
 // Validating table is empty    
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;    
    

// Error handling using the ON_ERROR option
-- We are going to set the ON_ERROR parameter to CONTINUE which will skip the error records and proceed with the valid records
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'CONTINUE';
-- We can see that out of 1500 records 2 records had erros there fore those two rows didn't get loaded
-- The output also shows the first error output, where we had 'one thousand' instead of 1000. 
  // Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
-- We can see only 1498 rows are there in the table now 

-- remove all the data records from the table 
TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;

// Error handling using the ON_ERROR option = ABORT_STATEMENT (default)
-- Now setting the ON_ERROR parameter to ABORT_STATEMENT, which will stop the COPY operation. This is the default behavior
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'ABORT_STATEMENT';

  // Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
-- As expected nothing got loaded into the tables

TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;

// Error handling using the ON_ERROR option = SKIP_FILE
-- Setting the ON_ERROR parameter to SKIP_FILE option. This will skip the operation of the file with errors to the next available file for loading
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE';
-- We can see that from the two files, nothing got loaded from the first file, because it had 2 errors and the current error limit is 1 therefore it skiped
    
// Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
-- We can see that whole of 285 lines got loaded from the second file
TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;    
    
// Error handling using the ON_ERROR option = SKIP_FILE_<number>
-- Setting the ON_ERROR parameter to SKIP_FILE with a number. Here the number represent the error_limit. 
-- Which means the file is skipped or aborted only if the number of errors exceeds the error_limit
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE_2';    
    
    
  // Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;    

    
// Error handling using the ON_ERROR option = SKIP_FILE_<number>
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE_0.5%'; 
-- We are setting the error_limit to 0.5%. 1500 * 0.5% is 7. Since the number of errors in the file is lower than 7 the valid records gets loaded
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

LIST @MANAGE_DB.external_stages.aws_stage_errorex;  
-- Look at the size of the files
TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;   
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = SKIP_FILE_3 
    SIZE_LIMIT = 30;
/*
Number (> 0) that specifies the maximum size (in bytes) of data to be loaded for a given COPY statement. 
When the threshold is exceeded, the COPY operation discontinues loading files. 
This option is commonly used to load a common group of files using multiple COPY statements. For each statement, the data load continues until the specified SIZE_LIMIT is exceeded, before moving on to the next statement.
For example, suppose a set of files in a stage path were each 10 MB in size. 
If multiple COPY statements set SIZE_LIMIT to 25000000 (25 MB), each would load 3 files. That is, each COPY operation would discontinue after the SIZE_LIMIT threshold was exceeded.
Note that at least one file is loaded regardless of the value specified for SIZE_LIMIT unless there is no file to be loaded.
 */
-- Validate
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
-- We can see the last file got loaded regardless of the SIZE_LIMIT and that's expected behavior