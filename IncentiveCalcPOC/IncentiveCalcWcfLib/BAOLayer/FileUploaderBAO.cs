using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;
using System.Data;
using System.Diagnostics;
using IncentiveCalcWcfLib.DAOLayer;


namespace IncentiveCalcWcfLib.BAOLayer
{
    public class FileUploaderBAO
    {
        public enum FileStatusCodes { New, Staged, InProcess, ProcessDataComplete, CreatePayoutComplete, Error}

        FileUploaderDAO DAO = new FileUploaderDAO();


        public bool UploadFile(string FileName, string FilePath, string SheetName, string FileType)
        {
 
            bool status = false;
            string[] sheetNames = null;
            string tableName;
            long FileId = 0;

            try
            {
                FileId = DAO.UploadFileDetails(FileName, FileType);
                if (FileId > 0)
                {

                    if ((SheetName != null) && (SheetName != ""))
                    {
                        sheetNames = SheetName.Split(',');
                    }
                    if ((sheetNames != null) && (sheetNames.Count() > 1))
                    {
                        //Multiple sheets to upload
                        foreach (string sheetName in sheetNames)
                        {
                            //Use table name without spaces
                            tableName = "tbl_" + sheetName.Replace(" ", "") + "_Staging";

                            status = UploadDataSheet(FilePath, FileName, sheetName, tableName, FileId);
                            if (status == false)
                                break;
                        }
                    }
                    else
                    {
                        //Single sheet to upload
                        tableName = "tbl_" + FileType.ToUpper() + "_Staging";

                        status = UploadDataSheet(FilePath, FileName, SheetName, tableName, FileId);
                    }

                }
                DAO.UpdateFileDetails(FileId, (int)FileStatusCodes.Staged);
            }
            catch (Exception ex)
            {
                if (FileId > 0)
                {
                    DAO.UpdateFileDetails(FileId, (int)FileStatusCodes.Error);
                }
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcService";
                appLog.WriteEntry(ex.Message);
                //throw ex;
            }
            return status;
        }

        private bool UploadDataSheet(string FilePath, string FileName, string SheetName, string TableName, long FileId)
        {

            bool status = false;
            DataTable dt = DAO.ConvertExcelToDataTable(FilePath + "\\" + FileName, SheetName);
            dt.Columns.Add("FileId", typeof(System.Int32));
            foreach (DataRow dr in dt.Rows)
            {
                dr["FileId"] = FileId;
            }
            bool _clearData = DAO.TruncateTable(TableName);
            if (_clearData)
            {
                status = DAO.BulkInsert(dt, TableName);
            }
            return status;
        }


        public bool ProcessDataFiles(string FileType)
        {

            bool status = false;
            long fileId = 0;
            try
            {
                fileId = DAO.GetDataFileId(FileType);
                if (fileId > 0)
                {
                    DAO.UpdateFileDetails(fileId, (int)FileStatusCodes.InProcess);
                    DAO.ProcessDataFile(FileType);
                    DAO.UpdateFileDetails(fileId, (int)FileStatusCodes.ProcessDataComplete);
                    status = true;
                }
                else
                {
                    var appLog = new EventLog("Application");
                    appLog.Source = "IncentiveCalcService";
                    appLog.WriteEntry("FileId for file type " + FileType + " not found.");
                }
            }
            catch (Exception ex)
            {
                DAO.UpdateFileDetails(fileId, (int)FileStatusCodes.Error);
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcService";
                appLog.WriteEntry(ex.Message);
                throw ex;
            }
            return status;
        }

        public void AccumulateRetainedLoyaltyAmounts(bool IsReprocess)
        {
            try
            {
                DAO.AccumulateRetainedLoyaltyAmounts(IsReprocess);
            }
            catch (Exception ex)
            {
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcService";
                appLog.WriteEntry(ex.Message);
                throw ex;
            }
        }
    }
}