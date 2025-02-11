

create Procedure spRpt_HouseownerOther
	@wardId int =0  
	As
	Begin
	Select  Particular, Value from(
	    select WardId as Particular,
		Count(*) as  Value
		from data.HouseOwnerOther
		where (@wardId =0 or  WardId=@wardId)
		group by  WardId
		) as   tbl order by Particular
	End



		