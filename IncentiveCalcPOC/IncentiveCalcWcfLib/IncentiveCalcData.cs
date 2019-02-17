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
            string filePath = GetConfigFilePath(fileType);

            bao.UploadFile(fileName, filePath, fileType.ToUpper());
    
            if (processDataFlag)
            {
                ProcessDataFile(fileType);
            }

        }

        public void ProcessDataFile(string FileType)
        {
            var output = ProcessFilesAsync(FileType.ToUpper());
        }

        private async Task<bool> ProcessFilesAsync(string FileType)
        {
            var processFiles = Task.Run(() => bao.ProcessDataFiles(FileType));
            var response = await processFiles;
            return Convert.ToBoolean(response);
        }


        private string GetConfigFilePath(string FileType)
        {
            string keyStr = FileType + "_FileLocation";
            string filePath = ConfigurationManager.AppSettings[keyStr];
            return filePath;
        }

    }
}
