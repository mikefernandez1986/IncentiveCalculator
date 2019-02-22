using System;
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
            try
            { 
                payoutFilename = DAO.CreateProductPayoutFile(ProductCode);
                DAO.InsertFileDetails(payoutFilename, ProductCode);
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
                DAO.InsertFileDetails(payoutFilename, "ALL");
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
