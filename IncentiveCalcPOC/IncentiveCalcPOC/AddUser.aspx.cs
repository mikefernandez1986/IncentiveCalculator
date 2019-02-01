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
    public partial class AddUser : System.Web.UI.Page
    {
        UserRoleBAO BAO = new UserRoleBAO();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Populate role ddl
                PopulateRoles();
                ResultLbl.Text = "";
            }
            //ContentPlaceHolder1.
        }

        private void PopulateRoles()
        {
            List<RoleEntities> roleList = new List<RoleEntities>();
            roleList = BAO.GetRoles();
            RoleDdl.DataSource = roleList;
            RoleDdl.DataTextField = "RoleName";
            RoleDdl.DataValueField = "RoleId";
            RoleDdl.DataBind();
        }

        protected void AddUserBtn_Click(object sender, EventArgs e)
        {
            string profilePicFileName = "";
            if (ProfilePicFileUpld.HasFile)
            {
                profilePicFileName = ProfilePicFileUpld.PostedFile.FileName;
            }
            bool isActive = Convert.ToBoolean(IsActiveRadioBtnList.Items[IsActiveRadioBtnList.SelectedIndex].Value) ? true : false; //Yes button true or false?
            AddUserResultCode addResult = BAO.AddUser(EmailTxtBox.Text, PwdTxtBox.Text, FirstNameTxtBox.Text, LastNameTxtBox.Text, DesignationTxtBox.Text, Convert.ToInt32(RoleDdl.SelectedValue), profilePicFileName, isActive);
            if (addResult == AddUserResultCode.Success)
            {
                ResultLbl.Text = "User " + EmailTxtBox.Text + " added successfully.";
                if (ProfilePicFileUpld.HasFile)
                {
                    string savePath = string.Concat(Server.MapPath("~/IncentiveInfo/ProfileImages/" + ProfilePicFileUpld.FileName));
                    ProfilePicFileUpld.SaveAs(savePath);
                }
            }
            else if (addResult == AddUserResultCode.UserAlreadyExists)
            {
                ResultLbl.Text = "User " + EmailTxtBox.Text + " already exists.";
            }
            else
            {
                ResultLbl.Text = "Error adding user " + EmailTxtBox.Text + ".";
            }
        }

    }
}