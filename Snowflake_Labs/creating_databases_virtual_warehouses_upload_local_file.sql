-- Checking the current_role
select
    current_role();
-- Roles are tied to the folders. Therefore we can't set the role inside a worksheet. 
-- Therefore the use role sysadmin; statement doesn't work

use warehouse COMPUTE_WH;

select 
    current_warehouse();

select 
    current_role();
-- creating a new virtual warehouse
create warehouse CH2_WH with warehouse_size = medium
    auto_suspend = 300 auto_resume = true initially_suspended = true;

-- creating a new virtual multicluster warehouse 
create warehouse CH2_MultiCluster_WH with 
    warehouse_size = medium
    auto_suspend = 300
    auto_resume = true 
    initially_suspended = true 
    max_cluster_count = 3
    min_cluster_count = 1
    scaling_policy = standard;

describe warehouse CH2_MultiCluster_WH;

show warehouses;

-- resizing a new virtual warehouse
alter warehouse CH2_WH
set warehouse_size = large;

describe warehouse CH2_WH;

-- Creating another multi cluster virtual warehouse
create or replace warehouse accounting_wh with 
    warehouse_size = medium
    min_cluster_count = 1
    max_cluster_count = 3
    scaling_policy = 'standard';

alter session set use_cached_result = false;

-- Clean up 
drop warehouse CH2_WH;
drop warehouse CH2_MULTICLUSTER_WH;
show warehouses;
drop warehouse accounting_wh;

show warehouses;


-- Uploading data from local machine
-- This command you have to run in the local machine command line 
-- $ snowsql -a <account_identifier> -u <user_name>

-- Creating a database
CREATE OR REPLACE DATABASE sf_tuts;
-- checking the current database and schema 
SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();

CREATE OR REPLACE TABLE emp_basic (
  first_name STRING ,
  last_name STRING ,
  email STRING ,
  streetaddress STRING ,
  city STRING ,
  start_date DATE
);

CREATE OR REPLACE WAREHOUSE sf_tuts_wh WITH
  WAREHOUSE_SIZE='X-SMALL'
  AUTO_SUSPEND = 180
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED=TRUE;

SELECT CURRENT_WAREHOUSE();
-- uploading the file into a table stage 

PUT file://D:\snowflake\getting-started\employees0*.csv @sf_tuts.public.%emp_basic;

-- @<namespace>.%<table_name>
LIST @sf_tuts.public.%emp_basic;

COPY INTO emp_basic
  FROM @%emp_basic
  FILE_FORMAT = (type = csv field_optionally_enclosed_by='"')
  PATTERN = '.*employees0[1-5].csv.gz'
  ON_ERROR = 'skip_file';

SELECT * FROM emp_basic;

INSERT INTO emp_basic VALUES
   ('Clementine','Adamou','cadamou@sf_tuts.com','10510 Sachs Road','Klenak','2017-9-22') ,
   ('Marlowe','De Anesy','madamouc@sf_tuts.co.uk','36768 Northfield Plaza','Fangshan','2017-1-26');

SELECT email FROM emp_basic WHERE email LIKE '%.uk';

SELECT first_name, last_name, DATEADD('day',90,start_date) FROM emp_basic WHERE start_date <= '2017-01-01';

DROP DATABASE IF EXISTS sf_tuts;

DROP WAREHOUSE IF EXISTS sf_tuts_wh;
