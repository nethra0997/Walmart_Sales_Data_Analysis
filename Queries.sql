-- -------------------------------------------------DATABASE CREATION-----------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS WalmartSalesData;


-- -----------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------TABLE CREATION-------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------#FEATURE ENGINEERING---------------------------------------------------------------
-- TIME OF DAY
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

# Adding the column using ALTER Table
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);




-- DAY NAME
SELECT
	date,
	DAYNAME(date)
FROM sales;

# Adding the column using ALTER Table
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);




-- MONTH NAME
SELECT
	date,
	MONTHNAME(date)
FROM sales;

# Adding the column using ALTER Table
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------GENERIC QUESTIONS-------------------------------------------------------

-- Q1 -> How many unique cities does the data have?

SELECT 
    COUNT(DISTINCT City) AS UniqueCityCount,
    GROUP_CONCAT(DISTINCT City ORDER BY City ASC) AS CityNames
FROM 
    Sales;

-- Q2 -> In which city is each branch?

SELECT 
	DISTINCT city,
    branch
FROM sales;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------PRODUCTS---------------------------------------------------------------


-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;

SELECT COUNT(DISTINCT product_line) as number_of_productlines from Sales;


-- What is the most selling product line
SELECT
	SUM(quantity) as total_qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY total_qty DESC;

-- What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;




-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;




-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;



-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;




-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;




-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;




-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);




-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;



-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;



-- What are the top products by Sales per Branch
WITH TotalSales AS (
    SELECT 
        Branch,
        Product_line,
        SUM(Total) AS TotalSales
    FROM 
        sales
    GROUP BY 
        Branch, Product_line
)
SELECT 
    Branch, 
    Product_line, 
    TotalSales
FROM 
    TotalSales
WHERE 
    TotalSales IN (
        SELECT MAX(TotalSales) 
        FROM TotalSales 
        GROUP BY Branch
    );
    
    
    
-- Ranking the products by popularity
SELECT 
    Branch,
    Product_line,
    SUM(Quantity) AS TotalQuantity,
    RANK() OVER (PARTITION BY Branch ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM 
    sales
GROUP BY 
    Branch, Product_line;



-- Selecting the top ranked products from each branch
-- The following query can be merged with the above query by creating the rank functionality as a CTE and using it to query data
    
SELECT 
    Branch,
    Product_line,
    TotalQuantity,
    ProductRank
FROM (
    SELECT 
        Branch,
        Product_line,
        SUM(Quantity) AS TotalQuantity,
        RANK() OVER (PARTITION BY Branch ORDER BY SUM(Quantity) DESC) AS ProductRank
    FROM 
        sales
    GROUP BY 
        Branch, Product_line
) AS RankedProducts
WHERE 
    ProductRank = 1;
    
    

-- Stored Procedure to analyze 
-- the sales trend for different product lines, including total sales, average sales per transaction, and total quantity sold
DELIMITER //
CREATE PROCEDURE ProductLineAnalysis()
BEGIN
    SELECT 
        Product_line,
        SUM(Total) AS TotalSales,
        AVG(Total) AS AvgSalesPerTransaction,
        SUM(Quantity) AS TotalQuantitySold
    FROM 
        Sales
    GROUP BY 
        Product_line
    ORDER BY 
        TotalSales DESC;
END //

DELIMITER ;

CALL ProductLineAnalysis();



-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------Customers---------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- What are the unique payment methods in the data?
SELECT
	DISTINCT payment
FROM sales;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- Use the AVG() window function to calculate a rolling average of customer ratings over a specified time period
SELECT 
    Date,
    Rating,
    AVG(Rating) OVER (
        ORDER BY Date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS MovingAvgRating
FROM 
    sales
ORDER BY 
    Date;

-- Calculate the number of purchases made by each customer and then rank customers by their purchase frequency
WITH CustomerPurchaseCount AS (
    SELECT 
        Customer_type,
        Branch,
        COUNT(*) AS PurchaseCount
    FROM 
        sales
    GROUP BY 
        Customer_type, Branch
)
SELECT 
    Customer_type,
    Branch,
    PurchaseCount,
    RANK() OVER (
        PARTITION BY Branch 
        ORDER BY PurchaseCount DESC
    ) AS CustomerRank
FROM 
    CustomerPurchaseCount
ORDER BY 
    Branch, CustomerRank;


-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------- Sales ------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

-- Dynamic Sales Report
DELIMITER //
CREATE PROCEDURE GenerateSalesReport(
    IN startDate DATE,
    IN endDate DATE,
    IN branchName VARCHAR(255)
)
BEGIN
    SELECT 
        DATE(Date) AS Date,  -- Extracting only the date part
        SUM(Total) AS TotalSales,
        SUM(gross_income) AS TotalGrossIncome
    FROM 
        sales
    WHERE 
        DATE(Date) BETWEEN startDate AND endDate
        AND Branch = branchName
    GROUP BY 
        DATE(Date)
    ORDER BY 
        DATE(Date);
END //

DELIMITER ;

CALL GenerateSalesReport('2019-01-01', '2019-02-28', 'A');
-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------