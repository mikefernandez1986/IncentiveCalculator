USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetLoanPayout', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetLoanPayout; 
GO

/****** Object:  StoredProcedure [dbo].[usp_GetLoanPayout]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_GetLoanPayout]
AS
BEGIN  

	SELECT * FROM tbl_INC_LOAN
	order by emp_no

END

GO


--exec usp_GetLoanPayout
