-- Let's now clean the environment
use role securityadmin;
use warehouse common_wh;
select current_role(), current_warehouse();
-- Checking for Users to clean
-- Listing down all the users
show users;
-- Deleting the newly created users
drop user kasun;
drop user amali;
drop user yometh;
drop user nimasha;
drop user dasun;
drop user anjelo;
drop user nalaka;
drop user dewni;
drop user wasana;
drop user priyashan;

-- Checking for Custom Roles to clean
-- Listing down all the roles
show roles;
drop role sales_analyst;
drop role sales_dba;
drop role customer_support_analyst;
drop role customer_support_dba;
drop role datascientist;
drop role marketing_analyst;
drop role marketing_dba;

-- Checking for Databases to clean
-- Listing down all the databases;
show databases;
drop database dev_maven_market;
drop database dev_maven_manage;




