using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using IncentiveCalcWcfLib.Entities;
using IncentiveCalcWcfLib.DAOLayer;

namespace IncentiveCalcWcfLib.BAOLayer
{
    public class PayoutBAO
    {
        public List<EmpPayoutEntity> GetEmpPayoutDetails(string productType)
        {
            EmpPayoutDAO dao = new EmpPayoutDAO();
            return dao.GetEmpPayoutDetails(productType);
        }
    }
}
