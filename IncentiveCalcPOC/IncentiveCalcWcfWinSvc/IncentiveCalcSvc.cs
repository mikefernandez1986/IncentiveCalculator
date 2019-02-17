using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Description;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace IncentiveCalcWcfWinSvc
{
    public partial class IncentiveCalcSvc : ServiceBase
    {
        private ServiceHost incentiveCalcSvcHost = null;

        public IncentiveCalcSvc()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            if (incentiveCalcSvcHost != null) incentiveCalcSvcHost.Close();

            string strAdrHTTP = "http://localhost:9001/IncentiveCalcService";

            Uri[] adrbase = { new Uri(strAdrHTTP)};
            incentiveCalcSvcHost = new ServiceHost(typeof(IncentiveCalcWcfLib.IncentiveCalcData), adrbase);

            ServiceMetadataBehavior mBehave = new ServiceMetadataBehavior();
            incentiveCalcSvcHost.Description.Behaviors.Add(mBehave);

            BasicHttpBinding httpb = new BasicHttpBinding();
            incentiveCalcSvcHost.AddServiceEndpoint(typeof(IncentiveCalcWcfLib.IIncentiveCalcData), httpb, strAdrHTTP);
            incentiveCalcSvcHost.AddServiceEndpoint(typeof(IMetadataExchange),
            MetadataExchangeBindings.CreateMexHttpBinding(), "mex");

            incentiveCalcSvcHost.Open();

        }

        protected override void OnStop()
        {
            if (incentiveCalcSvcHost != null)
            {
                incentiveCalcSvcHost.Close();
                incentiveCalcSvcHost = null;
            }
        }
    }
}
