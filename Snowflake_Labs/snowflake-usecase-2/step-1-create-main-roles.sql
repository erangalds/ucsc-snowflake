/* We need to create new users and assign them to main Snowflake Roles */

-- AccountAdmin Role
-- AccountAdmin - Kasun
-- Creae User : Kasun
CREATE USER kasun PASSWORD = 'ucsc1234' DEFAULT_ROLE = ACCOUNTADMIN MUST_CHANGE_PASSWORD = FALSE;
-- Assign Kasun the ACCOUNTADMIN Role
GRANT ROLE ACCOUNTADMIN TO USER kasun;

-- SecurityAdmin Role
-- SecurityAdmin - Amali
-- Create User : Amali
CREATE USER amali PASSWORD = 'ucsc1234' DEFAULT_ROLE = SECURITYADMIN MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE SECURITYADMIN TO USER amali;

-- SYSADMIN Role
-- SYSADMIN - Yometh
-- Create User : Yometh
CREATE USER yometh PASSWORD = 'ucsc1234' DEFAULT_ROLE = SYSADMIN MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE SYSADMIN TO USER yometh;



