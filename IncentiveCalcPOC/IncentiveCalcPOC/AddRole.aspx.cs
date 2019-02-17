using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.BAOLayer;

namespace IncentiveCalcPOC
{
    public partial class AddRole : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AccessLvlDdl.DataSource = Enum.GetNames(typeof(AccessLevels));
            AccessLvlDdl.DataBind();
        }

        protected void AddRoleBtn_Click(object sender, EventArgs e)
        {
            UserRoleBAO BAO = new UserRoleBAO();
            AccessLevels accessLevelType = (AccessLevels)Enum.Parse(typeof(AccessLevels), AccessLvlDdl.SelectedValue);
            bool addStatus = BAO.AddRole(RoleNameTextBox.Text, RoleDescTextBox.Text, (int)accessLevelType);
            if (addStatus)
            {
                ResultLbl.Text = "Role " + RoleNameTextBox.Text + " added successfully.";
            }
            else
            {
                ResultLbl.Text = "Error adding role " + RoleNameTextBox.Text + ".";
            }


        }
    }
}