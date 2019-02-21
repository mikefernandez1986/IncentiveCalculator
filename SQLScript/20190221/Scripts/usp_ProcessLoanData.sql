USE [ICBankSohar]
GO

IF OBJECT_ID('usp_ProcessLoanData', 'P') IS NOT NULL 
  DROP PROC dbo.usp_ProcessLoanData; 
GO

/****** Object:  StoredProcedure [dbo].[usp_ProcessLoanData]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Mike Fernandez
-- Create date: 21 Feb 2019
-- Description:	Calculate the payout for Loans
-- =============================================
CREATE PROCEDURE [dbo].[usp_ProcessLoanData] 
AS
BEGIN
	

		DECLARE @LCPoints float , @LGPoints float, @QualityAmount float, @ProductCode nvarchar(20) = 'LOANS'
		SELECT  A.[ProductId], A.[ProductName], A.[ProductCode], A.[ProductDesc], A.[ProductSegment], A.[ProductPoints]
			   ,D.QualityMonth, D.QualityReqAmount
			   ,E.AdditionalCaveatDesc
			   ,C.QualityParams
		  INTO #ProductRules
		  FROM [tbl_ProductMaster] A
		  INNER JOIN tbl_RuleEngineMaster B ON A.ProductId = B.ProductId
		  INNER JOIN tbl_QualityCaveatMaster C ON b.CaveatId = C.CaveatId
		  INNER JOIN tbl_PayoutQualityMaster D ON D.QualityId = B.QualityId
		  INNER JOIN tbl_AdditionalCaveatMaster E ON E.AdditionalCaveatId = C.AdditionalCaveatmasterId
		  INNER JOIN tbl_ProductMapping F ON A.ProductId = F.ProductId
		  WHERE a.ProductCode = @ProductCode
		  ORDER By A.Productid
		  -- get the points for LG and LC along with the Quality Amount to be deducted
		  SELECT @LCPoints = ProductPoints, @LGPoints = ((25/100.00) * ProductPoints), @QualityAmount = QualityReqAmount FROm #ProductRules

		  ALTER TABLE #ProductRules 
		  ADD RulesId INT IDENTITY

  
		  CREATE TABLE #AdditionalCaveat
		  (Id INT Identity,ProductId INT, AdditionalCaveatDesc varchar(500),VariableValues varchar(100))
		  INSERT INTO #AdditionalCaveat
		  SELECT ProductId,  AdditionalCaveatDesc, Params2.Item as VariableValues  FROM #ProductRules
		  CROSS APPLY dbo.SplitString (QualityParams, '|') AS Params
		  CROSS APPLY dbo.SplitString (Params.Item, '~') AS Params2

		  DECLARE @Count INT 
		  DECLARE @Incr INT = 1
		  DECLARE @ProductId INT, @variableName varchar(100), @VariableValue varchar(200)
		  SELECT @Count= COUNT(*) FROM #AdditionalCaveat
		  WHILE (@Count >= @Incr)
		  BEGIN
			SELECT @ProductId = ProductId, @variableName = VariableValues FROM #AdditionalCaveat WHERE Id = @Incr	
			SET @Incr = @Incr + 1
			SELECT @VariableValue = VariableValues FROM #AdditionalCaveat WHERE Id = @Incr
			UPDATE #ProductRules
			SET AdditionalCaveatDesc =  REPLACE(AdditionalCaveatDesc, @variableName, @VariableValue)
			WHERE ProductId = @ProductId
			SET @Incr = @Incr + 1
		  END
		DECLARE  @AdditionalCondition NVARCHAR(MAX)
		SELECT @AdditionalCondition = AdditionalCaveatDesc FROM #ProductRules
		DECLARE @SQL NVARCHAR(MAX)
		-- Create a temp table with schema to be used further 
		SELECT TOP 0 * INTO #tempAfterRule FROM tbl_Loan_Staging
		
		SET @SQL = 'INSERT INTO #tempAfterRule SELECT * FROM tbl_Loan_Staging WHERE ' + @AdditionalCondition

		EXEC (@SQL)

		--SELECT * INTO #tempAfterRule FROM tbl_Loan_Staging WHERE [GOV / Pr] <> 'Private' AND [Loan Type] NOT IN ('ADDITIONAL LOAN (TOP UP)')

		SELECT a.[Scheme Code], a.[Acct Open Date],a.[Net Disb growth in local crncy] AS RoundValue   
		 ,a.[LG Code],a.[LC Code],a.[RM Code] 
		 INTO #LGTemp
		 FROM #tempAfterRule a
		 INNER JOIN tbl_EmpBasicInfo b ON a.[LG Code] = b.EMP_NO AND b.[Incentive_Bonus] = 'Bonus'
		WHERE a.[LG Code] IS NOT NULL 

		SELECT [LG Code] AS EMP_NO, SUM(RoundValue) as TotalAmount INTO #LGAccumulated FROM #LGTemp 
		GROUP BY [LG Code]

		SELECT CalLGLOAN.* INTO #LGCalculatedLOAN 
		FROM (
		SELECT a.*, ISNULL(b.LOANS, 0) AS TargetLOAN, 
		CASE WHEN a.TotalAmount >= 0 THEN 'Y' ELSE 'N'END AS TargetAchived,
		CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN
					100
		WHEN ISNULL(a.TotalAmount, 0) <= 0 THEN 0
		END AS TargetPercentAchived,
		CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN 
				--ROUND ((a.TotalAmount/10000), 0, 0)* 1.25
				  ((a.TotalAmount/@QualityAmount)) * @LGPoints
		ELSE 0 END
		AS  TotalPoints 
		FROM #LGAccumulated a 
		INNER JOIN tbl_EmpTargetInfo b ON a.EMP_NO = b.EMP_NO
		) CalLGLOAN


		SELECT EMP_NO, TargetLOAN, TotalAmount as AchivedLOAN, TargetAchived, TargetPercentAchived, TotalPoints, 
		3 AS KPIRating 
		INTO #KPILGLOAN
		FROM #LGCalculatedLOAN

		--LOAN LC

		SELECT [Scheme Code], [Acct Open Date],[Net Disb growth in local crncy] AS RoundValue   
		 ,[LG Code],[LC Code],[RM Code]
		INTO #TEMP 
		FROM #tempAfterRule a
		INNER JOIN tbl_EmpBasicInfo b ON a.[LC Code] = b.EMP_NO AND b.[Incentive_Bonus] = 'Incentive '
		where [LC Code] IS NOT NULL
 
		--SELECT * FROM #TEMP WHERE LOANEligible = 'N'
		SELECT [LC Code] AS EMP_NO, SUM(RoundValue) as TotalAmount INTO #Accumulated FROM #TEMP 
		--WHERE LOANEligible = 'Y'
		GROUP BY [LC Code]

		SELECT CalLOAN.* INTO #CalculatedLOAN 
		FROM (
		SELECT a.*, ISNULL(b.LOANS, 0) AS TargetLOAN, 
		CASE WHEN a.TotalAmount >= ISNULL(b.LOANS, 0) THEN 'Y' ELSE 'N'END AS TargetAchived,
		CASE WHEN (ISNULL(b.LOANS, 0) > 0 AND ISNULL(a.TotalAmount, 0) > 0) THEN
					ROUND (((a.TotalAmount /b.LOANS) * 100) , 0, 0)
		WHEN ISNULL(a.TotalAmount, 0) <= 0 THEN 0
		ELSE 126 
		END AS TargetPercentAchived,
		CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN 
				--ROUND ((a.TotalAmount/10000), 0, 0)* 5 
					((a.TotalAmount/@QualityAmount))* @LCPoints
		ELSE 0 END
		AS  TotalPoints 
		FROM #Accumulated a 
		INNER JOIN tbl_EmpTargetInfo b ON a.EMP_NO = b.EMP_NO
		) CalLOAN

		SELECT EMP_NO, TargetLOAN, TotalAmount as AchivedLOAN, TargetAchived, TargetPercentAchived, TotalPoints, 
		(CASE 
			WHEN (TargetPercentAchived >=  60  AND TargetPercentAchived <= 84) THEN 1
			WHEN (TargetPercentAchived >  84  AND TargetPercentAchived <= 99) THEN 2
			WHEN (TargetPercentAchived > 99  AND TargetPercentAchived <= 114) THEN 3
			WHEN (TargetPercentAchived >  114  AND TargetPercentAchived <= 125) THEN 4
			WHEN (TargetPercentAchived > 125) THEN 5
			ELSE 0
		END) AS KPIRating 
		INTO #KPILOAN
		FROM #CalculatedLOAN

		SELECT a.EMP_NO,c.EMP_NAME, TargetLOAN, AchivedLOAN, TargetAchived, TargetPercentAchived, TotalPoints, a.KPIRating, b.ProposedPayoutPercent
		,(((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
		,(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as ActualPayAmount
		,(25 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as RetainedLoyalityAmt
		,'LC' AS PAYOUTCODE
		FROM #KPILOAN a
		INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
		INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO
		UNION ALL
		SELECT a.EMP_NO,c.EMP_NAME, TargetLOAN, AchivedLOAN, TargetAchived, TargetPercentAchived, TotalPoints, a.KPIRating, b.ProposedPayoutPercent
		,(((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
		,(75 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as ActualPayAmount
		,(25 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as RetainedLoyalityAmt
		,'LG' AS PAYOUTCODE
		FROM #KPILGLOAN a
		INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
		INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO

		Truncate TABLE dbo.tbl_INC_LOAN


		Insert into tbl_INC_LOAN

		SELECT a.EMP_NO,c.EMP_NAME, 'LOAN' AS PRODUCT,  TargetAchived,  TotalPoints, a.KPIRating
		,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
		,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
		,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
		,'LC' AS PAYOUTCODE
		--INTO tbl_INC_LOAN
		FROM #KPILOAN a
		INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
		INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO

		UNION ALL
		SELECT a.EMP_NO,c.EMP_NAME, 'LOAN' AS PRODUCT,  TargetAchived,  TotalPoints, a.KPIRating
		,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
		,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
		,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
		,'LG' AS PAYOUTCODE
		FROM #KPILGLOAN a
		INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
		INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO

		SELECT * FROM tbl_INC_LOAN 

		DROP TABLE #KPILOAN
		DROP TABLE #CalculatedLOAN
		DROP TABLE #TEMP
		DROP TABLE #Accumulated
		DROP TABLE #LGTemp
		DROP TABLE #LGAccumulated
		DROP TABLE #LGCalculatedLOAN
		DROP TABLE #KPILGLOAN
		DROP TABLE #tempAfterRule
		DROP TABLE #ProductRules
		DROP TABLE #AdditionalCaveat
END


GO


