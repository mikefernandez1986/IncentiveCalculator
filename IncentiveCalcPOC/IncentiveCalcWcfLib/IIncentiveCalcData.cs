using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ServiceModel;

using IncentiveCalcWcfLib.Entities;

namespace IncentiveCalcWcfLib
{

    [ServiceContract]
    public interface IIncentiveCalcData
    {
        [OperationContract]
        List<EmpPayoutEntity> GetCurrentMonthPayout(string productType);

        [OperationContract]
        void UploadDataFile(string fileType, string fileName, bool processDataFlag);

        [OperationContract]
        void ProcessDataFile(string fileType);

    }
}
