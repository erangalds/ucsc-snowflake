/* Access Management IN Snowflakes DATABASE */
use role useradmin;
use warehouse compute_wh;
select current_role(), current_warehouse();
CREATE USER kasun PASSWORD = 'ucsc1234' DEFAULT_ROLE = ACCOUNTADMIN MUST_CHANGE_PASSWORD = FALSE;
/* Even though you assign the DEFAULT_ROLE TO "ACCOUNTADMIN" the USER will NOT GET that ROLE untill you specifically GRANT that ROLE */
use role securityadmin;
GRANT ROLE ACCOUNTADMIN TO USER kasun;

/* CREATE a USER FOR SECURITY admin ROLE */
use role useradmin;
CREATE USER yometh PASSWORD = 'ucsc1234' DEFAULT_ROLE = SECURITYADMIN MUST_CHANGE_PASSWORD = FALSE;
use role securityadmin;
GRANT ROLE SECURITYADMIN TO USER yometh;

/* CREATE A USER FOR SYSTEM ADMIN ROLE */
use role useradmin;
CREATE USER nimasha PASSWORD = 'ucsc1234' DEFAULT_ROLE = SYSADMIN MUST_CHANGE_PASSWORD = FALSE;
use role securityadmin;
GRANT ROLE SYSADMIN TO USER nimasha;

/* Listing the Users in the snowflakes environment */
SHOW USERS;
drop user wasana;maven_market_manage.stages.DESCRIBE USER kasun;
DESCRIBE USER yometh;
DESCRIBE USER nimasha;

/* shows details about the available roles, assigned user counts */
SHOW ROLES;
/* Shows the granted roles to the current user */
SHOW GRANTS;

/* Dropping / Removing a user */
DROP USER kasun;




