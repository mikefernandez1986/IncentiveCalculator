USE [ICBankSohar]
GO

IF OBJECT_ID('usp_ProcessNLIFEData', 'P') IS NOT NULL 
  DROP PROC dbo.usp_ProcessNLIFEData; 
GO

/****** Object:  StoredProcedure [dbo].[usp_ProcessNLIFEData]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create PROCEDURE [dbo].[usp_ProcessNLIFEData]
AS  
BEGIN  

	select [Premium]*10/100 as RTB, [Generated Lead Staff ID _(LG CODE)] as LG
	into #NLTemp1
	from tbl_NLife_Staging 

	select sum(RTB) as RTBSum, sum(RTB/10) as TotalPoints, LG, 0 as EmpTarget, sum(RTB/(10*4)) as Payout
	into #NLtemp2
	from #NLtemp1
	inner join tbl_EmpBasicInfo t1 on emp_no = LG
	and LTrim(Rtrim(Upper(t1.[Incentive_Bonus]))) = 'BONUS'
	group by LG
	order by LG

	truncate table tbl_INC_NLIFE

	insert into tbl_INC_NLIFE
		select 
			LG,
			t1.EMP_NAME, 
			'NLIF',
			RTBSum,
			'Y',
			totalpoints,
			3, 
			cast(Payout as decimal(18,2)),
			cast(Payout*75/100 as decimal(18,2)),
			cast(Payout*25/100 as decimal(18, 2)),
		'LG'
		from #NLtemp2 cc
		inner join tbl_EmpBasicInfo t1 on t1.EMP_NO = cc.LG

		--select * from tbl_INC_NLIFE order by EMP_NO
END


GO


-- exec usp_ProcessNLIFEData
