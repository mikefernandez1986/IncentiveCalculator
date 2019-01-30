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
                        //Need to hash and encrypt password//
                        cmd.Parameters.Add("@Password", SqlDbType.VarChar).Value = userItem.Password;
                        cmd.Parameters.Add("@FirstName", SqlDbType.VarChar).Value = userItem.FirstName;
                        cmd.Parameters.Add("@LastName", SqlDbType.VarChar).Value = userItem.LastName;
                        cmd.Parameters.Add("@Designation", SqlDbType.VarChar).Value = userItem.Designation;
                        cmd.Parameters.Add("@RoleId", SqlDbType.Int).Value = userItem.RoleId;
                        cmd.Parameters.Add("@Enabled", SqlDbType.Bit).Value = userItem.Enabled ? 1 : 0;

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
                   , CommandType.StoredProcedure, "usp_GetUserDetails");
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
                        entities.Enabled = Convert.ToBoolean(dr["Enabled"]);
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
            DataSet ds = dbHelper.GetDatasetFromSP("usp_GetUser", sqlParams);
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    userInfo.Password = ds.Tables[0].Rows[0].ItemArray.GetValue(2).ToString();
                }
            }
            return userInfo;
            
        }

    }
}