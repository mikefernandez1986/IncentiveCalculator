USE [ICBankSohar]
GO

/****** Object:  Table [dbo].[tbl_Loan_Staging]    Script Date: 21-02-2019 22:20:08 ******/
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


