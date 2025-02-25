USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[sprpt_FacilityReceviedhouseholdOwner]    Script Date: 1/5/2025 11:56:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  procedure [dbo].[sprpt_FacilityReceviedhouseholdOwner]
@wardId int =0

As
Begin
	Select Particular ,  Value , DisplayOrder from (
		Select f.Name Particular ,f.Displayorder, 
		Count(f.Name) Value from [Data].[HouseFacility] as hf
		cross   apply openjson(hf.FacilitiesJSON) as ij 
		inner join   Setup.Facilities  as  f  on ij.value   = f.Id
		inner join [Data].[HouseOwner] as ho on  hf.Id = ho.Id
		where hf.FacilitiesJSON is not null 
		and (@wardId =0 or ho.WardId = @wardId)
		group by f.Name , f.DisplayOrder
	) as  tbl order by particular , DisplayOrder


	End
