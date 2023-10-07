-- Checking the current context
select
    current_role();
select
    current_warehouse();
select
    current_account();
select
    current_database();
select
    current_schema();
select
    current_schemas();
-- Setting the curent context
    use database snowflake_sample_data;
select
    current_database();
select
    current_schema();
select
    current_schemas();

-- Displaying the current available schemas
show schemas;
use schema tpcds_sf10tcl;
select
    current_schemas();

-- Directly selecting a schema
create or replace database myfirst_db;

show databases;

use schema myfirst_db.public;

select
    current_schemas();
select
    current_Database();

-- Cleaning up the environment
drop database myfirst_db;
-- Verify the deletion of the database
show databases;

