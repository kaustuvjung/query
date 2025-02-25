USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_CasteHouseHoldDetail]    Script Date: 1/5/2025 10:20:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_CasteHouseHoldDetail]
	@wardId int = 0
	As
	Begin
	Select Particular, Value, DisplayOrder from(
		Select c.Name Particular , c.DisplayOrder,
		Count(c.Name)  Value from [Data].[HouseOwner] as o
		inner join Setup.Caste as c on  o.CasteId = c.Id
		where (@wardId = 0 or o.WardId = @wardId)
		group by c.Name , c.DisplayOrder
		
	) as   tbl order by Particular, DisplayOrder
	End


 
	

