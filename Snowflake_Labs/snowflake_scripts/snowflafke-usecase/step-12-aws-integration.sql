/* Setting up AWS and Snowflake Storage Integration Object */

CREATE OR REPLACE STORAGE INTEGRATION ucsc_int
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::958926894263:role/my_snowflake_1'
    STORAGE_ALLOWED_LOCATIONS = ('<cloud>://<bucket>/<path>/','<cloud>://<bucket>/<path>/')
    COMMENT = '<any comment>';
    
DESC INTEGRATION ucsc_int;

CREATE OR REPLACE STORAGE INTEGRATION ucsc_int
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::958926894263:role/my_snowflake_1'
    STORAGE_ALLOWED_LOCATIONS = ('s3://ucsc-snowflake/sales/','s3://ucsc-snowflake/customer_support/')
    COMMENT = 'Integrating my Snowflake #1 account with my AWS Account';

DESC INTEGRATION ucsc_int;

-- Testing the Storage Integration Object
CREATE OR REPLACE DATABASE ST_INT_TEST;

CREATE SCHEMA ST_INT_TEST.TEST;

CREATE OR REPLACE STAGE ST_INT_TEST.TEST.AWS_S3_STAGE
    URL = 's3://s3://ucsc-snowflake/sales/'
    STORAGE_INTEGRATION = ucsc_int
    FILE_FORMAT = dev_maven_manage.sales.csv_format;

LIST @ST_INT_TEST.TEST.AWS_S3_STAGE/facts/;
LIST @ST_INT_TEST.TEST.AWS_S3_STAGE/dimensions/;

create or replace table ST_INT_TEST.TEST.Customers(
    customer_id number not null,
    customer_acct_number number not null,
    first_name string,
    last_name string,
    customer_address string,
    customer_city string,
    customer_state_province string,
    customer_postal_code string,
    customer_country string,
    customer_birth_date date,
    marital_status string,
    yearly_income string,
    gender string,
    total_children number,
    number_of_children_at_home number,
    education string,
    acct_open_date date,
    member_card string,
    occupation string,
    homeowner string,
    constraint PK_Customers primary key (customer_id)
);

/* Customers Table */
copy into ST_INT_TEST.TEST.Customers
from @ST_INT_TEST.TEST.AWS_S3_STAGE/dimensions/MavenMarket_Customers.csv 
file_format=(FORMAT_NAME = dev_maven_manage.sales.csv_format);


SELECT * FROM "ST_INT_TEST"."TEST"."CUSTOMERS";