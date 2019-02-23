USE [ICBankSohar]
GO


/****** Object:  Table [dbo].[tbl_FileDownloadDetails]    Script Date: 22-02-2019 23:23:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_FileDownloadDetails](
	[FileId] [bigint] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](100) NULL,
	[FileType] [nvarchar](10) NULL,
	[DateCreated] [datetime] NULL
 CONSTRAINT [PK_tbl_FileDownloadDetails] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tbl_FileDownloadDetails] ADD  CONSTRAINT [DF_tbl_FileDownloadDetails_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO


