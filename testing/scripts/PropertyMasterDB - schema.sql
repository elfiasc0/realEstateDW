CREATE DATABASE Propertymaster
GO

USE Propertymaster
GO

CREATE TABLE Apartment (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Address VARCHAR(70) UNIQUE NOT NULL,
    District VARCHAR(30) NOT NULL,
    City VARCHAR(30) NOT NULL,
    Postal_Code VARCHAR(6) NOT NULL,
    Size FLOAT NOT NULL,
    Floor_Number INT NOT NULL,
    Number_Of_Rooms INT NOT NULL,
    Year_Of_Construction DATE NOT NULL
)
GO

CREATE TABLE Owner (
    PESEL CHAR(11) PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female', 'Other')) NOT NULL,
    Phone_Number VARCHAR(15) NOT NULL,
    First_Contact_Date DATE NOT NULL
)
GO

CREATE TABLE Buyer (
    PESEL CHAR(11) PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female', 'Other')) NOT NULL,
	Phone_Number VARCHAR(15) NOT NULL,
    First_Contact_Date DATE NOT NULL
);

CREATE TABLE Real_Estate_Agent (
    PESEL CHAR(11) PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female', 'Other')) NOT NULL,
    Date_Of_Joining DATE NOT NULL,
    City_Of_Agency VARCHAR(30) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Phone_Number VARCHAR(15) NOT NULL
)
GO

CREATE TABLE Selling_Process (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Start_Date DATE NOT NULL,
    For_Sale_Start_Date DATE,
    End_Date DATE,
    Listing_Price FLOAT,
    Final_Price FLOAT,
    Commission_Rate FLOAT,
    Condition_Of_Apartment VARCHAR(10) CHECK (Condition_Of_Apartment IN ('very poor', 'poor', 'acceptable', 'good', 'very good')),
    Status VARCHAR(11) CHECK (Status IN ('Pre-Sale', 'For sale', 'Under offer', 'Sold', 'Cancelled')) NOT NULL,
    Agreement VARCHAR(7) CHECK (Agreement IN ('Deal', 'No Deal')),
    Apartment_Address VARCHAR(70) NOT NULL,
    Owner_PESEL CHAR(11) NOT NULL,
    Buyer_PESEL CHAR(11),
    Real_Estate_Agent_PESEL CHAR(11) NOT NULL,
    FOREIGN KEY (Apartment_Address) REFERENCES Apartment(Address),
    FOREIGN KEY (Owner_PESEL) REFERENCES Owner(PESEL),
    FOREIGN KEY (Buyer_PESEL) REFERENCES Buyer(PESEL),
    FOREIGN KEY (Real_Estate_Agent_PESEL) REFERENCES Real_Estate_Agent(PESEL)
)
GO