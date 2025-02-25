USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_ReligionHouseHoldDetail]    Script Date: 1/5/2025 10:21:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_ReligionHouseHoldDetail]
	@wardId int = 0
	As
	Begin
	Select Particular, Value,DisplayOrder from(
		Select r.Name Particular , r.DisplayOrder,
		Count(r.Name)  Value from [Data].[HouseOwner] as re
		inner join Setup.Religion as r on  re.ReligionId = r.Id
		where (@wardId = 0 or re.WardId = @wardId)
		group by r.Name , r.DisplayOrder
	) as   tbl order by Particular, DisplayOrder
	End
