Create Procedure spRpt_HealthInstitutionDetailsInfo
@wardId int =0
As
Begin
	Select  Particular, Value, DisplayOrder from(
		Select i.Name  Particular, i.DisplayOrder,
		Count(i.Name) Value from  [Data].[HealthInfo] as hf
		cross apply openjson(hf.HealthInstitutionJSON) as ij
		inner join Setup.HealthInstitution   as i on  ij.value = i.Id	
		inner  join [Data].[HouseOwner] as ho on  hf.Id    =  ho.Id
		where hf.HealthInstitutionJSON is not null
		and(@wardId =0 or  ho.WardId=@wardId)
		group by  i.Name, i.DisplayOrder
		) as   tbl order by Particular, DisplayOrder
	End