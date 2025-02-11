Create procedure spRpt_GovFacilitiesExpected
	@wardId int=0
As
Begin
	Select Particular, Value, DisplayOrder from(
		Select gfe.Name Particular , gfe.DisplayOrder,
		Count(gfe.Name) Value from[Data].[HouseFacility] as hf
		cross apply openjson(hf.GovFacilitiesExpectedJSON)  as ij
		inner join Setup.GovFacility as gfe on ij.value = gfe.Id
		inner join  [Data].[HouseOwner] as ho on  hf.Id = ho.Id
		where hf.GovFacilitiesExpectedJSON is not null
		and (@wardId = 0 or ho.WardId = @wardId)
		group by gfe.Name, gfe.DisplayOrder
	
	)as tbl order by Particular, DisplayOrder
End