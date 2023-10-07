use role sysadmin;
use warehouse compute_wh;

-- Creating and Managing Snowflake Databases 
-- Create a pernant database
-- Below are the mainly used key words to manage databases 
-- CREATE DATABSE / ALTER DATABASE / DROP DATABASE / SHOW DATABASES 
create or replace transient database DEMO3A_DB
comment = 'Permanent Database for Exercises'; 
-- comment option can specify some description of the databse

-- Create a transient database
create or replace transient database DEMO3B_DB
comment = 'Transient Database for Exercises';

use role accountadmin;
show databases;

-- Data retention time (in days) is the same as the Time Travel number of days and specifies the number of days for which the underlying data is retained after deletion, and for which the CLONE and UNDROP commands can be performed on the database. 
-- You can't change the data retention time in days for a transient database to something more than 1. Max you can set is 1. 
-- If we change the data retention time in days to 0 (zero) then we can't use CLONE or UNDROP features. 

-- Let's now specify the data_retention_time_in_days while creating the database 
use role sysadmin;
alter database demo3a_db 
set data_retention_time_in_days=10;

show databases;

-- creating a table in the transient database
use role sysadmin;

create or replace table demo3b_db.public.summary
(
    cach_amt number,
    receivable_amt number,
    customer_amt number
);

-- transient schema tables will be transient by default
show tables;

-- SNOWFLAKE SCHEMAS 
-- creating snowflake schemas
use role sysadmin;use database demo3a_db;
create or replace schema banking;

create or replace schema demo3a_db.banking2;

show schemas;
-- changing the data_retention_time_in_days value for the schema
alter schema demo3a_db.banking
set data_retention_time_in_days=1;

-- check for the retention time
show schemas;
-- replacing a table into a new schema by renaming the table
use role sysadmin;
create or replace schema demo3b_db.banking;

alter table demo3b_db.public.summary
rename to demo3b_db.banking.summary;

-- check for schemas name 
show tables;


-- Creating Managed Access Schema
use role sysadmin; 
use database demo3a_db;
create or replace schema MSCHEMA with managed access;

show schemas;

use schema information_schema;

--  Account Views in INFORMATION_SCHEMA
select * from demo3a_db.information_schema.applicable_roles;
select * from databases;
select * from enabled_roles;
select * from information_schema_catalog_name;
select * from load_history;
select * from replication_databases;

-- Database Views in the INFORMATION_SCHEMA 
select * from columns;
select * from external_tables;
select * from file_formats;
select * from functions;
select * from object_privileges;
select * from pipes;
select * from procedures;
select * from referential_constraints;
select * from schemata;
select * from sequences;
select * from stages;
select * from table_constraints;
select * from TABLE_PRIVILEGES;
select * from table_storage_metrics;
select * from tables;
select * from USAGE_PRIVILEGES;
select * from views;

-- checking the details from two different information schema tables;
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.DATABASES;
SELECT * FROM DEMO3A_DB.INFORMATION_SCHEMA.DATABASES;


SELECT * FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.APPLICABLE_ROLES;
SELECT * FROM DEMO3A_DB.INFORMATION_SCHEMA.APPLICABLE_ROLES;

-- taking information about the schemas
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.SCHEMATA;
SHOW SCHEMAS IN DATABASE SNOWFLAKE_SAMPLE_DATA;

-- listing the table privileges in a given database
SELECT * FROM DEMO3A_DB.INFORMATION_SCHEMA.TABLE_PRIVILEGES;
SELECT * FROM DEMO3B_DB.INFORMATION_SCHEMA.TABLE_PRIVILEGES;

-- How to check the credit usage by virtual warehouses
USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE;
USE SCHEMA ACCOUNT_USAGE;
USE WAREHOUSE COMPUTE_WH;

SELECT start_time::date AS USAGE_DATE, WAREHOUSE_NAME,
SUM(credits_used) AS TOTAL_CREDITS_CONSUMED
FROM warehouse_metering_history
WHERE start_time >= date_trunc(Month, current_date)
GROUP BY 1,2
ORDER BY 2,1;

select current_database();

select current_role();

use role sysadmin;
use database demo3a_db;

create or replace schema banking;

-- creating few new tables
CREATE OR REPLACE TABLE CUSTOMER_ACCT
(Customer_Account int, Amount int, transaction_ts timestamp);
CREATE OR REPLACE TABLE CASH
(Customer_Account int, Amount int, transaction_ts timestamp);
CREATE OR REPLACE TABLE RECEIVABLES
(Customer_Account int, Amount int, transaction_ts timestamp);



-- Creating a view
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER;

USE ROLE SYSADMIN;
CREATE OR REPLACE VIEW DEMO3B_DB.PUBLIC.NEWVIEW AS
SELECT CC_NAME
FROM (SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER);
-- creating a materialized view
USE ROLE SYSADMIN;
CREATE OR REPLACE MATERIALIZED VIEW DEMO3B_DB.PUBLIC.NEWVIEW_MVW AS
SELECT CC_NAME
FROM (SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER);

-- Listing the views
use schema demo3b_db.public;
show views;
show materialized views;

-- Creating a simple stage object with a file format
use role sysadmin;
use database demo3b_db;
create or replace file format ff_json type = json;

create or replace temporary stage banking_stg file_format = ff_json;