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
using System.Windows;
using System.Configuration;

namespace IncentiveCalcPOC
{
    public partial class UploadInfo : System.Web.UI.Page
    {
        FileUploaderBAO BAO = new FileUploaderBAO();
        KPIBAO KPI_BAO = new KPIBAO();
        IncentiveCalcDataClient client = new IncentiveCalcDataClient();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            try
            {
                List<FileDetails> ddlFileDetails = new List<FileDetails>();
                ddlFileDetails = BAO.getFileTypes();
                foreach (FileDetails f in ddlFileDetails)
                {
                    ListItem item = new ListItem(f.FileTypeDesc,f.FileType.ToString());
                    //item.Selected = p.Selected;
                    ddlFileType.Items.Add(item);
                }
                tb_KPIDetails.InnerHtml = KPI_BAO.getFileUploadDetails();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            
           // ScriptManager1.RegisterAsyncPostBackControl(btn_FileUpload);
        }

        protected void btn_Refresh_Click(object sender, EventArgs e)
        {
            try
            {
                tb_KPIDetails.InnerHtml = KPI_BAO.getFileUploadDetails();
            }
            catch(Exception ex)
            {

            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            btn_FileUpload.Enabled = false;
            try
            {
                if (FileUpload1.HasFile)
                {
                    if (System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName) == ".xls" || System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName) == ".xlsx")
                    {
                        try
                        {

                            string path = string.Concat(Server.MapPath("~/IncentiveInfo/" + FileUpload1.FileName));
                            FileUpload1.SaveAs(path);
                            //var upload = await UploadFilesAsync(ddlFileType.SelectedItem.Value, FileUpload1.FileName).ConfigureAwait(false);
                            client = new IncentiveCalcDataClient();
                            client.UploadDataFile(ddlFileType.SelectedItem.Value, FileUpload1.FileName, true, true);

                           // var a =  await ProcessFilesAsync(ddlFileType.SelectedItem.Value).ConfigureAwait(false); 
                            //Task.WaitAll(Task.Run(async () => await ProcessFilesAsync(ddlFileType.SelectedItem.Value)));
                            // UploadDetails.Text = "File Uploaded Successfully!! Processing the file in background";

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
            catch (Exception ex)
            {

            }
            finally
            {
                btn_FileUpload.Enabled = true;
            }
            
        }


        private async Task<bool> UploadFilesAsync(string fileType, string fileName)
        {
            string filePath = GetConfigFilePath(fileType);
            string sheetName = GetConfigSheetName(fileType);

            var uploadFiles = Task.Run(() => BAO.UploadFile(fileName, filePath, sheetName, fileType.ToUpper()));
            var response = await uploadFiles;
            return Convert.ToBoolean(response);
        }


        private string GetConfigFilePath(string FileType)
        {
            string keyStr = FileType + "_FileLocation";
            string filePath = ConfigurationManager.AppSettings[keyStr];
            return filePath;
        }

        private string GetConfigSheetName(string FileType)
        {
            string keyStr = FileType + "_SheetName";
            string sheetName = ConfigurationManager.AppSettings[keyStr];
            return sheetName;
        }

        public async Task<bool> ProcessFilesAsync(string FileType)
        {
            bool response = false;
            try
            {
                client = new IncentiveCalcDataClient();
                var processFiles = Task.Run(() => client.ProcessDataFile(FileType));
                var updateInfo = Task.Run(() => KPI_BAO.getFileUploadDetails());
                await processFiles;
                tb_KPIDetails.InnerHtml = Convert.ToString(await updateInfo);

                response = true;
            }
            catch (Exception ex)
            {
                response = false;
            }

            return Convert.ToBoolean(response);
        }
    }
}