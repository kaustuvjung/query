create Procedure spRpt_MaritalStatusHouseHoldOwnerDetails
@wardId int =0
As
Begin
	Select Particular, Value, DisplayOrder from(
		Select m.Name Particular , m.DisplayOrder,
		Count(m.Name)  Value from [Data].[HouseOwner] as o
		inner join Setup.MaritalStatus as m  on  o.MaritalStatusId = m.Id
		where (@wardId = 0 or o.WardId = @wardId)
		group by m.Name , m.DisplayOrder	
	) as   tbl order by Particular, DisplayOrder

End

