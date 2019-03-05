using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace IncentiveCalcPOC
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        void Application_BeginRequest(object sender, EventArgs e)
        {
            String fullOrigionalpath = Request.Url.ToString();
            String[] sElements = fullOrigionalpath.Split('/');
            String[] sFilePath = sElements[sElements.Length - 1].Split('.');
           // String[] sQueryString = sElements[sElements.Length - 1].Split('?');

            if (!fullOrigionalpath.Contains(".aspx") && sFilePath.Length == 1)
            {
                if (!string.IsNullOrEmpty(sFilePath[0].Trim()))
                {
                    //if(sQueryString.Length == 1)
                    //{
                        Context.RewritePath(sFilePath[0] + ".aspx");
                    //}
                    //else
                    //{
                    //    Context.RewritePath(sFilePath[0] + ".aspx?" + sQueryString[0]);
                    //}
                }
                    
            }
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}