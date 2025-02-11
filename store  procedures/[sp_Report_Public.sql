USE [NagarProfileMandandeupurNew]
GO
/****** Object:  StoredProcedure [dbo].[sp_Report_Public]    Script Date: 1/5/2025 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[sp_Report_Public]
	@wardId int,
	@questionConfigId int
As
Begin
	Declare @_wardId int = @wardId,
			@_questionConfigId int = @questionConfigId

	Declare @sp_name nvarchar(50),
			@diplaytext nvarchar(400),
			@valuetext nvarchar(400)

	Select @sp_name = SPName, @diplaytext = DisplayText, @valueText = ValueText 
		from dbo.QuestionConfig where Id = @_questionConfigId

	Declare @_sql nvarchar(500)
	Set @_sql = 'Execute ' + @sp_name + ' @wardId'

	print @_sql

	Exec sp_executesql @_sql, N'@wardId int', @wardId

	Select @diplaytext DisplayText, @valuetext ValueText
End



-- Execute sp_Report_Public 0, 4