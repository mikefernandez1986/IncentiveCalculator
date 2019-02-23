USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetLifePayout', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetLifePayout; 
GO

/****** Object:  StoredProcedure [dbo].[usp_GetLifePayout]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_GetLifePayout]
AS
BEGIN  

	SELECT * FROM tbl_INC_LIFE
	order by emp_no

END

GO


--exec usp_GetLifePayout
