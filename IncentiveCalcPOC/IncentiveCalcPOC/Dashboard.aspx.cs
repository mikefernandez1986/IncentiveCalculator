using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using IncentiveCalcPOC.BAOLayer;
using IncentiveCalcPOC.Entities;

namespace IncentiveCalcPOC
{
    public partial class Dashboard : System.Web.UI.Page
    {
        static UserKPIInfoBAO BAO = new UserKPIInfoBAO();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["USER"] != null)
            {
                UserEntities userInfo = (UserEntities)Session["USER"];
                Emp_Entities Emp_Details = new Emp_Entities();
                Emp_Details = GetEmpInfo(userInfo.Emp_No);
                Cache.Insert("EmpDetails", Emp_Details, null, DateTime.MaxValue, TimeSpan.FromMinutes(10));
                dvTotalPoints.InnerText = Convert.ToString(Emp_Details.Emp_TotalPoints);
                dvAvgKPI.InnerText = achivedData_KPI.Value = Convert.ToString(Emp_Details.Emp_KPIRating);
                dvPayout.InnerText = Convert.ToString(Emp_Details.Emp_ActualPayoutAmount);
                dvRetention.InnerText = Convert.ToString(Emp_Details.Emp_RetainedPayoutAmount);
                achivedData_value.Value = string.Join(", ", from item in Emp_Details.EMP_AchievedInfo select item.value);
                achivedData_color.Value = string.Join(", ", from item in Emp_Details.EMP_AchievedInfo select item.color);
                achivedData_labels.Value = string.Join(", ", from item in Emp_Details.EMP_AchievedInfo select item.label);

                targetData_value.Value = string.Join(", ", from item in Emp_Details.Emp_TargetInfo select item.value);
                targetData_color.Value = string.Join(", ", from item in Emp_Details.Emp_TargetInfo select item.color);
                targetData_labels.Value = string.Join(", ", from item in Emp_Details.Emp_TargetInfo select item.label);

                targetData_Plan.Value = Convert.ToString(Emp_Details.Emp_Plan);
            }
        }

        
        public static Emp_Entities GetEmpInfo(string Emp_No)
        {
            try
            {
                string Emp_Id = Emp_No;
                Emp_Entities Emp_Details = new Emp_Entities();
                Emp_Details = BAO.EmployeeDetails(Emp_Id);
                return Emp_Details;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [WebMethod]
        public static bool GetIncentiveInfo()
        {
           return true;
        }
    }
}