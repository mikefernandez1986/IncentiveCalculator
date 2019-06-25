using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.Entities;
using System.Configuration;

namespace IncentiveCalcPOC
{
    public partial class IncentiveCalc : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentPage = System.IO.Path.GetFileName(Request.Url.AbsolutePath);

            breadCrumbName.InnerText = Convert.ToString(ConfigurationManager.AppSettings[currentPage]);

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

                //1 --> Basic User,  2--> Admin, 3 --> Super Admin, 4 --> Download Admin, 5--> Upload Admin

                if(userInfo.Role.AccessLevelId != 1)
                {
                    UploadDownload.Style.Add("display", "block");
                    if(userInfo.Role.AccessLevelId == 2 || userInfo.Role.AccessLevelId == 3 || userInfo.Role.AccessLevelId == 4)
                    {
                        upload.Style.Add("display", "block");
                    }
                    if (userInfo.Role.AccessLevelId == 2 || userInfo.Role.AccessLevelId == 3 || userInfo.Role.AccessLevelId == 5)
                    {
                        download.Style.Add("display", "block");
                    }
                }

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