USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetCumulativePayout', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetCumulativePayout; 
GO

/****** Object:  StoredProcedure [dbo].[usp_GetCumulativePayout]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_GetCumulativePayout]
AS
BEGIN

	SELECT a.* INTO #FinalTemp FROM (
	SELECT * FROM tbl_INC_CASA
	UNION ALL 
	SELECT * FROM tbl_INC_LOAN
	UNION ALL
	SELECT * FROM tbl_INC_CARD
	UNION ALL
	SELECT * FROM tbl_INC_LIFE
	UNION ALL
	SELECT * FROM tbl_INC_NLIFE
	)a
	ORDER BY EMP_No

	SELECT Emp_No, EMP_Name, 'ALL' AS PRODUCT, CONVERT (decimal(16,2), AVG(CAST(KPIRating AS float))) as KPIRating, SUM(TotalPoints) as TotalPoints ,SUM(PropsedPayAmount) as PropsedPayAmount,SUM(ActualPayAmount) AS ActualPayAmount
	,SUM(RetainedLoyalityAmt)  AS RetainedLoyalityAmt FROM #FinalTemp
	GROUP BY Emp_No, EMP_Name
	ORDER BY emp_no

	--SELECT * FROM  #FinalTemp order by emp_no 

	DROP TABLE #FinalTemp


END

GO

-- exec usp_GetCumulativePayout