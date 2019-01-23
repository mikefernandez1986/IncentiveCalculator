using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.ApplicationBlocks.Data;
using System.Data.OleDb;

namespace IncentiveCalcPOC.DAOLayer
{
    public class FileUploaderDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;
        
        public bool TruncateTable(string TableName)
        {
            bool truncateStatus = false;
            SqlConnection conn = null;
            try
            {
                using (conn = new SqlConnection(sqlConnectionString))
                {
                    conn.Open();
                    // Delete old entries
                    SqlCommand truncate = new SqlCommand("TRUNCATE TABLE " + TableName, conn);
                    truncate.ExecuteNonQuery();
                    conn.Close();
                    truncateStatus = true;
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                if(conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            return truncateStatus;
        }

        public bool BulkInsert(DataTable dt, string tableName)
        {
            bool status = false;
            SqlBulkCopy bulkCopy = null;
            try
            {
                bulkCopy = new SqlBulkCopy(sqlConnectionString, SqlBulkCopyOptions.TableLock)
                {
                    DestinationTableName = tableName,
                    BatchSize = 100000,
                    BulkCopyTimeout = 360
                };
                bulkCopy.WriteToServer(dt);
                bulkCopy.Close();
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
               if(bulkCopy != null)
                {
                    bulkCopy.Close();
                }
            }
            return status;
        }

        public long UploadFileDetails(string FileName)
        {
            long FileId = 0;
            SqlDataReader dr = SqlHelper.ExecuteReader(
                     sqlConnectionString 
                    ,CommandType.StoredProcedure, "usp_InsertFileInfo"
                    , new SqlParameter("@FileName", FileName));
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

        public DataTable ConvertExcelToDataTable(string FileName)
        {
            DataTable dtResult = null;
            int totalSheet = 0; //No of sheets on excel file  
            using (OleDbConnection objConn = new OleDbConnection(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + FileName + ";Extended Properties='Excel 12.0;HDR=YES;IMEX=1;';"))
            {
                objConn.Open();
                OleDbCommand cmd = new OleDbCommand();
                OleDbDataAdapter oleda = new OleDbDataAdapter();
                DataSet ds = new DataSet();
                DataTable dt = objConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                string sheetName = string.Empty;
                if (dt != null)
                {
                    var tempDataTable = (from dataRow in dt.AsEnumerable()
                                         where !dataRow["TABLE_NAME"].ToString().Contains("FilterDatabase")
                                         select dataRow).CopyToDataTable();
                    dt = tempDataTable;
                    totalSheet = dt.Rows.Count;
                    sheetName = dt.Rows[0]["TABLE_NAME"].ToString();
                }
                cmd.Connection = objConn;
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "SELECT * FROM [" + sheetName + "]";
                oleda = new OleDbDataAdapter(cmd);
                oleda.Fill(ds, "excelData");
                dtResult = ds.Tables["excelData"];
                objConn.Close();
                return dtResult; //Returning Dattable  
            }
        }
    }
}