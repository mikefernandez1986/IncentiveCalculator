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

SELECT [Scheme Code], [Acct Open Date],
  [Bal in local crncy last financial year] as Prevbal
 ,[Bal in local crncy] AS CurrentBal
 ,CASE WHEN ([Net growth in local crncy] < 0) THEN 0
       ELSE [Net growth in local crncy] END AS RoundValue 
 ,[Net growth in local crncy]  
 ,[LG Code],[LC Code],[RM Code] 
 INTO #LGTemp
 FROM tbl_CASA_STAGING
WHERE [LG Code] <> [RM Code] AND [Acct Open Date] >  @M0_Start

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
		--ROUND ((a.TotalAmount/10000), 0, 0)* 1.25
		  ((a.TotalAmount/10000)) * 1.25
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
 ,[Bal in local crncy] AS CurrentBal
 ,--CASE WHEN ([Net growth in local crncy] < 0) THEN 0
       --ELSE 
	   [Net growth in local crncy] --END 
	   AS RoundValue 
 ,[Net growth in local crncy]  
 ,[LG Code],[LC Code],[RM Code]
 , CASE WHEN [Acct Open Date] < @M0_Start THEN 'Y' ELSE 'N' END AS CASAEligible
INTO #TEMP
FROM tbl_CASA_STAGING where [RM Code] IS NOT NULL
 
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
ELSE 125 
END AS TargetPercentAchived,
CASE WHEN (ISNULL(a.TotalAmount, 0) > 0) THEN 
		--ROUND ((a.TotalAmount/10000), 0, 0)* 5 
			((a.TotalAmount/10000))* 5
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

SELECT a.EMP_NO,c.EMP_NAME, TargetCASA, AchivedCASA, TargetAchived, TargetPercentAchived, TotalPoints, a.KPIRating, b.ProposedPayoutPercent
,(((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
,(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as ActualPayAmount
,(25 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as RetainedLoyalityAmt
FROM #KPICASA a
INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO
UNION ALL
SELECT a.EMP_NO,c.EMP_NAME, TargetCASA, AchivedCASA, TargetAchived, TargetPercentAchived, TotalPoints, a.KPIRating, b.ProposedPayoutPercent
,(((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
,(75 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as ActualPayAmount
,(25 *  (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00 as RetainedLoyalityAmt
FROM #KPILGCASA a
INNER JOIN tbl_ProposedPayout b on a.KPIRating = b.KPIRating
INNER JOIN tbl_EmpBasicInfo c on a.EMP_NO = c.Emp_NO


SELECT a.EMP_NO,c.EMP_NAME, 'CASA' AS PRODUCT,  TargetAchived,  TotalPoints, a.KPIRating
,CONVERT(decimal(16,2),((b.ProposedPayoutPercent/100.00) * a.TotalPoints)) as PropsedPayAmount 
,CONVERT(decimal(16,2),(75 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as ActualPayAmount
,CONVERT(decimal(16,2),(25 * (((b.ProposedPayoutPercent/100.00) * a.TotalPoints))) /100.00) as RetainedLoyalityAmt
,'RM' AS PAYOUTCODE
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


