/* In below 
 fails because your database is not actually named beverages. 
The subsequent commands are used to find out where your data is hiding and look inside those tables.*/

USE beverages;

SHOW DATABASES; 
/* In below 
SHOW DATABASES;This lists every single database folder on your server. 
 Think of a database like a filing cabinet. You must find the right cabinet before looking for a file.*/

SHOW TABLES;
 /* In below  -- ( Once you are inside a database, this lists all the individual tables (the file folders) inside it.)
*/

/* In below 
 SELECT * FROM beverages_chunk_001 LIMIT 100; → Fetches all columns and the first 100 rows from the beverages_chunk_001 table.
 Logic: SELECT * = all columns → FROM = table → LIMIT 100 = maximum 100 rows.
 */ 
 SELECT * FROM  beverages_chunk_001 LIMIT 100;
 SELECT * FROM  beverages_chunk_002 LIMIT 20;
 SELECT * FROM  beverages_chunk_003 LIMIT 20;
 SELECT  * FROM beverages_chunk_004 LIMIT 20;

/* In below 
 DESCRIBE (or DESC) is a rapid metadata command that reads a table’s structural blueprint from the system catalog instantly—without touching a single row of real data.📋 The 6 Output Fields (The Blueprint)Field: The column header name.Type: The data restriction format (INT, VARCHAR).Null: Can it accept empty values? (YES/NO).Key: Is it indexed? (PRI = Primary, MUL = Foreign/Non-unique).Default: What value drops in if left blank?Extra: Bonus behavior rules (like auto_increment). 
*/

DESCRIBE beverages_chunk_001;
DESCRIBE beverages_chunk_002;
DESCRIBE beverages_chunk_003;
DESCRIBE beverages_chunk_004;

/* In below  query checks INFORMATION_SCHEMA to count how many of our chunk tables contain each column header.If the table_count for a column is exactly 4, it instantly proves that column name matches identically across all four chunks. 
*/
SELECT column_name, COUNT(DISTINCT table_name) AS table_count
FROM information_schema.columns
WHERE table_schema = 'beverages'
  AND table_name IN ('beverages_chunk_001', 'beverages_chunk_002', 'beverages_chunk_003', 'beverages_chunk_004')
GROUP BY column_name;

/* 
UNION ALL is faster because it simply merges rows, whereas UNION forces the database to sort the data and 
remove duplicate records, using significantly more CPU and memory
*/
CREATE OR REPLACE VIEW Beverages_Data_View AS
SELECT * FROM beverages_chunk_001
UNION ALL
SELECT * FROM beverages_chunk_002
UNION ALL
SELECT * FROM beverages_chunk_003
UNION ALL
SELECT * FROM beverages_chunk_004;

SELECT  * FROM
               Beverages_Data_View
                 LIMIT 100;

DESCRIBE Beverages_Data_View;

/* 
I used IS NULL with SUM() for each column. The result was 0 for all 46 columns, 
so there are no NULL values in the dataset.
*/
SELECT
    SUM(Product_ID IS NULL) AS Product_ID_NULL,
    SUM(Company_Name IS NULL) AS Company_Name_NULL,
    SUM(Brand_Name IS NULL) AS Brand_Name_NULL,
    SUM(Category IS NULL) AS Category_NULL,
    SUM(Sub_Category IS NULL) AS Sub_Category_NULL,
    SUM(Product_Name IS NULL) AS Product_Name_NULL,
    SUM(Weight_g IS NULL) AS Weight_g_NULL,
    SUM(MRP IS NULL) AS MRP_NULL,
    SUM(Selling_Price IS NULL) AS Selling_Price_NULL,
    SUM(Discount_Percent IS NULL) AS Discount_Percent_NULL,
    SUM(Rating IS NULL) AS Rating_NULL,
    SUM(Reviews IS NULL) AS Reviews_NULL,
    SUM(Seller_Name IS NULL) AS Seller_Name_NULL,
    SUM(Marketplace IS NULL) AS Marketplace_NULL,
    SUM(Marketplace_URL IS NULL) AS Marketplace_URL_NULL,
    SUM(Availability IS NULL) AS Availability_NULL,
    SUM(Protein_g IS NULL) AS Protein_g_NULL,
    SUM(Sugar_g IS NULL) AS Sugar_g_NULL,
    SUM(Calories IS NULL) AS Calories_NULL,
    SUM(Health_Score IS NULL) AS Health_Score_NULL,
    SUM(Health_Rating IS NULL) AS Health_Rating_NULL,
    SUM(Quality_Grade IS NULL) AS Quality_Grade_NULL,
    SUM(Recommended_For IS NULL) AS Recommended_For_NULL,
    SUM(State IS NULL) AS State_NULL,
    SUM(Profit_Margin_Percent IS NULL) AS Profit_Margin_Percent_NULL,
    SUM(City IS NULL) AS City_NULL,
    SUM(Region IS NULL) AS Region_NULL,
    SUM(Is_Premium_Brand IS NULL) AS Is_Premium_Brand_NULL,
    SUM(Certifications IS NULL) AS Certifications_NULL,
    SUM(Certification_Count IS NULL) AS Certification_Count_NULL,
    SUM(Manufacturing_State IS NULL) AS Manufacturing_State_NULL,
    SUM(Shelf_Life_Months IS NULL) AS Shelf_Life_Months_NULL,
    SUM(Order_Date IS NULL) AS Order_Date_NULL,
    SUM(Order_Month IS NULL) AS Order_Month_NULL,
    SUM(Order_Quarter IS NULL) AS Order_Quarter_NULL,
    SUM(Order_Year IS NULL) AS Order_Year_NULL,
    SUM(Day_of_Week IS NULL) AS Day_of_Week_NULL,
    SUM(Is_Weekend_Order IS NULL) AS Is_Weekend_Order_NULL,
    SUM(Price_Category IS NULL) AS Price_Category_NULL,
    SUM(Fat_g IS NULL) AS Fat_g_NULL,
    SUM(Carbs_g IS NULL) AS Carbs_g_NULL,
    SUM(Sodium_mg IS NULL) AS Sodium_mg_NULL,
    SUM(Fiber_g IS NULL) AS Fiber_g_NULL,
    SUM(Revenue_INR IS NULL) AS Revenue_INR_NULL,
    SUM(Units_Sold IS NULL) AS Units_Sold_NULL,
    SUM(Return_Rate_Percent IS NULL) AS Return_Rate_Percent_NULL
FROM Beverages_Data_View;
/* How do you find duplicate records? */
SELECT 
    Product_ID,
    COUNT(*) AS Duplicate_Count
FROM Beverages_Data_View
GROUP BY Product_ID
HAVING COUNT(*) > 1;

/*First check how many duplicate rows exist:
*/
SELECT 
    COUNT(*) - COUNT(DISTINCT Product_ID) AS Duplicate_Rows
FROM Beverages_Data_View;

/*
*/
-- 1. Delete old clean table if it exists
DROP TABLE IF EXISTS Beverages_Clean;

select * from Beverages_Clean;
-- 2. Create clean table
--    Keep only ONE row for each Product_ID
DROP TABLE IF EXISTS Beverages_Clean;

CREATE TABLE Beverages_Clean AS
WITH RankedData AS (
    SELECT
        b.*,
        ROW_NUMBER() OVER (
            PARTITION BY Product_ID
            ORDER BY Product_ID
        ) AS rn
    FROM Beverages_Data_View b
)
SELECT
    *
FROM RankedData
WHERE rn = 1;
-- 3. Check total rows in clean table
SELECT COUNT(*) AS Clean_Total_Rows
FROM Beverages_Clean;


-- 4. Check duplicate Product_IDs
--    This should return NO rows
SELECT
    Product_ID,
    COUNT(*) AS Duplicate_Count
FROM Beverages_Clean
GROUP BY Product_ID
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;


-- 5. Show complete cleaned data
SELECT *
FROM Beverages_Clean
LIMIT 100;
/*
I used ROW_NUMBER() with PARTITION BY Product_ID to identify duplicate records and filtered rn = 1 
to retain one record per Product_ID while preserving all columns
*/

SELECT DISTINCT Category
FROM Beverages_Clean;






/* 
whithout cleaned and with clean data
*/
--
SELECT COUNT(*) 
FROM Beverages_Data_View;
/*  I observed **175,000 rows using `COUNT(*)` before data cleaning**.
After removing duplicate `Product_ID` records, **`COUNT(*)` showed approximately 100,000 rows** in the cleaned dataset.

*/

/* Difference between COUNT(*) and COUNT(column) , Dis*/
/*
 COUNT(*)

Counts all rows 
*/
SELECT COUNT(*)
FROM Beverages_Clean;

/*
Counts only non-NULL values in that column.
*/
SELECT COUNT(Product_Name)
FROM Beverages_Clean;

/*
 remove duplicate rows from your query results and return only unique values. 
*/
SELECT DISTINCT Product_Name 
FROM Beverages_Clean; 

/* Difference between WHERE and HAVING*/
/* 
WHERE = Filters rows before grouping.
*/
SELECT *
FROM Beverages_Clean
WHERE Rating >= 4;
/*
Having =  Filters groups after GROUP BY
*/
SELECT distinct Brand_Name, AVG(Rating) AS Avg_Rating
FROM Beverages_Clean
GROUP BY Brand_Name
HAVING AVG(Rating) >= 4;
/*
Interview = WHERE filters rows before aggregation, while HAVING filters grouped results after aggregation
*/
 
 /* Group By = GROUP BY combines rows having the same value so that we can perform aggregate calculations.
*/
SELECT Category, COUNT(*) AS Product_Count
FROM Beverages_Clean
GROUP BY Category; 


/* What are aggregate functions?

Common aggregate functions:

COUNT()
SUM()
AVG()
MIN()
MAX() 
*/

SELECT
    COUNT(*) AS Total_Products,
    SUM(Revenue_INR) AS Total_Revenue,
    ROUND(AVG(Rating), 2) AS Average_Rating,

    MIN(Selling_Price) AS Minimum_Price,

    (SELECT Product_Name
     FROM Beverages_Clean
     ORDER BY Selling_Price ASC
     LIMIT 1) AS Minimum_Price_Product,

    (SELECT Brand_Name
     FROM Beverages_Clean
     ORDER BY Selling_Price ASC
     LIMIT 1) AS Minimum_Price_Brand,

    MAX(Selling_Price) AS Maximum_Price,

    (SELECT Product_Name
     FROM Beverages_Clean
     ORDER BY Selling_Price DESC
     LIMIT 1) AS Maximum_Price_Product,

    (SELECT Brand_Name
     FROM Beverages_Clean
     ORDER BY Selling_Price DESC
     LIMIT 1) AS Maximum_Price_Brand
FROM Beverages_Clean;

/*
 First see Tea and Coffee data
*/
SELECT *
FROM Beverages_clean
WHERE LOWER(category) IN ('tea', 'coffee');
/*
 Logic inabove: This filters the dataset and keeps only Tea and Coffee products. 
*/

/* 
2. See all Tea and Coffee brand names
*/
SELECT DISTINCT brand_name
FROM Beverages_clean
WHERE LOWER(category) IN ('tea', 'coffee')
ORDER BY brand_name;
/*
Logic: DISTINCT removes duplicate brand names
*/

/*
See Tea brands only
*/
SELECT DISTINCT brand_name
FROM Beverages_clean
WHERE LOWER(category) ='tea'
ORDER BY brand_name;

/* See Coffe brands only
*/
SELECT DISTINCT  brand_name

FROM Beverages_clean
WHERE LOWER(category) = 'coffee'
ORDER BY brand_name;

SELECT COUNT(DISTINCT Brand_Name) AS Coffee_Brand_Count
FROM Beverages_Clean
WHERE LOWER(Category) = 'coffee';
/* 
"I used DISTINCT to get unique brands and filtered the category using LOWER() to handle case differences."
*/

/*
5. Highest-priced Tea
*/

describe Beverages_clean;

SELECT
    Product_ID,
    Product_Name,
    Brand_Name,
    Weight_g,
    Price_Category,
    MRP,
    Selling_Price,
    Discount_Percent,
    Rating
FROM Beverages_Clean
WHERE LOWER(Category) = 'tea'
ORDER BY Selling_Price DESC
LIMIT 1;
/*
Interview logic

"I filtered the data for Tea category, sorted the products by Selling Price in descending order, 
 and 
     used LIMIT 1 to find the highest-selling-price Tea product"
*/

/* 
Lowest-priced Tea 
*/
SELECT
    Product_ID,
    Product_Name,
    Brand_Name,
    Weight_g,
    Price_Category,
    MRP,
    Selling_Price,
    Discount_Percent,
    Rating
FROM Beverages_Clean
WHERE LOWER(Category) = 'tea'
ORDER BY Selling_Price ASC
LIMIT 1;
/*
   ASC means smallest to largest.
   DESC means largest to smallest
*/

/*
        7. Highest-priced Coffee
*/
SELECT
    Product_ID,
    Product_Name,
    Brand_Name,
    Weight_g,
    Price_Category,
    MRP,
    Selling_Price,
    Discount_Percent,
    Rating
FROM Beverages_Clean
WHERE LOWER(Category) = 'coffee'
ORDER BY Selling_Price DESC
LIMIT 1;

/* 
   8. Lowest Price of coffee
   */
SELECT
    Product_ID,
    Product_Name,
    Brand_Name,
    Weight_g,
    Price_Category,
    MRP,
    Selling_Price,
    Discount_Percent,
    Rating
    
FROM Beverages_Clean
WHERE LOWER(Category) = 'coffee'
ORDER BY Selling_Price ASC
LIMIT 1;

/*
   9. Average Tea price
*/
SELECT AVG(Selling_Price) AS average_tea_price
FROM Beverages_clean
WHERE LOWER(category) = 'tea';

/* 
     9. Average Coffee price
*/
SELECT AVG(Selling_Price) AS average_coffee_price
FROM Beverages_clean
WHERE LOWER(category) = 'coffee';

/*
    11. Highest, lowest and average price together
*/
SELECT
    category,
    MIN(Selling_Price) AS lowest_price,
    MAX(Selling_Price) AS highest_price,
    AVG(Selling_Price) AS average_price,
    COUNT(*) AS total_products
FROM Beverages_clean
WHERE LOWER(category) IN ('tea', 'coffee')
GROUP BY category;

/*
   Brand-wise average price
*/
SELECT
    category,
    brand_name,
    ROUND(AVG(Selling_Price), 2) AS average_price
FROM Beverages_clean
WHERE LOWER(category) IN ('tea', 'coffee')
GROUP BY category, brand_name
ORDER BY average_price DESC;

/*
   13. Brand-wise highest and lowest prices
*/

SELECT
    Category,
    Brand_Name,
    Weight_g,
    MIN(Selling_Price) AS Lowest_Price,
    MAX(Selling_Price) AS Highest_Price,
    ROUND(AVG(Selling_Price), 2) AS Average_Price
FROM Beverages_Clean
WHERE LOWER(Category) IN ('tea', 'coffee')
GROUP BY Category, Brand_Name, Weight_g
ORDER BY Category, Average_Price DESC;

-- Remove old analysis table if it already exists
DROP TABLE IF EXISTS Tea_Coffee_Analysis;

-- Create Tea & Coffee analysis table
CREATE TABLE Tea_Coffee_Analysis AS

SELECT
    Product_ID,
    Company_Name,
    Brand_Name,
    Category,
    Sub_Category,
    Product_Name,
    Weight_g,

    Price_Category,
    MRP,
    Selling_Price,
    Discount_Percent,

    Rating,
    Reviews,

    Health_Rating,
    Health_Score,
    Quality_Grade,
    Recommended_For,

    State,
    City,
    Region,

    Seller_Name,
    Marketplace,
    Availability,

    Protein_g,
    Sugar_g,
    Calories,
    Fat_g,
    Carbs_g,
    Sodium_mg,
    Fiber_g,

    Is_Premium_Brand,
    Certifications,
    Certification_Count,

    Manufacturing_State,
    Shelf_Life_Months,

    Order_Date,
    Order_Month,
    Order_Quarter,
    Order_Year,
    Day_of_Week,
    Is_Weekend_Order,

    Profit_Margin_Percent,
    Revenue_INR,
    Units_Sold,
    Return_Rate_Percent,

    -- Category-level price analysis
    MIN(Selling_Price) OVER (
        PARTITION BY LOWER(Category)
    ) AS Lowest_Price,

    MAX(Selling_Price) OVER (
        PARTITION BY LOWER(Category)
    ) AS Highest_Price,

    ROUND(
        AVG(Selling_Price) OVER (
            PARTITION BY LOWER(Category)
        ), 2
    ) AS Average_Price,

    -- Category-level rating analysis
    ROUND(
        AVG(Rating) OVER (
            PARTITION BY LOWER(Category)
        ), 2
    ) AS Average_Rating,

    MIN(Rating) OVER (
        PARTITION BY LOWER(Category)
    ) AS Lowest_Rating,

    MAX(Rating) OVER (
        PARTITION BY LOWER(Category)
    ) AS Highest_Rating

FROM Beverages_Clean

WHERE LOWER(Category) IN ('tea', 'coffee');


-- Check the final table
SELECT *
FROM Tea_Coffee_Analysis
ORDER BY Category, Selling_Price DESC
;

--------------------------------
/* ============================================================
   TEA + COFFEE BUSINESS ANALYSIS
   Faster version for large datasets
   ============================================================ */

DROP TABLE IF EXISTS Tea_Coffee_Analysis;


/* ============================================================
   STEP 1: CREATE MAIN TEA + COFFEE TABLE
   ============================================================ */

CREATE TABLE Tea_Coffee_Analysis AS

SELECT
    Product_ID,
    Company_Name,
    Brand_Name,
    Category,
    Sub_Category,
    Product_Name,
    Weight_g,

    Price_Category,
    MRP,
    Selling_Price,
    Discount_Percent,

    Rating,
    Reviews,

    Health_Rating,
    Health_Score,
    Quality_Grade,
    Recommended_For,

    Protein_g,
    Sugar_g,
    Calories,
    Fat_g,
    Carbs_g,
    Sodium_mg,
    Fiber_g,

    Seller_Name,
    Marketplace,
    Marketplace_URL,
    Availability,

    State,
    City,
    Region,

    Manufacturing_State,
    Is_Premium_Brand,
    Certifications,
    Certification_Count,
    Shelf_Life_Months,

    Order_Date,
    Order_Month,
    Order_Quarter,
    Order_Year,
    Day_of_Week,
    Is_Weekend_Order,

    Profit_Margin_Percent,
    Revenue_INR,
    Units_Sold,
    Return_Rate_Percent,

    /* Price information */
    MRP - Selling_Price AS Discount_Amount,

    /* Revenue per unit */
    CASE
        WHEN Units_Sold > 0
        THEN ROUND(Revenue_INR / Units_Sold, 2)
        ELSE 0
    END AS Revenue_Per_Unit

FROM Beverages_Clean

WHERE LOWER(Category) IN ('tea', 'coffee');


/* ============================================================
   STEP 2: ADD CATEGORY ANALYSIS
   ============================================================ */

ALTER TABLE Tea_Coffee_Analysis
ADD COLUMN Lowest_Price DECIMAL(12,2),
ADD COLUMN Highest_Price DECIMAL(12,2),
ADD COLUMN Average_Price DECIMAL(12,2),
ADD COLUMN Lowest_Rating DECIMAL(5,2),
ADD COLUMN Highest_Rating DECIMAL(5,2),
ADD COLUMN Average_Rating DECIMAL(5,2),
ADD COLUMN Category_Total_Revenue DECIMAL(18,2),
ADD COLUMN Category_Total_Units BIGINT,
ADD COLUMN Category_Average_Discount DECIMAL(8,2),
ADD COLUMN Category_Average_Profit_Margin DECIMAL(8,2),
ADD COLUMN Category_Average_Return_Rate DECIMAL(8,2);


/* ============================================================
   STEP 3: UPDATE CATEGORY ANALYSIS
   ============================================================ */

UPDATE Tea_Coffee_Analysis t

JOIN
(
    SELECT
        LOWER(Category) AS Category,

        MIN(Selling_Price) AS Lowest_Price,
        MAX(Selling_Price) AS Highest_Price,
        ROUND(AVG(Selling_Price), 2) AS Average_Price,

        MIN(Rating) AS Lowest_Rating,
        MAX(Rating) AS Highest_Rating,
        ROUND(AVG(Rating), 2) AS Average_Rating,

        SUM(Revenue_INR) AS Category_Total_Revenue,
        SUM(Units_Sold) AS Category_Total_Units,

        ROUND(AVG(Discount_Percent), 2)
            AS Category_Average_Discount,

        ROUND(AVG(Profit_Margin_Percent), 2)
            AS Category_Average_Profit_Margin,

        ROUND(AVG(Return_Rate_Percent), 2)
            AS Category_Average_Return_Rate

    FROM Tea_Coffee_Analysis

    GROUP BY LOWER(Category)

) a

ON LOWER(t.Category) = a.Category

SET

    t.Lowest_Price =
        a.Lowest_Price,

    t.Highest_Price =
        a.Highest_Price,

    t.Average_Price =
        a.Average_Price,

    t.Lowest_Rating =
        a.Lowest_Rating,

    t.Highest_Rating =
        a.Highest_Rating,

    t.Average_Rating =
        a.Average_Rating,

    t.Category_Total_Revenue =
        a.Category_Total_Revenue,

    t.Category_Total_Units =
        a.Category_Total_Units,

    t.Category_Average_Discount =
        a.Category_Average_Discount,

    t.Category_Average_Profit_Margin =
        a.Category_Average_Profit_Margin,

    t.Category_Average_Return_Rate =
        a.Category_Average_Return_Rate;
/* ==================================================================
Error 1175 occurred because MySQL Safe Update Mode was enabled. Safe Update Mode prevents UPDATE or 
DELETE statements when the WHERE condition does not use a key column.
In my query, I was updating records based on Category, but Category was not a key column. 
Therefore, MySQL blocked the update.
To solve it, I temporarily disabled Safe Update Mode using SET SQL_SAFE_UPDATES = 0, 
executed the update, and then enabled it again using SET SQL_SAFE_UPDATES = 1.
*/
SET SQL_SAFE_UPDATES = 0;

UPDATE Tea_Coffee_Analysis AS t
JOIN (
    SELECT
        LOWER(Category) AS Category,
        MIN(Selling_Price) AS Lowest_Price,
        MAX(Selling_Price) AS Highest_Price,
        ROUND(AVG(Selling_Price), 2) AS Average_Price,
        MIN(Rating) AS Lowest_Rating,
        MAX(Rating) AS Highest_Rating,
        ROUND(AVG(Rating), 2) AS Average_Rating,
        SUM(Revenue_INR) AS Category_Total_Revenue,
        SUM(Units_Sold) AS Category_Total_Units,
        ROUND(AVG(Discount_Percent), 2) AS Category_Average_Discount,
        ROUND(AVG(Profit_Margin_Percent), 2) AS Category_Average_Profit_Margin,
        ROUND(AVG(Return_Rate_Percent), 2) AS Category_Average_Return_Rate
    FROM Tea_Coffee_Analysis
    GROUP BY LOWER(Category)
) AS a
    ON LOWER(t.Category) = a.Category
SET
    t.Lowest_Price = a.Lowest_Price,
    t.Highest_Price = a.Highest_Price,
    t.Average_Price = a.Average_Price,
    t.Lowest_Rating = a.Lowest_Rating,
    t.Highest_Rating = a.Highest_Rating,
    t.Average_Rating = a.Average_Rating,
    t.Category_Total_Revenue = a.Category_Total_Revenue,
    t.Category_Total_Units = a.Category_Total_Units,
    t.Category_Average_Discount = a.Category_Average_Discount,
    t.Category_Average_Profit_Margin = a.Category_Average_Profit_Margin,
    t.Category_Average_Return_Rate = a.Category_Average_Return_Rate;

SET SQL_SAFE_UPDATES = 1;
/*==================================================================
The error occurred because Safe Update Mode prevented an update without 
a key-column condition, so I temporarily disabled safe updates, performed the controlled update, 
and re-enabled it afterward
========================================================================*/

/* ============================================================
   STEP 4: CREATE INDEXES
   These make future analysis faster
   ============================================================ */

CREATE INDEX idx_category
ON Tea_Coffee_Analysis(Category(50));

CREATE INDEX idx_company
ON Tea_Coffee_Analysis(Company_Name(100));

CREATE INDEX idx_brand
ON Tea_Coffee_Analysis(Brand_Name(100));

CREATE INDEX idx_state
ON Tea_Coffee_Analysis(State(100));

CREATE INDEX idx_city
ON Tea_Coffee_Analysis(City(100));

CREATE INDEX idx_region
ON Tea_Coffee_Analysis(Region(100));

CREATE INDEX idx_manufacturing_state
ON Tea_Coffee_Analysis(Manufacturing_State(100));


/* ============================================================
   STEP 5: CHECK FINAL TABLE
   ============================================================ */

SELECT *
FROM Tea_Coffee_Analysis
ORDER BY Category, Selling_Price DESC
LIMIT 50000;

SELECT *
FROM Tea_Coffee_Analysis
WHERE LOWER(State) = 'telangana';

SELECT *
FROM Tea_Coffee_Analysis
WHERE LOWER(State) = 'telangana'
  AND LOWER(Manufacturing_State) = 'telangana';
  
