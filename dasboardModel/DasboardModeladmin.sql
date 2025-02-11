
SELECT 
    N'स्थायी ठेगाना (घरधुरीको आधारमा)' AS Name, 
    CASE 
        WHEN ho.IsPermanentResident = 0 THEN N'होइन' 
        ELSE N'हो' 
    END AS Particular, 
    COUNT(ho.IsPermanentResident) AS Value
FROM [Data].[HouseOwner] ho
--WHERE (@wardId = 0 OR ho.WardId = @wardId)
GROUP BY ho.IsPermanentResident

UNION ALL

SELECT 
    N'जम्मा जनसंख्या' AS Name, 
    N'जम्मा' AS Particular, 
    COUNT(*) AS Value
FROM [NagarProfileMandandeupurNew].[Data].[HouseMember] hm
INNER JOIN [Data].[HouseOwner] ho 
    ON hm.HouseOwnerId = ho.Id
--WHERE (@wardId = 0 OR ho.WardId = @wardId)

UNION ALL

SELECT 
     N'लिङ्ग (घरधुरीको आधारमा)' AS Name, 
    CASE
        WHEN hm.Gender = 1 THEN N'पुरुस'
        WHEN hm.Gender = 2 THEN N'माहिला' 
        ELSE N'अन्य'  
    END AS Particular,  
    COUNT(hm.Gender) AS Value
FROM [NagarProfileMandandeupurNew].[Data].[HouseMember] hm
INNER JOIN [Data].[HouseOwner] ho  ON hm.HouseOwnerId = ho.Id
--WHERE (@wardId = 0 OR ho.WardId = @wardId) 
GROUP BY hm.Gender

UNION ALL

SELECT 
    N'घरधुरीको विवरण (अन्यत्रबास भए) बसो' AS Name,
    N'जम्मा' AS Particular, 
    COUNT(*) AS Value
FROM [Data].[HouseOwnerOther] ho_other
--WHERE (@wardId = 0 OR ho_other.WardId = @wardId);
