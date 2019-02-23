USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetDataFileId', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetDataFIleId; 
GO


/****** Object:  StoredProcedure [dbo].[usp_GetDataFileId]    Script Date: 17-02-2019 00:59:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- =============================================
CREATE PROCEDURE [dbo].[usp_GetDataFileId] 
	(
		@FileType Varchar(10)
	)
AS
BEGIN
	Declare @QueryStr nvarchar(500), @tableName nvarchar(255)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if (@FileType = 'CARD')
	Begin
		set @tableName = 'tbl_CARD_Staging'
	End
	Else if (@FileType = 'CASA')
	Begin
		set @tableName = 'tbl_CASA_Staging'
	End
	Else if (@FileType = 'LOAN')
	Begin
		set @tableName = 'tbl_LOAN_Staging'
	End
	Else if (@FileType = 'EMP')
	Begin
		set @tableName = 'tbl_EMP_Staging'
	End
	Else if (@FileType = 'LIFE')
	Begin
		set @tableName = 'tbl_LIFE_Staging'
	End
	Else if (@FileType = 'NLIFE')
	Begin
		set @tableName = 'tbl_NLIFE_Staging'
	End
	Else
	Begin
		set @tableName = 'tbl_' + @FileType + '_Staging'
	End
	
	print @QueryStr
	set @QueryStr = 'Select top 1 fileId from ' + @tableName
	execute sp_executesql @QueryStr
End

GO


