Create procedure spRpt_ResidenceAbroadStatuDetails
 @wardId int = 0 
 As
 Begin
 Select Particular, Value, DisplayOrder from(
	Select r.Name as Particular , r.DisplayOrder,
		Count(r.Name) as  Value from [Data].[HouseMember] as hm
		inner join Setup.ResidenceAbroadStatus as r on r.Id = hm.ResidenceAbroadStatusId
		inner join [Data].[HouseOwner] as ho on    hm.HouseOwnerId= ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by r.Name , r.DisplayOrder
	) as tbl order by Particular, DisplayOrder

	End