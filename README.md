# GYSV Tea & Coffee Business Intelligence — SQL Analysis

> **A MySQL-based data cleaning, transformation, and business analysis project developed for GYaaNa SAroVar (GYSV).**

---

## 📌 Project Overview

The **GYSV Tea & Coffee Business Intelligence — SQL Analysis** project focuses on analyzing beverage product data using **MySQL and MySQL Workbench**.

The project demonstrates a complete SQL analytics workflow starting from raw data exploration and validation through data cleaning, duplicate handling, Tea & Coffee analysis, category-level business metrics, indexing, and final validation.

The project is designed as a practical **Data Analytics / SQL Business Intelligence project** for GYaaNa SAroVar (GYSV).

---

## 🏢 Organization

**GYaaNa SAroVar (GYSV)**

**Project:** Tea & Coffee Business Intelligence — SQL Analysis

**Technology:** MySQL / SQL

**Development Tool:** MySQL Workbench

---

## 🎯 Project Objectives

* Explore a large beverage dataset using SQL.
* Validate the structure and consistency of source tables.
* Combine multiple source tables into a unified analytical view.
* Identify NULL values and duplicate Product IDs.
* Create a cleaned analytical dataset.
* Analyze Tea and Coffee products separately and together.
* Perform product, brand, pricing, rating, revenue, and sales analysis.
* Build category-level analytical metrics.
* Improve query performance using indexes.
* Create a reusable SQL-based analytical workflow.

---

## 🛠️ Technologies Used

| Technology          | Purpose                                        |
| ------------------- | ---------------------------------------------- |
| MySQL               | Database and SQL analysis                      |
| MySQL Workbench     | Query development and execution                |
| SQL                 | Data exploration and transformation            |
| CTE                 | Data preparation                               |
| Window Functions    | Duplicate handling and analytical calculations |
| Views               | Combining source datasets                      |
| Aggregate Functions | Business metrics                               |
| Indexes             | Query performance                              |

---

## 📊 Project Workflow

```text
Raw Beverage Data
        ↓
Source Table Exploration
        ↓
Schema Validation
        ↓
Data Integration
        ↓
Beverages_Data_View
        ↓
NULL Validation
        ↓
Duplicate Detection
        ↓
Beverages_Clean
        ↓
Tea & Coffee Filtering
        ↓
Tea_Coffee_Analysis
        ↓
Category-Level Analysis
        ↓
Indexes
        ↓
Final Validation
```

---

## 📁 Source Data

The source dataset is divided into multiple beverage tables:

```text
beverages_chunk_001
beverages_chunk_002
beverages_chunk_003
beverages_chunk_004
```

These tables are combined using `UNION ALL` to create:

```text
Beverages_Data_View
```

---

## 🔍 Data Exploration

The project begins by exploring:

* Available databases
* Available tables
* Table structures
* Column names
* Data types
* NULLability
* Keys and indexes
* Sample records

SQL commands such as `SHOW DATABASES`, `SHOW TABLES`, `DESCRIBE`, and `SELECT` are used during the exploration stage.

---

## 🔗 Data Integration

The four source tables are combined into one logical dataset:

```sql
CREATE OR REPLACE VIEW Beverages_Data_View AS
SELECT * FROM beverages_chunk_001
UNION ALL
SELECT * FROM beverages_chunk_002
UNION ALL
SELECT * FROM beverages_chunk_003
UNION ALL
SELECT * FROM beverages_chunk_004;
```

This creates a unified analytical view without physically duplicating the source data.

---

## 🧹 Data Cleaning

The project performs:

* NULL-value validation
* Duplicate Product ID detection
* Duplicate row analysis
* Record deduplication
* Category filtering
* Analytical table creation

Duplicate Product IDs are identified using:

```sql
GROUP BY Product_ID
HAVING COUNT(*) > 1
```

The cleaned table is:

```text
Beverages_Clean
```

`ROW_NUMBER()` with `PARTITION BY Product_ID` is used to retain one record for each Product ID.

---

## ☕ Tea & Coffee Analysis

The cleaned dataset is filtered to focus on:

```text
Tea
Coffee
```

The analysis includes:

* Tea products
* Coffee products
* Tea brands
* Coffee brands
* Highest-priced Tea
* Lowest-priced Tea
* Highest-priced Coffee
* Lowest-priced Coffee
* Average Tea price
* Average Coffee price
* Brand-wise average price
* Brand-wise minimum price
* Brand-wise maximum price

---

## 📈 Business Metrics

The project analyzes important business metrics including:

### Product Metrics

* Product count
* Selling price
* MRP
* Discount percentage
* Rating
* Reviews

### Sales Metrics

* Revenue
* Units Sold
* Revenue per Unit

### Business Metrics

* Profit Margin
* Return Rate
* Discount Amount

### Product & Market Dimensions

* Company
* Brand
* Category
* Sub-category
* Marketplace
* Seller
* State
* City
* Region
* Manufacturing State
* Availability

---

## 📊 Main Analytical Table

The primary analytical table created by the project is:

```text
Tea_Coffee_Analysis
```

It contains the Tea and Coffee records required for detailed business analysis.

Additional calculated metrics include:

```text
Discount_Amount
Revenue_Per_Unit
Lowest_Price
Highest_Price
Average_Price
Lowest_Rating
Highest_Rating
Average_Rating
Category_Total_Revenue
Category_Total_Units
Category_Average_Discount
Category_Average_Profit_Margin
Category_Average_Return_Rate
```

---

## 🚀 Performance Optimization

Indexes are created on important analytical columns, including:

```text
Category
Company_Name
Brand_Name
State
City
Region
Manufacturing_State
```

These indexes are intended to improve performance for repeated filtering and analytical queries.

---

## ⚠️ SQL Challenge

During the category-level update, MySQL returned:

```text
Error Code: 1175
```

The issue was caused by **MySQL Safe Update Mode**, which prevented an update that did not use a key column in the required condition.

The project resolves this by temporarily disabling safe updates for the controlled operation and enabling them again afterward.

```sql
SET SQL_SAFE_UPDATES = 0;

-- Controlled UPDATE

SET SQL_SAFE_UPDATES = 1;
```

---

## 📂 Repository Structure

```text
GYSV-Tea-Coffee-SQL-Analysis/
│
├── README.md
│
├── SQL/
│   ├── 01_database_exploration.sql
│   ├── 02_data_validation.sql
│   ├── 03_data_cleaning.sql
│   ├── 04_tea_coffee_analysis.sql
│   ├── 05_category_analysis.sql
│   └── 06_indexes_validation.sql
│
├── Data/
│   └── README.md
│
├── Screenshots/
│
└── Documentation/
    └── SQL_Project_Documentation.md
```

---

## 📚 Documentation

Detailed project documentation is available in the repository Wiki.

The Wiki covers:

* Project architecture
* Dataset structure
* SQL workflow
* Data cleaning methodology
* Duplicate handling
* Tea analysis
* Coffee analysis
* Business metrics
* Category analysis
* Indexing
* SQL concepts
* Error handling
* Interview questions
* Future enhancements

---

## 🔮 Future Scope

The SQL project can later be extended into a broader Microsoft Fabric analytics solution involving:

```text
MySQL / Source Data
        ↓
Microsoft Fabric
        ↓
Bronze Layer
        ↓
Silver Layer
        ↓
Gold Layer
        ↓
Machine Learning
        ↓
Warehouse
        ↓
Power BI
```

The Microsoft Fabric implementation will be maintained as a **separate project** from this SQL repository.

---

## 👨‍💻 Project Organization

**GYaaNa SAroVar (GYSV)**

This project is part of the GYSV data analytics and business intelligence project portfolio.

---

## 📌 Project Status

**Status:** SQL Analysis Completed

**Platform:** MySQL Workbench

**Focus:** Data Cleaning + SQL Analytics + Business Intelligence

---

## ⭐ Key SQL Skills Demonstrated

```text
SELECT
WHERE
GROUP BY
HAVING
ORDER BY
DISTINCT
UNION ALL
JOIN
CASE
CTE
ROW_NUMBER()
Window Functions
Aggregate Functions
Views
CREATE TABLE
ALTER TABLE
UPDATE
CREATE INDEX
Data Validation
Data Cleaning
Business Analysis
```
