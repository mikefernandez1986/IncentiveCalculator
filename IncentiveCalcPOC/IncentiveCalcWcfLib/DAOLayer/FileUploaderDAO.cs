using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using Microsoft.ApplicationBlocks.Data;
using System.Data.OleDb;

namespace IncentiveCalcWcfLib.DAOLayer
{
    public class FileUploaderDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;
        //private static readonly string sqlConnectionString = @"Data Source=RAI-PC\SQLEXPRESS;Initial Catalog=ICBankSohar; User Id=sa;Password=sysadmiN19;";

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
                status = true;
            }
            catch (Exception ex)
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

        public long UploadFileDetails(string FileName, string FileType)
        {
            long FileId = 0;
            SqlParameter[] sqlParams = new SqlParameter[2];
            sqlParams[0] = new SqlParameter("FileName", FileName);
            sqlParams[1] = new SqlParameter("FileType", FileType);
            SqlDataReader dr = SqlHelper.ExecuteReader(
                     sqlConnectionString 
                    ,CommandType.StoredProcedure, "usp_InsertFileInfo"
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

        public void UpdateFileDetails(long FileId, int StatusCode)
        {
            SqlParameter[] sqlParams = new SqlParameter[2];
            sqlParams[0] = new SqlParameter("@FileId", FileId);
            sqlParams[1] = new SqlParameter("@Status", StatusCode);
            SqlHelper.ExecuteNonQuery(
                     sqlConnectionString
                    , CommandType.StoredProcedure, "usp_UpdateFileInfo"
                    , sqlParams);

        }

        public DataTable ConvertExcelToDataTable(string FileName, string ConfigSheetName)
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
                    DataTable tempDataTable;
                    if ((ConfigSheetName != null) && (ConfigSheetName != ""))
                    {

                        tempDataTable = (from dataRow in dt.AsEnumerable()
                                         where ((dataRow["TABLE_NAME"].ToString().Contains(ConfigSheetName)) &&
                                          (!dataRow["TABLE_NAME"].ToString().Contains("FilterDatabase")))
                                         select dataRow).CopyToDataTable();
                    }
                    else
                    {
                        tempDataTable = (from dataRow in dt.AsEnumerable()
                                         where !dataRow["TABLE_NAME"].ToString().Contains("FilterDatabase")
                                         select dataRow).CopyToDataTable();
                    }
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

        public bool ProcessDataFile(string fileType)
        {
            bool processStatus = false;
            string spName = "usp_Process" + fileType + "Data";
            SqlConnection conn = null;
            try
            {
                using (conn = new SqlConnection(sqlConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(spName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        processStatus = true;
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }

            }
            return processStatus;
        }

        public long GetDataFileId(string FileType)
        {
            long fileId = 0;
            SqlConnection conn = null;
            try
            {
                using (conn = new SqlConnection(sqlConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_GetDataFileId", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@FileType", FileType));
                        conn.Open();

                        object res = cmd.ExecuteScalar();
                        fileId = Convert.ToInt64(res);
                        
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }

            }
            return fileId;
        }

        public void AccumulateRetainedLoyaltyAmounts(bool IsReprocess)
        {
            SqlConnection conn = null;
            try
            {
                using (conn = new SqlConnection(sqlConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_AccumulateRetainedLoyaltyAmt", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@IsReprocess", IsReprocess ? 1 : 0));
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }

            }
        }

    }
}