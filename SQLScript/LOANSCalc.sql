DECLARE  @M0_Start DATETIME, @M1_Start DATETIME, @M2_Start DATETIME , @M0_END DATETIME, @M1_END DATETIME, @M2_END DATETIME
					,@QuarterStart DATETIME, @QuarterEnd DATETIME
			DECLARE @Date datetime = GETDATE()
SELECT @QuarterStart= DATEADD(q, DATEDIFF(q, 0, @Date), 0),
				   @QuarterEnd = DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, @Date) + 1, 0))
	
			IF(MONTH(@Date) <> MONTH(DATEADD(d,1,@Date)))
			BEGIN
				SELECT @M0_Start = DATEADD(mm, DATEDIFF(mm , 0, GETDATE()), 0)
					  ,@M0_END = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
					  ,@M1_Start = DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0)
					  ,@M1_END = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0))+1,0)) 
			END
			ELSE
			BEGIN
				SELECT @M0_Start = DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) 
					  ,@M0_END = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0))+1,0)) 
					  ,@M1_Start = DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 2, 0)
					  ,@M1_END = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 2, 0))+1,0))
			END	

--SELECT @M0_Start , @M0_END, @M1_Start, @M1_END

SELECT [Scheme Code], [Acct Open Date],[Net Disb growth in local crncy] AS RoundValue   
 ,[LG Code],[LC Code],[RM Code] 
 INTO #LGTemp
 FROM tbl_Loan_Staging
WHERE [LG Code] <> [LC Code] AND [Acct Open Date] >  @M0_Start

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
		  ((a.TotalAmount/5000)) * 3
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
FROM tbl_Loan_Staging where [LC Code] IS NOT NULL
 
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
ELSE 125 
END AS TargetPercentAchived,
CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN 
		--ROUND ((a.TotalAmount/10000), 0, 0)* 5 
			((a.TotalAmount/5000))* 12
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
FROM #KPILOAN a
INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO
UNION ALL
SELECT a.EMP_NO,c.EMP_NAME, TargetLOAN, AchivedLOAN, TargetAchived, TargetPercentAchived, TotalPoints, a.KPIRating, b.ProposedPayoutPercent
,(((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
,(75 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as ActualPayAmount
,(25 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as RetainedLoyalityAmt
FROM #KPILGLOAN a
INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO


SELECT a.EMP_NO,c.EMP_NAME, 'LOAN' AS PRODUCT,  TargetAchived,  TotalPoints, a.KPIRating
,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
,'LC' AS PAYOUTCODE
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

DROP TABLE #KPILOAN
DROP TABLE #CalculatedLOAN
DROP TABLE #TEMP
DROP TABLE #Accumulated
DROP TABLE #LGTemp
DROP TABLE #LGAccumulated
DROP TABLE #LGCalculatedLOAN
DROP TABLE #KPILGLOAN


