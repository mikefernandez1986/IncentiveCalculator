using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using IncentiveCalcPOC.DAOLayer;
using IncentiveCalcPOC.Entities;
using IncentiveCalcPOC.Helpers;

namespace IncentiveCalcPOC.BAOLayer
{
    public enum AccessLevels
    {
        Basic = 1,
        Admin = 2,
        SuperAdmin = 3
    }

    public class UserRoleBAO
    {
        UserRoleDetailsDAO DAO = new UserRoleDetailsDAO();
        public bool AddRole(string roleName, int accessLevel)
        {
            bool addStatus = false;
            RoleEntities role = new RoleEntities();
            role.RoleName = roleName;
            role.AccessLevelId = accessLevel;
            DAO.AddRole(role);
            return addStatus;
        }

        public bool AddUser(string emailId, string firstName, string lastName, string designation, int roleId, bool enabled)
        {
            bool addStatus = false;
            UserEntities user = new UserEntities();
            user.EmailId = emailId;
            user.FirstName = firstName;
            user.LastName = lastName;
            user.Designation = designation;
            user.RoleId = roleId;
            user.Enabled = enabled;
            DAO.AddUser(user);
            return addStatus;
        }

        public List<RoleEntities> GetRoles()
        {
            return DAO.GetRoles();
        }

        public List<UserEntities> GetUsers()
        {
            return DAO.GetUsers();
        }

        public bool ValidateUser(string emailStr, string pwdStr)
        {
            UserEntities userInfo = DAO.GetUser(emailStr);
            HashHelper hashHelper = new HashHelper();
            if (hashHelper.CompareHash(pwdStr, userInfo.Password))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }

}