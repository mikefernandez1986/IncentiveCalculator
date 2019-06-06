using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IncentiveCalcPOC.Entities
{
    public class UserEntities
    {
        public int UserId { get; set; }
        public string Emp_No { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Designation { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public bool Enabled { get; set; }
        public string ProfilePicPath { get; set; }
        public DateTime LastUpdated { get; set; }
        public DateTime JoinDate { get; set; }
        public string Dept { get; set; }
        public string Division { get; set; }
        public string Branchname { get; set; }

        public RoleEntities Role { get; set; }

        public UserEntities()
        {
            Role = new RoleEntities();
        }
    }
}