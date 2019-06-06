using IncentiveCalcPOC.BAOLayer;
using IncentiveCalcPOC.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace IncentiveCalcPOC
{
    public partial class EmployeeDetails : System.Web.UI.Page
    {
        GetUserBasicInfoBAO BAO = new GetUserBasicInfoBAO();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;
            if (Session["USER"] != null)
            {
                UserEntities userInfo = (UserEntities)Session["USER"];
                UserEntities EmpBasicInfo = new UserEntities();
                EmpBasicInfo = BAO.GetEmpInfoyEmpId(userInfo.Emp_No);
                txt_EmpNo.Text = Convert.ToString(EmpBasicInfo.Emp_No);
                txt_EmpName.Text = Convert.ToString(EmpBasicInfo.FirstName);
                txt_DOJ.Text = Convert.ToString(String.Format("{0:d}", EmpBasicInfo.JoinDate));
                txt_Role.Text = Convert.ToString(EmpBasicInfo.RoleName);
                txt_dept.Text = Convert.ToString(EmpBasicInfo.Dept);
                txt_Div.Text = Convert.ToString(EmpBasicInfo.Division);
                txt_Branch.Text = Convert.ToString(EmpBasicInfo.Branchname);
            }

        }
        protected void btnImg_Click(object sender, EventArgs e)
        {
            if (Session["USER"] != null)
            {
                UserEntities userInfo = (UserEntities)Session["USER"];
                btn_ImgUpload.Enabled = false;
                try
                {
                    if (ImgFu.HasFile)
                    {
                        if (System.IO.Path.GetExtension(ImgFu.PostedFile.FileName) == ".png" || System.IO.Path.GetExtension(ImgFu.PostedFile.FileName) == ".jpeg" || System.IO.Path.GetExtension(ImgFu.PostedFile.FileName) == ".jpg")
                        {
                            string path = string.Concat(Server.MapPath("~/IncentiveInfo/ProfileImages/" + ImgFu.FileName));
                            ImgFu.SaveAs(path);
                            bool IsImgUploaded = BAO.UpdateProfilePic(ImgFu.FileName, userInfo.Emp_No);
                            UserEntities NewSession = new UserEntities();
                            NewSession = userInfo;
                            NewSession.ProfilePicPath = ImgFu.FileName;
                            Session.Clear();
                            Session.Add("USER", NewSession);
                            Response.Redirect("EmployeeDetails.aspx");
                        }
                    }
                }
                catch (Exception ex)
                {

                }
                finally
                {
                    btn_ImgUpload.Enabled = true;
                }
            }
        }
    }
}