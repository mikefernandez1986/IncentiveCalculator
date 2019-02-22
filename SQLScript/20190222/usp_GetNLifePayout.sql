USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetNLifePayout', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetNLifePayout; 
GO

/****** Object:  StoredProcedure [dbo].[usp_GetNLifePayout]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_GetNLifePayout]
AS
BEGIN  

	SELECT * FROM tbl_INC_NLIFE
	order by emp_no

END

GO


--exec usp_GetNLifePayout
