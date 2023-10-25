/* Defining Customer Support Schema Tables */
-- Login as CUSTOMER_SUPPORT_DBA and create the 
-- Customer Support DBA - Nalaka
-- Verify that he can see the dev_maven_market.customer_support database and schema
SHOW DATABASES;
-- Selecting the dev_maven_market database
USE dev_maven_market;
-- Listing the Schemas
SHOW SCHEMAS;
-- Selecting Sales Schema for Table Creation
USE dev_maven_market.customer_support;

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