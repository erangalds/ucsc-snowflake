-- Marketing_DBA creating tables and assining Marketing_analysts
-- Logged in as the marketing DBA create new table
-- and grant access to the marketing analyst role
SHOW DATABASES;

USE demo_db;
SHOW TABLES;

-- Checking whether marketing_dba_1 user can access the databases which he can list 
USE snowflake_sample_data;
SHOW SCHEMAS;
USE snowflake_sample_data.tpcds_sf100tcl;
SHOW TABLES;

SHOW GRANTS;

USE marketing_database;
SHOW SCHEMAS;
USE marketing_database.PUBLIC;
SHOW TABLES;

CREATE TABLE MARKETING_DATABASE."PUBLIC".CUSTOMER
(
	FIRSTNAME STRING,
	LASTNAME STRING
);

SHOW TABLES;

-- grant usage on the database and the schema
GRANT USAGE ON DATABASE marketing_database TO ROLE MARKETING_ANALYST;
GRANT USAGE ON SCHEMA MARKETING_DATABASE."PUBLIC" TO ROLE MARKETING_ANALYST;

-- GRANT SELECT ON THE TABLE
GRANT SELECT ON TABLE MARKETING_DATABASE."PUBLIC".CUSTOMER TO ROLE MARKETING_ANALYST;

-- do this after tyring to insert data as the finance analyst
-- grant insert on the TABLE 
GRANT INSERT ON TABLE MARKETING_DATABASE."PUBLIC".CUSTOMER TO ROLE MARKETING_ANALYST;

