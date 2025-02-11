Select 
 N'पर्यटकीय स्थलको विवरण' as Name,

   it.Name as Particular,
  Count (it.Name) Value  from  Data.Institution i
  inner join Setup.InstitutionalDataType as it on it.Id =  i.InstitutionalDataTypeId
  --where (WardId = @wardId)
  group by it.Name
  
  Union All

  Select 
  N'पर्यटकीय स्थल तथा धार्मिक विवरण वडा अनुसार' as Name,
  w.Name, Count(i.Id) as Value from Data.Institution as i
  inner join Setup.Ward as w on w.id =  i.WardId
  --where (WardId = @wardId)
  group by w.Name

UNION All

Select 
N'पुर्खोली भाषा (घरधुरीको आधारमा)' as Name,
l.Name as Particular ,
Count(l.Name) as Value
from Data.HouseMember as hm
inner join Setup.Language as l on l.Id = hm.LanguageId
group by l.Name

Union All
Select 
N'जाति (घरधुरीको आधारमा)' AS Name,
c.Name as Particular,
Count(c.Name) as Value from Data.HouseMember as hm
inner join Setup.Caste as c on hm.CasteId =  c.Id
group by c.Name











