USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_LifeInsurancedetails]    Script Date: 1/5/2025 10:21:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_LifeInsurancedetails]
	@wardId int = 0
As
Begin
		Select Particular, Value from (
	Select Case when hf.HasAnyInsurance = 0 Then N'छैन' Else N'छ' End Particular, 
			Count(hf.HasAnyInsurance) Value from [Data].[HouseFacility] as hf
			inner join[Data].[HouseOwner] as ho on hf.Id =ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by HasAnyInsurance
	) as tbl order by Value desc
End   
