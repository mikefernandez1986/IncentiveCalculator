using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.BAOLayer;
using IncentiveCalcPOC.Entities;
using IncentiveCalcPOC.Helpers;
using System.Configuration;

namespace IncentiveCalcPOC
{
    public partial class LoginPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InvalidLoginLbl.Visible = false;
            
        }

        protected void LoginBtn_Click(object sender, EventArgs e)
        {
            UserRoleBAO BAO = new UserRoleBAO();
            bool AuthenticateAD = Convert.ToBoolean(ConfigurationManager.AppSettings["AuthenticateAD"]);
            if (AuthenticateAD)
            {
                DirectoryIdentity ID = new DirectoryIdentity(EmailTxtBox.Text, PwdTxtBox.Text);
                if (ID.IsAuthenticated)
                {
                    string EmpName = ID.Name;
                    UserEntities userDetails = new UserEntities();
                    userDetails = BAO.ValidatebyAD(EmpName);
                    if(userDetails != null)
                    {
                        Session.Add("User", userDetails);
                        Response.Redirect("Dashboard.aspx");
                    }                    
                }
                else
                {
                    InvalidLoginLbl.Visible = true;
                }
                
            }
            else
            {
                
                UserEntities validUser = BAO.ValidateAndGetUser(EmailTxtBox.Text, PwdTxtBox.Text);
                if (validUser != null)
                {
                    Session.Add("User", validUser);
                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    InvalidLoginLbl.Visible = true;
                }
            }
            
            
        }

    }
}