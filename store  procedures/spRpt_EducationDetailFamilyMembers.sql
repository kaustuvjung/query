Create Procedure spRpt_EducationDetailFamilyMembers 
@wardId int = 0
as
Begin
Select Particular, Value, DisplayOrder from(
	Select e.Name as Particular , e.DisplayOrder,
		Count(e.Name) as  Value from [Data].[HouseMember] as hm
		inner join Setup.Education as e on e.Id = hm.EducationId
		inner join [Data].[HouseOwner] as ho on    hm.HouseOwnerId= ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by e.Name , e.DisplayOrder
	) as tbl order by Particular, DisplayOrder
End