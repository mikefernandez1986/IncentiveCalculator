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

namespace IncentiveCalcPOC.BAOLayer
{
    public class FileUploaderBAO
    {
        FileUploaderDAO DAO = new FileUploaderDAO();
        public bool UploadFile(string FileName, string FilePath, string tableName)
        {
            bool status = false;
            try
            {
                long FileId = DAO.UploadFileDetails(FileName);
                if(FileId > 0)
                {
                    DataTable dt = DAO.ConvertExcelToDataTable(FilePath);
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
            }
            catch(Exception ex)
            {
                throw ex;
            }

            return status;
        }
        
        public bool processFiles()
        {
            bool succeess = false;
            try
            {
                DAO.ProcessData();
            }
            catch(Exception ex)
            {
                throw ex;
            }
            return succeess;
        }
    }
}