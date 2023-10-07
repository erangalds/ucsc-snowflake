/* Copying the DATA FROM CSV FILES INTO target TABLES */
/* Customers Table */
copy into maven_market.sales.Customers
from @maven_market_manage.stages.maven_market_dimensions/MavenMarket_Customers.csv 
file_format=( type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

/* Verifying the DATA LOAD */ 
SELECT * FROM maven_market.sales.CUSTOMERS;

/* Product */
copy into maven_market.sales.Products
from @maven_market_manage.stages.maven_market_dimensions/MavenMarket_Products.csv 
file_format=( type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

/* Verifying the DATA LOAD */ 
SELECT * FROM maven_market.sales.PRODUCTS;

/* Region */
copy into maven_market.sales.Regions
from @maven_market_manage.stages.maven_market_dimensions/MavenMarket_Regions.csv 
file_format=( type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

/* Verifying the DATA LOAD */ 
SELECT * FROM maven_market.sales.REGIONS;

/* Stores */
copy into maven_market.sales.Stores
from @maven_market_manage.stages.maven_market_dimensions/MavenMarket_Stores.csv 
file_format=( type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

/* Verifying the DATA LOAD */ 
SELECT * FROM maven_market.sales.STORES;

/* Stores */
copy into maven_market.sales.Returns
from @maven_market_manage.stages.maven_market_dimensions/MavenMarket_Returns_1997-1998.csv
file_format=( type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

/* Verifying the DATA LOAD */ 
SELECT * FROM maven_market.sales.RETURNS;

/* Transactions */
copy into maven_market.sales.Transactions
from @maven_market_manage.stages.maven_market_facts/MavenMarket_Transactions_1997.csv
file_format=( type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');
copy into maven_market.sales.Transactions
from @maven_market_manage.stages.maven_market_facts/MavenMarket_Transactions_1998.csv
file_format=( type = csv field_delimiter = ',' skip_header = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

/* Verifying the DATA LOAD */ 
SELECT * FROM maven_market.sales.TRANSACTIONS;







