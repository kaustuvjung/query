create procedure spRpt_WaterSourceDetails
@wardId int =0
As 
Begin
Select  Particular, Value, DisplayOrder from(
		Select w.Name  Particular, w.DisplayOrder,
		Count(w.Name) Value from  [Data].[WaterResource] as ws
		cross apply openjson(ws.WaterSourceJSON) as ij
		inner join Setup.WaterSource   as w on  ij.value = w.Id	
		inner  join [Data].[HouseOwner] as ho on  ws.Id    =  ho.Id
		where ws.WaterSourceJSON is not null
		and(@wardId =0 or  ho.WardId=@wardId)
		group by  w.Name, w.DisplayOrder
		) as   tbl order by Particular, DisplayOrder
End

