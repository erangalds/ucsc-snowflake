//Transforming the Data of the Source File, while loading data using the COPY Command
// Example 1 - 
// Create Table
-- Earlier we loaded all the columns in the Oderdetail table into the orders table. 
-- Let's see how many columns we had on that table
select current_role();
use role sysadmin;
use database our_first_db;
select current_database();
show schemas;
use schema public;
select current_schema();
show tables;
describe table orders;
-- Let's create a table with only two columns and try to insert data only for those two columns
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT
);
-- verify the table creation
show tables;
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

// Transforming using the SELECT statement
-- loading the data from the same Orderdetails File, but only selecting the columns we need. Which is first two columns
-- Columns can be selected based on their position in the file. $1 refers first columns and $2 refers to the second column
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select s.$1, s.$2 from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');
-- We can see 1500 rows parsed and all got loaded without any error
-- Verify the data load
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
   
// Example 2 - 
// Create Table    
-- Now we are going to change the table again
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
);
show tables;
describe table our_first_db.public.ORDERS_EX;

// Example 2 - Copy Command using a SQL function (subset of functions available)
-- Enriching the data while doing the data load
-- Here we can see that we are able to enrich the data set, with a conditional statement
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            CASE WHEN CAST(s.$3 as int) < 0 THEN 'not profitable' ELSE 'profitable' END 
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');
-- We can see again that the 1500 rows got inserted without any errors
-- Let's verify the data load
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
-- We can see the conditionally enriched colum was properly filled


// Example 3 - 
// Create Table
-- Now we are going to select only a part of a field while getting the data loaded
-- Changing the table 
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    CATEGORY_SUBSTRING VARCHAR(5)
);


// Example 3 - Copy Command using a SQL function (subset of functions available)
-- Here we are using the substring function to select only a part of the field from the original data file
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            substring(s.$5,1,5) 
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');
-- Verify the data load
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
-- we can see that the 1st 5 characters were extracted and loaded as expected

// Example 4 - 
// Create Table
-- Let's see whether we can use the basic * or + kind of arithmatic operations while using the COPY command
-- Changing the table 
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    DOUBLE_PROFIT INT 
);


// Example 4 - Copy Command using arithmatic operations
-- Using the * and + operations 
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            s.$3 * 2
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');


COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            s.$3 + s.$3
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');
-- We can see that arith matic operations were not supported while using the copy command
-- We have to first load the data into a stage table and then do the arithmatic operations while loading to a second table


