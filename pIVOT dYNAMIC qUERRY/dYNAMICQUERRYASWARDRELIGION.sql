DECLARE @WardName NVARCHAR(100) = NULL; 
DECLARE @ReligionName NVARCHAR(100) = NULL; 

-- Define variables for dynamic SQL and columns
DECLARE @sql NVARCHAR(MAX);		
DECLARE @cols NVARCHAR(MAX);


SELECT @cols = STUFF((
    SELECT ',' + QUOTENAME(r.Name)  -- This creates a comma-separated list of religion names
    FROM Setup.Religion r
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 1, ''); 
-- Create the dynamic SQL for the PIVOT operation
SET @sql = N'
SELECT WardName AS [बडा न], ' + @cols + ' 
FROM 
(
    SELECT 
        w.Name AS WardName,
        r.Name AS ReligionName,
        hm.Id AS HouseOwnerId
    FROM 
        data.HouseOwner AS hm
		INNER JOIN Setup.Ward AS w ON w.Id = hm.WardId
		INNER JOIN Setup.Religion AS r ON r.Id = hm.ReligionId
		WHERE 
        (@WardName IS NULL OR w.Name = @WardName)  
        AND (@ReligionName IS NULL OR r.Name = @ReligionName) 
) AS SourceTable
PIVOT
(
    COUNT(HouseOwnerId) 
    FOR ReligionName IN (' + @cols + ')  -- Religion names as columns
) AS pvt';


EXEC sp_executesql @sql, N'@WardName NVARCHAR(100), @ReligionName NVARCHAR(100)', @WardName, @ReligionName;