-- Insert data into Person
INSERT INTO Person (PESEL, NameAndSurname, Gender, PhoneNumber, LoyaltyCategory, ISCURRENT)
VALUES
('90010112345', 'Alice Kowalska', 'Female', '123456789', 'loyal', 1),
('85050554321', 'Bob Nowak', 'Male', '987654321', 'new', 1),
('92030399999', 'Charlie Wisniewski', 'Other', '555444333', 'potential loyal', 1)
GO

-- Insert data into Apartment
INSERT INTO Apartment (Address, District, City, PostalCode, SizeCategory, FloorNumber, NumberOfRooms, DecadeOfConstruction)
VALUES
('Main St 1', 'Central', 'Warsaw', '00-001', 'medium', '2', '3', '1990s'),
('Green Ave 5', 'North', 'Krakow', '30-001', 'large', '5', '4', '2000s')
GO

-- Insert data into Branch
INSERT INTO Branch (City, Address, PostalCode, NumberOfAgents, NumberOfApartments, ISCURRENT)
VALUES
('Warsaw', 'Agency St 10', '00-002', '10', '100', 1),
('Krakow', 'Market Sq 12', '30-002', '7', '80', 1)
GO

-- Insert data into Real_Estate_Agent
INSERT INTO Real_Estate_Agent (PESEL, NameAndSurname, Gender, SeniorityCategory, Email, PhoneNumber, ID_branch, ISCURRENT)
VALUES
('78010111111', 'Diana Broker', 'Female', 'senior', 'diana@agency.com', '1122334455', 1, 1),
('80020222222', 'Edward Agent', 'Male', 'junior', 'edward@agency.com', '9988776655', 2, 1)
GO

-- Insert data into Date_Dim
INSERT INTO Date_Dim (DateValue, Year, MonthNo)
VALUES
('2023-01-01', 2023, 1),
('2023-06-15', 2023, 6),
('2023-12-31', 2023, 12)
GO

-- Insert data into Junk_Sale
INSERT INTO Junk_Sale (Status, Condition, Agreement)
VALUES
('completed', 'new', 'yes'),
('pending', 'used', 'no')
GO

-- Insert data into Junk_Interest
INSERT INTO Junk_Interest (Status)
VALUES
('highly interested'),
('not interested')
GO

-- Insert data into Apartment_Sale
INSERT INTO Apartment_Sale (
    ID_owner, ID_buyer, ID_apartment, ID_real_estate_agent,
    ID_start_date, ID_for_sale_start_date, ID_end_date,
    ID_junk_sale, FinalPrice, ListingPrice, CommissionRate,
    Profit, DaysOnMarket
)
VALUES
(1, 2, 1, 1, 1, 2, 3, 1, 500000, 520000, 0.03, 15000, 30),
(2, 3, 2, 2, 2, 3, NULL, 2, 750000, 780000, 0.02, 10000, 45)
GO

-- Insert data into Interest
INSERT INTO Interest (
    ID_apartment, ID_potential_buyer, ID_owner, ID_buyer,
    ID_real_estate_agent, ID_start_date, ID_for_sale_start_date,
    ID_end_date, ID_junk_sale, ID_junk_interest
)
VALUES
(1, 3, 1, 2, 1, 1, 2, 3, 1, 1),
(2, 1, 2, 3, 2, 2, 3, NULL, 2, 2)
GO