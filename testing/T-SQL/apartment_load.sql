USE PropertymasterDW
go

If (object_id('vETLApartmentData') is not null) Drop View vETLApartmentData;
go
CREATE VIEW vETLApartmentData
AS
SELECT DISTINCT
	A.ID as [ID_apartment],
	[Address],
	[District],
	[City],
	[Postal_Code] as [PostalCode],
	CASE
		WHEN [Size] BETWEEN 10 AND 30 THEN 'studio'
		WHEN [Size] BETWEEN 31 AND 50 THEN 'small'
		WHEN [Size] BETWEEN 51 AND 80 THEN 'medium'
		WHEN [Size] BETWEEN 81 AND 120 THEN 'large'
		ELSE 'very large'
	END AS [SizeCategory],
	CASE
		WHEN [Floor_Number] BETWEEN 0 AND 1 THEN 'low floor'
		WHEN [Floor_Number] BETWEEN 2 AND 4 THEN 'medium floor'
		ELSE 'higher floors'
	END AS [FloorNumber],
	CAST([Number_Of_Rooms] AS varchar) as [NumberOfRooms],
	CASE
		WHEN [Year_Of_Construction] BETWEEN '1950-01-01' AND '1959-12-31' THEN '50s'
		WHEN [Year_Of_Construction] BETWEEN '1960-01-01' AND '1969-12-31' THEN '60s'
		WHEN [Year_Of_Construction] BETWEEN '1970-01-01' AND '1979-12-31' THEN '70s'
		WHEN [Year_Of_Construction] BETWEEN '1980-01-01' AND '1989-12-31' THEN '80s'
		WHEN [Year_Of_Construction] BETWEEN '1990-01-01' AND '1999-12-31' THEN '90s'
		WHEN [Year_Of_Construction] BETWEEN '2000-01-01' AND '2009-12-31' THEN '00s'
		WHEN [Year_Of_Construction] BETWEEN '2010-01-01' AND '2019-12-31' THEN '2010s'
		ELSE '2020s'
	END AS [DecadeOfConstruction]
FROM [Propertymaster].dbo.[Apartment] A;
;
go

MERGE INTO Apartment as Adw
	USING vETLApartmentData as Ad
		ON Adw.Address = Ad.Address
			WHEN Not Matched
				THEN
					INSERT
					Values (
					Ad.Address,
					Ad.District,
					Ad.City,
					Ad.PostalCode,
					Ad.SizeCategory,
					Ad.FloorNumber,
					Ad.NumberOfRooms,
					Ad.DecadeOfConstruction
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;

Drop View vETLApartmentData;