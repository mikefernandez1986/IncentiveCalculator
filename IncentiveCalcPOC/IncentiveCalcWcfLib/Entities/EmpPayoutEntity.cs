using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IncentiveCalcWcfLib.Entities
{
    public class EmpPayoutEntity
    {
        public string EmployeeNo { get; set; }
        public string EmployeeName { get; set; }
        public string ProductType { get; set; }
        public char TargetAchvdFlag { get; set; }
        public int TotalPoints { get; set; }
        public decimal KPIRating { get; set; }
        public decimal ProposedPayoutAmt { get; set; }
        public decimal ActualPayoutAmt { get; set; }
        public decimal RetainedLoyaltyAmt { get; set; }
        public string PayoutCode { get; set; }
    }
}
