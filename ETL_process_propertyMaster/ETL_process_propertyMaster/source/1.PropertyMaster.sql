use Propertymaster
GO

DELETE FROM dbo.Selling_Process
DELETE FROM dbo.Apartment
DELETE FROM dbo.Owner
DELETE FROM dbo.Buyer
DELETE FROM dbo.Real_Estate_Agent

BULK INSERT dbo.Apartment 
FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1apartment.csv' --file from which we load the apartment data, C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source should be changed to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source that corresponds to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source of the file in the computer
WITH (
    FIELDTERMINATOR = '|', 
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Owner
FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1owner.csv' --file from which we load the owner data, C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source should be changed to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source that corresponds to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source of the file in the computer
WITH (
    FIELDTERMINATOR = '|',
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Buyer
FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1buyer.csv' --file from which we load the buyer data, C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source should be changed to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source that corresponds to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source of the file in the computer
WITH (
    FIELDTERMINATOR = '|',
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Real_Estate_Agent --file from which we load the real estate agent data, C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source should be changed to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source that corresponds to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source of the file in the computer
FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1agent.csv'
WITH (
    FIELDTERMINATOR = '|',  
	ROWTERMINATOR = ';'
);

BULK INSERT dbo.Selling_Process --file from which we load the selling process data, C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source should be changed to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source that corresponds to the C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source of the file in the computer
FROM 'C:\Users\DELL\Documents\ETL_process_propertyMaster\ETL_process_propertyMaster\source\1selling_process.csv'
WITH (
    FIELDTERMINATOR = '|', 
	ROWTERMINATOR = ';',
	KEEPNULLS
);

--presentation of the first 15 rows of each table for the first snapshot 
/*
SELECT TOP 15 * FROM dbo.Apartment;
SELECT TOP 15 * FROM dbo.Owner;
SELECT TOP 15 * FROM dbo.Buyer;
SELECT TOP 15 * FROM dbo.Real_Estate_Agent;
SELECT TOP 15 * FROM dbo.Selling_Process;
*/