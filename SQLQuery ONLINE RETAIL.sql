--Preview the Dataset
select * from [OnlineRetail dataset]
select top 10 * from [OnlineRetail dataset]

--Row Count Query
select count (*) as Total_Rows
from [OnlineRetail dataset]

--Column Information
select COLUMN_NAME,DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'OnlineRetail dataset'

--Identification of Primary Key
select COLUMN_NAME
from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
where OBJECTPROPERTY( OBJECT_ID(CONSTRAINT_NAME),
'IsPrimaryKey') = 1
and table_name = 'OnlineRetail dataset'

select count (*) as total_rows,
count (distinct InvoiceNo) as unique_invoiceno
from [OnlineRetail dataset]

--Data Cleaning
--Check for missing Values
select count(*) as Total_rows,
sum(case when invoiceno is null then 1 else 0 end) as Null_invoiceno,
sum(case when Stockcode is null then 1 else 0 end) as Null_Stockcode,
sum(case when Description is null then 1 else 0 end) as Null_Description,
sum(case when Quantity is null then 1 else 0 end) as Null_Quantity,
sum(case when invoicedate is null then 1 else 0 end) as Null_invoicedate,
sum(case when unitprice is null then 1 else 0 end) as Null_unitprice,
sum(case when customerid is null then 1 else 0 end) as Null_customerid,
sum(case when country is null then 1 else 0 end) as Null_Country
from [OnlineRetail dataset]

--Investigation
-- See what these null CustomerID rows look like
select top 20 *
from [OnlineRetail dataset]
where CustomerID IS NULL

select top 20 *
from [OnlineRetail dataset]
where Description IS NULL


select top 20 *
from [OnlineRetail dataset]
where UnitPrice IS NULL

-- How many cancelled invoices exist (start with 'C')?
SELECT COUNT(*) AS cancelled_transactions
FROM [OnlineRetail dataset]
WHERE InvoiceNo LIKE 'C%'

-- How many adjustment entries exist (start with 'A')?
SELECT COUNT(*) AS adjustment_entries
FROM [OnlineRetail dataset]
WHERE InvoiceNo LIKE 'A%'

-- How many rows have negative quantity?
SELECT COUNT(*) AS negative_quantity
FROM [OnlineRetail dataset]
WHERE Quantity < 0

-- How many guest orders (NULL CustomerID but valid sale)?
SELECT COUNT(*) AS guest_orders
FROM [OnlineRetail dataset]
WHERE CustomerID IS NULL
  AND Quantity > 0
  AND UnitPrice > 0

  -- Negative quantity rows that are NOT cancellations
SELECT TOP 20 *
FROM [OnlineRetail dataset]
WHERE Quantity < 0
  AND InvoiceNo NOT LIKE 'C%'

  -- Cleaned View
CREATE VIEW vw_OnlineRetail_Clean AS
SELECT
    InvoiceNo,
    StockCode,
    ISNULL(Description, 'No Description')     AS Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CAST(
        ISNULL(CAST(CustomerID AS NVARCHAR(10)), 'Guest') 
    AS NVARCHAR(10))                           AS CustomerID,
    Country
FROM [OnlineRetail dataset]
WHERE Quantity  > 0                -- removes negatives, cancellations, adjustments
  AND UnitPrice > 0                -- removes zero-price entries
  AND InvoiceNo NOT LIKE 'A%';    -- removes bad debt adjustments
-- Verify the cleaned view
SELECT COUNT(*) AS clean_rows FROM vw_OnlineRetail_Clean

--Check for duplicates
select invoiceno, count(*)
from [OnlineRetail dataset]
group by InvoiceNo
having count(*) > 1

-- Correct duplicate check on composite key
SELECT 
    InvoiceNo,
    StockCode,
    COUNT(*) AS cnt
FROM [OnlineRetail dataset]
GROUP BY InvoiceNo, StockCode
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- Standardize date format to YYYY-MM-DD
SELECT 
    CONVERT(VARCHAR(10), InvoiceDate, 120) AS InvoiceDate_Clean
FROM [OnlineRetail dataset];

CONVERT(VARCHAR(10), InvoiceDate, 120) AS InvoiceDate

-- 1. Standardize date in the cleaned view (final version)
CREATE OR ALTER VIEW vw_OnlineRetail_Clean AS
SELECT
    InvoiceNo,
    StockCode,
    ISNULL(Description, 'No Description')           AS Description,
    Quantity,
    CONVERT(VARCHAR(10), InvoiceDate, 120)           AS InvoiceDate,
    ROUND(UnitPrice, 2)                              AS UnitPrice,
    ISNULL(CAST(CustomerID AS NVARCHAR(10)), 'Guest') AS CustomerID,
    Country
FROM [OnlineRetail dataset]
WHERE Quantity  > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%';

-- 2. Verify final clean row count
SELECT COUNT(*) AS final_clean_rows FROM vw_OnlineRetail_Clean

SELECT * FROM vw_OnlineRetail_Clean


--Exploratory Data Analysis
SELECT SUM(Unitprice) AS Total_Revenue
FROM vw_OnlineRetail_Clean

SELECT AVG(Unitprice) as Average_Revenue
FROM vw_OnlineRetail_Clean

SELECT COUNT(CustomerId) AS Total_customers
FROM vw_OnlineRetail_Clean

SELECT MAX(Unitprice) AS Highest_Price
FROM vw_OnlineRetail_Clean

SELECT MIN(Unitprice) AS Lowest_Price
FROM vw_OnlineRetail_Clean

SELECT STDEV(Unitprice) AS Std_Dev_Sample
FROM vw_OnlineRetail_Clean

-- 1. Top Selling Products 
SELECT TOP 10 StockCode,Description,
    SUM(Quantity) AS total_quantity_sold,
    COUNT(DISTINCT InvoiceNo) AS times_ordered
FROM vw_OnlineRetail_Clean
GROUP BY StockCode, Description
ORDER BY total_quantity_sold DESC


-- 2. Highest Revenue Generating Countries
SELECT TOP 10 Country,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS total_items_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue,
    ROUND(AVG(Quantity * UnitPrice), 2) AS avg_order_value
FROM vw_OnlineRetail_Clean
GROUP BY Country
ORDER BY total_revenue DESC;


-- 3. Monthly Sales Trend
SELECT
    FORMAT(CAST(InvoiceDate AS DATE), 'yyyy-MM') AS month,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS total_items_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS monthly_revenue,
    ROUND(AVG(Quantity * UnitPrice), 2) AS avg_order_value
FROM vw_OnlineRetail_Clean
GROUP BY FORMAT(CAST(InvoiceDate AS DATE), 'yyyy-MM')
ORDER BY month;


-- 4. Most Purchased Products (by number of orders)
SELECT TOP 10 StockCode,Description,
    COUNT(DISTINCT InvoiceNo) AS times_purchased,
    SUM(Quantity) AS total_units_sold,
    ROUND(AVG(UnitPrice), 2) AS avg_unit_price,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM vw_OnlineRetail_Clean
GROUP BY StockCode, Description
ORDER BY times_purchased DESC;


-- 5. CUSTOMER PURCHASING BEHAVIOUR

-- 5a. Overall customer spend summary
SELECT CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS total_items_bought,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_spent,
    ROUND(AVG(Quantity * UnitPrice), 2) AS avg_order_value,
    MIN(CAST(InvoiceDate AS DATE)) AS first_purchase,
    MAX(CAST(InvoiceDate AS DATE)) AS last_purchase
FROM vw_OnlineRetail_Clean
WHERE CustomerID != 'Guest'
GROUP BY CustomerID
ORDER BY total_spent DESC;

-- 5b. Top 10 customers by revenue
SELECT TOP 10 CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_spent,
    ROUND(AVG(Quantity * UnitPrice), 2) AS avg_order_value
FROM vw_OnlineRetail_Clean
WHERE CustomerID != 'Guest'
GROUP BY CustomerID
ORDER BY total_spent DESC;
