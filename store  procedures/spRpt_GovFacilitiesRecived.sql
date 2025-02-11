Create Procedure spRpt_GovFacilitiesRecived
@wardId int =0
As
Begin
	Select Particular, Value , DisplayOrder from(
		Select gfr.Name Particular , gfr.DisplayOrder,
		Count(gfr.Name) Value from[Data].[HouseFacility] as hf
		cross apply openjson(hf.GovFacilitiesReceiveJSON)  as ij
		inner join Setup.GovFacility as gfr on ij.value = gfr.Id
		inner join [Data].[HouseOwner] as ho on hf.Id = ho.Id
		where hf.GovFacilitiesReceiveJSON is not null
		and (@wardId=0 or ho.WardId = @wardId)
		group by gfr.Name , gfr.DisplayOrder
	) as tbl order by Particular , DisplayOrder
End
