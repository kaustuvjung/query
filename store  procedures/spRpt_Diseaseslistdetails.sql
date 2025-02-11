Create Procedure spRpt_Diseaseslistdetails
@wardId int = 0
As
Begin
Select Particular, Value, DisplayOrder from(
	Select d.Name as Particular , d.DisplayOrder,
		Count(d.Name) as  Value from [Data].[HealthInfo] as hi
		cross apply openjson(hi.DiseaseJSON) as ij
		inner join Setup.Disease as d on ij.value = d.Id
		inner join [Data].[HouseOwner] as ho on    hi.Id= ho.Id
		where hi.DiseaseJSON is not null  
		and (@wardId = 0 or ho.WardId = @wardId)
		group by d.Name , d.DisplayOrder
	) as tbl order by Particular, DisplayOrder
End