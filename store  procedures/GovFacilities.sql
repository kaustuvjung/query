Select i.Name, Count(i.Name) as Value from Data.HouseFacility
	cross apply openjson(GovFacilitiesReceiveJSON) as ij
	inner join Setup.GovFacility as i on ij.Value = i.Id
	where GovFacilitiesReceiveJSON is not null
	group by i.Name

	Select i.Name, Count(i.Name) as Value from Data.HouseFacility
	cross apply openjson(GovFacilitiesReceiveJSON) as ij
	inner join Setup.GovType as i on ij.Value = i.Id
	where GovFacilitiesReceiveJSON is not null
	group by i.Name


	Select i.Name, Count(i.Name) as Value from Data.HouseFacility
	cross apply openjson(GovFacilitiesExpectedJSON) as ij
	inner join Setup.GovFacility as i on ij.Value = i.Id
	where GovFacilitiesExpectedJSON is not null
	group by i.Name


	Select i.Name, Count(i.Name) as Value from Data.HouseFacility
	cross apply openjson(GovFacilitiesExpectedJSON) as ij
	inner join Setup.GovType as i on ij.Value = i.Id
	where GovFacilitiesExpectedJSON is not null
	group by i.Name
	