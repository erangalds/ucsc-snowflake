// Handling Unstructured Data in Snowflake
// Most of the data we capture today are unstructured
// Here we are going to load a JSON Data Set
// First step: Load Raw JSON ==========================================

// Create a new Stage
CREATE OR REPLACE stage MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
     url='s3://bucketsnowflake-jsondemo';

// Create a new FILE_FORMAT with TYPE of JSOn
CREATE OR REPLACE file format MANAGE_DB.FILE_FORMATS.JSONFORMAT
    TYPE = JSON;
    
// Creating a Table with a single column of type VARIANT     
CREATE OR REPLACE table OUR_FIRST_DB.PUBLIC.JSON_RAW (
    raw_file variant);

// Loading the JSON Data into the table
COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
    FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    file_format= MANAGE_DB.FILE_FORMATS.JSONFORMAT
    files = ('HR_data.json');
    
// Validating the data load
SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

// Second step: Parse & Analyze RAW JSON ==========================================

// Selecting attribute/column
SELECT RAW_FILE:city FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
// We can specify the Column Number using $1
SELECT $1:first_name FROM OUR_FIRST_DB.PUBLIC.JSON_RAW


// Selecting attribute/column - formattted
SELECT RAW_FILE:first_name::string as first_name  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT RAW_FILE:id::int as id  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;
// Combining the 
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:last_name::STRING as last_name,
    RAW_FILE:gender::STRING as gender
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

// Handling nested data
   
SELECT RAW_FILE:job as job  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

// Third Step : Handling the Nested Data Set ======================================
   // Handling nested data
   
SELECT RAW_FILE:job as job  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

// using the <parent>.<child> format to access the nested data 
SELECT 
      RAW_FILE:job.salary::INT as salary
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


// Combining multiple columns in the select
SELECT 
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:job.salary::INT as salary,
    RAW_FILE:job.title::STRING as title
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


// Handling arreys
// We can see that not every employee has a previous company in the HR records. Which is a possibility in Unstructured data
SELECT
    RAW_FILE:prev_company as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT
    RAW_FILE:prev_company[1]::STRING as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


SELECT
    ARRAY_SIZE(RAW_FILE:prev_company) as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

// Combining the Two Previous Company Records
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:prev_company[0]::STRING as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:prev_company[1]::STRING as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
ORDER BY id;

// Dealing with Heirarchy
SELECT 
    RAW_FILE:spoken_languages as spoken_languages
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


SELECT 
     array_size(RAW_FILE:spoken_languages) as spoken_languages
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW


SELECT 
     RAW_FILE:first_name::STRING as first_name,
     array_size(RAW_FILE:spoken_languages) as spoken_languages
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW



SELECT 
    RAW_FILE:spoken_languages[0] as First_language
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


SELECT 
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:spoken_languages[0] as First_language
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


SELECT 
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as First_language,
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW

SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as First_language,
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[1].language::STRING as First_language,
    RAW_FILE:spoken_languages[1].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[2].language::STRING as First_language,
    RAW_FILE:spoken_languages[2].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
ORDER BY ID

// The above UNION ALL method, has few disadvantages, first, its needs long code,
// second, if we have more nested objects in the array, then its not easier to write this
// third we end up getting null values for those records which don't have more nested objects in the array
// Therefore there is a much more convenient way to handle this, using the flatten function in snwoflake sql
// This handles n level of nested objects in the array and remove null rows and gives a clean output. 
select
   RAW_FILE:first_name::STRING as First_name,
   f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;

// Step 4 - Loading the data into the Final Snowflake Table
// Option 1: CREATE TABLE AS

CREATE OR REPLACE TABLE Languages AS
SELECT
   RAW_FILE:first_name::STRING as First_name,
   f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;

SELECT * FROM Languages;

TRUNCATE TABLE languages;

// Option 2: INSERT INTO

INSERT INTO Languages
SELECT
   RAW_FILE:first_name::STRING as First_name,
   f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;


SELECT * FROM Languages;

