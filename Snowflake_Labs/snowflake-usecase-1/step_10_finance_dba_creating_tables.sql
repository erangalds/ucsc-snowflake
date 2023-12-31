-- LOGGED IN AS FINANCE DBA
SHOW DATABASES;

USE FINANCE_DATABASE;
SHOW TABLES;

CREATE TABLE FINANCE_DATABASE."PUBLIC".TRANSACTIONS
(
	CUSTOMER_ID STRING,
	TXN_DATE DATE,
	TXN_AMT INTEGER
);

--grant usage on the database and the schema
GRANT USAGE ON DATABASE FINANCE_DATABASE TO ROLE FINANCE_ANALYST;
GRANT USAGE ON SCHEMA FINANCE_DATABASE."PUBLIC" TO ROLE FINANCE_ANALYST;

-- grant select on the table
GRANT SELECT ON TABLE FINANCE_DATABASE."PUBLIC".TRANSACTIONS TO ROLE FINANCE_ANALYST;