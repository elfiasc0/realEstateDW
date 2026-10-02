use Propertymaster
GO

DELETE FROM dbo.Selling_Process
DELETE FROM dbo.Apartment
DELETE FROM dbo.Owner
DELETE FROM dbo.Buyer
DELETE FROM dbo.Real_Estate_Agent

BULK INSERT dbo.Apartment 
FROM 'path\2apartment.csv' --file from which we load the apartment data, path should be changed to the path that corresponds to the path of the file in the computer
WITH (
    FIELDTERMINATOR = '|', 
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Owner
FROM 'path\2owner.csv' --file from which we load the owner data, path should be changed to the path that corresponds to the path of the file in the computer
WITH (
    FIELDTERMINATOR = '|',
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Buyer
FROM 'path\2buyer.csv' --file from which we load the buyer data, path should be changed to the path that corresponds to the path of the file in the computer
WITH (
    FIELDTERMINATOR = '|',
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Real_Estate_Agent --file from which we load the real estate agent data, path should be changed to the path that corresponds to the path of the file in the computer
FROM 'path\2agent.csv'
WITH (
    FIELDTERMINATOR = '|', 
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Selling_Process --file from which we load the selling process data, path should be changed to the path that corresponds to the path of the file in the computer
FROM 'path\2selling_process.csv'
WITH (
    FIELDTERMINATOR = '|',  
	ROWTERMINATOR = ';',
	KEEPNULLS
);

--presentation of the first 15 rows of each table for the second snapshot 
SELECT TOP 15 * FROM dbo.Apartment;
SELECT TOP 15 * FROM dbo.Owner;
SELECT TOP 15 * FROM dbo.Buyer;
SELECT TOP 15 * FROM dbo.Real_Estate_Agent;
SELECT TOP 15 * FROM dbo.Selling_Process;