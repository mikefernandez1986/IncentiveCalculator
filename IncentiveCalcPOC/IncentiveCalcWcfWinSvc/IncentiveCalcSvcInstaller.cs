using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Linq;
using System.ServiceProcess;
using System.Threading.Tasks;



namespace IncentiveCalcWcfWinSvc
{
    [RunInstaller(true)]
    public partial class IncentiveCalcSvcInstaller : System.Configuration.Install.Installer
    {
        public IncentiveCalcSvcInstaller()
        {
            serviceProcessInstaller1 = new ServiceProcessInstaller();
            serviceProcessInstaller1.Account = ServiceAccount.LocalSystem;
            serviceInstaller1 = new ServiceInstaller();
            serviceInstaller1.ServiceName = "WinSvcHostedIncentiveCalcService";
            serviceInstaller1.DisplayName = "WinSvcHostedIncentiveCalcService";
            serviceInstaller1.Description = "WCF Incentive Calculator Service Hosted by Windows Service";
            serviceInstaller1.StartType = ServiceStartMode.Manual;
            Installers.Add(serviceProcessInstaller1);
            Installers.Add(serviceInstaller1);
        }
    }
}
