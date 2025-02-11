DECLARE @WardName NVARCHAR(100) = Null;
DECLARE @ReligionName NVARCHAR(100) = NULL;


SELECT w.Name AS N'बडा न', r.Name, COUNT(hm.Id) AS HouseOwnerCount
FROM data.HouseOwner AS hm
INNER JOIN Setup.Ward AS w ON w.Id = hm.WardId
INNER JOIN Setup.Religion AS r ON r.Id = hm.ReligionId
WHERE 
    (@WardName IS NULL OR w.Name = @WardName) 
    AND (@ReligionName IS NULL OR r.Name = @ReligionName)
GROUP BY w.Name, r.Name;
