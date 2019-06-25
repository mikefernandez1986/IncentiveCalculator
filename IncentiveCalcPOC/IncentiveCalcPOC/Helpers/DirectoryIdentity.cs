using System;
using System.DirectoryServices;
using System.Security.Principal;

namespace IncentiveCalcPOC.Helpers
{
    public class DirectoryIdentity : IIdentity
    {

        #region Internal Fields
        internal string name;
        private string path;
        private bool auth;
        #endregion

        #region Constructors
        public DirectoryIdentity(string userName, string password) : this(null, userName, password) { }

        public DirectoryIdentity(string path, string userName, string password)
        {
            DirectoryEntry de = new DirectoryEntry(path, userName, password);
            try
            {
                object o = de.NativeObject;
                DirectorySearcher ds = new DirectorySearcher(de);
                if (userName.Contains("\\"))
                    userName = userName.Substring(userName.IndexOf("\\") + 1);
                ds.Filter = "samaccountname=" + userName;
                ds.PropertiesToLoad.Add("cn");
                SearchResult sr = ds.FindOne();
                if (sr == null) throw new Exception();
                this.name = userName;
                this.path = sr.Path;
                auth = true;
            }
            catch
            {
                auth = false;
            }
        }
        #endregion

        #region Methods and Overrides
        #endregion

        #region Properties and Events
        public string AuthenticationType
        {
            get { return null; }
        }

        public string GivenName
        {
            get { return Name.Substring(0, Name.IndexOf(' ')); }
        }

        public bool IsAuthenticated
        {
            get { return auth; }
        }

        public string Name
        {
            get
            {
                int i = path.IndexOf('=') + 1, j = path.IndexOf(',');
                return path.Substring(i, j - i);
            }
        }
        #endregion
    }

    public class DirectoryPrincipal : IPrincipal
    {

        #region Internal Fields
        private DirectoryIdentity di;
        #endregion

        #region Constructors
        public DirectoryPrincipal(DirectoryIdentity di)
        {
            this.di = di;
        }
        #endregion

        #region Methods and Overrides
        public bool IsInRole(string role)
        {
            try
            {
                role = role.ToLowerInvariant();
                DirectorySearcher ds = new DirectorySearcher(new DirectoryEntry(null));
                ds.Filter = "samaccountname=" + di.name;
                SearchResult sr = ds.FindOne();
                DirectoryEntry de = sr.GetDirectoryEntry();
                PropertyValueCollection dir = de.Properties["memberOf"];
                for (int i = 0; i < dir.Count; ++i)
                {
                    string s = dir[i].ToString().ToLowerInvariant();
                    s = s.Substring(3, s.IndexOf(',') - 3);
                    if (s == role) return true;
                }
                throw new Exception();
            }
            catch
            {
                return false;
            }
        }
        #endregion

        #region Properties and Events
        public IIdentity Identity
        {
            get { return di; }
        }
        #endregion
    }
}