Create Procedure spRpt_DisasterInfoDetails

  Select i.Name, Count(i.Name) as Value from Data.RiskAndDisaster
	cross apply openjson(DisasterJSON) as ij
	inner join Setup.Disaster as i on ij.Value = i.Id
	where DisasterJSON is not null
	group by i.Name