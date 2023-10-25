/* Defining Stages for Customer Support Data */
-- Login as CUSTOMER_SUPPORT_DBA and create the stages
-- Customer Support DBA - nalaka
-- Verify that he can see the dev_maven_market.customer_support database and schema
SHOW DATABASES;
-- Selecting the dev_maven_market database
USE dev_maven_manage;
-- Listing the Schemas
SHOW SCHEMAS;
-- Selecting Customer Support Schema for Table Creation
USE dev_maven_manage.customer_support;

/* Listing down the Stages for the database */
SHOW STAGES;

/* CREATE the STAGES AND upload the FILES */
/* Create Stage for dimensions data */
CREATE OR REPLACE STAGE dev_maven_manage.customer_support.maven_market_returns;
/* Upload data files into the stage */
put file://C:\Users\erang\OneDrive\Documents\UCSC_Lectures\Snowflake_Labs\snowflake_scripts\customer_support\*.csv @dev_maven_manage.customer_support.maven_market_returns;


LIST @dev_maven_manage.customer_support.maven_market_returns;

/* Creating the FileFormat Objects */
CREATE OR REPLACE FILE FORMAT dev_maven_manage.customer_support.csv_format
    TYPE = csv 
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null')
    EMPTY_FIELD_AS_NULL = TRUE;