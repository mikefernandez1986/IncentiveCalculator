using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using IncentiveCalcPOC.DAOLayer;
using IncentiveCalcPOC.Entities;
using System.Text;


namespace IncentiveCalcPOC.BAOLayer
{
    public class GetUserBasicInfoBAO
    {
        GetUserBasicInfoDAO DAO = new GetUserBasicInfoDAO();

        public UserEntities GetEmpInfoyEmpId(string Emp_Id)
        {
            UserEntities UserInfo = new UserEntities();

            try
            {
                UserInfo = DAO.GetEmpInfoyEmpId(Emp_Id);
            }
            catch (Exception ex)
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
                isUpdated = DAO.UpdateProfilePic(FilePath, EmpId);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isUpdated;
        }
    }
}