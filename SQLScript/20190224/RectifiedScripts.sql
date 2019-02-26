USE [ICBankSohar]
GO

/****** Object:  Table [dbo].[tbl_Loan_Staging]    Script Date: 02/24/2019 11:33:21 AM ******/
DROP TABLE [dbo].[tbl_Loan_Staging]
GO

/****** Object:  Table [dbo].[tbl_Loan_Staging]    Script Date: 02/24/2019 11:33:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_Loan_Staging](
	[Cif ID] [nvarchar](255) NULL,
	[Acct Number] [nvarchar](255) NULL,
	[Acct Name] [nvarchar](255) NULL,
	[Branch] [nvarchar](255) NULL,
	[Acct Open Date] [datetime] NULL,
	[Scheme Code] [nvarchar](255) NULL,
	[TYPE] [nvarchar](255) NULL,
	[Currency Code] [nvarchar](255) NULL,
	[Net Disb growth in local crncy] [float] NULL,
	[GOV / Pr] [nvarchar](255) NULL,
	[LG Code] [nvarchar](255) NULL,
	[LC Code] [nvarchar](255) NULL,
	[RM Code] [nvarchar](255) NULL,
	[Loan Type] [nvarchar](255) NULL,
	[FileId] [bigint] NULL
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[tbl_INC_CASA]    Script Date: 02/24/2019 11:33:57 AM ******/
DROP TABLE [dbo].[tbl_INC_CASA]
GO

/****** Object:  Table [dbo].[tbl_INC_CASA]    Script Date: 02/24/2019 11:33:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_INC_CASA](
	[EMP_NO] [nvarchar](255) NULL,
	[EMP_NAME] [nvarchar](255) NULL,
	[PRODUCT] [varchar](4) NOT NULL,
	[Achieved] [float] NULL,
	[TargetAchieved] [varchar](1) NOT NULL,
	[TotalPoints] [float] NULL,
	[KPIRating] [int] NOT NULL,
	[PropsedPayAmount] [decimal](16, 2) NULL,
	[ActualPayAmount] [decimal](16, 2) NULL,
	[RetainedLoyalityAmt] [decimal](16, 2) NULL,
	[PAYOUTCODE] [varchar](2) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/****** Object:  Table [dbo].[tbl_INC_LOAN]    Script Date: 02/24/2019 11:34:39 AM ******/
DROP TABLE [dbo].[tbl_INC_LOAN]
GO

/****** Object:  Table [dbo].[tbl_INC_LOAN]    Script Date: 02/24/2019 11:34:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_INC_LOAN](
	[EMP_NO] [nvarchar](255) NULL,
	[EMP_NAME] [nvarchar](255) NULL,
	[PRODUCT] [varchar](4) NOT NULL,
	[Achieved] [float] NULL,
	[TargetAchieved] [varchar](1) NOT NULL,
	[TotalPoints] [float] NULL,
	[KPIRating] [int] NOT NULL,
	[PropsedPayAmount] [decimal](16, 2) NULL,
	[ActualPayAmount] [decimal](16, 2) NULL,
	[RetainedLoyalityAmt] [decimal](16, 2) NULL,
	[PAYOUTCODE] [varchar](2) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- =============================================
-- Author:		Mike Fernandez
-- Create date: 21 Feb 2019
-- Description:	Calculate the payout for Loans
-- =============================================
ALTER PROCEDURE [dbo].[usp_ProcessLoanData] 
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

		SELECT a.[Acct Open Date],a.[Net Disb growth in local crncy] AS RoundValue   
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


		SELECT EMP_NO, TargetLOAN, TotalAmount as Achived_Target, TargetAchived, TargetPercentAchived, TotalPoints, 
		3 AS KPIRating 
		INTO #KPILGLOAN
		FROM #LGCalculatedLOAN

		--LOAN LC

		SELECT [Acct Open Date],[Net Disb growth in local crncy] AS RoundValue   
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

		SELECT EMP_NO, TargetLOAN, TotalAmount as Achived_Target, TargetAchived, TargetPercentAchived, TotalPoints, 
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

		Truncate TABLE dbo.tbl_INC_LOAN
		Insert into tbl_INC_LOAN

		SELECT a.EMP_NO,c.EMP_NAME, 'LOAN' AS PRODUCT, Achived_Target, TargetAchived,  TotalPoints, a.KPIRating
		,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
		,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
		,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
		,'LC' AS PAYOUTCODE
		--INTO tbl_INC_LOAN
		FROM #KPILOAN a
		INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
		INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO

		UNION ALL
		SELECT a.EMP_NO,c.EMP_NAME, 'LOAN' AS PRODUCT,Achived_Target,  TargetAchived,  TotalPoints, a.KPIRating
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

-- =============================================
-- Author:		Mike Fernandez
-- Create date: 21-02-2019
-- Description:	Generate the CASA Information 
-- =============================================
ALTER PROCEDURE [dbo].[usp_ProcessCASAData]
	
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


	SELECT EMP_NO, TargetCASA, TotalAmount as Achived_Target, TargetAchived, TargetPercentAchived, TotalPoints, 
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

	SELECT CAST(EMP_NO AS NVARCHAR(200)) AS EMP_NO, TargetCASA, TotalAmount as Achived_Target, TargetAchived, TargetPercentAchived, TotalPoints, 
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
	
	--DROP TABLE tbl_INC_CASA
	TRUNCATE TABLE tbl_INC_CASA

	INSERT INTO tbl_INC_CASA

	SELECT a.EMP_NO,c.EMP_NAME, 'CASA' AS PRODUCT, Achived_Target, TargetAchived, TotalPoints, a.KPIRating
	,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
	,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
	,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
	,'RM' AS PAYOUTCODE
	--INTO tbl_INC_CASA
	FROM #KPICASA a
	INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
	INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO

	UNION ALL
	SELECT a.EMP_NO,c.EMP_NAME, 'CASA' AS PRODUCT, Achived_Target, TargetAchived,  TotalPoints, a.KPIRating
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

