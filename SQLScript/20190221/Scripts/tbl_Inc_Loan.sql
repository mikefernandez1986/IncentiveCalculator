USE [ICBankSohar]
GO

/****** Object:  Table [dbo].[tbl_INC_LOAN]    Script Date: 21-02-2019 21:33:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_INC_LOAN](
	[EMP_NO] [nvarchar](255) NULL,
	[EMP_NAME] [nvarchar](255) NULL,
	[PRODUCT] [varchar](4) NOT NULL,
	[TargetAchived] [varchar](1) NOT NULL,
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


