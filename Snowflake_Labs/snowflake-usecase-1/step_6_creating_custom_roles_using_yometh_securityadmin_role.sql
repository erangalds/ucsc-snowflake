/* CREATE a USER FOR SECURITY admin ROLE */
use role useradmin;
CREATE USER yometh PASSWORD = 'ucsc1234' DEFAULT_ROLE = SECURITYADMIN MUST_CHANGE_PASSWORD = FALSE;
use role securityadmin;
GRANT ROLE SECURITYADMIN TO USER yometh;
-- using the New Security Admin Role to create the new custom roles and users

-- create a role for marketing database administrators
-- people in this role will be able to create manage objects
-- in marketing database
use role useradmin;
CREATE ROLE MARKETING_DBA;

-- create a role for marketing analyst users
CREATE ROLE MARKETING_ANALYST;

-- grant the marketting analyst role to the marketting_dba
-- as per the guidelines by snowflakes, to connect the hierarchy of roles
GRANT ROLE MARKETING_ANALYST TO ROLE MARKETING_DBA;

-- Grant the marketing_dba role to sysadmin
-- as per the guidelines by snowflakes to complete the hierarchy
GRANT ROLE MARKETING_DBA TO ROLE SYSADMIN;

-- Verify the roles
SHOW ROLES;

-- create the marketing_analyst user
CREATE USER	marketing_analyst_1 PASSWORD = 'ucsc1234' DEFAULT_ROLE = MARKETING_ANALYST MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE MARKETING_ANALYST TO USER marketing_analyst_1;

-- create the marketing database administrator
CREATE USER marketing_dba_1 PASSWORD = 'ucsc1234' DEFAULT_ROLE = MARKETING_DBA MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE MARKETING_DBA TO USER marketing_dba_1;

-- create the finance analyst role
CREATE ROLE FINANCE_ANALYST;
-- create the finance dba role
CREATE ROLE FINANCE_DBA;

-- GRANTIG THE FINANCE_ANALYST ROLE TO FINANCE_DBA ROLE
GRANT ROLE FINANCE_ANALYST TO ROLE FINANCE_DBA;

-- GRANTING THE FINANCE_DBA ROLE TO SYSADMIN ROLE
GRANT ROLE FINANCE_DBA TO ROLE SYSADMIN; 

--CREATE A FINANCE ANALYST USER
CREATE USER finance_analyst_1 PASSWORD = 'ucsc1234' DEFAULT_ROLE = FINANCE_ANALYST MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE FINANCE_ANALYST TO USER finance_analyst_1;

-- create finance dba user
CREATE USER finance_dba_1 PASSWORD = 'ucsc1234' DEFAULT_ROLE = FINANCE_DBA MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE FINANCE_DBA TO USER finance_dba_1;

