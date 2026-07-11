/*=========================================================
    Project : Bank Customer Analytics
    File : 06_Dashboard_Queries.sql
=========================================================*/

USE BankAnalytics;
GO

/*=========================================================
KPI 1
=========================================================*/

SELECT
COUNT(*) TotalCustomers
FROM Users;

GO

/*=========================================================
KPI 2
=========================================================*/

SELECT
COUNT(*) TotalCards
FROM Cards;

GO

/*=========================================================
KPI 3
=========================================================*/

SELECT
COUNT(*) TotalTransactions
FROM Transactions;

GO

/*=========================================================
KPI 4
=========================================================*/

SELECT
SUM(amount) TotalRevenue
FROM Transactions;

GO

/*=========================================================
KPI 5
=========================================================*/

SELECT
AVG(amount) AverageTransaction
FROM Transactions;

GO

/*=========================================================
Gender Distribution
=========================================================*/

SELECT

gender,

COUNT(*) Total

FROM Users

GROUP BY gender;

GO

/*=========================================================
Income Distribution
=========================================================*/

SELECT

CASE

WHEN yearly_income<50000 THEN 'Low'

WHEN yearly_income<100000 THEN 'Medium'

ELSE 'High'

END IncomeCategory,

COUNT(*) Customers

FROM Users

GROUP BY

CASE

WHEN yearly_income<50000 THEN 'Low'

WHEN yearly_income<100000 THEN 'Medium'

ELSE 'High'

END;

GO

/*=========================================================
Card Brands
=========================================================*/

SELECT

card_brand,

COUNT(*) TotalCards

FROM Cards

GROUP BY card_brand;

GO

/*=========================================================
Card Types
=========================================================*/

SELECT

card_type,

COUNT(*) TotalCards

FROM Cards

GROUP BY card_type;

GO

/*=========================================================
Monthly Revenue
=========================================================*/

SELECT

YEAR(date) Year,

MONTH(date) Month,

SUM(amount) Revenue

FROM Transactions

GROUP BY

YEAR(date),

MONTH(date)

ORDER BY

Year,

Month;

GO

/*=========================================================
Top Customers
=========================================================*/

SELECT TOP 10

client_id,

SUM(amount) Spending

FROM Transactions

GROUP BY client_id

ORDER BY Spending DESC;

GO

/*=========================================================
Top Merchant Cities
=========================================================*/

SELECT TOP 10

merchant_city,

SUM(amount) Revenue

FROM Transactions

GROUP BY merchant_city

ORDER BY Revenue DESC;

GO

/*=========================================================
Top Merchants
=========================================================*/

SELECT TOP 10

merchant_id,

SUM(amount) Revenue

FROM Transactions

GROUP BY merchant_id

ORDER BY Revenue DESC;

GO

/*=========================================================
MCC Categories
=========================================================*/

SELECT

m.Description,

SUM(t.amount) Revenue

FROM Transactions t

JOIN MCC_Codes m

ON t.mcc=m.mcc_id

GROUP BY m.Description

ORDER BY Revenue DESC;

GO

/*=========================================================
Credit Score Distribution
=========================================================*/

SELECT

CASE

WHEN credit_score>=750 THEN 'Excellent'

WHEN credit_score>=700 THEN 'Good'

WHEN credit_score>=650 THEN 'Fair'

ELSE 'Poor'

END ScoreCategory,

COUNT(*) Customers

FROM Users

GROUP BY

CASE

WHEN credit_score>=750 THEN 'Excellent'

WHEN credit_score>=700 THEN 'Good'

WHEN credit_score>=650 THEN 'Fair'

ELSE 'Poor'

END;

GO

/*=========================================================
Top Spending States
=========================================================*/

SELECT

merchant_state,

SUM(amount) Revenue

FROM Transactions

GROUP BY merchant_state

ORDER BY Revenue DESC;

GO

/*=========================================================
Dashboard Ready Dataset
=========================================================*/

SELECT *

FROM vw_TransactionDetails;

GO

PRINT 'Dashboard Queries Ready';