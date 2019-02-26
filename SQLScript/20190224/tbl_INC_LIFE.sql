USE [ICBankSohar]
GO

DROP TABLE [dbo].[tbl_INC_LIFE]
GO

/****** Object:  Table [dbo].[tbl_INC_LIFE]    Script Date: 24-02-2019 21:19:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_INC_LIFE](
	[EMP_NO] [nvarchar](255) NULL,
	[EMP_NAME] [nvarchar](255) NULL,
	[PRODUCT] [varchar](10) NOT NULL,
	[Achieved] [float] NULL,
	[TargetAchieved] [varchar](1) NOT NULL,
	[TotalPoints] [float] NULL,
	[KPIRating] [int] NOT NULL,
	[PropsedPayAmount] [decimal](16, 2) NULL,
	[ActualPayAmount] [decimal](16, 2) NULL,
	[RetainedLoyalityAmt] [decimal](16, 2) NULL,
	[PAYOUTCODE] [varchar](2) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


