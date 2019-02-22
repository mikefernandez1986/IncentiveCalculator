USE [ICBankSohar]
GO

IF OBJECT_ID('usp_InsertFileDownloadDetails', 'P') IS NOT NULL 
  DROP PROC dbo.usp_InsertFileDownloadDetails; 
GO

/****** Object:  StoredProcedure [dbo].[usp_InsertFileDownloadDetails]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_InsertFileDownloadDetails]
( @FileName varchar(255),
  @FileType varchar(25)
 )
AS
BEGIN  

	insert into tbl_FileDownloadDetails
	([FileName], FileType)
	Values
	(@FileName, @FileType)

	SELECT SCOPE_IDENTITY()as FileId

END

GO

--exec usp_InsertFileDownloadDetails 'testfile.sdf', 'CARD'

--select * from tbl_FileDownloadDetails