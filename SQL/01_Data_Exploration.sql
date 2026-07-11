USE BankAnalytics;
GO

--------------------------------------------------
-- Users Overview
--------------------------------------------------


SELECT COUNT(*) AS TotalUsers
FROM Users;

SELECT *
FROM Users;

SELECT TOP (10) *
FROM Users;


SELECT
MIN(current_age) AS Youngest,
MAX(current_age) AS Oldest,
AVG(current_age) AS AverageAge
FROM Users;

SELECT
gender,
COUNT(*) AS Total
FROM Users
GROUP BY gender;


SELECT
AVG(credit_score) AS AverageCreditScore
FROM Users;

SELECT
MIN(credit_score) AS LowestScore,
MAX(credit_score) AS HighestScore
FROM Users;

---------------------------------------------------------
-- Cards Overview
---------------------------------------------------------

SELECT COUNT(*)
FROM Cards;

SELECT
card_brand,
COUNT(*) TotalCards
FROM Cards
GROUP BY card_brand;

SELECT
card_type,
COUNT(*) TotalCards
FROM Cards
GROUP BY card_type;

SELECT
AVG(credit_limit)
FROM Cards;

SELECT
MAX(credit_limit)
FROM Cards;

---------------------------------------------------------
-- Transactions Overview
---------------------------------------------------------
SELECT COUNT(*)
FROM Transactions;

SELECT
SUM(amount) AS TotalSales
FROM Transactions;


SELECT
AVG(amount) AS AverageTransaction
FROM Transactions;

SELECT
MIN(amount),
MAX(amount)
FROM Transactions;

SELECT
COUNT(DISTINCT merchant_id)
FROM Transactions;

SELECT
COUNT(DISTINCT client_id)
FROM Transactions;

---------------------------------------------------------
-- MCC Overview
---------------------------------------------------------

SELECT *
FROM MCC_Codes;

SELECT COUNT(*)
FROM MCC_Codes;

