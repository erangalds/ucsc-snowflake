/* Creating separate Views to share with Marketting Team */
/* Login as Dasun */
use role sales_dba;
use warehouse sales_wh;
use schema dev_maven_market.sales;
select current_role(), current_warehouse(), current_database(), current_schema();

-- Year Month / Product / Total Sales
CREATE OR REPLACE VIEW dev_maven_market.sales.PRODUCT_SALES_OVER_TIME AS 
SELECT 
YEAR(TRANSACTION_DATE) AS YEAR, 
MONTH(TRANSACTION_DATE) AS MONTH,
P.PRODUCT_NAME AS PRODUCT_NAME,
SUM( T.QUANTITY * P.PRODUCT_RETAIL_PRICE) AS SALES 
FROM dev_maven_market.sales.Transactions T
INNER JOIN dev_maven_market.sales.Products P ON 
P.PRODUCT_ID = T.PRODUCT_ID
GROUP BY
YEAR,
MONTH,
PRODUCT_NAME;

select * from dev_maven_market.sales.PRODUCT_SALES_OVER_TIME;

-- Year Month / STORE / Total Sales
CREATE OR REPLACE VIEW dev_maven_market.sales.STORE_SALES_OVER_TIME AS 
SELECT 
YEAR(TRANSACTION_DATE) AS YEAR, 
MONTH(TRANSACTION_DATE) AS MONTH,
S.STORE_NAME AS STORE_NAME,
SUM( T.QUANTITY * P.PRODUCT_RETAIL_PRICE) AS SALES 
FROM dev_maven_market.sales.Transactions T
INNER JOIN dev_maven_market.sales.Products P ON 
P.PRODUCT_ID = T.PRODUCT_ID
INNER JOIN dev_maven_market.sales.Stores S ON
T.STORE_ID = S.STORE_ID
GROUP BY
YEAR,
MONTH,
STORE_NAME;

select * from dev_maven_market.sales.STORE_SALES_OVER_TIME;

-- Year Month / PRODUCT_NAME / STORE / Total Sales
CREATE OR REPLACE VIEW dev_maven_market.sales.PRODUCT_SALES_IN_STORES_OVER_TIME AS 
SELECT 
YEAR(TRANSACTION_DATE) AS YEAR, 
MONTH(TRANSACTION_DATE) AS MONTH,
P.PRODUCT_NAME AS PRODUCT_NAME,
S.STORE_NAME AS STORE_NAME,
SUM( T.QUANTITY * P.PRODUCT_RETAIL_PRICE) AS SALES
FROM dev_maven_market.sales.Transactions T
INNER JOIN dev_maven_market.sales.Products P ON 
P.PRODUCT_ID = T.PRODUCT_ID
INNER JOIN dev_maven_market.sales.Stores S ON
T.STORE_ID = S.STORE_ID
GROUP BY
YEAR,
MONTH,
PRODUCT_NAME,
STORE_NAME;

select * from dev_maven_market.sales.PRODUCT_SALES_IN_STORES_OVER_TIME;

-- GRANT PERMISSION TO THESE VIEWS TO THE MARKETTING_ANALYSTS
GRANT SELECT ON VIEW dev_maven_market.sales.PRODUCT_SALES_OVER_TIME TO ROLE MARKETTING_ANALYST;
GRANT SELECT ON VIEW dev_maven_market.sales.STORE_SALES_OVER_TIME TO ROLE MARKETTING_ANALYST;
GRANT SELECT ON VIEW dev_maven_market.sales.PRODUCT_SALES_IN_STORES_OVER_TIME TO ROLE MARKETTING_ANALYST;
-- Schema usage needs to be given by the schema owner - in this case SYSADMIN - Yometh
GRANT USAGE ON SCHEMA dev_maven_market.sales TO ROLE MARKETTING_ANALYST;