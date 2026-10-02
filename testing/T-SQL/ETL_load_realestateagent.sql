USE PropertyMasterDW
GO

-- Drop the staging view if it exists
IF (OBJECT_ID('vETLReal_Estate_AgentData') IS NOT NULL) DROP VIEW vETLReal_Estate_AgentData;
GO

-- Create staging view
CREATE VIEW vETLReal_Estate_AgentData AS
SELECT
    [PESEL],
    CAST([Name] + ' ' + [Surname] AS NVARCHAR(40)) AS [NameAndSurname],
    [Gender],
    CASE 
        WHEN DATEDIFF(YEAR, Date_Of_Joining, GETDATE()) < 2 THEN 'Junior'
        WHEN DATEDIFF(YEAR, Date_Of_Joining, GETDATE()) BETWEEN 2 AND 4 THEN 'Mid'
        ELSE 'Senior'
    END AS [SeniorityCategory],
    [Email],
    [Phone_Number],
    B.ID_branch AS IDBranch
FROM PropertyMaster.dbo.Real_Estate_Agent AS A
JOIN Branch AS B ON A.City_Of_Agency = B.City AND B.ISCURRENT = 1;
GO

-- 1️⃣ Mark existing records as not current where data changed
UPDATE AgtDW
SET IsCurrent = 0
FROM Real_Estate_Agent AgtDW
JOIN vETLReal_Estate_AgentData AgtD
    ON AgtDW.PESEL = AgtD.PESEL
WHERE AgtDW.IsCurrent = 1
AND (
    AgtDW.SeniorityCategory <> AgtD.SeniorityCategory
    OR AgtDW.Email <> AgtD.Email
    OR AgtDW.PhoneNumber <> AgtD.Phone_Number
    OR AgtDW.ID_branch <> AgtD.IDBranch
);

-- 2️⃣ Insert new current records (only those not existing and current)
INSERT INTO Real_Estate_Agent (
    PESEL, 
    NameAndSurname, 
    Gender, 
    SeniorityCategory, 
    Email, 
    PhoneNumber, 
    ID_branch,
    IsCurrent
)
SELECT 
    AgtD.PESEL,
    AgtD.NameAndSurname,
    AgtD.Gender,
    AgtD.SeniorityCategory,
    AgtD.Email,
    AgtD.Phone_Number,
    AgtD.IDBranch,
    1
FROM vETLReal_Estate_AgentData AgtD
WHERE NOT EXISTS (
    SELECT *
    FROM Real_Estate_Agent AgtDW
    WHERE AgtDW.PESEL = AgtD.PESEL
      AND AgtDW.SeniorityCategory = AgtD.SeniorityCategory
      AND AgtDW.Email = AgtD.Email
      AND AgtDW.PhoneNumber = AgtD.Phone_Number
      AND AgtDW.ID_branch = AgtD.IDBranch
);



-- Drop staging view
DROP VIEW vETLReal_Estate_AgentData;
GO
