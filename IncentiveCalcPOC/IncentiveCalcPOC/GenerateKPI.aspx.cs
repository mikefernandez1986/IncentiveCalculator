using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.BAOLayer;

namespace IncentiveCalcPOC
{
    public partial class GenerateKPI : System.Web.UI.Page
    {
        FileUploaderBAO BAO = new FileUploaderBAO();
        KPIBAO KPI_BAO = new KPIBAO();
        protected void Page_Load(object sender, EventArgs e)
        {
            tb_KPIDetails.InnerHtml = KPI_BAO.getFileUploadDetails();
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                if (System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName) == ".xls")
                {
                    try
                    {

                        string path = string.Concat(Server.MapPath("~/IncentiveInfo/" + FileUpload1.FileName));
                        FileUpload1.SaveAs(path);

                      //  bool UploadFile = BAO.UploadFile(FileUpload1.FileName, path, ddlFileType.SelectedValue);

                        ///UploadDetails.Text = "File Uploaded Successfully";

                    }

                    catch (Exception ex)
                    {
                       // UploadDetails.Text = ex.Message;
                    }
                }
                else
                {
                   // UploadDetails.Text = "Invalid file format. Please upload .xls files.";
                }

            }
        }
    }
}