using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.ApplicationBlocks.Data;
using OfficeOpenXml;

namespace IncentiveCalcWcfLib.DAOLayer
{
    public class FileDownloadDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;

        public string CreateEmpPayoutFile(string EmpNo)
        {
            string payoutFileLocation = ConfigurationManager.AppSettings["Download_Location"] + "\\";
            string payoutFileName = "EMP_" + EmpNo + "_" + DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss") + ".xlsx";
            SqlParameter[] sqlParams = new SqlParameter[1];
            sqlParams[0] = new SqlParameter("@Emp_No", EmpNo);
            DataSet ds = SqlHelper.ExecuteDataset(sqlConnectionString, CommandType.StoredProcedure, "usp_GetEmpPayout", sqlParams);

            if (ds.Tables.Count > 0)
            {
                string fileLocation = ConfigurationManager.AppSettings["Download_Location"];
                CreateExcelFileFromDataTable(ds.Tables[0], payoutFileLocation + payoutFileName, "EMP_" + EmpNo);
                return payoutFileName;
            }
            else
            {
                return null;
            }

        }


        public string CreateProductPayoutFile(string ProductCode)
        {
            string payoutFileLocation = ConfigurationManager.AppSettings["Download_Location"] + "\\";
            string payoutFileName = ProductCode + "_" + DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss") + ".xlsx";

            DataSet ds = SqlHelper.ExecuteDataset(sqlConnectionString, CommandType.StoredProcedure, "usp_Get" + ProductCode + "Payout");

            if (ds.Tables.Count > 0)
            {
                string fileLocation = ConfigurationManager.AppSettings["Download_Location"];
                CreateExcelFileFromDataTable(ds.Tables[0], payoutFileLocation + payoutFileName, ProductCode);
                return payoutFileName;
            }
            else
            {
                return null;
            }
            
        }


        public string CreateCumulativePayoutFile()
        {
            string payoutFileLocation = ConfigurationManager.AppSettings["Download_Location"] + "\\";
            string payoutFileName = "Cumulative_" + DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss") + ".xlsx";

            DataSet ds = SqlHelper.ExecuteDataset(sqlConnectionString, CommandType.StoredProcedure, "usp_GetCumulativePayout");

            if (ds.Tables.Count > 0)
            {
                CreateExcelFileFromDataTable(ds.Tables[0], payoutFileLocation + payoutFileName, "ALL");
                return payoutFileName;
            }
            else
                return null;
            
        }

        private bool CreateExcelFileFromDataTable(DataTable dt, string LongFileName, string SheetName)
        {
            try
            {
                using (ExcelPackage package = new ExcelPackage())
                {
                    ExcelWorksheet ws = package.Workbook.Worksheets.Add(SheetName);
                    int rowNumber = 1;
                    ws.Cells["A" + rowNumber].LoadFromDataTable(dt, true);
                    rowNumber += dt.Rows.Count + 2; // to create 2 empty rows
                    package.SaveAs(new FileInfo(LongFileName));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return true;
        }

        public long InsertFileDetails(string FileName, string FileType)
        {
            long FileId = 0;
            SqlParameter[] sqlParams = new SqlParameter[2];
            sqlParams[0] = new SqlParameter("FileName", FileName);
            sqlParams[1] = new SqlParameter("FileType", FileType);
            SqlDataReader dr = SqlHelper.ExecuteReader(
                     sqlConnectionString
                    , CommandType.StoredProcedure, "usp_InsertFileDownloadDetails"
                    , sqlParams);
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    FileId = Convert.ToInt64(dr["FileId"]);
                }
            }
            dr.Close();

            return FileId;

        }


    }
}
