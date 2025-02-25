USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_LingusticDetailsallHouseHold]    Script Date: 1/6/2025 12:21:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_LingusticDetailsallHouseHold]
@wardId int =0
As
Begin
	Select Particular, Value, DisplayOrder from(
	Select l.Name Particular , l.DisplayOrder,
		Count(l.Name)  Value from [Data].[HouseMember] as hm
		inner join Setup.Language as l on  hm.LanguageId = l.Id
		inner join [Data].[HouseOwner] as ho on    hm.HouseOwnerId= ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by l.Name , l.DisplayOrder
	) as tbl order by Particular, DisplayOrder
End