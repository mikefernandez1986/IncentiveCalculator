using System;
using IncentiveCalcPOC.DAOLayer;
using IncentiveCalcPOC.Entities;

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
    }
}