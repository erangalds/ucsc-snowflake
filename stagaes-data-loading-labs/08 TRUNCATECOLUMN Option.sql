// Now let's see how we can handle loading data which are larger than the specified column sizes
---- TRUNCATECOLUMNS ----
select current_role();
use role sysadmin;
CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(10),
    SUBCATEGORY VARCHAR(30));

// Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';
  
LIST @COPY_DB.PUBLIC.aws_stage_copy;
    
 //Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @COPY_DB.PUBLIC.aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';

select * from copy_db.public.orders;
-- Query failes because the column character size is lower than the filed value in the file
-- In such situations, if needed we can enable TRUNCATECOLUMNS option
-- That will load part of the value in the field to suite the actual column size
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @COPY_DB.PUBLIC.aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    TRUNCATECOLUMNS = true; 
-- Validate the data load
select * from copy_db.public.orders;