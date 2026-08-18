/*
===========================
   
   WSDA Music Database
      SQL Project
	  
===========================


Name: Rachel Saini
Create date: 8/15/2026

Description: This SQL project uses the WSDA Music database to uncover a discrepancy in the company's records between 2011 and 2012.


------------------------
       CONTENTS:
Line 27 - High-level overciew of data
Line 54 - Exploring customers and employee records
Line 190 - Looking into highest-commissioned employee
Line 282 - Conclusion
------------------------
*/

/*
===================================================================================================
Part 1: Get a high-level overview of the data between 2011 and 2012.
===================================================================================================
*/

-- Get the total number of transactions that took place between 2011 and 2012.
--> 167 transactions
SELECT
  COUNT(*) AS "transaction_count"
FROM
  Invoice
WHERE
  InvoiceDate >= '2011-01-01' AND InvoiceDate < '2013-01-01';
 

-- Extract the total amount of money WSDA Music made during that time period.
--> $1947.97
SELECT
  SUM(total) AS "total_sum"
FROM
  Invoice
WHERE
  InvoiceDate >= '2011-01-01' AND InvoiceDate < '2013-01-01';

  

/*
===================================================================================================
Part 2: Investigate customers and employee records between 2011 and 2012.
===================================================================================================
*/

-- Retrieve a list of customers who made purchases between 2011 and 2012.

-- This query lists customers from 2011 and 2012 each time they made a purchase during that period.
SELECT
  i.CustomerId,
  c.FirstName,
  c.LastName,
  i.InvoiceId,
  DATE(i.InvoiceDate) AS "invoice_date",
  i.total
FROM
 Invoice AS i
INNER JOIN
  Customer AS c
  ON i.CustomerId = c.CustomerId
WHERE
  i.InvoiceDate >= '2011-01-01' AND i.InvoiceDate < '2013-01-01'
ORDER BY
  i.InvoiceId;
  
-- This query does the same as above but only returns each customer once.
SELECT DISTINCT
  i.CustomerId,
  c.FirstName,
  c.LastName
FROM
 Invoice AS i
INNER JOIN
  Customer AS c
  ON i.CustomerId = c.CustomerId
WHERE
  i.InvoiceDate >= '2011-01-01' AND i.InvoiceDate < '2013-01-01'
ORDER BY
  c.LastName;


-- Get a list of customers, sales representatives, and total transaction amounts for each customer between 2011 and 2012.
-- Each customer is listed once with the sum of all their transactions from the time period.
SELECT
  i.CustomerId,
  c.FirstName AS "customer_first_name",
  c.LastName AS "customer_last_name",
  c.SupportRepId AS "employee_id",
  e.FirstName AS "employee_first_name",
  e.LastName AS "employee_last_name",
  SUM(i.total) AS "total_spent"
FROM
  Invoice AS i
INNER JOIN
  Customer AS c
ON i.CustomerId = c.CustomerId
INNER JOIN
  Employee AS e
ON c.SupportRepId = e.EmployeeId
WHERE
  i.InvoiceDate >= '2011-01-01' AND i.InvoiceDate < '2013-01-01'
GROUP BY
  i.CustomerId,
  c.FirstName,
  c.LastName,
  c.SupportRepId,
  e.FirstName,
  e.LastName
ORDER BY
  c.LastName;

-- The following query does the same as above but lists each transaction the customers make, along with the date.
SELECT
  i.CustomerId,
  c.FirstName AS "customer_first_name",
  c.LastName AS "customer_last_name",
  i.InvoiceId,
  DATE(i.InvoiceDate) AS "invoice_date",
  c.SupportRepId AS "employee_id",
  e.FirstName AS "employee_first_name",
  e.LastName AS "employee_last_name",
  i.total AS "transaction_amount"
FROM
  Invoice AS i
INNER JOIN
  Customer AS c
ON i.CustomerId = c.CustomerId
INNER JOIN
  Employee AS e
ON c.SupportRepId = e.EmployeeId
WHERE
  i.InvoiceDate >= '2011-01-01' AND i.InvoiceDate < '2013-01-01'
ORDER BY
  c.LastName;
  

-- Get the number of transactions above the average transaction amount between 2011 and 2012.

-- The following query returns the average transaction during that time period.
--> Average = $11.66
SELECT
  ROUND(AVG(total), 2) AS "avg_total"
FROM
  Invoice
WHERE
  InvoiceDate >= '2011-01-01' AND InvoiceDate < '2013-01-01';

-- This query returns the number of transactions greater than the average total.
--> 26 invoices
SELECT
  COUNT(*) AS "transactions_above_avg"
FROM Invoice
WHERE
  (InvoiceDate >= '2011-01-01' AND InvoiceDate < '2013-01-01') AND total >
  (SELECT
    ROUND(AVG(total), 2) AS "avg_total"
  FROM
    Invoice
  WHERE
    InvoiceDate >= '2011-01-01' AND InvoiceDate < '2013-01-01');


-- Retrieve the average transaction amount for each year that WSDA Music has been in business.
SELECT
  SUBSTR(InvoiceDate, 1, 4) AS "invoice_year",
  ROUND(AVG(total), 2) AS "avg_transaction_amount"
FROM
  Invoice
GROUP BY
  invoice_year
ORDER BY
  invoice_year;



/*
===================================================================================================
Part 3: Look into the highest-commissioned employee.
===================================================================================================
*/

-- Create view to refer back to for employee and customer relationships and invoices from 2011-2012.
CREATE VIEW V_employee_customer_invoices AS
  SELECT
    e.EmployeeId,
    e.FirstName AS "employee_first_name",
    e.LastName AS "employee_last_name",
    c.CustomerId,
    c.FirstName AS "customer_first_name",
    c.LastName AS "customer_last_name",
    i.InvoiceId,
    DATE(i.InvoiceDate) AS "invoice_date",
    i.total
  FROM
    Invoice AS i
  INNER JOIN
    Customer AS c
  ON i.CustomerId = c.CustomerId
  INNER JOIN
    Employee AS e
  ON c.SupportRepId = e.EmployeeId
  WHERE
    i.InvoiceDate >= '2011-01-01' AND i.InvoiceDate < '2013-01-01';


-- Obtain a list of employees and their sales' average transaction amounts.
SELECT
  EmployeeId,
  employee_first_name,
  employee_last_name,
   ROUND(AVG(total), 2) AS "average_total_transactions"
FROM
  V_employee_customer_invoices
GROUP BY
  EmployeeId,
  employee_first_name,
  employee_last_name;

  
-- Create a Commission Payout column that displays each employee’s commission based on 15% of the sales transaction amount.
-- Compare each employee's commission total and note the employee with the highest commission.
--> Jane Peacock, $199.77
SELECT
  EmployeeId,
  employee_first_name,
  employee_last_name,
  ROUND(SUM(total * 0.15), 2) AS "commissions_total"
FROM
  V_employee_customer_invoices
GROUP BY
  EmployeeId,
  employee_first_name,
  employee_last_name
ORDER BY
  commissions_total DESC;


-- List the customers that the identified employee worked with. Find the customer with the greatest individual purchase.
SELECT
  EmployeeId,
  employee_first_name,
  employee_last_name,
  CustomerId,
  customer_first_name,
  customer_last_name,
  InvoiceId,
  total
FROM
  V_employee_customer_invoices
WHERE
  EmployeeId = 3
ORDER BY
  total DESC;


-- Inspect all the customer's information.
--> Most entires are null (e.g., address, phone, billing address). Customer appears to be fabricated.
SELECT *
FROM
  Customer AS c
INNER JOIN
  Invoice AS i
ON c.CustomerId = i.CustomerId
WHERE
  c.CustomerId = 60;


/*
===================================================================================================
CONCLUSION: The data suggests Jane Peacock may have committed fraud, resulting in the discrepancy.
===================================================================================================
*/