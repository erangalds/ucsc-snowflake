/* Defining Stages for Sales Data */
-- Login as SALES_DBA and create the 
-- Sales DBA - Dasun
use role sales_dba;
use warehouse sales_wh;
-- Verify that he can see the dev_maven_market.sales database and schema
SHOW DATABASES;
-- Selecting the dev_maven_market database
USE dev_maven_manage;
-- Listing the Schemas
SHOW SCHEMAS;
-- Selecting Sales Schema for Table Creation
USE dev_maven_manage.sales;
select current_role(),current_warehouse(),current_database(),current_schema();
/* Listing down the Stages for the database */
SHOW STAGES;

/* CREATE the STAGES AND upload the FILES */
/* Create Stage for dimensions data */
CREATE OR REPLACE STAGE dev_maven_manage.sales.maven_market_dimensions;
SHOW STAGES;
/* Upload data files into the stage */
put file://Snowflake_Labs\snowflake-sample-data-for-labs\sales\dimensions\*.csv @dev_maven_manage.sales.maven_market_dimensions;

/* NOTE: If the source data files gets mofidied and needs to be uploaded again we have force=ovewrite otherwise it will not read the new file. */
/* Default behavior of Snowflakes is that it will not load the new file if the file name is same during the last 90 days. unless we force overwrite it */
put file://\\VBOXSVR\vagrant\data\dimensions\MavenMarket_Customers.csv @maven_market_dimensions auto_compress=true overwrite=true;

/* Create a stage for facts data */
CREATE OR REPLACE STAGE dev_maven_manage.sales.maven_market_facts;
show stages;
/* upload the transaction data */
put file://Snowflake_Labs\snowflake-sample-data-for-labs\sales\facts\*.csv @dev_maven_manage.sales.maven_market_facts;

LIST @dev_maven_manage.sales.maven_market_dimensions;
LIST @dev_maven_manage.sales.maven_market_facts;

/* Creating the FileFormat Objects */
show file formats;
CREATE OR REPLACE FILE FORMAT dev_maven_manage.sales.csv_format
    TYPE = csv 
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';

/* A more advanced FileFormat Object */
CREATE OR REPLACE FILE FORMAT dev_maven_manage.sales.csv_format
    TYPE = csv 
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null')
    EMPTY_FIELD_AS_NULL = TRUE;

show file formats;