Create Procedure spRpt_LanguageHouseOwnerDetails
@wardId int =0
As
Begin

	Select Particular, Value, DisplayOrder from(
	Select l.Name Particular , l.DisplayOrder,
		Count(l.Name)  Value from [Data].[HouseOwner] as o
		inner join Setup.LandType as l on  o.LanguageId = l.Id
		where (@wardId = 0 or o.WardId = @wardId)
		group by l.Name , l.DisplayOrder
	
	) as tbl order by Particular, DisplayOrder
End
