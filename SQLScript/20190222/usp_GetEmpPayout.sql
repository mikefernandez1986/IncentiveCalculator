USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetEmpPayout', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetEmpPayout; 
GO

/****** Object:  StoredProcedure [dbo].[usp_GetEmpPayout]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_GetEmpPayout]
(	@Emp_No nvarchar(255)
)
AS
BEGIN  


	SELECT a.* FROM (
	SELECT * FROM tbl_INC_CASA where emp_no = @emp_no
	UNION ALL 
	SELECT * FROM tbl_INC_LOAN  where emp_no = @emp_no
	UNION ALL
	SELECT * FROM tbl_INC_CARD  where emp_no = @emp_no
	)a order by product, payoutcode

END

GO


--exec usp_GetEmpPayout '469'
