/*=========================================================
    Project : Bank Customer Analytics
    File    : 03_Advanced_SQL.sql
    Author  : Ahmad Al Serhan
=========================================================*/

USE BankAnalytics;
GO

/*=========================================================
    SECTION 1 - CASE STATEMENTS
=========================================================*/

-- Q1. Customer Income Category

SELECT
    id,
    yearly_income,
    CASE
        WHEN yearly_income < 50000 THEN 'Low Income'
        WHEN yearly_income BETWEEN 50000 AND 100000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS Income_Category
FROM Users;

----------------------------------------------------------

-- Q2. Credit Score Category

SELECT
    id,
    credit_score,
    CASE
        WHEN credit_score >= 750 THEN 'Excellent'
        WHEN credit_score >=700 THEN 'Good'
        WHEN credit_score >=650 THEN 'Fair'
        ELSE 'Poor'
    END AS Credit_Category
FROM Users;

----------------------------------------------------------

-- Q3. Transaction Size

SELECT
    id,
    amount,
    CASE
        WHEN amount < 50 THEN 'Small'
        WHEN amount BETWEEN 50 AND 200 THEN 'Medium'
        ELSE 'Large'
    END AS Transaction_Size
FROM Transactions;


/*=========================================================
    SECTION 2 - SUBQUERIES
=========================================================*/

-- Q4. Customers Above Average Income

SELECT *
FROM Users
WHERE yearly_income >
(
    SELECT AVG(yearly_income)
    FROM Users
);

----------------------------------------------------------

-- Q5. Transactions Above Average Amount

SELECT *
FROM Transactions
WHERE amount >
(
    SELECT AVG(amount)
    FROM Transactions
);

----------------------------------------------------------

-- Q6. Highest Credit Limit

SELECT *
FROM Cards
WHERE credit_limit =
(
    SELECT MAX(credit_limit)
    FROM Cards
);


/*=========================================================
    SECTION 3 - COMMON TABLE EXPRESSIONS (CTE)
=========================================================*/

-- Q7. Top Spending Customers

WITH CustomerSpending AS
(
    SELECT
        client_id,
        SUM(amount) AS TotalSpent
    FROM Transactions
    GROUP BY client_id
)

SELECT TOP 10 *
FROM CustomerSpending
ORDER BY TotalSpent DESC;

----------------------------------------------------------

-- Q8. Average Spending Per Customer

WITH CustomerAverage AS
(
    SELECT
        client_id,
        AVG(amount) AS AvgSpent
    FROM Transactions
    GROUP BY client_id
)

SELECT *
FROM CustomerAverage
ORDER BY AvgSpent DESC;


/*=========================================================
    SECTION 4 - ROW_NUMBER()
=========================================================*/

-- Q9. Row Number by Transaction Amount

SELECT

    id,
    client_id,
    amount,

ROW_NUMBER() OVER
(
ORDER BY amount DESC
) AS RowNum

FROM Transactions;


/*=========================================================
    SECTION 5 - RANK()
=========================================================*/

-- Q10. Customer Ranking

SELECT

client_id,

SUM(amount) AS TotalSpent,

RANK() OVER
(
ORDER BY SUM(amount) DESC
) AS CustomerRank

FROM Transactions

GROUP BY client_id;


/*=========================================================
    SECTION 6 - DENSE_RANK()
=========================================================*/

SELECT

client_id,

SUM(amount) TotalSpent,

DENSE_RANK() OVER
(
ORDER BY SUM(amount) DESC
) AS DenseRank

FROM Transactions

GROUP BY client_id;


/*=========================================================
    SECTION 7 - NTILE()
=========================================================*/

-- Divide Customers into 4 Groups

SELECT

client_id,

SUM(amount) TotalSpent,

NTILE(4) OVER
(
ORDER BY SUM(amount) DESC
) SpendingQuartile

FROM Transactions

GROUP BY client_id;


/*=========================================================
    SECTION 8 - LAG()
=========================================================*/

-- Previous Transaction

SELECT

client_id,

date,

amount,

LAG(amount)
OVER
(
PARTITION BY client_id
ORDER BY date
) PreviousAmount

FROM Transactions;


/*=========================================================
    SECTION 9 - LEAD()
=========================================================*/

-- Next Transaction

SELECT

client_id,

date,

amount,

LEAD(amount)
OVER
(
PARTITION BY client_id
ORDER BY date
) NextAmount

FROM Transactions;


/*=========================================================
    SECTION 10 - RUNNING TOTAL
=========================================================*/

SELECT

client_id,

date,

amount,

SUM(amount)
OVER
(
PARTITION BY client_id
ORDER BY date
ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW
) RunningTotal

FROM Transactions;


/*=========================================================
    SECTION 11 - MOVING AVERAGE
=========================================================*/

SELECT

client_id,

date,

amount,

AVG(amount)
OVER
(
PARTITION BY client_id
ORDER BY date
ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW
) MovingAverage

FROM Transactions;


/*=========================================================
    SECTION 12 - FIRST_VALUE
=========================================================*/

SELECT

client_id,

date,

amount,

FIRST_VALUE(amount)
OVER
(
PARTITION BY client_id
ORDER BY date
) FirstTransaction

FROM Transactions;


/*=========================================================
    SECTION 13 - LAST_VALUE
=========================================================*/

SELECT

client_id,

date,

amount,

LAST_VALUE(amount)
OVER
(
PARTITION BY client_id
ORDER BY date
ROWS BETWEEN CURRENT ROW
AND UNBOUNDED FOLLOWING
) LastTransaction

FROM Transactions;


/*=========================================================
    SECTION 14 - PERCENT OF TOTAL SPENDING
=========================================================*/

SELECT

client_id,

SUM(amount) TotalSpent,

ROUND
(
SUM(amount)*100.0/
SUM(SUM(amount)) OVER(),
2
) SpendingPercent

FROM Transactions

GROUP BY client_id

ORDER BY SpendingPercent DESC;


/*=========================================================
    SECTION 15 - TOP 5 TRANSACTIONS PER CUSTOMER
=========================================================*/

WITH RankedTransactions AS
(

SELECT

id,

client_id,

amount,

ROW_NUMBER() OVER
(
PARTITION BY client_id
ORDER BY amount DESC
) rn

FROM Transactions

)

SELECT *

FROM RankedTransactions

WHERE rn<=5;


/*=========================================================
    SECTION 16 - CUSTOMER SEGMENTATION
=========================================================*/

WITH CustomerSummary AS
(
SELECT

u.id,

u.credit_score,

SUM(t.amount) AS TotalSpent

FROM Users u

JOIN Transactions t

ON u.id=t.client_id

GROUP BY

u.id,

u.credit_score

)

SELECT

*,

CASE

WHEN TotalSpent>=10000 AND credit_score>=750
THEN 'Premium'

WHEN TotalSpent>=5000
THEN 'Gold'

WHEN TotalSpent>=2000
THEN 'Silver'

ELSE 'Bronze'

END CustomerSegment

FROM CustomerSummary;


/*=========================================================
    SECTION 17 - MONTHLY SALES
=========================================================*/

SELECT

YEAR(date) Year,

MONTH(date) Month,

SUM(amount) MonthlySales

FROM Transactions

GROUP BY

YEAR(date),

MONTH(date)

ORDER BY

Year,

Month;


/*=========================================================
    SECTION 18 - TOP 10 MERCHANTS
=========================================================*/

SELECT TOP 10

merchant_id,

SUM(amount) Revenue

FROM Transactions

GROUP BY merchant_id

ORDER BY Revenue DESC;


/*=========================================================
    END
=========================================================*/

PRINT 'Advanced SQL Completed Successfully'; 