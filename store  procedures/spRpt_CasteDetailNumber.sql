create Procedure spRpt_CasteDetailNumber
@wardId int =0
As 
Begin
	Select Particular, Value, DisplayOrder from(
	Select c.Name Particular , c.DisplayOrder,
		Count(c.Name)  Value from [Data].[HouseMember] as hm
		inner join Setup.Caste as c on  hm.CasteId = c.Id
		inner join [Data].[HouseOwner] as ho on    hm.HouseOwnerId= ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by c.Name , c.DisplayOrder
	) as tbl order by Particular, DisplayOrder
End