USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_WardHouseHoldDetail]    Script Date: 1/5/2025 10:21:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_WardHouseHoldDetail]
	@wardId int = 0
As
Begin
	Select Particular, Value, DisplayOrder from (
	Select w.Name Particular, w.DisplayOrder, 
			Count(w.Name) Value from [Data].[HouseOwner] as o
			inner join Setup.Ward as w on o.WardId = w.Id
			where (@wardId = 0 or o.WardId = @wardId)
		group by w.Name, w.DisplayOrder
	) as tbl order by Particular, DIsplayOrder
End


