USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_HouseOwnerGender]    Script Date: 1/5/2025 11:33:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_HouseOwnerGender]
	@wardId int = 0
As
Begin
	Select Particular, Value from (
	Select Case when hm.Gender = 1 Then N'पुरुस' 
			When  hm.Gender = 2 Then N'माहिला'
			Else N'अन्य' End Particular, 
			Count(hm.Gender) Value from [Data].[HouseMember] as hm
			inner join  [Data].[HouseOwner] as ho  on  hm.HouseOwnerId  = ho.Id
			where (@wardId = 0 or ho.WardId = @wardId)
		group by hm.Gender
		
	) as tbl order by Value desc
End





