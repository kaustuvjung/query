USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[spRpt_IsMigratedBetweenLast5Years]    Script Date: 1/5/2025 10:21:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[spRpt_IsMigratedBetweenLast5Years]
	@wardId int = 0
As
Begin
	Select Particular ,  Value from  (
		Select Case when  IsMigratedBetweenLast5Year =0  Then N'होइन' Else  N'हो' End Particular, 
		Count ( IsMigratedBetweenLast5Year ) Value  from [Data].[HouseDetail] as hd
		inner join [Data].[houseOwner] as ho on hd.Id =  ho.Id
		where (@wardId = 0 or ho.WardId = @wardid)
		group by  IsMigratedBetweenLast5Year 
		
	) As tbl order by value desc

End