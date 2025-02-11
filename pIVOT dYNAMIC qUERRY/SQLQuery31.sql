exec sp_executesql N'Declare @RowParameter nvarchar(400), @ColumnParameter nvarchar(400),
@ColumnParameterType nvarchar(50), @IsTotal bit = 0, @IsRange bit, @RangeParameter nvarchar(MAX), @SumParameter nvarchar(4000)

Select Top 1 @RowParameter = Label from dbo.Question where [Name] = @RowParameterKey and AssetId = @AssetId and IsDeleted = 0
Select Top 1 @ColumnParameter = Label from dbo.Question where [Name] = @ColumnParameterKey and AssetId = @AssetId and IsDeleted = 0

Create Table #RawData
(
	Id int identity(1, 1),
	AnswerId bigint,
	AnswerPID int,
	Answer1PID int,
	Value int,
	KoboMatrixRow nvarchar(200),
	WardNo int
)

Select JSON_VALUE([value],''$.label'') as [Key], JSON_VALUE([value],''$.name'') as [KeyID]
into #RowParameter
	 from dbo.Question as q
	 cross apply OPENJSON(Options)
	where AssetId = @AssetId and Name = @RowParameterKey

Select JSON_VALUE([value],''$.label'') as [Key], JSON_VALUE([value],''$.name'') as [KeyID]
into #ColumnParameter
	 from dbo.Question as q
	 cross apply OPENJSON(Options) 
	where AssetId = @AssetId and Name = @ColumnParameterKey

Declare @_sql nvarchar(max)
Declare @columns nvarchar(max), @columns1 nvarchar(max), @sql nvarchar(max)

If @RowParameter is not null
	Exec (''Alter Table #RawData Add ['' + @RowParameter + ''] nvarchar(400)'') 
If @ColumnParameter is not null
	Exec (''Alter Table #RawData Add ['' + @ColumnParameter + ''] nvarchar(400)'') 

IF @ColumnParameterType = ''begin_kobomatrix''
	BEGIN
		Insert into #RawData (AnswerId, Value, KoboMatrixRow)
		Select AnswerId, Value, KoboMatrixRow from dbo.Answer as a
			inner join dbo.Question as q on a.AssetId = q.AssetId and a.Name = q.Name
		where q.Type = ''begin_kobomatrix'' and q.Name = @ColumnParameterKey and a.Value is not null

	Set @_sql = N''Update rw Set ['' + @RowParameter + ''] = rp.[Key] from dbo.Answer as a
		inner join #RawData as rw on a.AnswerId = rw.AnswerId
		inner join #RowParameter as rp on a.Value = rp.[KeyID]
		inner join dbo.Question as q on a.Name = q.Name
		where q.Label = N'''''' + @RowParameter + ''''''''

	Exec(@_sql) 

	Set @_sql = N''Update rw Set ['' + @ColumnParameter + ''] = cp.[Key] from dbo.Answer as a
		inner join #RawData as rw on a.AnswerId = rw.AnswerId
		inner join #ColumnParameter as cp on a.KoboMatrixRow = cp.[KeyID]
		inner join dbo.Question as q on a.Name = q.Name
		cross apply OPENJSON(Options) as o
		where JSON_VALUE(o.[value],''''$.name'''') = cp.[KeyID] 
			and JSON_VALUE(o.[value],''''$.name'''') = rw.KoboMatrixRow 
			and q.Label = N'''''' + @ColumnParameter + ''''''''
	
	Exec(@_sql) 

	Select @columns = Coalesce(@columns + '','', '''') + ''['' + [Key] + '']'',
		@columns1 = Coalesce(@columns1 + '','', '''') + ''Sum(IsNull(['' + [Key] + ''], '''''''')) as ['' + [Key] + '']''
		from #ColumnParameter
		group by [Key]
 
	Set @sql = N''Select [Key] ['' + @RowParameter + ''],
			'' + @columns1 + ''
			from #RowParameter rp
			left join #RawData on #RawData.['' + @RowParameter + ''] = rp.[Key]
			pivot(SUM(Value) for ['' + @ColumnParameter + ''] in ('' + @columns + ''))
			as p group by [Key]''

	print @sql
	Exec(@sql)
		
	END
ELSE
	BEGIN
		If @ColumnParameter is not null and @RowParameter is not null
		Begin
		Insert into #RawData (AnswerPID, AnswerId)
			Select Id, AnswerId from dbo.Answer
				where AssetId = @AssetId and Name = @ColumnParameterKey

		Update #RawData set Answer1PID = a.Id
			from dbo.Answer as a
				inner join #RawData on a.AnswerId = #RawData.AnswerId
			where AssetId = @AssetId and Name = @RowParameterKey
		End
		Else If @ColumnParameter is not null and @RowParameter is null
		Begin
		Insert into #RawData (AnswerPID, AnswerId)
			Select Id, AnswerId from dbo.Answer
				where AssetId = @AssetId and Name = @ColumnParameterKey
		End
		Else If @ColumnParameter is null and @RowParameter is not null
		Begin
		Insert into #RawData (AnswerPID, AnswerId)
			Select Id, AnswerId from dbo.Answer
				where AssetId = @AssetId and Name = @RowParameterKey
		End

		Update rw Set WardNo = a.Value
			from #RawData as rw
			inner join dbo.Answer as a on rw.AnswerId = a.AnswerId
			where a.Name = ''ward_no''

		Select * into #FinalData 
			from #RawData 
		where @WardNo = 0 or WardNo = @WardNo

		If @ColumnParameter is not null and @RowParameter is not null
		Begin
			Set @_sql = N''Update rw Set ['' + @RowParameter + ''] = rp.[Key] from dbo.Answer as a
				inner join #FinalData as rw on a.Id = rw.Answer1PID
				inner join #RowParameter as rp on a.Value = rp.[KeyID]
				inner join dbo.Question as q on a.Name = q.Name
				where q.Label = N'''''' + @RowParameter + ''''''''

			Exec(@_sql) 

			Set @_sql = N''Update rw Set ['' + @ColumnParameter + ''] = cp.[Key] from dbo.Answer as a
				inner join #FinalData as rw on a.Id = rw.AnswerPID
				inner join #ColumnParameter as cp on a.Value = cp.[KeyID]
				inner join dbo.Question as q on a.Name = q.Name
				where q.Label = N'''''' + @ColumnParameter + ''''''''
	
			Exec(@_sql)
		End
		Else
		Begin
			Set @_sql = N''Update rw Set ['' + @RowParameter + ''] = rp.[Key] from dbo.Answer as a
				inner join #FinalData as rw on a.Id = rw.AnswerPID
				inner join #RowParameter as rp on a.Value = rp.[KeyID]
				inner join dbo.Question as q on a.Name = q.Name
				where q.Label = N'''''' + @RowParameter + ''''''''

			Exec(@_sql) 

			Set @_sql = N''Update rw Set ['' + @ColumnParameter + ''] = cp.[Key] from dbo.Answer as a
				inner join #FinalData as rw on a.Id = rw.AnswerPID
				inner join #ColumnParameter as cp on a.Value = cp.[KeyID]
				inner join dbo.Question as q on a.Name = q.Name
				where q.Label = N'''''' + @ColumnParameter + ''''''''
	
			Exec(@_sql)
		End

		Select @columns = Coalesce(@columns + '','', '''') + ''['' + [Key] + '']'',
			@columns1 = Coalesce(@columns1 + '','', '''') + ''Sum(IsNull(['' + [Key] + ''], '''''''')) as ['' + [Key] + '']''
			from #ColumnParameter
			group by [Key]
 
		If @ColumnParameter is not null and @RowParameter is not null and @IsTotal = 0
		Begin
			Set @sql = N''Select [Key] ['' + @RowParameter + ''],
			'' + @columns1 + ''
			from #RowParameter rp
			left join #FinalData on #FinalData.['' + @RowParameter + ''] = rp.[Key]
			pivot(Count(AnswerId) for ['' + @ColumnParameter + ''] in ('' + @columns + ''))
			as p group by [Key]
			order by Len([Key]), [Key]''
		End
		Else If @ColumnParameter is not null and @RowParameter is null and @IsTotal = 0
		Begin
			Set @sql = N''Select [Key],
			'' + @columns1 + ''
			from #ColumnParameter cp
			left join #FinalData on #FinalData.['' + @ColumnParameter + ''] = cp.[Key]
			pivot(Count(AnswerId) for ['' + @ColumnParameter + ''] in ('' + @columns + ''))
			as p group by [Key]
			order by Len([Key]), [Key]''
		End
		Else If @ColumnParameter is null and @RowParameter is not null and @IsTotal = 0
		Begin
			Set @sql = N''Select [Key], Count(AnswerId) as Total
				from #RowParameter rp
				left join #FinalData on #FinalData.['' + @RowParameter + ''] = rp.[Key]
				group by [Key], rp.[KeyID]
				having Count(AnswerId) > 0
				order by Len(rp.[KeyID]), rp.[KeyID]''
		End
		Else If @IsTotal = 1
		Begin
			Set @sql = N''Select N''''जम्मा'''' as [Key], Count(AnswerId) as Total
				from #RowParameter rp
				left join #FinalData on #FinalData.['' + @RowParameter + ''] = rp.[Key]''
		End

		print @sql
		Exec(@sql)
	END

Drop Table #RowParameter
Drop Table #ColumnParameter
Drop Table #RawData
Drop Table #FinalData',N'@AssetId nvarchar(22),@wardNo int,@RowParameterKey nvarchar(10),@ColumnParameterKey nvarchar(7)',@AssetId=N'aCPTaKvZYQGBekbMRq4tEk',@wardNo=0,@RowParameterKey=N'H_language',@ColumnParameterKey=N'H_caste'