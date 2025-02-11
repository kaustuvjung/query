Create Procedure spRpt_ExpertDetaisInHouse
@wardId int = 0 
As 
Begin
	select Particular , Value , DisplayOrder from(
		Select s.Name Particular , s.DisplayOrder ,
		Count(s.Name) Value from[Data].[HouseMember] as hm
		inner join Setup.Specialist as s on hm.SpecialistId =  s.Id
		inner join [Data].[HouseOwner] as ho on hm.HouseOwnerId = ho.Id
		where (@wardId = 0 or ho.WardId = @wardId)
		group by s.Name , s.DisplayOrder
	) as tbl order by Particular , DisplayOrder

End
