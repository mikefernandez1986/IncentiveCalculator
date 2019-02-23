USE [ICBankSohar]
GO

IF OBJECT_ID('usp_ProcessCardData', 'P') IS NOT NULL 
  DROP PROC dbo.usp_ProcessCardData; 
GO

/****** Object:  StoredProcedure [dbo].[usp_ProcessCardData]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_ProcessCardData]
AS  
BEGIN  

	/**** Get card data, respective points and Quality Month based on product code/type ************/
	/****************************************************************************************/
	select [Type_Of_Card], [Card_Issue_Date], [Card_Active_Date], LC, LG,
	pm.ProductCode, 
	pm.ProductPoints,
	qm.QualityMonth,
		(CASE 
			WHEN (QualityMonth = 'M0') THEN DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,[Card_Issue_Date])+1,0))
			WHEN (QualityMonth = 'M2') THEN DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,[Card_Issue_Date])+3,0))
			ELSE DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,[Card_Issue_Date])+2,0)) /**Default of M0**/
		END) as QualityDate
	into #CCTemp1
	from tbl_Card_Staging cc
	inner join tbl_ProductMaster pm on RTRIM(LTRIM(Upper(cc.[Type_of_Card]))) = pm.ProductCode
	inner join tbl_RuleEngineMaster rm on pm.ProductId = rm.Productid
	inner join tbl_PayoutQualityMaster qm on rm.QualityId = qm.QualityId


	/**** Filter out invalid card data based on Quality Month check ************/
	/****************************************************************************************/
	select [Type_Of_Card], LC, LG, ProductPoints,
	ProductCode
	into #CCTemp2
	from #CCTemp1 
	where [Card_Active_Date] <= QualityDate

	
	/**** Get total # of cards and points, for each LC ************/
	/****************************************************************************************/
	select 
		LC,
		t3.CreditCard as EmpTarget, 
		count(*) as TotalCards, 
		sum(ProductPoints) as TotalPoints
	into #CCLCTemp1
	from 
		#CCTemp2 t1
		inner join tbl_EmpBasicInfo t2 on t2.emp_no = t1.LC
		inner join tbl_EmpTargetInfo t3 on t3.emp_no = t2.emp_no
	where RTrim(LTrim(LC)) != ''
		and  LTrim(Rtrim(Upper(t2.Incentive_Bonus))) = 'INCENTIVE'
		and t3.[creditcard] is not Null
	group by  LC, t3.[creditcard]


	/**** Get total # of cards and points, for each LG ************/
	/****************************************************************************************/
	select 
		LG, 
		count(*) as TotalCards, 
		sum(ProductPoints) as TotalPoints
	into #CCLGTemp1
	from 
		#CCTemp2 t1
		inner join tbl_EmpBasicInfo t2 on emp_no = t1.LG
	where RTrim(LTrim(LG)) != ''
		and  LTrim(Rtrim(Upper(t2.Incentive_Bonus))) = 'BONUS'
	group by  LG


	/**** Get Target and calculate performance score for the LC ************/
	/****************************************************************************************/
	select LC,
			TotalCards,
			TotalPoints,
			EmpTarget,
			(t1.TotalCards*100/EmpTarget) as PerfScore 
	into #CCLCTemp2
	from #CCLCTemp1 t1

	

	/**** Calculate KPI for the LC ************/
	/****************************************************************************************/
	select LC,
			TotalCards,
			TotalPoints,
			EmpTarget,
			PerfScore, 
			(CASE 
				WHEN (PerfScore >=  60  AND PerfScore <= 84) THEN 1
				WHEN (PerfScore >  84  AND PerfScore <= 99) THEN 2
				WHEN (PerfScore > 99  AND PerfScore <= 114) THEN 3
				WHEN (PerfScore >  114  AND PerfScore <= 125) THEN 4
				WHEN (PerfScore > 125) THEN 5
				ELSE 0
			END) as KPIRating
	into #CCLCTemp3
	from #CCLCTemp2


	/**** Calculate Payout for the LC ************/
	/****************************************************************************************/
	select LC,
			TotalCards,
			TotalPoints,
			EmpTarget,
			PerfScore, 
			KPIRating,
			(CASE 
				WHEN (KPIRating = 1) THEN TotalPoints*60.0/100
				WHEN (KPIRating = 2) THEN TotalPoints*80.0/100
				WHEN (KPIRating = 3) THEN TotalPoints*100.0/100
				WHEN (KPIRating = 4) THEN TotalPoints*120.0/100
				WHEN (KPIRating = 5) THEN TotalPoints*150.0/100
				ELSE 0
			END) as Payout
	into #CCLCTemp4
	from #CCLCTemp3
	--where KPIRating > 0


	/**** Calculate Payout for the LG ************/
	/****************************************************************************************/
	select LG,
			0 as EmpTarget,
			TotalCards,
			TotalPoints,
			(TotalPoints*25.0/100) as Payout
	into #CCLGTemp2
	from #CCLGTemp1 t1

		
	truncate table tbl_INC_CARD

	insert into tbl_INC_CARD
		select 
			LC,
			t1.EMP_NAME, 
			'CARD',
			Iif((KPIRating > 0), 'Y', 'N'),
			totalpoints,
			KPIRating, 
			cast(Payout as decimal(18,2)),
			cast(Payout*75/100 as decimal(18,2)),
			cast(Payout*25/100 as decimal(18, 2)),
		'LC'
		from #CCLCTemp4 cc
		inner join tbl_EmpBasicInfo t1 on t1.EMP_NO = cc.LC

	insert into tbl_INC_CARD
		select 
			LG, 
			t1.EMP_NAME, 
			'CARD',
			'Y', 
			totalpoints, 
			3, 
			cast(Payout as decimal(18,2)),
			cast(Payout*75/100 as decimal(18,2)),
			cast(Payout*25/100 as decimal(18, 2)),
			'LG'
		from #CCLGTemp2 cc
		inner join tbl_EmpBasicInfo t1 on t1.EMP_NO = cc.LG

	drop table #CCTemp1
	drop table #CCTemp2
	drop table #CCLCTemp1
	drop table #CCLCTemp2
	drop table #CCLCTemp3
	drop table #CCLCTemp4
	drop table #CCLGTemp1
	drop table #CCLGTemp2

END  


GO

-- exec usp_ProcessCardData
