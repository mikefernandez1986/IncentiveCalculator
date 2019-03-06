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
        FileUploaderBAO uploadBAO = new FileUploaderBAO();
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


        public void UploadDataFile(string fileType, string fileName, bool processDataFlag, bool createPayoutFlag)
        {

            if (processDataFlag)
            {
                var uploadAndProcessTaskOutput = UploadAndProcessFilesAsync(fileType, fileName, createPayoutFlag);
            }
            else
            {
                var uploadTaskOutput = UploadFilesAsync(fileType, fileName);
            }

        }

        public void ProcessDataFile(string FileType)
        {
            var ProcessTaskOutput = ProcessFilesAsync(FileType.ToUpper());
        }

        public void AccumulateRetainedLoyaltyAmounts(bool ReprocessFlag)
        {
            uploadBAO.AccumulateRetainedLoyaltyAmounts(ReprocessFlag);
        }


        private async Task<bool> ProcessFilesAsync(string FileType)
        {
            var processFiles = Task.Run(() => uploadBAO.ProcessDataFiles(FileType));
            var response = await processFiles;
            return Convert.ToBoolean(response);
        }

        private async Task<bool> UploadFilesAsync(string fileType, string fileName)
        {
            string filePath = GetConfigFilePath(fileType);
            string sheetName = GetConfigSheetName(fileType);

            var uploadFiles = Task.Run(() => uploadBAO.UploadFile(fileName, filePath, sheetName, fileType.ToUpper()));
            var response = await uploadFiles;
            return Convert.ToBoolean(response);
        }


        private async Task<bool> UploadAndProcessFilesAsync(string FileType, string fileName, bool createPayoutFlag)
        {
            string filePath = GetConfigFilePath(FileType);
            string sheetName = GetConfigSheetName(FileType);

            var uploadFiles = Task.Run(() => uploadBAO.UploadFile(fileName, filePath, sheetName, FileType.ToUpper()));
            bool uploadResponse = await uploadFiles;

            if (uploadResponse == true)
            {
                var processFiles = Task.Run(() => uploadBAO.ProcessDataFiles(FileType.ToUpper()));
                bool processResponse = await processFiles;

                if (processResponse == true)
                {
                    if (createPayoutFlag == true)
                    {
                        CreateProductPayout(FileType);
                    }
                }

                return Convert.ToBoolean(processResponse);
            }
            else
            {
                return uploadResponse;
            }
            
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
