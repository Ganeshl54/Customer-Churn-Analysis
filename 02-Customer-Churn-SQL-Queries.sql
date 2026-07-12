create database customer_churn;
use customer_churn;
show tables;
describe customer_churn;

CREATE TABLE customer_churn (
    customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(5)
);
 
LOAD DATA LOCAL INFILE "C:/Users/Admin/OneDrive/Desktop/Customer_churn.csv"
INTO TABLE customer_churn
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from customer_churn;

select count(*) from customer_churn;

-- 1) Total Customers :

SELECT count(*) AS total_customers
FROM customer_churn;

-- 2) Customers by Contract :

SELECT contract,
count(*) AS total_customers
FROM customer_churn
GROUP BY contract;

-- 3) Churn by Contract :

SELECT contract,
count(*) AS Churn_customer
FROM customer_churn
WHERE churn ='yes'
GROUP BY contract
ORDER BY Churn_customer DESC;

-- 4) Revenue By internet Service :

SELECT internetservice,
SUM(totalcharges) as Revenue
FROM customer_churn
GROUP BY internetservice
ORDER BY Revenue DESC ;

-- 5) Maximum Monthly Charges :

SELECT MAX(monthlycharges)  
FROM customer_churn;

-- 6) Average Monthly Charges By Contract :

SELECT contract,
AVG(monthlycharges) AS Avg_monthlycharges
FROM customer_churn
GROUP BY contract;

-- 7) Contract Types Having More Than 2000 Customers :

SELECT contract,
count(*) AS total_customers
FROM customer_churn
GROUP BY contract
HAVING total_customers >2000;

-- 8) Top 10 Highest Paying Customers :

SELECT customerID,
SUM(totalcharges) AS Total_charges
FROM customer_churn
GROUP BY customerID
ORDER BY total_charges DESC
LIMIT 10;

-- 9) Customers with Above Average Charges :

SELECT customerID,
monthlycharges AS monthly_charges
FROM customer_churn
WHERE Monthlycharges >
(select AVG(monthlycharges) AS AVG_monthly_charges
from customer_churn);


-- 10) Second Highest Total charges :

SELECT MAX(totalcharges) AS Second_Highest_Totalcharges from customer_churn
where totalcharges<(select max(totalcharges) from customer_churn);

-- 11) Customers Monthly Charges Above Department Average :

SELECT customerID,
contract,
monthlycharges AS monthly_charges
FROM customer_churn c
WHERE Monthlycharges >
(select AVG(monthlycharges) AS AVG_monthly_charges
from customer_churn
where contract =c.contract);

-- 12) Find customers whose total charges are greater than the average total charges :

WITH customer_charges AS (
    SELECT customerID,
           TotalCharges
    FROM customer_churn
)
SELECT *
FROM customer_charges
WHERE TotalCharges > (
    SELECT AVG(TotalCharges)
    FROM customer_charges
);

-- 13) Top 3 Customers By Revenue :

SELECT * FROM 
(SELECT customerID,
totalcharges,
RANK() OVER (ORDER BY totalcharges DESC) AS Rnk
FROM customer_churn)t
WHERE Rnk <=3;

-- 14) Top  5 customers by Mothly Charges

SELECT * FROM 
(SELECT customerID,
monthlycharges As Monthly_charges,
DENSE_RANK() OVER(ORDER BY monthlycharges DESC) AS Rnk
FROM customer_churn)t
WHERE Rnk <=5;


-- 15) customers By Tenure :

SELECT customerID,tenure,
ROW_NUMBER() OVER(ORDER BY tenure DESC) AS Row_num
FROM customer_churn;

-- 16) Running Revenue By Rank-wise :

SELECT * FROM 
(SELECT customerID,
totalcharges,
SUM(totalcharges) OVER(ORDER BY totalcharges DESC) AS Running_Revenue,
ROW_NUMBER() OVER(ORDER BY totalcharges DESC) AS rn 
FROM customer_churn)t
WHERE rn<=3;