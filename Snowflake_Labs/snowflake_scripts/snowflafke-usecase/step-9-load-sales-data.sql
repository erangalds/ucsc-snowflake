/* Loading Sales Data */
-- Login as SALES_DBA - Dasun 
/* Copying the DATA FROM CSV FILES INTO target TABLES */
/* Customers Table */
copy into dev_maven_market.sales.Customers
from @dev_maven_manage.sales.maven_market_dimensions/MavenMarket_Customers.csv 
file_format=(FORMAT_NAME = dev_maven_manage.sales.csv_format);

/* Verifying the DATA LOAD */ 
SELECT * FROM maven_market.sales.CUSTOMERS;

/* Product */
copy into dev_maven_market.sales.Products
from @dev_maven_manage.sales.maven_market_dimensions/MavenMarket_Products.csv 
file_format=(FORMAT_NAME = dev_maven_manage.sales.csv_format);

/* Verifying the DATA LOAD */ 
SELECT * FROM dev_maven_market.sales.Products;

/* Region */
copy into dev_maven_market.sales.Regions
from @dev_maven_manage.sales.maven_market_dimensions/MavenMarket_Regions.csv 
file_format=(FORMAT_NAME = dev_maven_manage.sales.csv_format);

/* Verifying the DATA LOAD */ 
SELECT * FROM dev_maven_market.sales.Regions;

/* Stores */
copy into dev_maven_market.sales.Stores
from @dev_maven_manage.sales.maven_market_dimensions/MavenMarket_Stores.csv 
file_format=(FORMAT_NAME = dev_maven_manage.sales.csv_format);

/* Verifying the DATA LOAD */ 
SELECT * FROM dev_maven_market.sales.Stores;

/* Transactions */
copy into dev_maven_market.sales.Transactions
from @dev_maven_manage.sales.maven_market_facts/MavenMarket_Transactions_1997.csv
file_format=(FORMAT_NAME = dev_maven_manage.sales.csv_format);
copy into dev_maven_market.sales.Transactions
from @dev_maven_manage.sales.maven_market_facts/MavenMarket_Transactions_1998.csv
file_format=(FORMAT_NAME = dev_maven_manage.sales.csv_format);

/* Verifying the DATA LOAD */ 
SELECT * FROM dev_maven_market.sales.Transactions;


