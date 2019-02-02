using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.ApplicationBlocks.Data;
using IncentiveCalcPOC.Entities;
using IncentiveCalcPOC.Helpers;

namespace IncentiveCalcPOC.DAOLayer
{
    public class UserRoleDetailsDAO
    {
        private static readonly string sqlConnectionString = ConfigurationManager.ConnectionStrings["SqlConnString"].ConnectionString;

        public bool AddRole(RoleEntities roleItem)
        {
            bool insertStatus = false;
            SqlConnection conn = null;
            try
            {
                using (conn = new SqlConnection(sqlConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_RoleInsert", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@RoleName", SqlDbType.VarChar).Value = roleItem.RoleName;
                        cmd.Parameters.Add("@RoleDesc", SqlDbType.VarChar).Value = roleItem.RoleDesc;
                        cmd.Parameters.Add("@AccessLevelId", SqlDbType.Int).Value = roleItem.AccessLevelId;

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        insertStatus = true;
                    }
                }
            }
            catch(Exception ex)
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
            return insertStatus;
        }

        public List<RoleEntities> GetRoles()
        {
            List<RoleEntities> roleInfo = new List<RoleEntities>();
            try
            {
                SqlDataReader dr = SqlHelper.ExecuteReader(
                    sqlConnectionString
                   , CommandType.StoredProcedure, "usp_GetRoleDetails");
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        RoleEntities entities = new RoleEntities();
                        entities.RoleId = Convert.ToInt32(dr["RoleId"]);
                        entities.RoleName = Convert.ToString(dr["RoleName"]);
                        entities.AccessLevelId = Convert.ToInt32(dr["AccessLevelId"]);
                        entities.AccessLevelName = Convert.ToString(dr["AccessLevelName"]);
                        roleInfo.Add(entities);
                    }
                }
                dr.Close();

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return roleInfo;
        }

        public bool AddUser(UserEntities userItem)
        {
            bool insertStatus = false;
            SqlConnection conn = null;
            try
            {
                using (conn = new SqlConnection(sqlConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_UserInsert", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@EmailId", SqlDbType.VarChar).Value = userItem.EmailId;
                        cmd.Parameters.Add("@Passwrd", SqlDbType.VarChar).Value = userItem.Password;
                        cmd.Parameters.Add("@FirstName", SqlDbType.VarChar).Value = userItem.FirstName;
                        cmd.Parameters.Add("@LastName", SqlDbType.VarChar).Value = userItem.LastName;
                        cmd.Parameters.Add("@Designation", SqlDbType.VarChar).Value = userItem.Designation;
                        cmd.Parameters.Add("@ProfileImageFileName", SqlDbType.VarChar).Value = userItem.ProfilePicPath;
                        cmd.Parameters.Add("@RoleId", SqlDbType.Int).Value = userItem.RoleId;
                        cmd.Parameters.Add("@Enabld", SqlDbType.Bit).Value = userItem.Enabled ? 1 : 0;

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        insertStatus = true;
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
            return insertStatus;
        }

        public List<UserEntities> GetUsers()
        {
            List<UserEntities> userInfo = new List<UserEntities>();
            try
            {
                SqlDataReader dr = SqlHelper.ExecuteReader(
                    sqlConnectionString
                   , CommandType.StoredProcedure, "usp_GetUsers");
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        UserEntities entities = new UserEntities();
                        entities.UserId = Convert.ToInt32(dr["UserId"]);
                        entities.EmailId = Convert.ToString(dr["EmailId"]);
                        entities.FirstName = Convert.ToString(dr["FirstName"]);
                        entities.LastName = Convert.ToString(dr["LastName"]);
                        entities.Designation = Convert.ToString(dr["Designation"]);
                        entities.ProfilePicPath = Convert.ToString(dr["ProfileImageFileName"]);
                        entities.Enabled = Convert.ToBoolean(dr["Enabld"]);
                        entities.LastUpdated = Convert.ToDateTime(dr["LastUpdated"]);
                        entities.RoleId = Convert.ToInt32(dr["RoleId"]);
                        entities.RoleName = Convert.ToString(dr["RoleName"]);
                        userInfo.Add(entities);
                    }
                }
                dr.Close();

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return userInfo;
        }

        public UserEntities GetUser(string emailStr)
        {
            UserEntities userInfo = new UserEntities();
            DBHelper dbHelper = new DBHelper();
            SqlParameter[] sqlParams = new SqlParameter[1];
            sqlParams[0] = new SqlParameter("EmailId", emailStr);
            DataSet ds = dbHelper.GetDatasetFromSP("usp_GetUserDetails", sqlParams);
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    userInfo.EmailId = emailStr;
                    userInfo.Password = ds.Tables[0].Rows[0].ItemArray.GetValue(2).ToString();
                    userInfo.FirstName = ds.Tables[0].Rows[0].ItemArray.GetValue(3).ToString();
                    userInfo.LastName = ds.Tables[0].Rows[0].ItemArray.GetValue(4).ToString();
                    userInfo.Designation = ds.Tables[0].Rows[0].ItemArray.GetValue(5).ToString();
                    userInfo.ProfilePicPath = ds.Tables[0].Rows[0].ItemArray.GetValue(6).ToString();
                    userInfo.Enabled = Convert.ToBoolean(ds.Tables[0].Rows[0].ItemArray.GetValue(7));
                    userInfo.LastUpdated = Convert.ToDateTime(ds.Tables[0].Rows[0].ItemArray.GetValue(8));
                    userInfo.RoleId = Convert.ToInt32(ds.Tables[0].Rows[0].ItemArray.GetValue(9));
                    userInfo.Role.RoleName = ds.Tables[0].Rows[0].ItemArray.GetValue(10).ToString();
                    userInfo.Role.AccessLevelId = Convert.ToInt32(ds.Tables[0].Rows[0].ItemArray.GetValue(11));
                }
            }
            return userInfo;
            
        }

    }
}