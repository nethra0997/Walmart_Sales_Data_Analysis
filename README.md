# Walmart Sales Data Analysis

## About
This project aims to explore Walmart sales data to understand top-performing branches and products, sales trends, and customer behavior. The goal is to study how sales strategies can be improved and optimized. The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition.

## Purpose of the Project
The primary aim of this project is to gain insights into Walmart's sales data to understand the different factors that influence sales across various branches. This analysis will help in optimizing sales strategies, inventory management, and marketing efforts.

## About the Data
The dataset contains sales transactions from three Walmart branches located in Mandalay, Yangon, and Naypyitaw. The data includes 17 columns and captures various aspects of sales, including customer details, product lines, and financial metrics.

## Approach Used

### Data Wrangling
- **Database Creation:** Created the WalmartSalesData database and populated it with the sales data.
- **Table Creation:** Defined the schema for the sales table to ensure data integrity and consistency.
- **Feature Engineering:** 
  - Added columns for `time_of_day`, `day_name`, and `month_name` to provide insights into sales patterns based on the time of day, day of the week, and month.

### Exploratory Data Analysis (EDA)
Conducted exploratory data analysis to answer various business questions related to product performance, customer behavior, and sales trends.

## Business Questions Answered

### Generic Questions
1. How many unique cities does the data have?
2. In which city is each branch located?

### Product Analysis
1. How many unique product lines does the data have?
2. What is the most selling product line?
3. What is the total revenue by month?
4. Which month had the largest COGS?
5. Which product line had the largest revenue?
6. Which city generated the largest revenue?
7. Which product line had the largest VAT?
8. How does each product line perform compared to the average sales? (Good/Bad categorization)
9. Which branch sold more products than the average product sold?
10. What is the most common product line by gender?
11. What is the average rating of each product line?
12. What are the top products by sales per branch?
13. How are products ranked by popularity?
14. What are the top-ranked products in each branch?

### Customer Analysis
1. How many unique customer types does the data have?
2. What are the unique payment methods in the data?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender distribution across branches?
6. Which time of the day do customers give the most ratings?
7. Which day of the week has the best average ratings?
8. How do average ratings vary by branch and time of day?
9. How do customer purchases rank by frequency within each branch?

### Sales Analysis
1. What is the number of sales made during different times of the day per weekday?
2. Which customer type brings in the most revenue?
3. Which city has the largest average tax percentage?
4. Which customer type pays the most in VAT?
5. What are the sales trends over a specified time period for different branches?

### Stored Procedures
- **Product Line Analysis:** Analyzed sales trends for different product lines, including total sales, average sales per transaction, and total quantity sold.
- **Dynamic Sales Report:** Generated dynamic sales reports based on specified date ranges and branches.

## Conclusion
This project provided valuable insights into Walmart's sales data, revealing trends in product performance, customer behavior, and financial metrics. The analyses conducted can be used to inform strategic decisions, optimize sales strategies, and enhance overall business performance.
