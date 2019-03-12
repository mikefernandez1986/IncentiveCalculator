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
    
    public class UserKPIInfoDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;
        public Emp_Entities EmployeeDetails(string Emp_Id)
        {
            Emp_Entities Emp_Details = new Emp_Entities();
            try
            {
                string[] arrColor = new string[] { "#4dc9f6", "#f67019", "#f53794","#537bc4", "#acc236", "#166a8f","#00a950","#58595b", "#8549ba" };
                using (SqlDataReader dr = SqlHelper.ExecuteReader(sqlConnectionString, CommandType.StoredProcedure, "usp_GetEmpInfo_Dashboard"
                     , new SqlParameter("@Emp_No", Emp_Id)))
                {
                    Emp_Details.Emp_TargetInfo = new List<IncentiveSourceEntities>();
                    Emp_Details.EMP_AchievedInfo = new List<IncentiveSourceEntities>();
                    if (dr.HasRows)
                    {
                        int counter = 0;
                        while (dr.Read())
                        {
                            IncentiveSourceEntities target = new IncentiveSourceEntities();
                            IncentiveSourceEntities achived = new IncentiveSourceEntities();
                            target.label = achived.label = Convert.ToString(dr["ProductName"]);
                            target.value = Convert.ToString(dr["TargetSet"]);
                            achived.value = Convert.ToString(dr["Achieved"]);
                            target.color = achived.color = arrColor[counter];
                            Emp_Details.Emp_TargetInfo.Add(target);
                            Emp_Details.EMP_AchievedInfo.Add(achived);
                            counter++;
                        }
                        dr.NextResult();
                        while (dr.Read())
                        {
                            Emp_Details.Emp_No = Convert.ToString(dr["Emp_No"]);
                            Emp_Details.Emp_Name = Convert.ToString(dr["EMP_Name"]);
                            Emp_Details.Emp_Plan = Convert.ToString(dr["Incentive_Bonus"]);
                            Emp_Details.Emp_Product = Convert.ToString(dr["PRODUCT"]);
                            Emp_Details.Emp_KPIRating = Convert.ToDecimal(dr["KPIRating"]);
                            Emp_Details.Emp_TotalPoints = Convert.ToDouble(dr["TotalPoints"]);
                            Emp_Details.Emp_ProposedPayoutAmount = Convert.ToDouble(dr["PropsedPayAmount"]);
                            Emp_Details.Emp_ActualPayoutAmount = Convert.ToDouble(dr["ActualPayAmount"]);
                            Emp_Details.Emp_RetainedPayoutAmount = Convert.ToDouble(dr["RetainedLoyalityAmt"]);
                        }
                    }
                }


            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Emp_Details;
        }
    }
}