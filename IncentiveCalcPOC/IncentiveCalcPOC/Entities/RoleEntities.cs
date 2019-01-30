using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IncentiveCalcPOC.Entities
{
    public class RoleEntities
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public int AccessLevelId { get; set; }
        public string AccessLevelName { get; set; }
    }
}