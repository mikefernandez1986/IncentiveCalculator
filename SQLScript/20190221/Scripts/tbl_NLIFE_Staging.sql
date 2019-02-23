USE [ICBankSohar]
GO

/****** Object:  Table [dbo].[tbl_NLIFE_Staging]    Script Date: 21-02-2019 21:58:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_NLIFE_Staging](
	[SR#] [nvarchar](255) NULL,
	[Vision RM Branch _(select from Dropdown)] [nvarchar](255) NULL,
	[Date of policy issue _( DD/MM/YYYY)] [datetime] NULL,
	[Customer Name ] [nvarchar](255) NULL,
	[Policy Number ] [nvarchar](255) NULL,
	[Premium] [float] NULL,
	[Generated Lead Staff ID _(LG CODE)] [nvarchar](255) NULL,
	[FileId] [bigint] NULL
) ON [PRIMARY]

GO


