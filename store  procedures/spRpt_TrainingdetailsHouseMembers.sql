 CREATE PROCEDURE spRpt_TrainingdetailsHouseMembers
 @wardId int = 0 
 As
 Begin

Select Particular, Value, DisplayOrder from(
	Select o.Name as Particular , o.DisplayOrder,
		Count(o.Name) as  Value from [Data].[HouseMember] as hm
		cross apply openjson(hm.OccupationJSON) as ij
		inner join Setup.Occupation as o on ij.value = o.Id
		inner join [Data].[HouseOwner] as ho on    hm.HouseOwnerId= ho.Id
		where hm.OccupationJSON is not null  
		and (@wardId = 0 or ho.WardId = @wardId)
		group by o.Name , o.DisplayOrder
	) as tbl order by Particular, DisplayOrder

	End