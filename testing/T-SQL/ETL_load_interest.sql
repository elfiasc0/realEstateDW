USE PropertyMasterDW;
GO

CREATE TABLE PropertyMasterDW.dbo.InterestPbuyer_Temp (
    [Name] varchar(40),
    [Surname] varchar(40),
    [Phone_Number] varchar(15),
	[City] varchar(30),
	[Interest_apartment] varchar(70),
	[Owner_pesel] varchar(11),
	[StartDateoftheSellingProcess] date,
	[Status] varchar(17) CHECK (Status IN ('viewing', 'negotiating price', 'contract signing', 'payment', 'withdrawn')) NOT NULL,
    [First_Contact_Date] date
);

BULK INSERT PropertyMasterDW.dbo.InterestPbuyer_Temp
    --FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1.agency_data.xlsx - Interested Buyers.csv' --snapshot1
	FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\2.agency_data.xlsx - Interested Buyers.csv' --snapshot2
    WITH
    (
	FIRSTROW=2,
    FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '\n',
    TABLOCK
    )

-- Drop the staging view if it exists
IF OBJECT_ID('vETLFInterest') IS NOT NULL DROP VIEW vETLFInterest;
GO

-- Create staging view for transformed keys
CREATE VIEW vETLFInterest AS
SELECT
    Aps.ID_apartment AS ApartmentKey,
    PBuy.ID_person AS PotentialBuyerKey,
    Aps.ID_owner AS OwnerKey,
    Aps.ID_buyer AS BuyerKey,
    Aps.ID_real_estate_agent AS RealEstateAgentKey,
    Aps.ID_start_date AS StartDateKey,
    Aps.ID_for_sale_start_date AS ForSaleStartDateKey,
    Aps.ID_end_date AS EndDateKey,
    APS.ID_junk_sale AS JunkSaleKey,
	JI.ID_junk_interest AS JunkInterestKey
FROM PropertyMasterDW.dbo.InterestPbuyer_Temp AS ST
LEFT JOIN dbo.Apartment AS A ON A.Address = ST.Interest_apartment
JOIN dbo.Apartment_Sale AS Aps ON Aps.ID_apartment = A.ID_apartment
JOIN dbo.Person AS PBuy ON PBuy.NameAndSurname = CAST(ST.Name + ' ' + ST.Surname AS nvarchar(40)) AND PBuy.PhoneNumber = ST.Phone_Number AND PBuy.ISCURRENT = 1
LEFT JOIN dbo.Person AS POwn ON POwn.ID_person = Aps.ID_owner AND POwn.ISCURRENT = 1
JOIN dbo.Person AS PBuyr ON PBuyr.ID_person = Aps.ID_buyer AND PBuyr.ISCURRENT = 1
JOIN dbo.Real_Estate_Agent AS REA ON REA.ID_real_estate_agent = Aps.ID_real_estate_agent AND REA.ISCURRENT = 1
LEFT JOIN dbo.Date_Dim AS DStart ON DStart.ID_date = Aps.ID_start_date AND DStart.DateValue = ST.StartDateoftheSellingProcess
JOIN dbo.Date_Dim AS DForSale ON DForSale.ID_date = Aps.ID_for_sale_start_date
JOIN dbo.Date_Dim AS DEnd ON DEnd.ID_date = Aps.ID_end_date
JOIN dbo.Junk_sale AS JS ON JS.ID_junk_sale = Aps.ID_junk_sale
JOIN dbo.Junk_Interest AS JI ON JI.Status = ST.Status
GO

SELECT * FROM vETLFInterest;
select * from dbo.Interest

-- Merge into fact table
MERGE INTO dbo.Interest AS TT
USING vETLFInterest AS ST
    ON TT.ID_apartment = ST.ApartmentKey
    AND TT.ID_potential_buyer = ST.PotentialBuyerKey
    AND TT.ID_owner = ST.OwnerKey
    AND TT.ID_start_date = ST.StartDateKey
    AND TT.ID_junk_interest = ST.JunkInterestKey
WHEN NOT MATCHED THEN
    INSERT (
        ID_apartment,
        ID_potential_buyer,
        ID_owner,
        ID_buyer,
        ID_real_estate_agent,
        ID_start_date,
        ID_for_sale_start_date,
        ID_end_date,
        ID_junk_sale,
        ID_junk_interest
    )
    VALUES (
        ST.ApartmentKey,
        ST.PotentialBuyerKey,
        ST.OwnerKey,  -- Include OwnerKey here
        ST.BuyerKey,
        ST.RealEstateAgentKey,
        ST.StartDateKey,
        ST.ForSaleStartDateKey,
        ST.EndDateKey,
        ST.JunkSaleKey,
        ST.JunkInterestKey
    );
GO

-- Drop the staging view after merge
DROP VIEW vETLFInterest;
GO

DROP TABLE InterestPbuyer_Temp;