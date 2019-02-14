
SELECT a.* INTO #FinalTemp FROM (
SELECT * FROM tbl_INC_CASA
UNION ALL 
SELECT * FROM tbl_INC_LOAN
UNION ALL
--SELECT * FROM tbl_INC_CARDS
SELECT Emp_NO , EMP_Name, PRODUCT, TARGET_ACHEIVED AS TARGETACHEIVED, TOTAL_POINTS AS TOTALPOINTS , KPI_RATING AS KPIRATING 
, PROPOSED_PAYOUT_AMT AS PropsedPayAmount, 
ACTUAL_PAYOUT_AMT AS ActualPayAmount, RETAINED_LOYALTY_AMT AS RetainedLoyalityAmt 
,PAYOUT_CODE AS PAYOUT_CODE FROM tbl_CreditCardInfo 
)a
ORDER BY EMP_No

SELECT Emp_No, EMP_Name, 'ALL' AS PRODUCT, CONVERT (decimal(16,2), AVG(CAST(KPIRating AS float))) as KPIRating, SUM(TotalPoints) as TotalPoints ,SUM(PropsedPayAmount) as PropsedPayAmount,SUM(ActualPayAmount) AS ActualPayAmount
,SUM(RetainedLoyalityAmt)  AS RetainedLoyalityAmt FROM #FinalTemp
GROUP BY Emp_No, EMP_Name
ORDER BY emp_no

SELECT * FROM  #FinalTemp order by emp_no 

DROP TABLE #FinalTemp


