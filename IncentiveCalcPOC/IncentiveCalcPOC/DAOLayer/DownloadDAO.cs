using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.ApplicationBlocks.Data;
using System.Data.OleDb;
using IncentiveCalcPOC.Entities;
using System.Collections.Generic;
using System;

namespace IncentiveCalcPOC.DAOLayer
{

    public class DownloadDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;

        public List<DownloadEntities> GetINCInfo(string FileType)
        {
            List<DownloadEntities> downloadInfo = new List<DownloadEntities>();
            string SpName = "usp_Get"+ FileType +"Payout";
            try
            {
                using (SqlDataReader dr = SqlHelper.ExecuteReader(sqlConnectionString, CommandType.StoredProcedure, SpName))
                {
                    if (dr.HasRows)
                    {
                        if(FileType != "Cumulative")
                        {
                            while (dr.Read())
                            {
                                DownloadEntities entities = new DownloadEntities();
                                entities.emp_No = Convert.ToString(dr["EMP_NO"]);
                                entities.emp_Name = Convert.ToString(dr["EMP_NAME"]);
                                entities.Product = Convert.ToString(dr["PRODUCT"]);
                                entities.AchievedTarget = Convert.ToString(dr["Achievedtarget"]);
                                entities.TargetStatus = Convert.ToString(dr["TargetStatus"]);
                                entities.TotalPoints = Convert.ToDouble(dr["TotalPoints"]);
                                entities.KPIRating = Convert.ToDouble(dr["KPIRating"]);
                                entities.PropsedPayAmount = Convert.ToDouble(dr["PropsedPayAmount"]);
                                entities.ActualPayAmount = Convert.ToDouble(dr["ActualPayAmount"]);
                                entities.RetainedLoyalityAmt = Convert.ToDouble(dr["RetainedLoyalityAmt"]);
                                entities.PAYOUTCODE = Convert.ToString(dr["PAYOUTCODE"]);

                                downloadInfo.Add(entities);
                            }
                        }
                        else
                        {
                            while (dr.Read())
                            {
                                DownloadEntities entitiesAll = new DownloadEntities();

                                entitiesAll.emp_No = Convert.ToString(dr["EMP_NO"]);
                                entitiesAll.emp_Name = Convert.ToString(dr["EMP_NAME"]);
                                entitiesAll.Product = Convert.ToString(dr["PRODUCT"]);
                                entitiesAll.TotalPoints = Convert.ToDouble(dr["TotalPoints"]);
                                entitiesAll.KPIRating = Convert.ToDouble(dr["KPIRating"]);
                                entitiesAll.PropsedPayAmount = Convert.ToDouble(dr["PropsedPayAmount"]);
                                entitiesAll.ActualPayAmount = Convert.ToDouble(dr["ActualPayAmount"]);
                                entitiesAll.RetainedLoyalityAmt = Convert.ToDouble(dr["RetainedLoyalityAmt"]);

                                downloadInfo.Add(entitiesAll);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return downloadInfo;
        }
    }
}