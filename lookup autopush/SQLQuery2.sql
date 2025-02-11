/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[OfficeId]
      ,[DeviceSerialNo]
      ,[DeviceOfficeName]
      ,[DeviceOfficeUrl]
      ,[Remark]
  FROM [AutoPush].[dbo].[Device]

  
 select * from  office

 insert into Office(OfficeName, HostUrl) values ('kaustuv test','https://localhost:44369/')