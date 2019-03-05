using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace IncentiveCalcPOC.Entities
{
    public class Emp_Entities
    {
        public List<IncentiveSourceEntities> Emp_TargetInfo { get; set; }

        public List<IncentiveSourceEntities> EMP_AchievedInfo { get; set; }

        public string Emp_No { get; set; }
        public string Emp_Name { get; set; }
        public string Emp_Plan { get; set; }
        public string Emp_Product { get; set; }
        public decimal Emp_KPIRating { get; set; }
        public double Emp_TotalPoints { get; set; }
        public double Emp_ProposedPayoutAmount { get; set; }
        public double Emp_ActualPayoutAmount { get; set; }
        public double Emp_RetainedPayoutAmount { get; set; }
    }
}