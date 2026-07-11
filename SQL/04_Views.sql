/*=========================================================
    Project : Bank Customer Analytics
    File    : 04_Views.sql
    Author  : Ahmad Al Serhan
=========================================================*/

USE BankAnalytics;
GO

/*=========================================================
    VIEW 1 - Customer Summary
=========================================================*/

CREATE VIEW vw_CustomerSummary
AS

SELECT

u.id,
u.gender,
u.current_age,
u.yearly_income,
u.credit_score,
u.num_credit_cards,

COUNT(t.id) AS TotalTransactions,

ISNULL(SUM(t.amount),0) AS TotalSpent,

ISNULL(AVG(t.amount),0) AS AvgTransaction

FROM Users u

LEFT JOIN Transactions t
ON u.id=t.client_id

GROUP BY

u.id,
u.gender,
u.current_age,
u.yearly_income,
u.credit_score,
u.num_credit_cards;
GO


/*=========================================================
    VIEW 2 - Card Summary
=========================================================*/

CREATE VIEW vw_CardSummary
AS

SELECT

c.id AS CardID,
c.client_id,
c.card_brand,
c.card_type,
c.credit_limit,

COUNT(t.id) AS TotalTransactions,

ISNULL(SUM(t.amount),0) AS TotalSpent

FROM Cards c

LEFT JOIN Transactions t
ON c.id=t.card_id

GROUP BY

c.id,
c.client_id,
c.card_brand,
c.card_type,
c.credit_limit;
GO


/*=========================================================
    VIEW 3 - Monthly Sales
=========================================================*/

CREATE VIEW vw_MonthlySales
AS

SELECT

YEAR(date) AS Year,

MONTH(date) AS Month,

COUNT(*) AS TotalTransactions,

SUM(amount) AS TotalSales,

AVG(amount) AS AverageTransaction

FROM Transactions

GROUP BY

YEAR(date),

MONTH(date);
GO


/*=========================================================
    VIEW 4 - Merchant Performance
=========================================================*/

CREATE VIEW vw_MerchantPerformance
AS

SELECT

merchant_id,

merchant_city,

merchant_state,

COUNT(*) AS TotalTransactions,

SUM(amount) AS Revenue,

AVG(amount) AS AvgTransaction

FROM Transactions

GROUP BY

merchant_id,
merchant_city,
merchant_state;
GO


/*=========================================================
    VIEW 5 - MCC Analysis
=========================================================*/

CREATE VIEW vw_MCCAnalysis
AS

SELECT

m.mcc_id,

m.Description,

COUNT(t.id) AS TotalTransactions,

SUM(t.amount) AS TotalRevenue,

AVG(t.amount) AS AvgTransaction

FROM MCC_Codes m

LEFT JOIN Transactions t
ON m.mcc_id=t.mcc

GROUP BY

m.mcc_id,
m.Description;
GO


/*=========================================================
    VIEW 6 - Top Spending Customers
=========================================================*/

CREATE VIEW vw_TopSpendingCustomers
AS

SELECT

u.id,

u.gender,

u.current_age,

u.credit_score,

SUM(t.amount) AS TotalSpent

FROM Users u

INNER JOIN Transactions t

ON u.id=t.client_id

GROUP BY

u.id,
u.gender,
u.current_age,
u.credit_score;
GO


/*=========================================================
    VIEW 7 - Customer Segmentation
=========================================================*/

CREATE VIEW vw_CustomerSegmentation
AS

SELECT

u.id,

u.credit_score,

u.yearly_income,

ISNULL(SUM(t.amount),0) AS TotalSpent,

CASE

WHEN ISNULL(SUM(t.amount),0) >=10000
AND u.credit_score>=750

THEN 'Premium'

WHEN ISNULL(SUM(t.amount),0)>=5000

THEN 'Gold'

WHEN ISNULL(SUM(t.amount),0)>=2000

THEN 'Silver'

ELSE 'Bronze'

END CustomerSegment

FROM Users u

LEFT JOIN Transactions t

ON u.id=t.client_id

GROUP BY

u.id,
u.credit_score,
u.yearly_income;
GO


/*=========================================================
    VIEW 8 - Transaction Details
=========================================================*/

CREATE VIEW vw_TransactionDetails
AS

SELECT

t.id AS TransactionID,

t.date,

t.amount,

u.id AS CustomerID,

u.gender,

u.current_age,

c.card_brand,

c.card_type,

m.Description AS MerchantCategory,

t.merchant_city,

t.merchant_state

FROM Transactions t

INNER JOIN Users u
ON t.client_id=u.id

INNER JOIN Cards c
ON t.card_id=c.id

INNER JOIN MCC_Codes m
ON t.mcc=m.mcc_id;
GO


/*=========================================================
    VIEW 9 - Income vs Spending
=========================================================*/

CREATE VIEW vw_IncomeVsSpending
AS

SELECT

u.id,

u.yearly_income,

ISNULL(SUM(t.amount),0) AS TotalSpent,

ROUND(
ISNULL(SUM(t.amount),0)
/ NULLIF(u.yearly_income,0)
*100,2
) AS SpendingPercentage

FROM Users u

LEFT JOIN Transactions t

ON u.id=t.client_id

GROUP BY

u.id,
u.yearly_income;
GO


/*=========================================================
    VIEW 10 - State Analysis
=========================================================*/

CREATE VIEW vw_StateAnalysis
AS

SELECT

merchant_state,

COUNT(*) AS TransactionsCount,

SUM(amount) AS Revenue,

AVG(amount) AS AvgTransaction

FROM Transactions

GROUP BY merchant_state;
GO


PRINT 'Views Created Successfully';