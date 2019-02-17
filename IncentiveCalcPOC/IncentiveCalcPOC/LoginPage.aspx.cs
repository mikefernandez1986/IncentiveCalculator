using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.BAOLayer;
using IncentiveCalcPOC.Entities;

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
            UserEntities validUser = BAO.ValidateAndGetUser(EmailTxtBox.Text, PwdTxtBox.Text);
            if (validUser != null)
            {
                Session.Add("User", validUser);
                Response.Redirect("UploadInfo.aspx"); 
            }
            else
            {
                
                InvalidLoginLbl.Visible = true;
            }
            
        }

    }
}