/* Selecting the maven market datbase */
USE maven_market;

/* Listing down the schemas in the database */
SHOW SCHEMAS;

/* Selecting sales schema */
USE maven_market.sales;

/* Listing the TABLES IN the SCHEMA */
SHOW TABLES;

/* Listing down the Stages for the database */
SHOW STAGES;

/* Create a database to keep all the stage details and file format details */
CREATE DATABASE maven_market_manage;

CREATE SCHEMA maven_market_manage.stages;

/* Selecting the maven market manage datbase */
USE maven_market_manage;

/* Listing down the schemas in the database */
SHOW SCHEMAS;

/* Selecting sales schema */
USE maven_market_manage.stages;

/* Listing down the Stages for the database */
SHOW STAGES;


/* CREATE the STAGES AND upload the FILES */
/* Create Stage for dimensions data */
CREATE OR REPLACE STAGE maven_market_manage.stages.maven_market_dimensions;
/* Upload data files into the stage */
put file://C:\Users\erang\OneDrive\Documents\UCSC_Lectures\Snowflake_Labs\snowflake_scripts\dimensions\*.csv @maven_market_manage.stages.maven_market_dimensions;

/* NOTE: If the source data files gets mofidied and needs to be uploaded again we have force=ovewrite otherwise it will not read the new file. */
/* Default behavior of Snowflakes is that it will not load the new file if the file name is same during the last 90 days. unless we force overwrite it */
put file://\\VBOXSVR\vagrant\data\dimensions\MavenMarket_Customers.csv @maven_market_dimensions auto_compress=true overwrite=true;

/* Create a stage for facts data */
CREATE OR REPLACE STAGE maven_market_facts;
/* upload the transaction data */
put file://C:\Users\erang\OneDrive\Documents\UCSC_Lectures\Snowflake_Labs\snowflake_scripts\facts\*.csv @maven_market_manage.stages.maven_market_facts;

LIST @maven_market_dimensions;
LIST @maven_market_facts;