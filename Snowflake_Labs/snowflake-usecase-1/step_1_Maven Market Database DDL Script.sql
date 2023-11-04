/* Creating the Database Named: Maven_market */
use role sysadmin;
use warehouse compute_wh;
select current_role(), current_warehouse();
--listing the databases
show databases;
drop database if exists maven_market;
CREATE DATABASE maven_market;
/* Creating a Schema for Sales Data */
CREATE SCHEMA sales;
select current_role(), current_warehouse(), current_database(), current_schema();
/* Creating the TABLES */
create or replace table maven_market.sales.Customers(
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

create or replace table maven_market.sales.products (
    product_id number not null,
    product_brand string,
    product_name string, 
    product_sku number,
    product_retail_price float,
    product_cost float, 
    product_weight float,
    recyclable number,
    low_fat number,
    constraint PK_Products primary key (product_id)
);

create or replace table maven_market.sales.regions(
    region_id number not null,
    sales_district string,
    sales_region string,
    constraint PK_Regions primary key (region_id)
);

create or replace table maven_market.sales.Stores(
    store_id number not null,
    region_id number,
    store_type string,
    store_name string,
    store_street_address string,
    store_city string,
    store_state string,
    store_country string,
    store_phone string,
    first_opened_date date,
    last_remodel_date date,
    total_square_feet number,
    grocery_square_feet number,
    constraint PK_Stores primary key (store_id)
);

create or replace table maven_market.sales.Returns(
    return_date date,
    product_id number,
    store_id number,
    quantity number    
);

create or replace table maven_market.sales.Transactions(
    transaction_date date,
    stock_date date,
    product_id number,
    customer_id number, 
    store_id number,
    quantity number
);


