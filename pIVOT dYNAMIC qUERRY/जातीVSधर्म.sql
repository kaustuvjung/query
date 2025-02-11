DECLARE @ReligionName  NVARCHAR(100) 
DECLARE @CasteName NVARCHAR(100) 

DECLARE @sql NVARCHAR(MAX);
DECLARE @cols NVARCHAR(MAX);

SELECT @cols  = STUFF((
		select ',' + QUOTENAME(r.Name)
		FROM Setup.Religion r
		FOR XML PATH('') , TYPE
		).value('.', 'NVARCHAR(MAX)'), 1,1, '');

SET @sql =N'
SELECT CasteName AS [जाती] , '+@cols+'
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
FOR ReligionName IN ('+ @cols +') 
) AS pvt
'

EXEC sp_executesql @sql , N'@CasteName NVARCHAR(100) , @ReligionName NVARCHAR(100)' , @CasteName, @ReligionName;