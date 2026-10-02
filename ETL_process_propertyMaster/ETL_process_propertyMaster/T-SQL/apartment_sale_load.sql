USE PropertymasterDW;
GO

-- Drop the view if it exists
IF (OBJECT_ID('vETLFApartmentSale') IS NOT NULL) 
    DROP VIEW vETLFApartmentSale;
GO

-- Create the view vETLFApartmentSale
CREATE VIEW vETLFApartmentSale
AS
SELECT 
    FinalPrice
    , ListingPrice
    , CommissionRate
    , Profit
    , Daysonmarket
    , IDowner
    , IDbuyer
    , IDapartment
    , IDagent
    , IDstartDate
    , IDsaleStartDate
    , IDendDate
    , IDjunkSale
FROM
    (SELECT 
          FinalPrice = SP.Final_Price
        , ListingPrice = SP.Listing_Price
        , CommissionRate = SP.Commission_Rate
        , Profit = SP.Final_Price * (SP.Commission_Rate / 100)
        , CASE 
              WHEN SSD.ID_date IS NULL THEN 0
              WHEN ED.ID_date IS NULL THEN DATEDIFF(DAY, SSD.DateValue, GETDATE())
              ELSE DATEDIFF(DAY, SSD.DateValue, ED.DateValue)
          END AS DaysOnMarket
        , IDowner = POwn.ID_person
        , IDbuyer = PBuyr.ID_person
        , IDapartment = A.ID_apartment
        , IDagent = REA.ID_real_estate_agent
        , IDstartDate = SD.ID_date
        , IDsaleStartDate = SSD.ID_date
        , IDendDate = ED.ID_date
        , IDjunkSale = junk.ID_junk_sale
    FROM Propertymaster.dbo.Selling_Process AS SP
    LEFT JOIN dbo.Apartment A ON A.Address = SP.Apartment_Address
    LEFT JOIN dbo.Date_Dim AS SD ON CONVERT(VARCHAR(10), SD.DateValue, 111) = CONVERT(VARCHAR(10), SP.Start_Date, 111)
    LEFT JOIN dbo.Date_Dim AS SSD ON CONVERT(VARCHAR(10), SSD.DateValue, 111) = CONVERT(VARCHAR(10), SP.For_Sale_Start_Date, 111)
    LEFT JOIN dbo.Date_Dim AS ED ON CONVERT(VARCHAR(10), ED.DateValue, 111) = CONVERT(VARCHAR(10), SP.End_Date, 111)
    JOIN dbo.Person AS POwn ON POwn.PESEL = SP.Owner_PESEL AND POwn.ISCURRENT = 1
    LEFT JOIN dbo.Person AS PBuyr ON PBuyr.PESEL = SP.Buyer_PESEL AND PBuyr.ISCURRENT = 1
    LEFT JOIN dbo.Real_Estate_Agent AS REA ON REA.PESEL = SP.Real_Estate_Agent_PESEL AND REA.ISCURRENT = 1
    INNER JOIN dbo.Junk_Sale AS junk ON junk.Status = SP.Status 
        AND junk.Condition = SP.Condition_Of_Apartment 
        AND junk.Agreement = SP.Agreement
    ) AS ApartmentSales;
GO

-- Perform the MERGE operation
MERGE INTO Apartment_Sale AS ASdw
USING vETLFApartmentSale AS ASd
    ON ASdw.ID_owner = ASd.IDowner
    AND ASdw.ID_apartment = ASd.IDapartment
    AND ASdw.ID_real_estate_agent = ASd.IDagent
    AND ASdw.ID_start_date = ASd.IDstartDate
    AND ASdw.ID_junk_sale = ASd.IDjunkSale
WHEN NOT MATCHED 
    THEN 
        INSERT (
            FinalPrice,
            ListingPrice,
            CommissionRate,
            Profit,
            DaysOnMarket,
            ID_owner,
            ID_buyer,
            ID_apartment,
            ID_real_estate_agent,
            ID_start_date,
            ID_for_sale_start_date,
            ID_end_date,
            ID_junk_sale
        )
        VALUES (
            ASd.FinalPrice,
            ASd.ListingPrice,
            ASd.CommissionRate,
            ASd.Profit,
            ASd.DaysOnMarket,
            ASd.IDowner,
            ASd.IDbuyer,
            ASd.IDapartment,
            ASd.IDagent,
            ASd.IDstartDate,
            ASd.IDsaleStartDate,
            ASd.IDendDate,
            ASd.IDjunkSale
        );
GO

-- Drop the view after merge
DROP VIEW vETLFApartmentSale;
GO
