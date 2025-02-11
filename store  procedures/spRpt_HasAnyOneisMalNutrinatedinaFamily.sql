create Procedure  spRpt_HasAnyOneisMalNutrinatedinaFamily
@wardId int =0
As
Begin
		Select  Particular, Value from(
			Select case when HasAnyoneMalnutritioned =0  Then N'होइन' Else  N'हो' End Particular, 
			Count(HasAnyoneMalnutritioned) value from 	[Data].[HealthInfo] as hi		
			inner  join [Data].[HouseOwner] as ho on  hi.Id    =  ho.Id
			where (@wardId =0 or  ho.WardId=@wardId)
			group by HasAnyoneMalnutritioned
		) as   tbl order by value desc
End