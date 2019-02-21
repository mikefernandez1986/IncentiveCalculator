USE [ICBankSohar]
GO

/****** Object:  Table [dbo].[tbl_LIFE_Staging]    Script Date: 21-02-2019 21:57:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_LIFE_Staging](
	[Certificate Number] [nvarchar](255) NULL,
	[Date of Application] [datetime] NULL,
	[Branch Name] [nvarchar](255) NULL,
	[Branch Code] [nvarchar](255) NULL,
	[Product Name] [nvarchar](255) NULL,
	[Name of the Insured Person] [nvarchar](255) NULL,
	[DOB] [datetime] NULL,
	[Premium Frequency] [nvarchar](255) NULL,
	[Premium Amount] [float] NULL,
	[UserName] [nvarchar](255) NULL,
	[Staff Id] [nvarchar](255) NULL,
	[ApprovedBy] [nvarchar](255) NULL,
	[ApprovedOn] [datetime] NULL,
	[DebitTransRefno] [nvarchar](255) NULL,
	[FileId] [bigint] NULL
) ON [PRIMARY]

GO


