using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using IncentiveCalcPOC.DAOLayer;
using IncentiveCalcPOC.Entities;
using System.Diagnostics;

namespace IncentiveCalcPOC.BAOLayer
{
    public class FileUploaderBAO
    {
        public enum FileStatusCodes { New, Staged, InProcess, Complete, Error }

        FileUploaderDAO DAO = new FileUploaderDAO();

        public List<FileDetails> getFileTypes()
        {
            List<FileDetails> file = new List<FileDetails>();
            try
            {
                file = DAO.getFileTypes();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return file;
        }
        public bool UploadFile(string FileName, string FilePath, string SheetName, string FileType)
        {
            bool status = false;
            string tableName = "tbl_" + FileType.ToUpper() + "_Staging";
            try
            {
                long FileId = DAO.UploadFileDetails(FileName, FileType);
                if (FileId > 0)
                {
                    DataTable dt = DAO.ConvertExcelToDataTable(FilePath + "\\" + FileName, SheetName);
                    dt.Columns.Add("FileId", typeof(System.Int32));
                    foreach (DataRow dr in dt.Rows)
                    {
                        dr["FileId"] = FileId;
                    }
                    bool _clearData = DAO.TruncateTable(tableName);
                    if (_clearData)
                    {
                        status = DAO.BulkInsert(dt, tableName);
                    }
                }
                DAO.UpdateFileDetails(FileId, (int)FileStatusCodes.Staged);
            }
            catch (Exception ex)
            {
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcService";
                appLog.WriteEntry(ex.Message);
                throw ex;
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
                    DAO.UpdateFileDetails(fileId, (int)FileStatusCodes.Complete);
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
    }
}