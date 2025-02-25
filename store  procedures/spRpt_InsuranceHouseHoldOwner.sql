USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_InsuranceHouseHoldowner]    Script Date: 1/5/2025 10:21:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_InsuranceHouseHoldowner]
	@wardId int =0  
	As
	Begin
	Select  Particular, Value, DisplayOrder from(
		Select i.Name  Particular, i.DisplayOrder,
		Count(i.Name) Value from  [Data].[HouseFacility] as hf
		cross apply openjson(hf.InsuranceJSON) as ij
		inner join Setup.Insurance   as i on  ij.value = i.Id	
		inner  join [Data].[HouseOwner] as ho on  hf.Id    =  ho.Id
		where hf.InsuranceJSON is not null
		and(@wardId =0 or  ho.WardId=@wardId)
		group by  i.Name, i.DisplayOrder
		) as   tbl order by Particular, DisplayOrder
	End



		