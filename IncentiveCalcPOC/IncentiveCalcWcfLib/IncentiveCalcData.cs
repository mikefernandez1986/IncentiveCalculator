using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


using IncentiveCalcWcfLib.BAOLayer;

namespace IncentiveCalcWcfLib
{
    public class IncentiveCalcData : IIncentiveCalcData
    {
        FileUploaderBAO UploadBao = new FileUploaderBAO();
        FileDownloadBAO payoutBAO = new FileDownloadBAO();

        public string CreateCumulativePayout()
        {
            return payoutBAO.CreateCumulativePayoutFile();
        }


        public string CreateProductPayout(string ProductCode)
        {
            return payoutBAO.CreateProductPayoutFile(ProductCode);
        }

        
        public string CreateEmpPayout(string EmpNo)
        {
            return payoutBAO.CreateEmpPayoutFile(EmpNo);
        }


        public void UploadDataFile(string fileType, string fileName, bool processDataFlag)
        {

            var uploadTaskOutput = UploadFilesAsync(fileType, fileName);
    
            if (processDataFlag)
            {
                ProcessDataFile(fileType);
            }

        }

        public void ProcessDataFile(string FileType)
        {
            var ProcessTaskOutput = ProcessFilesAsync(FileType.ToUpper());
        }

        //public void AccumulateRetainedLoyaltyAmounts(Boolean ReprocessFlag)
        //{
        //    //To do
        //}


        private async Task<bool> ProcessFilesAsync(string FileType)
        {
            var processFiles = Task.Run(() => UploadBao.ProcessDataFiles(FileType));
            var response = await processFiles;
            return Convert.ToBoolean(response);
        }

        private async Task<bool> UploadFilesAsync(string fileType, string fileName)
        {
            string filePath = GetConfigFilePath(fileType);
            string sheetName = GetConfigSheetName(fileType);

            var uploadFiles = Task.Run(() => UploadBao.UploadFile(fileName, filePath, sheetName, fileType.ToUpper()));
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
    }
}
