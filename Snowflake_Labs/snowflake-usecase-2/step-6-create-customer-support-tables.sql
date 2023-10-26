/* Defining Customer Support Schema Tables */
-- Login as CUSTOMER_SUPPORT_DBA and create the 
-- Customer Support DBA - Nalaka
use role customer_support_dba;
use warehouse customer_support_wh;
-- Verify that he can see the dev_maven_market.customer_support database and schema
SHOW DATABASES;
-- Selecting the dev_maven_market database
USE dev_maven_market;
-- Listing the Schemas
SHOW SCHEMAS;
-- Selecting Sales Schema for Table Creation
USE dev_maven_market.customer_support;
select current_role(), current_warehouse(), current_database(), current_schema();
-- Creating Tables
-- Returns Table
create or replace table dev_maven_market.customer_support.Returns(
    return_date date,
    product_id number,
    store_id number,
    quantity number    
);

--Granting Access to all tables to SALES_ANALYSTS Role
GRANT SELECT ON ALL TABLES IN SCHEMA dev_maven_market.customer_support TO ROLE CUSTOMER_SUPPORT_ANALYST;