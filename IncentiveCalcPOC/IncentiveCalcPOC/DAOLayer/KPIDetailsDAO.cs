using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.ApplicationBlocks.Data;
using System.Data.OleDb;
using IncentiveCalcPOC.Entities;

namespace IncentiveCalcPOC.DAOLayer
{   
    public class KPIDetailsDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;
        public List<UploadDetails> getFileUploadInfo()
        {
            List<UploadDetails> uploadInfo = new List<UploadDetails>();
            try
            {
                SqlDataReader dr = SqlHelper.ExecuteReader(sqlConnectionString,CommandType.StoredProcedure, "usp_GetUplaodFileDetails");
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        UploadDetails entities = new UploadDetails();
                        entities.FileId = Convert.ToInt64(dr["FileId"]);
                        entities.FileName = Convert.ToString(dr["FileName"]);
                        entities.FileType = Convert.ToString(dr["FileType"]);
                        entities.DateCreated = Convert.ToString(dr["DateCreated"]);
                        entities.IsProcessed = Convert.ToBoolean(dr["IsProcessed"]);
                        entities.ProcessedTime = Convert.ToString(dr["ProcessedTime"]);
                       // entities.Status = Convert.ToInt32(dr["Status"]);
                        entities.StatusDesc = Convert.ToString(dr["StatusDesc"]);
                        uploadInfo.Add(entities);
                    }
                }
                dr.Close();
                   
            }
            catch(Exception ex)
            {
                throw ex;
            }
            return uploadInfo;
        }
    }
}