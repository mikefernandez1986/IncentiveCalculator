using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ServiceModel;

namespace IncentiveCalcWcfLib
{

    [ServiceContract]
    public interface IIncentiveCalcData
    {
        [OperationContract]
        string CreateCumulativePayout();

        [OperationContract]
        string CreateProductPayout(string ProductCode);

        [OperationContract]
        string CreateEmpPayout(string EmpNo);

        [OperationContract]
        void UploadDataFile(string fileType, string fileName, bool processDataFlag);

        [OperationContract]
        void ProcessDataFile(string fileType);

       // [OperationContract]
        //void AccumulateRetainedLoyaltyAmounts(Boolean ReprocessFlag);

    }
}
