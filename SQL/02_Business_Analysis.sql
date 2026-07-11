/*=========================================================
    Project : Bank Customer Analytics
    File    : 02_Business_Analysis.sql
    Author  : Ahmad Al habab
=========================================================*/

USE BankAnalytics;
GO

/*=========================================================
    SECTION 1 - CUSTOMER ANALYSIS
=========================================================*/

-- Q1. Total Customers
SELECT COUNT(*) AS Total_Customers
FROM Users;

-- Q2. Customers by Gender
SELECT
    gender,
    COUNT(*) AS Total_Customers
FROM Users
GROUP BY gender;

-- Q3. Average Age
SELECT
    AVG(current_age) AS Average_Age
FROM Users;

-- Q4. Youngest & Oldest Customer
SELECT
    MIN(current_age) AS Youngest,
    MAX(current_age) AS Oldest
FROM Users;

-- Q5. Average Credit Score
SELECT
    AVG(credit_score) AS Average_Credit_Score
FROM Users;

-- Q6. Top 10 Highest Credit Scores
SELECT TOP 10
    id,
    credit_score
FROM Users
ORDER BY credit_score DESC;

-- Q7. Top 10 Highest Income Customers
SELECT TOP 10
    id,
    yearly_income
FROM Users
ORDER BY yearly_income DESC;

-- Q8. Top 10 Highest Debt Customers
SELECT TOP 10
    id,
    total_debt
FROM Users
ORDER BY total_debt DESC;

-- Q9. Customers Having More Than 3 Credit Cards
SELECT
    id,
    num_credit_cards
FROM Users
WHERE num_credit_cards > 3
ORDER BY num_credit_cards DESC;


/*=========================================================
    SECTION 2 - CARD ANALYSIS
=========================================================*/

-- Q10. Cards by Brand
SELECT
    card_brand,
    COUNT(*) AS Total_Cards
FROM Cards
GROUP BY card_brand
ORDER BY Total_Cards DESC;

-- Q11. Cards by Type
SELECT
    card_type,
    COUNT(*) AS Total
FROM Cards
GROUP BY card_type;

-- Q12. Average Credit Limit
SELECT
    AVG(credit_limit) AS Average_Credit_Limit
FROM Cards;

-- Q13. Highest Credit Limit
SELECT TOP 10
    id,
    credit_limit
FROM Cards
ORDER BY credit_limit DESC;

-- Q14. Chip vs Non-Chip Cards
SELECT
    has_chip,
    COUNT(*) AS Total
FROM Cards
GROUP BY has_chip;

-- Q15. Number of Cards Per Customer
SELECT
    client_id,
    COUNT(*) AS Cards_Count
FROM Cards
GROUP BY client_id
ORDER BY Cards_Count DESC;


/*=========================================================
    SECTION 3 - TRANSACTION ANALYSIS
=========================================================*/

-- Q16. Total Transactions
SELECT COUNT(*) AS Total_Transactions
FROM Transactions;

-- Q17. Total Transaction Amount
SELECT
    SUM(amount) AS Total_Spending
FROM Transactions;

-- Q18. Average Transaction Amount
SELECT
    AVG(amount) AS Average_Transaction
FROM Transactions;

-- Q19. Largest Transaction
SELECT TOP 10 *
FROM Transactions
ORDER BY amount DESC;

-- Q20. Smallest Transaction
SELECT TOP 10 *
FROM Transactions
ORDER BY amount ASC;

-- Q21. Transactions by Chip Usage
SELECT
    use_chip,
    COUNT(*) AS Total
FROM Transactions
GROUP BY use_chip;

-- Q22. Transactions by State
SELECT
    merchant_state,
    COUNT(*) AS Total
FROM Transactions
GROUP BY merchant_state
ORDER BY Total DESC;

-- Q23. Top 10 Merchant Cities
SELECT TOP 10
    merchant_city,
    COUNT(*) AS Transactions
FROM Transactions
GROUP BY merchant_city
ORDER BY Transactions DESC;

-- Q24. Top 10 Merchants
SELECT TOP 10
    merchant_id,
    COUNT(*) AS Total
FROM Transactions
GROUP BY merchant_id
ORDER BY Total DESC;

-- Q25. Top 10 MCC Categories
SELECT TOP 10
    mcc,
    COUNT(*) AS Total
FROM Transactions
GROUP BY mcc
ORDER BY Total DESC;


/*=========================================================
    SECTION 4 - BUSINESS INSIGHTS
=========================================================*/

-- Q26. Top 10 Customers by Total Spending

SELECT TOP 10
    u.id,
    SUM(t.amount) AS Total_Spending
FROM Users u
INNER JOIN Transactions t
ON u.id = t.client_id
GROUP BY u.id
ORDER BY Total_Spending DESC;

-- Q27. Average Spending Per Customer

SELECT
    u.id,
    AVG(t.amount) AS Average_Spending
FROM Users u
INNER JOIN Transactions t
ON u.id=t.client_id
GROUP BY u.id
ORDER BY Average_Spending DESC;

-- Q28. Customers with Highest Number of Transactions

SELECT TOP 10
    client_id,
    COUNT(*) AS Total_Transactions
FROM Transactions
GROUP BY client_id
ORDER BY Total_Transactions DESC;

-- Q29. Customers With More Than 100 Transactions

SELECT
    client_id,
    COUNT(*) AS Total
FROM Transactions
GROUP BY client_id
HAVING COUNT(*)>100
ORDER BY Total DESC;

-- Q30. Credit Limit by Card Brand

SELECT
    card_brand,
    AVG(credit_limit) AS Average_Limit
FROM Cards
GROUP BY card_brand;

-- Q31. Average Spending by Card Brand

SELECT
    c.card_brand,
    AVG(t.amount) AS Avg_Spending
FROM Transactions t
INNER JOIN Cards c
ON t.card_id=c.id
GROUP BY c.card_brand;

-- Q32. Most Used Card Brand

SELECT
    c.card_brand,
    COUNT(*) AS Usage_Count
FROM Transactions t
INNER JOIN Cards c
ON t.card_id=c.id
GROUP BY c.card_brand
ORDER BY Usage_Count DESC;

-- Q33. Top MCC Categories with Description

SELECT TOP 15
    m.Description,
    COUNT(*) AS Total
FROM Transactions t
INNER JOIN MCC_Codes m
ON t.mcc=m.mcc_id
GROUP BY m.Description
ORDER BY Total DESC;

-- Q34. Total Spending by Gender

SELECT
    u.gender,
    SUM(t.amount) AS Total_Spending
FROM Users u
INNER JOIN Transactions t
ON u.id=t.client_id
GROUP BY u.gender;

-- Q35. Average Credit Score by Gender

SELECT
    gender,
    AVG(credit_score) AS Avg_Credit_Score
FROM Users
GROUP BY gender;

PRINT 'Business Analysis Completed Successfully';