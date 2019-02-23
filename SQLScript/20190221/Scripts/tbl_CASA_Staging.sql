USE [ICBankSohar]
GO

/****** Object:  Table [dbo].[tbl_CASA_STAGING]    Script Date: 21-02-2019 22:19:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_CASA_STAGING](
	[Cif ID] [nvarchar](255) NULL,
	[Acct Number] [nvarchar](255) NULL,
	[Acct Open Date] [datetime] NULL,
	[Scheme Code] [nvarchar](255) NULL,
	[Currency Code] [nvarchar](255) NULL,
	[Bal in local crncy last financial year] [float] NULL,
	[Bal in local crncy] [float] NULL,
	[Net growth in local crncy] [float] NULL,
	[LG Code] [nvarchar](255) NULL,
	[LC Code] [nvarchar](255) NULL,
	[RM Code] [nvarchar](255) NULL,
	[FileId] [bigint] NULL
) ON [PRIMARY]

GO


