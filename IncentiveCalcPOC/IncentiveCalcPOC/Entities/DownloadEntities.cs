using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IncentiveCalcPOC.Entities
{
    public class DownloadEntities
    {
        public string emp_No { get; set; }
        public string emp_Name { get; set; }
        public string Product { get; set; }
        public string AchievedTarget { get; set; }
        public string TargetStatus { get; set; }
        public double TotalPoints { get; set; }
        public double KPIRating { get; set; }
        public double PropsedPayAmount { get; set; }
        public double ActualPayAmount { get; set; }
        public double RetainedLoyalityAmt { get; set; }
        public string PAYOUTCODE { get; set; }

    }
}