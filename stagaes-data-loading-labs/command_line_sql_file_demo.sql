select current_role();
use role sysadmin;

CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/returnfailed/';

LIST @COPY_DB.PUBLIC.aws_stage_copy;    

//Trying to load the data into a table
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @COPY_DB.PUBLIC.aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;

CREATE OR REPLACE TABLE COPY_DB.PUBLIC.rejected_commandline AS 
SELECT REJECTED_RECORD 
FROM TABLE (RESULT_SCAN (last_query_id()));

SELECT * FROM COPY_DB.PUBLIC.rejected_commandline;