// Sometimes its important for us to know what data, from which files got loaded to which table. 
// These meta data is stored in a separte schema in the database called information_schema 
// Query load history within a database
select current_role();
use role sysadmin;

USE COPY_DB;
-- by calling the load_history view we can get the entire load history for the database. 
SELECT * FROM information_schema.load_history;

// Query load history gloabally from SNOWFLAKE database --
select current_role();
use role accountadmin;
select current_role();
SELECT * FROM snowflake.account_usage.load_history;
-- we have to elevate the role to accountadmin in order to query the global load_history details from the snowflake database

// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
  where schema_name='PUBLIC' and
  table_name='ORDERS';
  
// Filter on specific table & schema and looking for loades with errors
SELECT * FROM snowflake.account_usage.load_history
  where schema_name='PUBLIC' and
  table_name='ORDERS' and
  error_count > 0;
  
// Filter on specific table & schema
-- selecting data loads done during the last 24 hours
SELECT * FROM snowflake.account_usage.load_history
WHERE DATE(LAST_LOAD_TIME) <= DATEADD(days,-1,CURRENT_DATE);