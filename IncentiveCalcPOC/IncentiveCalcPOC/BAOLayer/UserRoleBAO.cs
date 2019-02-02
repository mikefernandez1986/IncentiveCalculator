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

    public enum AddUserResultCode
    {
        Success = 1,
        UserAlreadyExists = 2,
        Other = 3
    }
    public class UserRoleBAO
    {
        UserRoleDetailsDAO DAO = new UserRoleDetailsDAO();
        public bool AddRole(string roleName, string roleDesc, int accessLevel)
        {
            bool addStatus = false;
            RoleEntities role = new RoleEntities();
            role.RoleName = roleName;
            role.RoleDesc = roleDesc;
            role.AccessLevelId = accessLevel;
            addStatus = DAO.AddRole(role);
            return addStatus;
        }

        public AddUserResultCode AddUser(string emailId, string password, string firstName, string lastName, string designation, int roleId, string profilePicPath, bool enabled)
        {
            AddUserResultCode addUserResult = AddUserResultCode.Other;

            UserEntities user = DAO.GetUser(emailId);
            if (user.EmailId != null)
            {
                addUserResult = AddUserResultCode.UserAlreadyExists;

            }
            else
            { 
                user = new UserEntities();
                user.EmailId = emailId.Trim();
                user.Password = new HashHelper().CreateHashWithSalt(password);
                user.FirstName = firstName.Trim();
                user.LastName = lastName.Trim();
                user.Designation = designation.Trim();
                user.RoleId = roleId;
                user.ProfilePicPath = profilePicPath;
                user.Enabled = enabled;
                if (DAO.AddUser(user))
                {
                    addUserResult = AddUserResultCode.Success;
                }
            }
            return addUserResult;
        }

        public List<RoleEntities> GetRoles()
        {
            return DAO.GetRoles();
        }

        public List<UserEntities> GetUsers()
        {
            return DAO.GetUsers();
        }

        public UserEntities ValidateAndGetUser(string emailStr, string pwdStr)
        {
            UserEntities userInfo = DAO.GetUser(emailStr);
            HashHelper hashHelper = new HashHelper();
            if (hashHelper.CompareHash(pwdStr, userInfo.Password))
            {
                return userInfo;
            }
            else
            {
                return null;
            }
        }
    }

}