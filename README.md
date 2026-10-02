# Home Expert – Real Estate Data Warehouse

A data warehouse project for **Home Expert**, a real estate agency operating across Poland. The project focuses on the **property listing management** process and provides analytical support for apartment sales, buyer interest, pricing, profitability, and time on market.

## Technologies

* **Microsoft SQL Server** – data warehouse database
* **SQL Server Integration Services (SSIS)** – ETL and data integration
* **Python** – data preparation and processing
* **Power BI** – data visualization and business intelligence
* **Excel / CSV** – potential buyer source data
* **PropertyMaster** – primary operational data source

## Project Overview

The purpose of the warehouse is to integrate operational data and provide a multidimensional model for analyzing the performance of Home Expert's property listings.

The warehouse supports questions such as:

* Which areas attract the most buyers?
* Which apartment sizes receive the most interest?
* In which districts do apartments sell the fastest?
* How do apartment prices compare across cities?
* Which districts receive the most buyer interest?
* How does the number of new listings change over time?
* Which real estate agents have the most successful listings?
* How does listing-related profit vary across cities?

## Data Warehouse Architecture

The solution follows a dimensional data warehouse approach.

### Fact Tables

#### `Apartment_sale`

Stores apartment sale transactions.

**Measures include:**

* Number of sales
* Listing price
* Final price
* Profit
* Commission rate
* Days on the market
* Price fluctuation
* Number of apartments
* Average sale speed per apartment

#### `Interest`

Stores potential buyers' interest in apartments.

**Measures include:**

* Number of interest records
* Number of potential buyers
* Number of apartments
* Average number of potential buyers per apartment

### Dimension Tables

The warehouse contains the following main dimensions:

| Dimension             | Description                                     |
| --------------------- | ----------------------------------------------- |
| **Apartment**         | Apartment location and characteristics          |
| **Person**            | Owners, buyers, and potential buyers            |
| **Real Estate Agent** | Agent information and seniority                 |
| **Branch**            | Branch location and branch-level information    |
| **Date**              | Date, year, and month                           |
| **Junk Sale**         | Sale status, apartment condition, and agreement |
| **Junk Interest**     | Potential buyer status                          |

The Apartment dimension supports a geographical hierarchy of **City → District → Address**, while the Date dimension supports **Year → Month** analysis.

## ETL Process

**SSIS** is used to extract, transform, and load data into the SQL Server data warehouse.

The main source systems are:

* **PropertyMaster** – apartment, owner, buyer, selling process, and real estate agent data
* **Excel/CSV** – potential buyer information
* **Generated calendar data** – Date dimension

Python is used as part of the data preparation workflow.

The ETL process includes activities such as:

1. Extracting data from source systems
2. Cleaning and transforming source data
3. Creating surrogate keys
4. Calculating derived attributes and measures
5. Loading dimension tables
6. Loading fact tables
7. Preparing data for analytical reporting

## Data Warehouse Design

The model uses **surrogate keys** for dimensions and foreign keys in the fact tables.

It also applies **Slowly Changing Dimension (SCD)** concepts to maintain appropriate dimension information. For example, the Person dimension contains an `IsCurrent` attribute for identifying the current version of a record.

The `Junk_sale` dimension combines several low-cardinality attributes:

* Status
* Apartment condition
* Agreement

The `Junk_interest` dimension stores potential buyer status values such as viewing, negotiating price, contract signing, payment, and withdrawn.

## Power BI Analytics

The warehouse data is used in **Power BI** to support analysis of:

* Apartment sales performance
* Average sale speed
* Days on market
* Listing and final prices
* Agency profit
* Buyer interest
* Apartment characteristics
* Geographic differences
* Branch performance
* Real estate agent performance
* Monthly and yearly trends

The multidimensional model was designed to support analytical questions involving apartment characteristics, location, buyer interest, sale speed, branches, and time.

## Example Analytical Questions

The warehouse can be used to answer questions such as:

> What characteristics are shared by the fastest-selling apartments?

> How does average sale speed differ between districts and cities?

> Is apartment sale speed related to price fluctuation?

> How does the number of interested buyers relate to sale speed?

> Which apartment size categories attract the most potential buyers?

> Which districts attract the most buyers?

> How does buyer interest change over time?

## Project Structure

```text
.
├── README.md
├── SQL/
│   ├── database/
│   ├── tables/
│   ├── views/
│   └── queries/
├── SSIS/
│   └── ...
├── Python/
│   └── ...
├── PowerBI/
│   └── ...
├── Data/
│   └── ...
└── Documentation/
    └── ...
```

> The folder structure should be adjusted to match the actual repository.

## Key Concepts Demonstrated

* Data warehouse architecture
* Dimensional modeling
* Fact and dimension tables
* Fact table granularity
* Surrogate keys
* Slowly Changing Dimensions
* Junk dimensions
* Dimension hierarchies
* ETL with SSIS
* SQL Server database design
* Python data processing
* Power BI reporting and visualization
* Business-oriented analytical queries
