using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.BAOLayer;

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
            bool validUser = BAO.ValidateUser(EmailTxtBox.Text, PwdTxtBox.Text);
            if (validUser)
            {
                //redirect to master page
                Response.Redirect("GenerateKPI.aspx"); //redirect to master page
            }
            else
            {
                
                InvalidLoginLbl.Visible = true;
            }
            
        }

    }
}