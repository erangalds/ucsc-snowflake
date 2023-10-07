// Using Reader Account to share data
-- Create Reader Account --

CREATE MANAGED ACCOUNT tech_joy_account
ADMIN_NAME = tech_yometh_admin,
ADMIN_PASSWORD = 'Yometh@1234',
TYPE = READER;

// Make sure to have selected the role of accountadmin

// Show accounts
SHOW MANAGED ACCOUNTS;
-- VW21779 Locator


-- Share the data -- 

ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT = <reader-account-id>;

ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT = VW21779;

ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT =  <reader-account-id>
SHARE_RESTRICTIONS=false;



-- Create database from share --

// Show all shares (consumer & producers)
SHOW SHARES;

// See details on share
DESC SHARE VLIZWXP.EW54843.ORDERS_SHARE;

// Create a database in consumer account using the share
CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_name_producer>.ORDERS_SHARE;

// Validate table access
SELECT * FROM  DATA_SHARE_DB.PUBLIC.ORDERS


// Setup virtual warehouse
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;
