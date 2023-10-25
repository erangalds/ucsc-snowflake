/* Defining Custom Roles */
-- There are four main divisions in the company
-- Each division has the analysts and dbas

-- Sales Team : Sales_Analyst / Sales_DBA
-- Customer Support Team : Customer_Support_Analyst / Customer_Support_DBA
-- Data Science Team : DS_Analyst
-- Marketing Team : Marketing_Analyst / Marketing_DBA

-- Login as Security Admin and Create these users and Roles

/* Sales Division */
-- Checking for existing roles
SHOW ROLES; 
--create sales role
CREATE ROLE SALES_ANALYST;
CREATE ROLE SALES_DBA;
-- As per snowflake best practice guidelines, connect all customer roles to SYSADMIN
GRANT ROLE SALES_ANALYST TO ROLE SALES_DBA;
GRANT ROLE SALES_DBA TO ROLE SYSADMIN;

-- SALES ANALYST - nimasha
--Checking for users
SHOW USERS;
CREATE USER nimasha PASSWORD = 'ucsc1234' DEFAULT_ROLE = SALES_ANALYST MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE SALES_ANALYST TO USER nimasha;
-- SALES DBA - dasun
--Checking for users
SHOW USERS;
CREATE USER dasun PASSWORD = 'ucsc1234' DEFAULT_ROLE = SALES_DBA MUST_CHANGE_PASSWORD = FALSE 
GRANT ROLE SALES_DBA TO USER dasun;

/* Customer Support Division */
-- Checking for existing roles
SHOW ROLES; 
--create customer support role
CREATE ROLE CUSTOMER_SUPPORT_ANALYST;
CREATE ROLE CUSTOMER_SUPPORT_DBA;
-- As per snowflake best practice guidelines, connect all custom roles to SYSADMIN
GRANT ROLE CUSTOMER_SUPPORT_ANALYST TO ROLE CUSTOMER_SUPPORT_DBA;
GRANT ROLE CUSTOMER_SUPPORT_DBA TO ROLE SYSADMIN;

-- CUSTOMER SUPPORT ANLYST - anjelo
--Checking for users
SHOW USERS;
CREATE USER anjelo PASSWORD = 'ucsc1234' DEFAULT_ROLE = CUSTOMER_SUPPORT_ANALYST MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE CUSTOMER_SUPPORT_ANALYST TO USER anjelo;
-- CUSTOMER SUPPORT DBA - nalaka
--Checking for users
SHOW USERS;
CREATE USER nalaka PASSWORD = 'ucsc1234' DEFAULT_ROLE = CUSTOMER_SUPPORT_DBA MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE CUSTOMER_SUPPORT_DBA TO USER nalaka;


/* Data Science Team */
-- Checking for existing roles
SHOW ROLES; 
--create data science team
CREATE ROLE DATASCIENTIST;
GRANT ROLE DATASCIENTIST TO ROLE SYSADMIN;
-- DATA SCIENCETIST - dewni
--Checking for users
SHOW USERS;
CREATE USER dewni PASSWORD = 'ucsc1234' DEFAULT_ROLE = DATASCIENTIST MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE DATASCIENTIST TO USER dewni;


/* Marketting Team */
-- Checking for existing roles
SHOW ROLES; 
CREATE ROLE MARKETTING_ANALYST;
CREATE ROLE MARKETTING_DBA;
-- As per snowflake best practice guidelines, connect all custom roles to SYSADMIN
GRANT ROLE MARKETTING_ANALYST TO ROLE MARKETTING_DBA;
GRANT ROLE MARKETTING_DBA TO ROLE SYSADMIN;

-- MARKETTING_ANALYST - wasana
--Checking for users
SHOW USERS;
CREATE USER wasana PASSWORD = 'ucsc1234' DEFAULT_ROLE = MARKETTING_ANALYST MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE MARKETTING_ANALYST TO USER wasana;
-- MARKETTING_DBA - priyashan
--Checking for users
SHOW USERS;
CREATE USER priyashan PASSWORD = 'ucsc1234' DEFAULT_ROLE = MARKETTING_DBA MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE MARKETTING_DBA TO USER priyashan;








