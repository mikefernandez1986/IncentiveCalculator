using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IncentiveCalcPOC.Entities
{
    public class UserEntities
    {
        public int UserId { get; set; }
        public string EmailId { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Designation { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public bool Enabled { get; set; }
        public DateTime LastUpdated { get; set; }
    }
}