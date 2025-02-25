USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_OccupationHouseHoldOwner]    Script Date: 1/5/2025 10:21:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[spRpt_OccupationHouseHoldOwner]
 @wardId int =0
As
	

	Begin
	Select  Particular, Value, DisplayOrder from(
		Select i.Name  Particular, i.DisplayOrder,
		Count(i.Name) Value from  [Data].[HouseOwner] as o
		cross apply openjson(o.OccupationJSON) as ij
		inner join Setup.Occupation   as i on  ij.value = i.Id
		where OccupationJSON is not null
		and (@wardId =0 or o.WardId = @wardId)
		group by  i.Name, i.DisplayOrder
		) as   tbl order by Particular, DisplayOrder
	End



