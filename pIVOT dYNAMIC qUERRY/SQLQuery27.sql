DECLARE @ReligionName NVARCHAR(100) ;
DECLARE @CasteName NVARCHAR(100) 

DECLARE @sql NVARCHAR(MAX);
DECLARE @cols NVARCHAR(MAX);


SELECT @cols = STUFF(
    (
        SELECT ',' + QUOTENAME(r.Name)
        FROM Setup.Religion r
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);


IF @CasteName IS  NULL AND @ReligionName IS NULL
BEGIN
    SET @sql = N'
    SELECT CasteName AS [जाती], ' + @cols + '
    FROM 
    (
        SELECT 
            r.Name AS ReligionName,
            c.Name AS CasteName,
            hm.Id AS HouseOwnerId
        FROM data.HouseOwner AS hm
        INNER JOIN Setup.Caste AS c ON c.Id = hm.CasteId
        INNER JOIN Setup.Religion AS r ON r.Id = hm.ReligionId
        WHERE (@CasteName IS NULL OR c.Name = @CasteName)  
          AND (@ReligionName IS NULL OR r.Name = @ReligionName) 
    ) AS SourceTable
    PIVOT
    (
        COUNT(HouseOwnerId) 
        FOR ReligionName IN (' + @cols + ') 
    ) AS pvt
    ';
END
ELSE
BEGIN
SET @sql = N'
SELECT 
    c.Name AS [जाती], 
    COUNT(hm.Id) AS [TOTAL]
FROM data.HouseOwner AS hm
INNER JOIN Setup.Caste AS c ON c.Id = hm.CasteId
WHERE (@CasteName IS NULL OR c.Name = @CasteName) -- Only caste filter is applied
GROUP BY c.Name
ORDER BY c.Name;
';
END

-- Execute the dynamic SQL
EXEC sp_executesql @sql, N'@CasteName NVARCHAR(100), @ReligionName NVARCHAR(100)', @CasteName, @ReligionName;










-- Execute the dynamic SQL
