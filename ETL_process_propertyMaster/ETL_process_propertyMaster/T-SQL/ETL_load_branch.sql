USE PropertymasterDW
go

CREATE TABLE PropertyMasterDW.dbo.Branch_Temp (
	[BranchID] int,
    [City] nvarchar(30),
    [Address] nvarchar(70),
    [Postal_Code] varchar(6),
    [Num_Agents] int,
    [Num_Apartments] int
);

BULK INSERT PropertyMasterDW.dbo.Branch_Temp
--FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1.agency_data.xlsx - Branch Offices.csv' --snapshot 1
FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\2.agency_data.xlsx - Branch Offices.csv' -- snapshot2
WITH
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)

-- Drop view if it exists
IF OBJECT_ID('vETLBranchData') IS NOT NULL DROP VIEW vETLBranchData;
GO

CREATE VIEW vETLBranchData AS
SELECT DISTINCT
    [City],
    [Address],
    TRIM([Postal_Code]) AS Postal_Code,  -- Remove any leading/trailing spaces
    CASE
        WHEN [Num_Agents] < 15 THEN 'few'
        WHEN [Num_Agents] BETWEEN 15 AND 25 THEN 'moderate'
        ELSE 'many'
    END AS NumberOfAgents,
    CASE
        WHEN [Num_Apartments] < 15 THEN 'few'
        WHEN [Num_Apartments] BETWEEN 15 AND 30 THEN 'moderate'
        ELSE 'many'
    END AS NumberOfApartments
FROM PropertyMasterDW.dbo.Branch_Temp;
GO

MERGE INTO Branch AS TT
USING vETLBranchData AS ST
    ON TT.City = ST.City
WHEN NOT MATCHED THEN
    INSERT (City, Address, PostalCode, NumberOfAgents, NumberOfApartments, IsCurrent)
    VALUES (ST.City, ST.Address, ST.Postal_Code, ST.NumberOfAgents, ST.NumberOfApartments, 1)
WHEN MATCHED 
	AND (TT.NumberOfAgents <> ST.NumberOfAgents
       OR TT.NumberOfApartments <> ST.NumberOfApartments)
	   OR TT.Address <> ST.Address
THEN
	UPDATE
	SET TT.IsCurrent = 0;
GO

INSERT INTO Branch(
	City,
	Address,
	PostalCode,
	NumberOfAgents,
	NumberOfApartments,
	IsCurrent
	)
	SELECT 
		City,
		Address,
		Postal_Code,
		NumberOfAgents,
		NumberOfApartments,
		1
	FROM vETLBranchData
	EXCEPT
	SELECT 
		City,
		Address,
		PostalCode,
		NumberOfAgents,
		NumberOfApartments,
		1
	FROM Branch;

DROP VIEW vETLBranchData;
GO

DROP TABLE Branch_Temp;

