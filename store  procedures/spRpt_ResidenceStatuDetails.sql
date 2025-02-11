Create procedure spRpt_ResidenceStatuDetails
 @wardId int = 0 
 As
 Begin
 Select Particular, Value, DisplayOrder from(
	Select r.Name as Particular , r.DisplayOrder,
		Count(r.Name) as  Value from [Data].[HouseMember] as hm
		inner join Setup.ResidenceStatus as r on r.Id = hm.ResidenceStatusId 
		inner join [Data].[HouseOwner] as ho on    hm.HouseOwnerId= ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by r.Name , r.DisplayOrder
	) as tbl order by Particular, DisplayOrder

	End

	