using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.ServiceModel;

namespace IncentiveCalcUtility
{
    class Program
    {
        static void Main(string[] args)
        {

            try
            {
                if (args.Count() == 0)
                {
                    throw new Exception("No arguments given.");
                }

                switch (args[0].ToUpper())
                {
                    case "UPLOAD":
                        ProcessUpload(args);
                        break;
                    case "CUML-PAYOUT":
                        ProcessCumulativePayout(args);
                        break;
                    case "ACCUM-RETAINED-AMT":
                        ProcessAccumulateRetainedAmts(args);
                        break;
                    default:
                        break;
                }

            }
            catch (Exception ex)
            {
                var appLog = new EventLog("Application");
                appLog.Source = "IncentiveCalcUtility";
                appLog.WriteEntry(ex.Message);
                //Console.WriteLine(ex.Message);
                //Console.ReadLine();
            }

        }

        static private void ProcessUpload(string[] args)
        {
            string destinationFolder = ConfigurationManager.AppSettings["DestinationFolder"];
            string fileName = System.IO.Path.GetFileNameWithoutExtension(args[2]) + "_" + DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss") + System.IO.Path.GetExtension(args[2]);
            System.IO.File.Move(args[2], destinationFolder + fileName);
            bool processDataFileFlag = IsProcessDataFile(args[1]);
            bool createPayoutFlag = IsCreatePayout(args[1]);
            IncentiveCalcSvcReference.IncentiveCalcDataClient incentiveCalcClient = new IncentiveCalcSvcReference.IncentiveCalcDataClient("BasicHttpBinding_IIncentiveCalcData");
            incentiveCalcClient.UploadDataFile(args[1], fileName, processDataFileFlag, createPayoutFlag);

        }

        static private void ProcessCumulativePayout(string[] args)
        {
            string destinationFolder = ConfigurationManager.AppSettings["DestinationFolder"];
            string fileName = System.IO.Path.GetFileNameWithoutExtension(args[1]) + "_" + DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss") + System.IO.Path.GetExtension(args[1]);
            System.IO.File.Move(args[1], destinationFolder + fileName);
            IncentiveCalcSvcReference.IncentiveCalcDataClient incentiveCalcClient = new IncentiveCalcSvcReference.IncentiveCalcDataClient("BasicHttpBinding_IIncentiveCalcData");
            incentiveCalcClient.CreateCumulativePayout();

        }

        static private void ProcessAccumulateRetainedAmts(string[] args)
        {
            string destinationFolder = ConfigurationManager.AppSettings["DestinationFolder"];
            string fileName = System.IO.Path.GetFileNameWithoutExtension(args[1]) + "_" + DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss") + System.IO.Path.GetExtension(args[1]);
            System.IO.File.Move(args[1], destinationFolder + fileName);
            IncentiveCalcSvcReference.IncentiveCalcDataClient incentiveCalcClient = new IncentiveCalcSvcReference.IncentiveCalcDataClient("BasicHttpBinding_IIncentiveCalcData");
            incentiveCalcClient.AccumulateRetainedLoyaltyAmounts(false);
        }

        static private bool IsProcessDataFile(string fileType)
        {
            string configProcess = System.Configuration.ConfigurationManager.AppSettings[fileType + "_Process"];
            if (configProcess.Contains("ProcessData"))
                return true;
            else
                return false;
        }

        static private bool IsCreatePayout(string fileType)
        {
            string configProcess = System.Configuration.ConfigurationManager.AppSettings[fileType + "_Process"];
            if (configProcess.Contains("CreatePayout"))
                return true;
            else
                return false;
        }

    }
}
