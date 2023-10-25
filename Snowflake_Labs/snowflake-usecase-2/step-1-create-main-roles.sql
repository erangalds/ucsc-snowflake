/* We need to create new users and assign them to main Snowflake Roles */
-- We are going to create a new user called Kasun and make him the accountadmin
-- AccountAdmin Role
-- AccountAdmin - Kasun
-- Creae User : Kasun
use role useradmin;
show warehouses;
use warehouse common_wh;
select current_role(), current_warehouse();
CREATE OR REPLACE USER kasun PASSWORD = 'ucsc1234' DEFAULT_ROLE = ACCOUNTADMIN MUST_CHANGE_PASSWORD = FALSE;
-- Assign Kasun the ACCOUNTADMIN Role
GRANT ROLE ACCOUNTADMIN TO USER kasun;
-- Only a user in accountadmin role can grant the role to another user
use role accountadmin;
select current_role(), current_warehouse();
GRANT ROLE ACCOUNTADMIN TO USER kasun;

-- Now we are going to create another user called Amali and assign her the Securityadmin Role
-- SecurityAdmin Role
-- SecurityAdmin - Amali
-- Create User : Amali
use role useradmin;
select current_role(), current_warehouse();
CREATE or replace USER amali PASSWORD = 'ucsc1234' DEFAULT_ROLE = SECURITYADMIN MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE SECURITYADMIN TO USER amali;
-- We need to be part of securityadmin role to provide another user access to that role
use role securityadmin;
select current_role(), current_warehouse();
GRANT ROLE SECURITYADMIN TO USER amali;

-- Now we are going to create another user called Yometh and make him part of the Sysadmin Role
-- SYSADMIN Role
-- SYSADMIN - Yometh
-- Create User : Yometh
use role useradmin;
select current_role(), current_warehouse();
CREATE or replace user yometh PASSWORD = 'ucsc1234' DEFAULT_ROLE = SYSADMIN MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE SYSADMIN TO USER yometh;
-- We need to be part of Sysadmin role or higher to add another user to the same role
use role securityadmin;
select current_role(), current_warehouse();
GRANT ROLE SYSADMIN TO USER yometh;



