using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


using IncentiveCalcWcfLib.Entities;
using IncentiveCalcWcfLib.BAOLayer;

namespace IncentiveCalcWcfLib
{
    public class IncentiveCalcData : IIncentiveCalcData
    {
        FileUploaderBAO bao = new FileUploaderBAO();
        public List<EmpPayoutEntity> GetCurrentMonthPayout(string productType)
        {
            PayoutBAO bao = new PayoutBAO();
            return bao.GetEmpPayoutDetails(productType);
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

        private async Task<bool> ProcessFilesAsync(string FileType)
        {
            var processFiles = Task.Run(() => bao.ProcessDataFiles(FileType));
            var response = await processFiles;
            return Convert.ToBoolean(response);
        }

        private async Task<bool> UploadFilesAsync(string fileType, string fileName)
        {
            string filePath = GetConfigFilePath(fileType);
            string sheetName = GetConfigSheetName(fileType);

            var uploadFiles = Task.Run(() => bao.UploadFile(fileName, filePath, sheetName, fileType.ToUpper()));
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
