using System;
using IncentiveCalcPOC.DAOLayer;
using IncentiveCalcPOC.Entities;
using System.Data;

namespace IncentiveCalcPOC.BAOLayer
{
    public class UserKPIInfoBAO
    {
        UserKPIInfoDAO DAO = new UserKPIInfoDAO();
        public Emp_Entities EmployeeDetails(string Emp_Id)
        {
            Emp_Entities Emp_Details = new Emp_Entities();
            try
            {
                Emp_Details = DAO.EmployeeDetails(Emp_Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Emp_Details;
        }
        public DataSet GetEmpInfoForDownload(string Emp_Id)
        {
            DataSet ds = new DataSet();
            try
            {
                ds = DAO.GetEmpInfoForDownload(Emp_Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ds;
        }
    }
}