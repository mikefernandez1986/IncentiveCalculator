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
        public List<KPIEntities> GetKPIDetails()
        {
            List<KPIEntities> kpiInfo = new List<KPIEntities>();
            try
            {
                SqlDataReader dr = SqlHelper.ExecuteReader(sqlConnectionString,CommandType.StoredProcedure, "usp_GetKPIDetails");
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        KPIEntities entities = new KPIEntities();
                        entities.CASAID = Convert.ToInt32(dr["CASAID"]);
                        entities.EmployeeCode = Convert.ToString(dr["EmployeeCode"]);
                        entities.EmployeeName = Convert.ToString(dr["EmployeeName"]);
                        entities.PerformanceScore = Convert.ToInt32(dr["PerformanceScore"]);
                        entities.KPIRating = Convert.ToInt32(dr["KPIRating"]);
                        kpiInfo.Add(entities);
                    }
                }
                dr.Close();
                   
            }
            catch(Exception ex)
            {
                throw ex;
            }
            return kpiInfo;
        }
    }
}