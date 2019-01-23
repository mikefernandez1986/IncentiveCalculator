using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IncentiveCalcPOC.Entities
{
    public class KPIEntities
    {
        public int CASAID { get; set; }
        public string EmployeeCode { get; set; }
        public string EmployeeName { get; set; }        
        public int PerformanceScore { get; set; }
        public int KPIRating { get; set; }
    }
}