INSERT INTO tbl_EmpBasicInfo
SELECT Emp_NO
,EMP_NAME
,[JOIN_DATE]
,POSITION
,DIVISION
,[DEPARTMENT]
,[Branch Code ] 
,[Branches Name ]
,[Region]
,[Role] 
FROM tbl_EmployeeInfo_Staging

EXCEPT

SELECT * FROM tbl_EmpBasicInfo

INSERT INTO [dbo].[tbl_EmpTargetInfo]
           ([EMP_NO]
           ,[NTB-AL Khaas]
           ,[NTB - Mass Affluent]
           ,[NTB - Mass]
           ,[Bancassurance]
           ,[CASA]
           ,[Credit Card]
           ,[Loans]
           ,[Wealth Management])

SELECT [EMP_NO]
      ,[NTB - AL Khaas]
      ,CAST(REPLACE ([NTB - Mass Affluent], ',', '') AS FLOAT)
      ,CAST(REPLACE ([NTB - Mass], ',', '') AS FLOAT)
      ,CAST(REPLACE ([Bancassurance], ',', '') AS FLOAT)
      ,[CASA]
      ,[Credit Card]
      ,CAST(REPLACE ([Loans], ',', '') AS FLOAT)
      ,CAST(REPLACE ([Wealth Management], ',', '') AS FLOAT)
  FROM tbl_EmployeeInfo_Staging

EXCEPT

SELECT [EMP_NO]
    ,[NTB-AL Khaas]
    ,[NTB - Mass Affluent]
    ,[NTB - Mass]
    ,[Bancassurance]
    ,[CASA]
    ,[Credit Card]
    ,[Loans]
    ,[Wealth Management] 
FROM tbl_EmpTargetInfo

