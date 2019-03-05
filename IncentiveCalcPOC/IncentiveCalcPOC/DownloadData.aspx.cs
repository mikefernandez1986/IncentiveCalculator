using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IncentiveCalcPOC.BAOLayer;
using System.Threading.Tasks;
using IncentiveCalcPOC.Entities;
using IncentiveCalcPOC.IncentiveCalcService;
using System.Globalization;

namespace IncentiveCalcPOC
{
    public partial class DownloadData : System.Web.UI.Page
    {
        FileUploaderBAO BAOFU = new FileUploaderBAO();
        DownloadBAO BAODL = new DownloadBAO();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            try
            {
                List<FileDetails> ddlFileDetails = new List<FileDetails>();
                ddlFileDetails = BAOFU.getFileTypes();
                foreach (FileDetails f in ddlFileDetails)
                {
                    ListItem item = new ListItem(f.FileTypeDesc, f.FileType.ToString());
                    //item.Selected = p.Selected;
                    ddlFileType.Items.Add(item);
                }
                ddlFileType.Items.Insert(0, new ListItem("All", "Cumulative"));

                
                th_ProductDetails.InnerHtml = "<tr><th>Employee No</th><th>Employee Name</th><th>Product</th><th>KPI Rating</th><th>Total Points</th><th>Propsed Pay Amount</th><th>Actual Pay Amount(75%)</th><th>Retained Amount(25%)</th></tr>";
                tb_ProductDetails.InnerHtml = BAODL.getFileDownloadDetails("Cumulative");
                spnproductName.InnerText = "Cumulative";
                prevmonth.InnerText = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(DateTime.Now.AddMonths(-1).Month);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btn_FileDownload_Click(object sender, EventArgs e)
        {
            try
            {
                prevmonth.InnerText = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(DateTime.Now.AddMonths(-1).Month);

                string FileType = ddlFileType.SelectedItem.Value;
                spnproductName.InnerText = FileType;
                if (FileType == "Cumulative")
                {
                    th_ProductDetails.InnerHtml = "<tr><th>Employee No</th><th>Employee Name</th><th>Product</th><th>KPI Rating</th><th>Total Points</th><th>Propsed Pay Amount</th><th>Actual Pay Amount(75%)</th><th>Retained Amount(25%)</th></tr>";
                }
                else
                {
                    th_ProductDetails.InnerHtml = "<tr><th>Employee No</th><th>Employee Name</th><th>Product</th><th>Achived Target Value</th><th>Target Status</th><th>Total Points</th><th>KPI Rating</th><th>Propsed Pay Amount</th><th>Actual Pay Amount(75%)</th><th>Retained Amount(25%)</th><th>Payout Code</th></tr>";
                }
                tb_ProductDetails.InnerHtml = BAODL.getFileDownloadDetails(FileType);
            }
            catch(Exception ex)
            {

            }
        }
    }
}