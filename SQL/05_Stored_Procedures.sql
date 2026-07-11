/*=========================================================
    Project : Bank Customer Analytics
    File    : 05_Stored_Procedures.sql
=========================================================*/

USE BankAnalytics;
GO

/*=========================================================
    Procedure 1
    Customer Details
=========================================================*/

CREATE PROCEDURE sp_GetCustomer
(
    @CustomerID INT
)
AS
BEGIN

SELECT *
FROM Users
WHERE id=@CustomerID;

END
GO

/*=========================================================
    Procedure 2
    Customer Transactions
=========================================================*/

CREATE PROCEDURE sp_CustomerTransactions
(
    @CustomerID INT
)
AS
BEGIN

SELECT

t.id,
t.date,
t.amount,
t.merchant_city,
t.merchant_state

FROM Transactions t

WHERE t.client_id=@CustomerID

ORDER BY t.date DESC;

END
GO

/*=========================================================
    Procedure 3
    Customer Spending
=========================================================*/

CREATE PROCEDURE sp_TotalSpending
(
    @CustomerID INT
)
AS
BEGIN

SELECT

u.id,

SUM(t.amount) TotalSpent,

AVG(t.amount) AverageTransaction,

COUNT(*) TotalTransactions

FROM Users u

JOIN Transactions t

ON u.id=t.client_id

WHERE u.id=@CustomerID

GROUP BY u.id;

END
GO

/*=========================================================
    Procedure 4
    Transactions By State
=========================================================*/

CREATE PROCEDURE sp_StateTransactions
(
@State NVARCHAR(50)
)

AS
BEGIN

SELECT *

FROM Transactions

WHERE merchant_state=@State;

END
GO

/*=========================================================
    Procedure 5
    Transactions Between Dates
=========================================================*/

CREATE PROCEDURE sp_DateRange

@StartDate DATE,

@EndDate DATE

AS

BEGIN

SELECT *

FROM Transactions

WHERE date

BETWEEN @StartDate

AND @EndDate;

END
GO

/*=========================================================
    Procedure 6
    Top Customers
=========================================================*/

CREATE PROCEDURE sp_TopCustomers

@Top INT

AS

BEGIN

SELECT TOP (@Top)

client_id,

SUM(amount) TotalSpent

FROM Transactions

GROUP BY client_id

ORDER BY TotalSpent DESC;

END
GO

/*=========================================================
    Procedure 7
    Merchant Revenue
=========================================================*/

CREATE PROCEDURE sp_MerchantRevenue

@MerchantID INT

AS

BEGIN

SELECT

merchant_id,

SUM(amount) Revenue,

COUNT(*) Transactions

FROM Transactions

WHERE merchant_id=@MerchantID

GROUP BY merchant_id;

END
GO

/*=========================================================
    Procedure 8
    Card Information
=========================================================*/

CREATE PROCEDURE sp_CardInformation

@CardID INT

AS

BEGIN

SELECT *

FROM Cards

WHERE id=@CardID;

END
GO

/*=========================================================
    Procedure 9
    MCC Lookup
=========================================================*/

CREATE PROCEDURE sp_MCC

@MCC SMALLINT

AS

BEGIN

SELECT *

FROM MCC_Codes

WHERE mcc_id=@MCC;

END
GO

/*=========================================================
    Procedure 10
    Customer Summary
=========================================================*/

CREATE PROCEDURE sp_CustomerSummary

@CustomerID INT

AS

BEGIN

SELECT *

FROM vw_CustomerSummary

WHERE id=@CustomerID;

END
GO

PRINT 'Stored Procedures Created Successfully'; 