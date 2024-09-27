// Creating and Assigning dedicated virtual warehouses for different user groups
// Create virtual warehouse for data scientist & DBA
use role sysadmin;
select current_role();
show warehouses;

// Creating a Virtual Warehouse for Data Scientists
CREATE WAREHOUSE DS_WH 
WITH WAREHOUSE_SIZE = 'SMALL'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 300 
AUTO_RESUME = TRUE 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 
SCALING_POLICY = 'STANDARD';

// Creating a Virtual Warehouse for DBA
CREATE WAREHOUSE DBA_WH 
WITH WAREHOUSE_SIZE = 'XSMALL'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 300 
AUTO_RESUME = TRUE 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 
SCALING_POLICY = 'STANDARD';

// Create role for Data Scientists & DBAs
-- Switching to User Admin to create the roles
use role useradmin;
select current_role();
CREATE ROLE DATA_SCIENTIST;
// Grant usage permission of the warehouse DS_WH to Data Scientist Role
use role securityadmin;
select current_role();
-- Granting permission to use the warehouse DS_WH to Role Data_Sciencetist
GRANT USAGE ON WAREHOUSE DS_WH TO ROLE DATA_SCIENTIST;
use role useradmin;
select current_role();
CREATE ROLE DBA;
// Grant usage permission of the warehouse DBA_WH to DBA Role
use role securityadmin;
select current_role();
-- Granting permission to use the warehouse DS_WH to Role DBA
GRANT USAGE ON WAREHOUSE DBA_WH TO ROLE DBA;

// Setting up users and assigning roles to the users
// Data Scientists
use role useradmin;
select current_role();
show users;
-- creating three new users for data science role
CREATE USER DS1 PASSWORD = 'DS1' LOGIN_NAME = 'DS1' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'DS_WH'  MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DS2 PASSWORD = 'DS2' LOGIN_NAME = 'DS2' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'DS_WH'  MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DS3 PASSWORD = 'DS3' LOGIN_NAME = 'DS3' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'DS_WH'  MUST_CHANGE_PASSWORD = FALSE;
-- assigning DS1 DS2 DS3 users to the data_sciencetist role
GRANT ROLE DATA_SCIENTIST TO USER DS1;
GRANT ROLE DATA_SCIENTIST TO USER DS2;
GRANT ROLE DATA_SCIENTIST TO USER DS3;

// DBAs
-- Creating two new users 
CREATE USER DBA1 PASSWORD = 'DBA1' LOGIN_NAME = 'DBA1' DEFAULT_ROLE='DBA' DEFAULT_WAREHOUSE = 'DBA_WH'  MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DBA2 PASSWORD = 'DBA2' LOGIN_NAME = 'DBA2' DEFAULT_ROLE='DBA' DEFAULT_WAREHOUSE = 'DBA_WH'  MUST_CHANGE_PASSWORD = FALSE;
-- Assigning the two users to the DBA role
GRANT ROLE DBA TO USER DBA1;
GRANT ROLE DBA TO USER DBA2;
-- Now the Data Science users and DBAs should be able to use the two separately created warehouses for their work.
-- Also we have to keep in mind that the default roles and default warehouses which we provide at the time of user creation doesn't mean they are given those role ow warehouses
-- We have to manually use the assign them to the roles and warehouses using the GRANT Option

// Cleaning the Environment
// Drop objects again
DROP USER DBA1;
DROP USER DBA2;

DROP USER DS1;
DROP USER DS2;
DROP USER DS3;

DROP ROLE DATA_SCIENTIST;
DROP ROLE DBA;

DROP WAREHOUSE DS_WH;
DROP WAREHOUSE DBA_WH;

show warehouses;

use role accountadmin;
show warehouses;
use role sysadmin;
select current_role();

DROP WAREHOUSE DS_WH;
DROP WAREHOUSE DBA_WH;
