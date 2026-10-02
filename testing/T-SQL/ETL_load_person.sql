USE PropertyMasterDW;
GO

-- Drop the view if it exists
IF (OBJECT_ID('vETLPersonBuyerOwnerData') IS NOT NULL) DROP VIEW vETLPersonBuyerOwnerData;
GO

-- Create a view for transforming person data from the source table
CREATE VIEW vETLPersonBuyerOwnerData AS
SELECT DISTINCT
    [PESEL],
    [NameAndSurname] = CAST([Name] + ' ' + [Surname] AS nvarchar(40)), -- Fix: Ensure correct concatenation and cast
    [Gender],
    [Phone_Number],
    [LoyaltyCategory] = CASE
        WHEN DATEDIFF(MONTH, [First_Contact_Date], GETDATE()) BETWEEN 0 AND 6 THEN 'new'
        WHEN DATEDIFF(MONTH, [First_Contact_Date], GETDATE()) BETWEEN 7 AND 18 THEN 'potential loyal'
        ELSE 'loyal'
    END
FROM PropertyMaster.dbo.Buyer

UNION

SELECT DISTINCT
    [PESEL],
    CAST([Name] + ' ' + [Surname] AS nvarchar(40)) AS NameAndSurname,  -- Fix: Ensure correct concatenation and cast
    [Gender],
    [Phone_Number],
    CASE
        WHEN DATEDIFF(MONTH, [First_Contact_Date], GETDATE()) BETWEEN 0 AND 6 THEN 'new'
        WHEN DATEDIFF(MONTH, [First_Contact_Date], GETDATE()) BETWEEN 7 AND 18 THEN 'potential loyal'
        ELSE 'loyal'
    END AS LoyaltyCategory
FROM PropertyMaster.dbo.Owner;
GO

-- Merge data from the transformed view into the DimPerson dimension table
MERGE INTO Person AS TT
    USING vETLPersonBuyerOwnerData AS ST
        ON TT.PESEL = ST.PESEL
    WHEN NOT MATCHED THEN
        INSERT (PESEL, NameAndSurname, Gender, PhoneNumber, LoyaltyCategory, IsCurrent)
        VALUES (ST.PESEL, ST.NameAndSurname, ST.Gender, ST.Phone_Number, ST.LoyaltyCategory, 1)
	WHEN MATCHED
	AND (TT.PhoneNumber <> ST.Phone_Number
	OR TT.LoyaltyCategory <> ST.LoyaltyCategory)
	THEN
	UPDATE
	SET TT.ISCurrent = 0;
GO

INSERT INTO Person(
	PESEL, 
	NameAndSurname, 
	Gender, 
	PhoneNumber, 
	LoyaltyCategory,
	IsCurrent
	)
	SELECT 
		PESEL,
		NameAndSurname, 
		Gender,
		Phone_Number, 
		LoyaltyCategory, 
		1
	FROM vETLPersonBuyerOwnerData
	EXCEPT
	SELECT 
		PESEL, 
		NameAndSurname, 
		Gender, 
		PhoneNumber, 
		LoyaltyCategory,
		1
	FROM Person;

-- Drop the view after the operation
DROP VIEW vETLPersonBuyerOwnerData;
GO

CREATE TABLE PropertyMasterDW.dbo.PotentialBuyer_Temp (
    [Name] nvarchar(40),
    [Surname] nvarchar(40),
    [Phone_Number] varchar(15),
	[City] varchar(30),
	[Interest_apartment] varchar(70),
	[Owner_pesel] varchar(11),
	[StartDateoftheSellingProcess] date,
	[Status] varchar(17),
    [First_Contact_Date] date
);

BULK INSERT PropertyMasterDW.dbo.PotentialBuyer_Temp
    --FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1.agency_data.xlsx - Interested Buyers.csv' -- snapshot1
	FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\2.agency_data.xlsx - Interested Buyers.csv' -- snapshot2
    WITH
    (
	FIRSTROW=2,
    FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
    TABLOCK
    )

-- Drop view if it exists
IF OBJECT_ID('vETLPersonPotentialBuyerData') IS NOT NULL DROP VIEW vETLPersonPotentialBuyerData;
GO

-- Create view for Potential Buyers
CREATE VIEW vETLPersonPotentialBuyerData AS
SELECT DISTINCT
    NULL AS PESEL,
    CAST([Name] + ' ' + [Surname] AS nvarchar(40)) AS NameAndSurname,
    [Phone_Number],
    CASE
        WHEN DATEDIFF(MONTH, [First_Contact_Date], GETDATE()) BETWEEN 0 AND 6 THEN 'new'
        WHEN DATEDIFF(MONTH, [First_Contact_Date], GETDATE()) BETWEEN 7 AND 18 THEN 'potential loyal'
        ELSE 'loyal'
    END AS LoyaltyCategory
FROM PropertyMasterDW.dbo.PotentialBuyer_Temp;
GO

MERGE INTO Person AS TT
    USING vETLPersonPotentialBuyerData AS ST
        ON TT.NameAndSurname = ST.NameAndSurname
    WHEN NOT MATCHED THEN
        INSERT (PESEL, NameAndSurname, Gender, PhoneNumber, LoyaltyCategory, IsCurrent)
        VALUES (ST.PESEL, ST.NameAndSurname, NULL, ST.Phone_Number, ST.LoyaltyCategory, 1)
	WHEN MATCHED
	AND (TT.PhoneNumber <> ST.Phone_Number
	OR TT.LoyaltyCategory <> ST.LoyaltyCategory)
	THEN
	UPDATE
	SET TT.ISCurrent = 0;
GO

INSERT INTO Person(
	PESEL, 
	NameAndSurname, 
	Gender, 
	PhoneNumber, 
	LoyaltyCategory,
	IsCurrent
	)
	SELECT 
		PESEL,
		NameAndSurname, 
		NULL,
		Phone_Number, 
		LoyaltyCategory, 
		1
	FROM vETLPersonPotentialBuyerData
	EXCEPT
	SELECT 
		PESEL, 
		NameAndSurname, 
		Gender, 
		PhoneNumber, 
		LoyaltyCategory,
		1
	FROM Person;

-- Drop the view after merge
DROP VIEW vETLPersonPotentialBuyerData;
GO

DROP TABLE PotentialBuyer_Temp;
