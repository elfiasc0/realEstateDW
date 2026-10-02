CREATE DATABASE PropertymasterDW
GO

USE PropertymasterDW
GO

CREATE TABLE Person (
    ID_person INT IDENTITY(1,1) PRIMARY KEY,
    PESEL CHAR(11),
    NameAndSurname VARCHAR(40) NOT NULL,
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female', 'Other')) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    LoyaltyCategory VARCHAR(18) CHECK (LoyaltyCategory IN ('new', 'potential loyal', 'loyal')) NOT NULL,
	ISCURRENT BIT
)
GO

CREATE TABLE Apartment (
    ID_apartment INT IDENTITY(1,1) PRIMARY KEY,
    Address VARCHAR(70) UNIQUE NOT NULL,
    District VARCHAR(30) NOT NULL,
    City VARCHAR(30) NOT NULL,
    PostalCode VARCHAR(6) NOT NULL,
    SizeCategory VARCHAR(10) NOT NULL,
    FloorNumber VARCHAR(13) NOT NULL,
    NumberOfRooms VARCHAR(2) NOT NULL,
    DecadeOfConstruction VARCHAR(5) NOT NULL
)
GO

CREATE TABLE Branch (
    ID_branch INT IDENTITY(1,1) PRIMARY KEY,
    City VARCHAR(30) NOT NULL,
    Address VARCHAR(70) NOT NULL,
    PostalCode VARCHAR(6) NOT NULL,
    NumberOfAgents VARCHAR(8) NOT NULL,
    NumberOfApartments VARCHAR(8) NOT NULL,
	ISCURRENT BIT
)
GO

CREATE TABLE Real_Estate_Agent (
    ID_real_estate_agent INT IDENTITY(1,1) PRIMARY KEY,
    PESEL CHAR(11) NOT NULL,
    NameAndSurname VARCHAR(40) NOT NULL,
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female', 'Other')) NOT NULL,
    SeniorityCategory VARCHAR(18) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    ID_branch INT NOT NULL,
    FOREIGN KEY (ID_branch) REFERENCES Branch(ID_branch),
	ISCURRENT BIT
)
GO

CREATE TABLE Date_Dim (
    ID_date INT IDENTITY(1,1) PRIMARY KEY,
    DateValue DATE NOT NULL,
    Year INT NOT NULL,
    MonthNo INT NOT NULL
)
GO

CREATE TABLE Junk_Sale (
    ID_junk_sale INT IDENTITY(1,1) PRIMARY KEY,
    Status VARCHAR(11) NOT NULL,
    Condition VARCHAR(10) NOT NULL,
    Agreement VARCHAR(7) NOT NULL
)
GO

CREATE TABLE Junk_Interest (
    ID_junk_interest INT IDENTITY(1,1) PRIMARY KEY,
    Status VARCHAR(17) NOT NULL
)
GO

CREATE TABLE Apartment_Sale (
    ID_owner INT NOT NULL,
    ID_buyer INT,
    ID_apartment INT NOT NULL,
    ID_real_estate_agent INT NOT NULL,
    ID_start_date INT NOT NULL,
    ID_for_sale_start_date INT,
    ID_end_date INT,
    ID_junk_sale INT,
    FinalPrice FLOAT,
    ListingPrice FLOAT,
    CommissionRate FLOAT,
    Profit FLOAT,
    DaysOnMarket INT,
    FOREIGN KEY (ID_owner) REFERENCES Person(ID_person),
    FOREIGN KEY (ID_buyer) REFERENCES Person(ID_person),
    FOREIGN KEY (ID_apartment) REFERENCES Apartment(ID_apartment),
    FOREIGN KEY (ID_real_estate_agent) REFERENCES Real_Estate_Agent(ID_real_estate_agent),
    FOREIGN KEY (ID_start_date) REFERENCES Date_Dim(ID_date),
    FOREIGN KEY (ID_for_sale_start_date) REFERENCES Date_Dim(ID_date),
    FOREIGN KEY (ID_end_date) REFERENCES Date_Dim(ID_date),
    FOREIGN KEY (ID_junk_sale) REFERENCES Junk_Sale(ID_junk_sale),

	CONSTRAINT composite_pk_sale PRIMARY KEY (
    ID_owner,
    ID_apartment,
    ID_real_estate_agent,
    ID_start_date,
    ID_junk_sale
	)
)
GO


CREATE TABLE Interest (
    ID_apartment INT NOT NULL,
    ID_potential_buyer INT NOT NULL,
    ID_owner INT NOT NULL,
    ID_buyer INT,
    ID_real_estate_agent INT NOT NULL,
    ID_start_date INT NOT NULL,
    ID_for_sale_start_date INT,
    ID_end_date INT,
    ID_junk_sale INT NOT NULL,
    ID_junk_interest INT NOT NULL,
    
    FOREIGN KEY (
        ID_owner,
        ID_apartment,
        ID_real_estate_agent,
        ID_start_date,
        ID_junk_sale
    ) REFERENCES Apartment_Sale (
        ID_owner,
        ID_apartment,
        ID_real_estate_agent,
        ID_start_date,
        ID_junk_sale
    ),
    
    FOREIGN KEY (ID_junk_interest) REFERENCES Junk_Interest(ID_junk_interest),
	FOREIGN KEY (ID_potential_buyer) REFERENCES Person(ID_person),

    CONSTRAINT composite_pk_interest PRIMARY KEY (
        ID_apartment,
        ID_potential_buyer
    )
)
GO
