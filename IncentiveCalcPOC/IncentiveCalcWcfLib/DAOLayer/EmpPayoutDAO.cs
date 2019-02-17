using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using IncentiveCalcWcfLib.Entities;

namespace IncentiveCalcWcfLib.DAOLayer
{
    public class EmpPayoutDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;

        public List<EmpPayoutEntity> GetEmpPayoutDetails(string productType)
        {
            List<EmpPayoutEntity> payoutList = null;
            SqlConnection conn = null;
            SqlDataReader dr = null;
            try
            {
                using (conn = new SqlConnection(sqlConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_GetEmpPayoutDetails", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@ProductCode", SqlDbType.VarChar).Value = productType;

                        conn.Open();
                        dr = cmd.ExecuteReader();
                        payoutList = BuildEmpPayoutList(dr);
                        dr.Close();
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
            return payoutList;
        }

        private List<EmpPayoutEntity> BuildEmpPayoutList(SqlDataReader dataReader)
        {
            List<EmpPayoutEntity> payoutList = new List<EmpPayoutEntity>();
            if ((dataReader != null) && (dataReader.HasRows))
            {
                while (dataReader.Read())
                {
                    EmpPayoutEntity empPayout = new EmpPayoutEntity();
                    empPayout.EmployeeNo = Convert.ToString(dataReader["EMP_NO"]);
                    empPayout.EmployeeName = Convert.ToString(dataReader["EMP_NAME"]);
                    empPayout.ProductType = Convert.ToString(dataReader["PRODUCT"]);
                    empPayout.TargetAchvdFlag = Convert.ToChar(dataReader["TARGET_ACHIEVED"]);
                    empPayout.TotalPoints = Convert.ToInt32(dataReader["TOTAL_POINTS"]);
                    empPayout.KPIRating = Convert.ToDecimal(dataReader["KPI_RATING"]);
                    empPayout.ProposedPayoutAmt = Convert.ToDecimal(dataReader["PROPOSED_PAYOUT_AMT"]);
                    empPayout.ActualPayoutAmt = Convert.ToDecimal(dataReader["ACTUAL_PAYOUT_AMT"]);
                    empPayout.RetainedLoyaltyAmt = Convert.ToDecimal(dataReader["RETAINED_LOYALTY_AMT"]);
                    empPayout.PayoutCode = Convert.ToString(dataReader["PAYOUT_CODE"]);
                    payoutList.Add(empPayout);
                }
            }

            return payoutList;

        }
    }
}
