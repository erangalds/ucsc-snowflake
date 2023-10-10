// Demonstrating the benefits of using Cluster Keys in tables
// Publicly accessible staging area    
use schema our_first_db.public;
use role sysadmin;
use warehouse compute_wh;
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

// List files in stage
LIST @MANAGE_DB.external_stages.aws_stage;

//Load data using copy command
select current_role(), current_database(), current_schema(), current_warehouse();
show tables;
-- We have our previously created orders table. Let's use that. 
truncate table our_first_db.public.orders;
select * from our_first_db.public.orders;
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*OrderDetails.*';
    
// Verify Data load
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;
// Create table
-- creating another table to to show caching
CREATE OR REPLACE TABLE COPY_DB.PUBLIC.ORDERS_CACHING (
ORDER_ID	VARCHAR(30)
,AMOUNT	NUMBER(38,0)
,PROFIT	NUMBER(38,0)
,QUANTITY	NUMBER(38,0)
,CATEGORY	VARCHAR(30)
,SUBCATEGORY	VARCHAR(30)
,DATE DATE);    


// Let’s insert some random data set into this new table

INSERT INTO COPY_DB.PUBLIC.ORDERS_CACHING 
SELECT
t1.ORDER_ID
,t1.AMOUNT	
,t1.PROFIT	
,t1.QUANTITY	
,t1.CATEGORY	
,t1.SUBCATEGORY	
,DATE(UNIFORM(1500000000,1700000000,(RANDOM())))
FROM ORDERS t1
CROSS JOIN (SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS) t2
CROSS JOIN (SELECT TOP 100 * FROM OUR_FIRST_DB.PUBLIC.ORDERS) t3;
-- loaded 225000000 rows

// Query Performance before Cluster Key
// Let's query without a WHERE Clause
SELECT * FROM COPY_DB.PUBLIC.ORDERS_CACHING;
/*
Query Duration	25s
Rows	225,000,000
End time	Tue Oct 10 2023
Scanned	1.1GB (100%)
 */
// Now Let's query with a WHERE Clause
SELECT * FROM COPY_DB.PUBLIC.ORDERS_CACHING  WHERE DATE = '2020-06-09';
/*
Query Duration	798ms
Rows	97,049
End time	Tue Oct 10 2023
Scanned	1.1GB (100%)
 */
SELECT * FROM COPY_DB.PUBLIC.ORDERS_CACHING  WHERE DATE = '2020-09-15';
/*
Query Duration	655ms
Rows	96,546
End time	Tue Oct 10 2023
Scanned	1.1GB (100%)
 */
// Adding Cluster Key & Compare the result

ALTER TABLE COPY_DB.PUBLIC.ORDERS_CACHING CLUSTER BY ( DATE );
-- Ideally we have wait for about 2 - 3 hours for the table to get clustered. 
-- Clustering happens in the back end using snowflake warehouses
SELECT * FROM COPY_DB.PUBLIC.ORDERS_CACHING  WHERE DATE = '2020-01-05';
/*
This result was not after 2 - 3 hours. It was just after creating the cluster key
Query Duration	714ms
Rows	97,763
End time	Tue Oct 10 2023
Scanned	1.1GB (100%)
 */


// Not ideal clustering & adding a different Cluster Key using function

SELECT * FROM COPY_DB.PUBLIC.ORDERS_CACHING  WHERE MONTH(DATE)=11;
/*
Query Duration	4s
Rows	18,843,278
End time	Tue Oct 10 2023
Scanned	1.1GB (100%)
 */

ALTER TABLE COPY_DB.PUBLIC.ORDERS_CACHING CLUSTER BY ( MONTH(DATE) );
-- Ideally we have wait for about 2 - 3 hours for the table to get clustered. 
-- Clustering happens in the back end using snowflake warehouses
SELECT * FROM COPY_DB.PUBLIC.ORDERS_CACHING  WHERE MONTH(DATE)=10;
/*
This result was not after 2 - 3 hours. It was just after creating the cluster key
Query Duration	4s
Rows	21,093,005
End time	Tue Oct 10 2023
Scanned	1.1GB (100%)
 */