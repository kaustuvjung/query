Create Procedure  spRpt_ReligionDetailAll
@wardId int =0
As
Begin
	Select Particular, Value, DisplayOrder from(
	Select r.Name Particular , r.DisplayOrder,
		Count(r.Name)  Value from [Data].[HouseMember] as hm
		inner join Setup.Religion as r on  hm.ReligionId = r.Id
		inner join [Data].[HouseOwner] as ho on    hm.HouseOwnerId= ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by r.Name , r.DisplayOrder
	) as tbl order by Particular, DisplayOrder

End