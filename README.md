# Home Expert – Real Estate Data Warehouse

A **fictional academic data warehouse project** based on a simulated real estate agency, **Home Expert**.

The project demonstrates the design and implementation of a data warehouse for analyzing the **property listing management** process, including apartment sales, potential buyer interest, pricing, profitability, and time on market.

> **Note:** Home Expert and the business data used in this project are fictional and were created for educational purposes.

## Technologies

* **Microsoft SQL Server** – data warehouse database
* **SQL Server Integration Services (SSIS)** – ETL and data integration
* **Python** – data preparation and processing
* **Power BI** – data visualization and analysis
* **Excel / CSV** – source data
* **PropertyMaster** – fictional operational data source used in the project

## Project Overview

The project follows a simulated real estate business scenario in which the agency wants to analyze its apartment listings and sales performance.

The warehouse is designed to support analytical questions such as:

* Which areas attract the most potential buyers?
* Which apartment sizes receive the most interest?
* In which districts do apartments sell the fastest?
* How do listing prices vary between cities?
* Which districts attract the most potential buyers?
* How does the number of new listings change over time?
* Which real estate agents handle the most successful listings?
* How does profit vary between locations?

## Data Warehouse Model

The warehouse uses a **dimensional model** with two main fact tables.

### `Apartment_sale`

Records apartment sale facts.

Key measures include:

* Number of sales
* Listing price
* Final price
* Profit
* Commission rate
* Days on the market
* Price fluctuation
* Number of apartments
* Average sale speed per apartment

### `Interest`

Records potential buyers' interest in apartments.

Key measures include:

* Number of interest records
* Number of potential buyers
* Number of apartments
* Average number of potential buyers per apartment

## Dimensions

The model contains the following dimensions:

* **Apartment**
* **Person**
* **Real Estate Agent**
* **Branch**
* **Date**
* **Junk Sale**
* **Junk Interest**

The model also supports analytical hierarchies such as:

```text
Apartment Location
City → District → Address

Time
Year → Month
```

## ETL

The ETL process is implemented using **SQL Server Integration Services (SSIS)**.

The project uses simulated source data representing:

* Apartments
* Owners
* Buyers
* Potential buyers
* Real estate agents
* Selling processes
* Branches

Python is also used for data preparation and processing.

The general workflow is:

```text
Source Data
    ↓
Python / Data Preparation
    ↓
SSIS ETL
    ↓
SQL Server Data Warehouse
    ↓
Power BI
    ↓
Business Analysis
```

## Power BI

The resulting warehouse data can be analyzed in **Power BI** to explore:

* Sales performance
* Days on market
* Sale speed
* Listing and final prices
* Profit
* Buyer interest
* Apartment characteristics
* Geographic differences
* Agent and branch performance
* Time-based trends

## Example Analytical Questions

The model was designed to support questions such as:

1. What characteristics are shared by the fastest-selling apartments?
2. How does average sale speed differ between districts?
3. Is sale speed related to price fluctuation?
4. How does the number of potential buyers relate to sale speed?
5. Which apartment size categories attract the most potential buyers?
6. Which districts attract the most buyers?
7. How does buyer interest change from month to month?
8. How does branch size relate to apartment sales performance?

## Key Data Warehouse Concepts

This project demonstrates:

* Dimensional modeling
* Fact and dimension tables
* Fact table granularity
* Surrogate keys
* Slowly Changing Dimensions
* Junk dimensions
* Dimension hierarchies
* ETL development with SSIS
* SQL Server data warehouse implementation
* Python data processing
* Power BI analytics

## Project Structure

```text
.
├── README.md
├── SQL/
├── SSIS/
├── Python/
├── PowerBI/
├── Data/
└── Documentation/
```

## Academic Project

This project was developed as an **educational exercise in data warehouse design and implementation**. The company, source systems, and business data represent a simulated scenario rather than a real commercial organization.
