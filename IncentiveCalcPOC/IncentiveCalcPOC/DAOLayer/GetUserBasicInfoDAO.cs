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
    public class GetUserBasicInfoDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;

        public UserEntities GetEmpInfoyEmpId(string Emp_Id)
        {
            UserEntities UserInfo = new UserEntities();
            try
            {
                using (SqlDataReader dr = SqlHelper.ExecuteReader(sqlConnectionString, CommandType.StoredProcedure, "usp_GetEmpDetailsById", new SqlParameter("@Emp_No", Emp_Id)))
                {
                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            UserInfo.Emp_No = Convert.ToString(dr["Emp_No"]);
                            UserInfo.FirstName = Convert.ToString(dr["EMP_NAME"]);
                            UserInfo.JoinDate = Convert.ToDateTime(dr["JOIN_DATE"]);
                            UserInfo.Designation = Convert.ToString(dr["POSITION"]);
                            UserInfo.Dept = Convert.ToString(dr["DEPARTMENT"]);
                            UserInfo.Division = Convert.ToString(dr["DIVISION"]);
                            UserInfo.Branchname = Convert.ToString(dr["BranchesName"]);
                            UserInfo.RoleName = Convert.ToString(dr["Role"]);
                            UserInfo.ProfilePicPath = Convert.ToString(dr["ProfileImageFileName"]);
                        }
                    }
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {

            }
            return UserInfo;
        }

        public bool UpdateProfilePic(string FilePath, string EmpId)
        {
            bool isUpdated = false;
            try
            {
                SqlParameter[] sqlParams = new SqlParameter[2];
                sqlParams[0] = new SqlParameter("FilePath", FilePath);
                sqlParams[1] = new SqlParameter("Emp_No", EmpId);
                SqlDataReader dr = SqlHelper.ExecuteReader(
                         sqlConnectionString
                        , CommandType.StoredProcedure, "usp_UpdateProfile"
                        , sqlParams);
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        isUpdated = Convert.ToBoolean(dr["Success"]);
                    }
                }
                dr.Close();
            }
            catch(Exception ex)
            {
                isUpdated = false;
                throw ex;
            }
            finally
            {

            }
            return isUpdated;
        }
    }
}