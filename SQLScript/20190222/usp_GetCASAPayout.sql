USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetCASAPayout', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetCASAPayout; 
GO

/****** Object:  StoredProcedure [dbo].[usp_GetCASAPayout]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_GetCASAPayout]
AS
BEGIN  

	SELECT * FROM tbl_INC_CASA
	order by emp_no

END

GO


--exec usp_GetCASAPayout
