USE [ICBankSohar]
GO

/****** Object:  Table [dbo].[tbl_FileUploadStatusMaster]    Script Date: 24-02-2019 22:21:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_FileUploadStatusMaster](
	[StatusCode] [int] NOT NULL,
	[StatusDesc] [nvarchar](255) NULL,
 CONSTRAINT [PK_tbl_FileUploadStatusMaster] PRIMARY KEY CLUSTERED 
(
	[StatusCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


INSERT INTO tbl_FileUploadStatusMaster VALUES (0, 'New')
INSERT INTO tbl_FileUploadStatusMaster VALUES (1, 'Staging-Complete')
INSERT INTO tbl_FileUploadStatusMaster VALUES (2, 'In-Process')
INSERT INTO tbl_FileUploadStatusMaster VALUES (3, 'Process-Complete')
INSERT INTO tbl_FileUploadStatusMaster VALUES (4, 'Error')

