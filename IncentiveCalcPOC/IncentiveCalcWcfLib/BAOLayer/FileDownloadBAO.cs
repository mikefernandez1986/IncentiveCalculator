﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



namespace IncentiveCalcWcfLib.BAOLayer
{
    public class FileDownloadBAO
    {

        DAOLayer.FileDownloadDAO DAO = new DAOLayer.FileDownloadDAO();
        DAOLayer.FileUploaderDAO uploadDAO = new DAOLayer.FileUploaderDAO();

        public string CreateEmpPayoutFile(string EmpNo)
        {
            string payoutFilename = "";
            try
            {
                payoutFilename = DAO.CreateEmpPayoutFile(EmpNo);
            }
            catch (Exception ex)
            {
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcService";
                appLog.WriteEntry(ex.Message);
            }
            return payoutFilename;
        }

        public string CreateProductPayoutFile(string ProductCode)
        {
            string payoutFilename = "";
            long fileId = 0;
            try
            {
                fileId = uploadDAO.GetDataFileId(ProductCode);
                if (fileId > 0)
                {
                    uploadDAO.UpdateFileDetails(fileId, (int)BAOLayer.FileUploaderBAO.FileStatusCodes.InProcess);
                    payoutFilename = DAO.CreateProductPayoutFile(ProductCode);
                    DAO.InsertDownloadFileDetails(payoutFilename, ProductCode);
                    uploadDAO.UpdateFileDetails(fileId, (int)BAOLayer.FileUploaderBAO.FileStatusCodes.CreatePayoutComplete);
                }
            }
            catch (Exception ex)
            {
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcService";
                appLog.WriteEntry(ex.Message);
            }
            return payoutFilename;
        }

        public string CreateCumulativePayoutFile()
        {
            string payoutFilename = "";
            try
            {
                payoutFilename = DAO.CreateCumulativePayoutFile();
                DAO.InsertDownloadFileDetails(payoutFilename, "ALL");
            }
            catch (Exception ex)
            {
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcService";
                appLog.WriteEntry(ex.Message);
            }
            return payoutFilename;
        }


    }
}
