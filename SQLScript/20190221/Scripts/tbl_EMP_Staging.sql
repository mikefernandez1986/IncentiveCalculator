USE [ICBankSohar]
GO

IF OBJECT_ID('dbo.tbl_EMP_Staging', 'U') IS NOT NULL 
  DROP TABLE dbo.tbl_EMP_Staging; 
GO

/****** Object:  Table [dbo].[tbl_EMP_Staging]    Script Date: 18-02-2019 17:20:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_EMP_Staging](
	[EMP_NO] [nvarchar](255) NULL,
	[EMP_NAME] [nvarchar](255) NULL,
	[JOIN_DATE] [datetime] NULL,
	[POSITION] [nvarchar](255) NULL,
	[DIVISION] [nvarchar](255) NULL,
	[DEPARTMENT] [nvarchar](255) NULL,
	[Branch Code ] [nvarchar](255) NULL,
	[Branches Name ] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NULL,
	[Branch Category] [nvarchar](255) NULL,
	[Role] [nvarchar](255) NULL,
	[Incentive / Bonus] [nvarchar](255) NULL,
	[NTB - AL Khaas] [float] NULL,
	[NTB - Mass Affluent] [nvarchar](255) NULL,
	[NTB - Mass] [nvarchar](255) NULL,
	[Bancassurance] [nvarchar](255) NULL,
	[CASA] [float] NULL,
	[Credit Card] [float] NULL,
	[Loans] [nvarchar](255) NULL,
	[Wealth Management ] [float] NULL,
	[F21] [nvarchar](255) NULL,
	[F22] [nvarchar](255) NULL,
	[F23] [nvarchar](255) NULL,
	[F24] [nvarchar](255) NULL,
	[F25] [nvarchar](255) NULL,
	[F26] [nvarchar](255) NULL,
	[F27] [nvarchar](255) NULL,
	[F28] [nvarchar](255) NULL,
	[F29] [nvarchar](255) NULL,
	[F30] [nvarchar](255) NULL,
	[Salalah Controll] [nvarchar](255) NULL,
	[Muscat Controll] [nvarchar](255) NULL,
	[Muscat Controll1] [nvarchar](255) NULL,
	[ Batinah] [nvarchar](255) NULL,
	[ Batinah1] [nvarchar](255) NULL,
	[Sales ] [nvarchar](255) NULL,
	[Interior] [nvarchar](255) NULL,
	[FileId] [bigint] NULL
) ON [PRIMARY]

GO


