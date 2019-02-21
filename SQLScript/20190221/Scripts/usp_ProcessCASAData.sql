USE [ICBankSohar]
GO

IF OBJECT_ID('usp_ProcessCASAData', 'P') IS NOT NULL 
  DROP PROC dbo.usp_ProcessCASAData; 
GO

/****** Object:  StoredProcedure [dbo].[usp_ProcessCASAData]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mike Fernandez
-- Create date: 21-02-2019
-- Description:	Generate the CASA Information 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ProcessCASAData]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE  @YearStartDate DATETIME = (SELECT DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))
	DECLARE @RMpoints float , @LGPoints float, @QualityAmount float, @ProductCode nvarchar(20) = 'CASA_VALUE'

	SELECT  @RMpoints = ProductPoints, @LGPoints = ((25/100.00) * ProductPoints), @QualityAmount = QualityReqAmount
	FROM tbl_ProductMaster A
	INNER JOIN tbl_RuleEngineMaster B ON A.ProductId = B.ProductId
	INNER JOIN tbl_QualityCaveatMaster C ON b.CaveatId = C.CaveatId
	INNER JOIN tbl_PayoutQualityMaster D ON D.QualityId = B.QualityId
	INNER JOIN tbl_AdditionalCaveatMaster E ON E.AdditionalCaveatId = C.AdditionalCaveatmasterId
	WHERE ProductCode = @ProductCode

	SELECT [Scheme Code], [Acct Open Date],
	  [Bal in local crncy last financial year] as Prevbal
	 ,[Bal in local crncy] AS CurrentBal
	 ,CASE WHEN ([Net growth in local crncy] < 0) THEN 0
		   ELSE [Net growth in local crncy] END AS RoundValue 
	 ,[Net growth in local crncy]  
	 ,[LG Code],[LC Code],[RM Code] 
	 INTO #LGTemp
	 FROM tbl_CASA_STAGING a
	 INNER JOIN tbl_EmpBasicInfo b ON a.[LG Code] = b.EMP_NO AND b.[Incentive_Bonus] = 'Bonus'
	WHERE [LG Code] IS NOT NULL AND [Acct Open Date] >  @YearStartDate

	SELECT [LG Code] AS EMP_NO, SUM(RoundValue) as TotalAmount INTO #LGAccumulated FROM #LGTemp 
	GROUP BY [LG Code]

	SELECT CalLGCASA.* INTO #LGCalculatedCASA 
	FROM (
	SELECT a.*, ISNULL(b.CASA, 0) AS TargetCASA, 
	CASE WHEN a.TotalAmount >= 0 THEN 'Y' ELSE 'N'END AS TargetAchived,
	CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN
				100
	WHEN ISNULL(a.TotalAmount, 0) <= 0 THEN 0
	END AS TargetPercentAchived,
	CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN 
			  ((a.TotalAmount/@QualityAmount)) * @LGPoints
	ELSE 0 END
	AS  TotalPoints 
	FROM #LGAccumulated a 
	INNER JOIN tbl_EmpTargetInfo b ON a.EMP_NO = b.EMP_NO
	) CalLGCASA


	SELECT EMP_NO, TargetCASA, TotalAmount as AchivedCASA, TargetAchived, TargetPercentAchived, TotalPoints, 
	3 AS KPIRating 
	INTO #KPILGCASA
	FROM #LGCalculatedCASA

	--CASA RM
	SELECT [Scheme Code], [Acct Open Date],
	 [Bal in local crncy last financial year] as Prevbal
	 ,[Bal in local crncy] AS CurrentBal, 
		   [Net growth in local crncy]  
		   AS RoundValue 
	 ,[Net growth in local crncy]  
	 ,[LG Code],[LC Code],[RM Code]
	INTO #TEMP
	FROM tbl_CASA_STAGING a
	INNER JOIN tbl_EmpBasicInfo b ON a.[RM Code] = b.EMP_NO AND b.[Incentive_Bonus] = 'Incentive '
	WHERE [RM Code] IS NOT NULL
 
	--SELECT * FROM #TEMP WHERE CASAEligible = 'N'
	SELECT [RM Code] AS EMP_NO, SUM(RoundValue) as TotalAmount INTO #Accumulated FROM #TEMP 
	--WHERE CASAEligible = 'Y'
	GROUP BY [RM Code]

	SELECT CalCASA.* INTO #CalculatedCASA 
	FROM (
	SELECT a.*, ISNULL(b.CASA, 0) AS TargetCASA, 
	CASE WHEN a.TotalAmount >= ISNULL(b.CASA, 0) THEN 'Y' ELSE 'N'END AS TargetAchived,
	CASE WHEN (ISNULL(b.CASA, 0) > 0 AND ISNULL(a.TotalAmount, 0) > 0) THEN
				ROUND (((a.TotalAmount /b.CASA) * 100) , 0, 0)
	WHEN ISNULL(a.TotalAmount, 0) <= 0 THEN 0
	ELSE 126 
	END AS TargetPercentAchived,
	CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN 
				((a.TotalAmount/@QualityAmount))* @RMpoints
	ELSE 0 END
	AS  TotalPoints 
	FROM #Accumulated a 
	INNER JOIN tbl_EmpTargetInfo b ON a.EMP_NO = b.EMP_NO
	) CalCASA

	SELECT EMP_NO, TargetCASA, TotalAmount as AchivedCASA, TargetAchived, TargetPercentAchived, TotalPoints, 
	(CASE 
		WHEN (TargetPercentAchived >=  60  AND TargetPercentAchived <= 84) THEN 1
		WHEN (TargetPercentAchived >  84  AND TargetPercentAchived <= 99) THEN 2
		WHEN (TargetPercentAchived > 99  AND TargetPercentAchived <= 114) THEN 3
		WHEN (TargetPercentAchived >  114  AND TargetPercentAchived <= 125) THEN 4
		WHEN (TargetPercentAchived > 125) THEN 5
		ELSE 0
	END) AS KPIRating 
	INTO #KPICASA
	FROM #CalculatedCASA

	truncate table tbl_INC_CASA

	Insert into tbl_INC_CASA

	SELECT a.EMP_NO,c.EMP_NAME, 'CASA' AS PRODUCT,  TargetAchived,  TotalPoints, a.KPIRating
	,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
	,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
	,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
	,'RM' AS PAYOUTCODE
	--INTO tbl_INC_CASA
	FROM #KPICASA a
	INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
	INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO

	UNION ALL
	SELECT a.EMP_NO,c.EMP_NAME, 'CASA' AS PRODUCT,  TargetAchived,  TotalPoints, a.KPIRating
	,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
	,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
	,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
	,'LG' AS PAYOUTCODE
	FROM #KPILGCASA a
	INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
	INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO

	DROP TABLE #KPICASA
	DROP TABLE #CalculatedCASA
	DROP TABLE #TEMP
	DROP TABLE #Accumulated
	DROP TABLE #LGTemp
	DROP TABLE #LGAccumulated
	DROP TABLE #LGCalculatedCASA
	DROP TABLE #KPILGCASA


	SELECT * FROM tbl_INC_CASA
END

GO
