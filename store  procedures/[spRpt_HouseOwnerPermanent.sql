USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_HouseOwnerPermanent]    Script Date: 1/5/2025 10:20:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_HouseOwnerPermanent]
	@wardId int = 0
As
Begin
	Select Particular, Value from (
	Select Case when IsPermanentResident = 0 Then N'होइन' Else N'हो' End Particular, 
			Count(IsPermanentResident) Value from [Data].[HouseOwner]
			where (@wardId = 0 or WardId = @wardId)
		group by IsPermanentResident
	) as tbl order by Value desc
End