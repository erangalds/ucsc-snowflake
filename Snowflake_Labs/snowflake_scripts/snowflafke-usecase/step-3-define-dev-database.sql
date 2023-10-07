/* Creating the Dev Environment first */
/* Dev Maven Market Database will have couple of schemas */
/* Schema : Sales, Schema : Customer-Support, Schema : Marketting */
/* Login as the SYSADMIN and create these databases */
-- SYSADMIN - Yometh
-- Checking for current Databases
SHOW DATABASES;
/* Creating the Database */
CREATE DATABASE dev_maven_market;
/* Creating the Schemas */
-- Select the dev_maven_market database and create the schemas
/* Sales Schema */
CREATE SCHEMA dev_maven_market.sales;
/* Customer Support Schema */
CREATE SCHEMA dev_maven_market.customer_support;
/* Marketting Schema */
CREATE SCHEMA dev_maven_market.marketting;


/* Creating the Database */
CREATE DATABASE dev_maven_manage;
/* Creating the Schemas */
-- Separate database to keep the stage objects and file formats
-- Select the dev_maven_manage database and create the schemas
/* Sales Schema */
CREATE SCHEMA dev_maven_manage.sales;
/* Customer Support Schema */
CREATE SCHEMA dev_maven_manage.customer_support;
/* Marketting Schema */
CREATE SCHEMA dev_maven_manage.marketting;

/* Granting Permission to the respective DBAs */
/* Sales Division */
-- Sales Analyst - Nimasha
-- Sales Analyst Role - SALES_ANALYST
-- Sales DBA - Dasun
-- Sales DBA Role - SALES_DBA
-- Granting ALL Priviledge to SALES_DBA Role
-- Maven Manage Database --
GRANT ALL ON SCHEMA dev_maven_manage.sales TO ROLE SALES_DBA;
-- Checking whether Dasun can create any objects etc. like tables
CREATE TABLE dev_maven_manage.sales.test ( name string );
-- Granting USAGE permission to SALES_DBA Role
GRANT USAGE ON SCHEMA dev_maven_manage.sales TO ROLE SALES_DBA;
GRANT USAGE ON DATABASE dev_maven_manage TO ROLE SALES_DBA;
-- DROP TEST TABLE
DROP TABLE dev_maven_manage.sales.test;
-- Granting SELECT (Read Only) Priviledge to SALES_ANALYST Role
GRANT SELECT ON ALL TABLES IN SCHEMA dev_maven_manage.sales TO ROLE SALES_ANALYST;
-- Create a Sample Table
CREATE TABLE dev_maven_manage.sales.test ( name string );
-- Granting USAGE permission to SALES_ANALYST Role
GRANT USAGE ON SCHEMA dev_maven_manage.sales TO ROLE SALES_ANALYST;
GRANT USAGE ON DATABASE dev_maven_manage TO ROLE SALES_ANALYST;
-- IDEAL WAY TO GRANT SELECT INCLUDING FOR FUTURE TABLES
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_maven_manage.sales TO ROLE SALES_ANALYST;
-- ------------------------------------------------------------------------- --
-- Maven Dev Database --
GRANT ALL ON SCHEMA dev_maven_market.sales TO ROLE SALES_DBA;
-- Checking whether Dasun can create any objects etc. like tables
CREATE TABLE dev_maven_market.sales.test ( name string );
-- Granting USAGE permission to SALES_DBA Role
GRANT USAGE ON SCHEMA dev_maven_market.sales TO ROLE SALES_DBA;
GRANT USAGE ON DATABASE dev_maven_market TO ROLE SALES_DBA;
-- DROP TEST TABLE
DROP TABLE dev_maven_market.sales.test;
-- Granting SELECT (Read Only) Priviledge to SALES_ANALYST Role
GRANT SELECT ON ALL TABLES IN SCHEMA dev_maven_market.sales TO ROLE SALES_ANALYST;
-- Create a Sample Table
CREATE TABLE dev_maven_market.sales.test ( name string );
-- Granting USAGE permission to SALES_ANALYST Role
GRANT USAGE ON SCHEMA dev_maven_market.sales TO ROLE SALES_ANALYST;
GRANT USAGE ON DATABASE dev_maven_market TO ROLE SALES_ANALYST;
-- IDEAL WAY TO GRANT SELECT INCLUDING FOR FUTURE TABLES
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_maven_market.sales TO ROLE SALES_ANALYST;



/* Customer Support */
-- Customer Support Analyst - Anjelo
-- Customer Support Analyst Role - CUSTOMER_SUPPORT_ANALYST
-- Customer Support DBA - nalaka
-- Customer Support DBA Role - CUSTOMER_SUPPORT_DBA
-- Granting ALL Priviledge to Customer Support DBA
-- Maven Manage Database -- 
-- Maven Manage Database --
GRANT ALL ON SCHEMA dev_maven_manage.customer_support TO ROLE CUSTOMER_SUPPORT_DBA;
-- Checking whether Dasun can create any objects etc. like tables
CREATE TABLE dev_maven_manage.customer_support.test ( name string );
-- Granting USAGE permission to SALES_DBA Role
GRANT USAGE ON SCHEMA dev_maven_manage.customer_support TO ROLE CUSTOMER_SUPPORT_DBA;
GRANT USAGE ON DATABASE dev_maven_manage TO ROLE CUSTOMER_SUPPORT_DBA;
-- DROP TEST TABLE
DROP TABLE dev_maven_manage.customer_support.test;
-- Granting SELECT (Read Only) Priviledge to SALES_ANALYST Role
GRANT SELECT ON ALL TABLES IN SCHEMA dev_maven_manage.customer_support TO ROLE CUSTOMER_SUPPORT_ANALYST;
-- Create a Sample Table
CREATE TABLE dev_maven_manage.customer_support.test ( name string );
-- Granting USAGE permission to SALES_ANALYST Role
GRANT USAGE ON SCHEMA dev_maven_manage.customer_support TO ROLE CUSTOMER_SUPPORT_ANALYST;
GRANT USAGE ON DATABASE dev_maven_manage TO ROLE CUSTOMER_SUPPORT_ANALYST;
-- IDEAL WAY TO GRANT SELECT INCLUDING FOR FUTURE TABLES
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_maven_manage.customer_support TO ROLE CUSTOMER_SUPPORT_ANALYST;
-- ------------------------------------------------------------------------- --
-- Maven Dev Database --
GRANT ALL ON SCHEMA dev_maven_market.customer_support TO ROLE CUSTOMER_SUPPORT_DBA;
-- Checking whether Dasun can create any objects etc. like tables
CREATE TABLE dev_maven_market.customer_support.test ( name string );
-- Granting USAGE permission to DATASCIENTIST Role
GRANT USAGE ON SCHEMA dev_maven_market.customer_support TO ROLE CUSTOMER_SUPPORT_DBA;
GRANT USAGE ON DATABASE dev_maven_market TO ROLE CUSTOMER_SUPPORT_DBA;
-- DROP TEST TABLE
DROP TABLE dev_maven_market.customer_support.test;
-- Granting SELECT (Read Only) Priviledge to SALES_ANALYST Role
GRANT SELECT ON ALL TABLES IN SCHEMA dev_maven_market.customer_support TO ROLE CUSTOMER_SUPPORT_ANALYST;
-- Create a Sample Table
CREATE TABLE dev_maven_market.customer_support.test ( name string );
-- Granting USAGE permission to SALES_ANALYST Role
GRANT USAGE ON SCHEMA dev_maven_market.customer_support TO ROLE CUSTOMER_SUPPORT_ANALYST;
GRANT USAGE ON DATABASE dev_maven_market TO ROLE CUSTOMER_SUPPORT_ANALYST;
-- IDEAL WAY TO GRANT SELECT INCLUDING FOR FUTURE TABLES
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_maven_market.customer_support TO ROLE CUSTOMER_SUPPORT_ANALYST;



/* Data Science */
-- DATASCIENTIST - Dewni
-- Maven Manage Database --
GRANT ALL ON SCHEMA dev_maven_manage.customer_support TO ROLE DATASCIENTIST;
GRANT ALL ON SCHEMA dev_maven_manage.sales TO ROLE DATASCIENTIST;
GRANT ALL ON SCHEMA dev_maven_manage.marketting TO ROLE DATASCIENTIST;
-- Granting USAGE permission to DATASCIENTIST Role
GRANT USAGE ON SCHEMA dev_maven_manage.customer_support TO ROLE DATASCIENTIST;
GRANT USAGE ON SCHEMA dev_maven_manage.sales TO ROLE DATASCIENTIST;
GRANT USAGE ON SCHEMA dev_maven_manage.marketting TO ROLE DATASCIENTIST;
GRANT USAGE ON DATABASE dev_maven_manage TO ROLE CUSTOMER_SUPPORT_DBA;

-- Maven Market Database --
GRANT ALL ON SCHEMA dev_maven_market.customer_support TO ROLE DATASCIENTIST;
GRANT ALL ON SCHEMA dev_maven_market.sales TO ROLE DATASCIENTIST;
GRANT ALL ON SCHEMA dev_maven_market.marketting TO ROLE DATASCIENTIST;
-- Granting USAGE permission to DATASCIENTIST Role
GRANT USAGE ON SCHEMA dev_maven_market.customer_support TO ROLE DATASCIENTIST;
GRANT USAGE ON SCHEMA dev_maven_market.sales TO ROLE DATASCIENTIST;
GRANT USAGE ON SCHEMA dev_maven_market.marketting TO ROLE DATASCIENTIST;
GRANT USAGE ON DATABASE dev_maven_market TO ROLE CUSTOMER_SUPPORT_DBA;



/* Marketting */
-- Marketting Analyst - wasana
-- Marketting Analyst Role - MARKETTING_ANALYST
-- Marketting DBA - nalaka
-- Marketting DBA Role - MARKETTING_DBA
-- Granting ALL Priviledge to Marketting DBA
-- Maven Manage Database -- 
-- Maven Manage Database --
GRANT ALL ON SCHEMA dev_maven_manage.marketting TO ROLE MARKETTING_DBA;
-- Checking whether Dasun can create any objects etc. like tables
CREATE TABLE dev_maven_manage.marketting.test ( name string );
-- Granting USAGE permission to SALES_DBA Role
GRANT USAGE ON SCHEMA dev_maven_manage.marketting TO ROLE MARKETTING_DBA;
GRANT USAGE ON DATABASE dev_maven_manage TO ROLE MARKETTING_DBA;
-- DROP TEST TABLE
DROP TABLE dev_maven_manage.marketting.test;
-- Granting SELECT (Read Only) Priviledge to SALES_ANALYST Role
GRANT SELECT ON ALL TABLES IN SCHEMA dev_maven_manage.marketting TO ROLE MARKETTING_ANALYST;
-- Create a Sample Table
CREATE TABLE dev_maven_manage.marketting.test ( name string );
-- Granting USAGE permission to SALES_ANALYST Role
GRANT USAGE ON SCHEMA dev_maven_manage.marketting TO ROLE MARKETTING_ANALYST;
GRANT USAGE ON DATABASE dev_maven_manage TO ROLE MARKETTING_ANALYST;
-- IDEAL WAY TO GRANT SELECT INCLUDING FOR FUTURE TABLES
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_maven_manage.marketting TO ROLE MARKETTING_ANALYST;
-- ------------------------------------------------------------------------- --
-- Maven Dev Database --
GRANT ALL ON SCHEMA dev_maven_market.marketting TO ROLE MARKETTING_DBA;
-- Checking whether Dasun can create any objects etc. like tables
CREATE TABLE dev_maven_market.marketting.test ( name string );
-- Granting USAGE permission to DATASCIENTIST Role
GRANT USAGE ON SCHEMA dev_maven_market.marketting TO ROLE MARKETTING_DBA;
GRANT USAGE ON DATABASE dev_maven_market TO ROLE MARKETTING_DBA;
-- DROP TEST TABLE
DROP TABLE dev_maven_market.marketting.test;
-- Granting SELECT (Read Only) Priviledge to SALES_ANALYST Role
GRANT SELECT ON ALL TABLES IN SCHEMA dev_maven_market.marketting TO ROLE MARKETTING_ANALYST;
-- Create a Sample Table
CREATE TABLE dev_maven_market.marketting.test ( name string );
-- Granting USAGE permission to SALES_ANALYST Role
GRANT USAGE ON SCHEMA dev_maven_market.marketting TO ROLE MARKETTING_ANALYST;
GRANT USAGE ON DATABASE dev_maven_market TO ROLE MARKETTING_ANALYST;
-- IDEAL WAY TO GRANT SELECT INCLUDING FOR FUTURE TABLES
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev_maven_market.marketting TO ROLE MARKETTING_ANALYST;






