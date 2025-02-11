DECLARE @ReligionName  NVARCHAR(100) = NULL;
DECLARE @CasteName NVARCHAR(100) = NULL;

DECLARE @sql NVARCHAR(MAX);
DECLARE @cols NVARCHAR(MAX);

SELECT @cols  = STUFF((
		select ',' + QUOTENAME(c.Name)
		FROM Setup.Caste c
		FOR XML PATH('') , TYPE
		).value('.', 'NVARCHAR(MAX)'), 1,1, '');

SET @sql =N'
SELECT ReligionName AS [धर्म] , '+@cols+'
FROM 
(
SELECT 
		r.Name AS ReligionName,
		c.Name As CasteName ,
		   hm.Id AS HouseOwnerId
		FROM  data.HouseOwner as hm 
		INNER JOIN Setup.Caste AS c ON c.Id = hm.CasteId
    INNER JOIN Setup.Religion AS r ON r.Id = hm.ReligionId
    WHERE (@CasteName IS NULL OR c.Name =@CasteName)  
        AND (@ReligionName IS NULL OR r.Name = @ReligionName) 
) As SourceTable
PIVOT
(
COUNT(HouseOwnerId) 
FOR CasteName IN ('+ @cols +') 
) AS pvt
'

EXEC sp_executesql @sql ,  N'@ReligionName NVARCHAR(100) , @CasteName NVARCHAR(100) ' , @ReligionName , @CasteName;