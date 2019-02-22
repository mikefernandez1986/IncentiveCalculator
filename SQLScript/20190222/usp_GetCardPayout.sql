USE [ICBankSohar]
GO

IF OBJECT_ID('usp_GetCardPayout', 'P') IS NOT NULL 
  DROP PROC dbo.usp_GetCardPayout; 
GO

/****** Object:  StoredProcedure [dbo].[usp_GetCardPayout]    Script Date: 17-02-2019 01:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[usp_GetCardPayout]
AS
BEGIN  

	SELECT * FROM tbl_INC_CARD
	order by emp_no

END

GO


--exec usp_GetCardPayout
