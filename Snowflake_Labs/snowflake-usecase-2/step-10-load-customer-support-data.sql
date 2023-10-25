/* Loading Customer Support Data */
-- Login as CUSTOMER_SUPPORT_DBA - Nalaka
/* Copying the DATA FROM CSV FILES INTO target TABLES */

/* Product Returns Data */
copy into dev_maven_market.customer_support.Returns
from @dev_maven_manage.customer_support.maven_market_returns/MavenMarket_Returns_1997-1998.csv
file_format=(FORMAT_NAME = dev_maven_manage.customer_support.csv_format);

/* Verifying the DATA LOAD */ 
SELECT * FROM dev_maven_market.customer_support.Returns;

