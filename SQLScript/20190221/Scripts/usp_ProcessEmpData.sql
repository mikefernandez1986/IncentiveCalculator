USE [ICBankSohar]
GO

IF OBJECT_ID('usp_ProcessEmpData', 'P') IS NOT NULL 
  DROP PROC dbo.usp_ProcessEmpData; 
GO

/****** Object:  StoredProcedure [dbo].[usp_ProcessEmpData]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_ProcessEmpData]
AS
BEGIN  

	MERGE tbl_EmpBasicInfo t 
		USING tbl_Emp_Staging s
	ON (s.emp_no = t.emp_no and s.emp_no is not null)
	WHEN MATCHED
		THEN UPDATE SET 
			t.EMP_NAME = s.EMP_NAME,
			t.[JOIN_DATE] = s.[JOIN_DATE]
	,t.POSITION = s.POSITION
	,t.DIVISION= s.DIVISION
	,t.[DEPARTMENT]= s.[DEPARTMENT]
	,t.[BranchCode]=  s.[Branch Code ]
	,t.[BranchesName]= s.[Branches Name ]
	,t.[Region]= s.[Region]
	,t.[Role] = s.[Role]
	,t.Incentive_Bonus = s.[Incentive / Bonus]
	WHEN NOT MATCHED BY TARGET 
		THEN INSERT (EMP_NO, EMP_NAME, JOIN_DATE, POSITION, DIVISION, DEPARTMENT, BranchCode, BranchesName, Region, [Role], Incentive_Bonus)
			 VALUES (s.EMP_No, s.EMP_NAME, s.JOIN_DATE, s.POSITION, s.DIVISION, s.DEPARTMENT, s.[Branch Code ], s.[Branches Name ], s.Region, s.[Role], s.[Incentive / Bonus]);



	MERGE tbl_EmpTargetInfo t 
		USING tbl_Emp_Staging s
	ON (s.emp_no = t.emp_no and s.emp_no is not null)
	WHEN MATCHED
		THEN UPDATE SET 
			t.[NTB_ALKhaas] = s.[NTB - AL Khaas]
	,t.NTB_MassAffluent = s.[NTB - Mass Affluent]
	,t.NTB_Mass= s.[NTB - Mass]
	,t.Bancassurance= s.[Bancassurance]
	,t.CASA=  s.[CASA]
	,t.CreditCard= s.[Credit Card]
	,t.Loans= s.Loans
	,t.WealthManagement = s.[Wealth Management ]
	WHEN NOT MATCHED BY TARGET 
		THEN INSERT (EMP_NO, NTB_ALKhaas, NTB_MassAffluent, NTB_Mass, Bancassurance, CASA, CreditCard, Loans, WealthManagement)
			 VALUES (s.EMP_NO, s.[NTB - AL Khaas], s.[NTB - Mass Affluent], s.[NTB - Mass], s.Bancassurance, s.CASA, s.[Credit Card], s.Loans, s.[Wealth Management ]);


END

GO

-- exec usp_ProcessEmpData