/* Loading Customer Support Data */
-- Login as CUSTOMER_SUPPORT_DBA - Nalaka
/* Copying the DATA FROM CSV FILES INTO target TABLES */
use role customer_support_dba;
use warehouse customer_support_wh;
use schema dev_maven_market.customer_support;
select current_role(), current_warehouse(), current_database(),current_schema();
/* Copying the DATA FROM CSV FILES INTO target TABLES */
list @dev_maven_manage.customer_support.maven_market_returns;
/* Product Returns Data */
copy into dev_maven_market.customer_support.Returns
from @dev_maven_manage.customer_support.maven_market_returns/MavenMarket_Returns_1997-1998.csv
file_format=(FORMAT_NAME = dev_maven_manage.customer_support.csv_format);

/* Verifying the DATA LOAD */ 
SELECT * FROM dev_maven_market.customer_support.Returns;

