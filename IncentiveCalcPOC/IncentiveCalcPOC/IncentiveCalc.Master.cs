using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.Entities;

namespace IncentiveCalcPOC
{
    public partial class IncentiveCalc : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["USER"] == null)
            {
                Response.Redirect("LoginPage.aspx", false);
            }
            else
            {
                UserEntities userInfo = (UserEntities)Session["USER"];
                if (userInfo.ProfilePicPath.Trim() != "")
                {
                    ProfileImage.ImageUrl = "IncentiveInfo\\ProfileImages\\" + userInfo.ProfilePicPath;
                }
                UserNameLabel.Text = userInfo.FirstName ;
                DesignationLabel.Text = userInfo.Designation;

                //Load user info
            }
        }

        protected void OnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("LoginPage.aspx");
        }
    }
}