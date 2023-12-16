// PARQUET is one of the most famous data types. The main reason is its high compression capabilities
// Snowflake has speacial features to handle parquet data files. 
use role sysadmin;
select current_role();
// Create file format object for the parquet object type
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT
    TYPE = 'parquet';
// Create a stage object
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'   
    FILE_FORMAT = MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT;
    
// Preview the data sitting in the Stage without loading into snowflake
// Listing the files in the stage 
LIST  @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;   
// Looking at the data in the stage  
-- We can query the data in the stage with a select query directly even without getting them loaded   
SELECT * FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;
    

// Its convenient to use the file format object in the stage 
-- otherwise we have to specifically mention that
-- Let's see what will happen if we don't specify the file type
// File format in Queries
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo';  
    
SELECT * 
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;
-- Snowflake is not able to figure out what the file format / type is. 
-- In such cases we can manually override the file format in the select query
SELECT * 
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
(file_format => 'MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT');

// Quotes can be omitted in case of the current namespace
USE MANAGE_DB.FILE_FORMATS;

SELECT * 
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
(file_format => MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT);


CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'   
    FILE_FORMAT = MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT;

// Syntax for Querying Semistructured data in the parquet data file
SELECT 
$1:__index_level_0__,
$1:cat_id,
$1:date,
$1:"__index_level_0__",
$1:"cat_id",
$1:"d",
$1:"date",
$1:"dept_id",
$1:"id",
$1:"item_id",
$1:"state_id",
$1:"store_id",
$1:"value"
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;

// Converting / Handling Dates in the Parquet file
    
SELECT 1;
SELECT DATE(365*60*60*24);

// Querying with conversions and aliases
SELECT 
$1:__index_level_0__::int as index_level,
$1:cat_id::VARCHAR(50) as category,
DATE($1:date::int ) as Date,
$1:"dept_id"::VARCHAR(50) as Dept_ID,
$1:"id"::VARCHAR(50) as ID,
$1:"item_id"::VARCHAR(50) as Item_ID,
$1:"state_id"::VARCHAR(50) as State_ID,
$1:"store_id"::VARCHAR(50) as Store_ID,
$1:"value"::int as value
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;

// Adding Metadata of the loaded data into the snowflake table for reference purpose
    
SELECT 
$1:__index_level_0__::int as index_level,
$1:cat_id::VARCHAR(50) as category,
DATE($1:date::int ) as Date,
$1:"dept_id"::VARCHAR(50) as Dept_ID,
$1:"id"::VARCHAR(50) as ID,
$1:"item_id"::VARCHAR(50) as Item_ID,
$1:"state_id"::VARCHAR(50) as State_ID,
$1:"store_id"::VARCHAR(50) as Store_ID,
$1:"value"::int as value,
METADATA$FILENAME as FILENAME,
METADATA$FILE_ROW_NUMBER as ROWNUMBER,
TO_TIMESTAMP_NTZ(current_timestamp) as LOAD_DATE
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;

// Removing the TimeZone
SELECT current_timestamp, TO_TIMESTAMP_NTZ(current_timestamp);

// Create destination table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.PARQUET_DATA (
    ROW_NUMBER int,
    index_level int,
    cat_id VARCHAR(50),
    date date,
    dept_id VARCHAR(50),
    id VARCHAR(50),
    item_id VARCHAR(50),
    state_id VARCHAR(50),
    store_id VARCHAR(50),
    value int,
    Load_date timestamp default TO_TIMESTAMP_NTZ(current_timestamp));

// Load the parquet data into a snowflake relational table
COPY INTO OUR_FIRST_DB.PUBLIC.PARQUET_DATA
    FROM (SELECT 
            METADATA$FILE_ROW_NUMBER,
            $1:__index_level_0__::int,
            $1:cat_id::VARCHAR(50),
            DATE($1:date::int ),
            $1:"dept_id"::VARCHAR(50),
            $1:"id"::VARCHAR(50),
            $1:"item_id"::VARCHAR(50),
            $1:"state_id"::VARCHAR(50),
            $1:"store_id"::VARCHAR(50),
            $1:"value"::int,
            TO_TIMESTAMP_NTZ(current_timestamp)
        FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE);
-- Validating the data load
SELECT * FROM OUR_FIRST_DB.PUBLIC.PARQUET_DATA;