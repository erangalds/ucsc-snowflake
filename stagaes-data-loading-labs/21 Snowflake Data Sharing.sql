//Data Sharing using SNOWFLAKE
CREATE OR REPLACE DATABASE DATA_S;


CREATE OR REPLACE STAGE aws_stage
    url='s3://bucketsnowflakes3';

// List files in stage
LIST @aws_stage;

// Create table
CREATE OR REPLACE TABLE ORDERS (
ORDER_ID	VARCHAR(30)
,AMOUNT	NUMBER(38,0)
,PROFIT	NUMBER(38,0)
,QUANTITY	NUMBER(38,0)
,CATEGORY	VARCHAR(30)
,SUBCATEGORY	VARCHAR(30));   


// Load data using copy command
COPY INTO ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*OrderDetails.*';
    
SELECT * FROM ORDERS;

// We first needs to create a SHARE object
// Create a share object
CREATE OR REPLACE SHARE ORDERS_SHARE;

---- Setup Grants ----

// Grant usage on database
GRANT USAGE ON DATABASE DATA_S TO SHARE ORDERS_SHARE; 

// Grant usage on schema
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE ORDERS_SHARE; 

// Grant SELECT on table

GRANT SELECT ON TABLE DATA_S.PUBLIC.ORDERS TO SHARE ORDERS_SHARE; 

// Validate Grants
SHOW GRANTS TO SHARE ORDERS_SHARE;


---- Add Consumer Account ----
ALTER SHARE ORDERS_SHARE ADD ACCOUNT=<consumer-account-id>;
use role accountadmin;
ALTER SHARE ORDERS_SHARE ADD ACCOUNT = BBNIEHE.NO20485;
ALTER SHARE ORDERS_SHARE ADD ACCOUNT = BBNIEHE.OD04243;
select current_role();
SELECT CURRENT_REGION();
show regions;
SELECT CURRENT_ACCOUNT();  -- This will return your account name (e.g., my_account)
use role orgadmin;
SELECT CURRENT_ORGANIZATION_NAME();      -- This will return your organization name (e.g., my_org)

SHOW ORGANIZATION ACCOUNTS;
-- QKTWYDN.EI33427
--VW21779
-- sharing to a non-business critical account
ALTER SHARE ORDERS_SHARE ADD ACCOUNT=VW21779
SHARE_RESTRICTIONS = false;


// In the Consumer Account the below tasks needs to be done. 
// Listing the INBOUND / OUTBOUND Shares
SHOW SHARES;

// Describing the Details of the share
DESC SHARE <inbound share name>;
DESC SHARE VLIZWXP.EW54843.ORDERS_SHARE;

// Thereafter we need to create a new database from the share for us to use the data
CREATE DATABASE DATA_S FROM SHARE <inbound share name>;
CREATE DATABASE DATA_S FROM SHARE VLIZWXP.EW54843.ORDERS_SHARE;

SELECT * FROM DATA_s.PUBLIC.<table name>;
SELECT * FROM DATA_S.PUBLIC.ORDERS;

// We need to create a virtual warehouse before running the query
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE = 'X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

SELECT * FROM DATA_S.PUBLIC.ORDERS;

// Creating new users in the reader account
CREATE USER NIMASHA PASSWORD = 'Nimasha@1234';
// Grant USAGE on warehouse
GRANT USAGE ON WAREHOUSE READ_WH TO ROLE PUBLIC;
// Grant privileges on a shared database for other users;
GRANT IMPORTED PRIVILEGES ON DATABASE DATA_S TO ROLE PUBLIC;





