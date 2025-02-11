CREATE PROCEDURE spRpt_HasAnyOneisdeadOrPregnentLadyIsDeadwithin3years
    @wardId INT = 0
AS
BEGIN
   
    SELECT Particular, Value
    FROM (
        SELECT 
            CASE 
                WHEN HasMaternalMortality = 0 THEN N'होइन'  
                ELSE N'हो' 
            END AS Particular, 
            COUNT(HasMaternalMortality) AS Value
        FROM [Data].[HealthInfo] AS hi
        
        INNER JOIN [Data].[HouseOwner] AS ho ON hi.Id= ho.Id 
        WHERE (@wardId = 0 OR ho.WardId = @wardId)
        GROUP BY HasMaternalMortality
    ) AS tbl
    ORDER BY Value DESC;  
End