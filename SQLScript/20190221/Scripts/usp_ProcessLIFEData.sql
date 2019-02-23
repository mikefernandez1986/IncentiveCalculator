USE [ICBankSohar]
GO

IF OBJECT_ID('usp_ProcessLIFEData', 'P') IS NOT NULL 
  DROP PROC dbo.usp_ProcessLIFEData; 
GO

/****** Object:  StoredProcedure [dbo].[usp_ProcessLIFEData]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_ProcessLIFEData]
AS  
BEGIN  

	select [Premium Amount]*70/100 as RTB, [Staff Id] as LC
	into #LTemp1
	from tbl_Life_Staging cc

	
	select sum(RTB) as RTBSum, LC, CONVERT(float, REPLACE(t2.Bancassurance, ',', '')) as EmpTarget
	into #Ltemp2
	from #Ltemp1
	inner join tbl_EmpBasicInfo t1 on t1.emp_no = LC
	inner join tbl_EmpTargetInfo t2 on t2.emp_no = t1.emp_no
	and LTrim(Rtrim(Upper(t1.[Incentive_Bonus]))) = 'INCENTIVE'
	group by LC , t2.Bancassurance
	order by LC

	
	select RTBSum,  RTBSum/10 as TotalPoints, LC, EmpTarget,
				(t1.RTBSum*100/EmpTarget) as PerfScore 
	into #LTemp3
	 from #LTemp2 t1
	

	select LC,
			RTBSum,
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
	into #LTemp4
	from #Ltemp3

		select LC,
			RTBSum,
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
	into #Ltemp5
	from #Ltemp4

	truncate table tbl_INC_LIFE

	insert into tbl_INC_LIFE
		select 
			LC,
			t1.EMP_NAME, 
			'LIFE',
			Iif((KPIRating > 0), 'Y', 'N'),
			totalpoints,
			KPIRating, 
			cast(Payout as decimal(18,2)),
			cast(Payout*75/100 as decimal(18,2)),
			cast(Payout*25/100 as decimal(18, 2)),
		'LC'
		from #Ltemp5 cc
		inner join tbl_EmpBasicInfo t1 on t1.EMP_NO = cc.LC

		--select * from tbl_inc_life order by emp_no

END

GO


-- exec usp_ProcessLIFEData