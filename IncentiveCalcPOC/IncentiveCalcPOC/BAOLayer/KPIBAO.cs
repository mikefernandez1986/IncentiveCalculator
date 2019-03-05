using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using IncentiveCalcPOC.DAOLayer;
using IncentiveCalcPOC.Entities;
using System.Text;

namespace IncentiveCalcPOC.BAOLayer
{
    public class KPIBAO
    {
        KPIDetailsDAO DAO = new KPIDetailsDAO();

        public string getFileUploadDetails()
        {
            string KPIHtml = "";
            try
            {
                List<UploadDetails> uploadDetails = new List<UploadDetails>();
                uploadDetails = DAO.getFileUploadInfo();
                KPIHtml = getTableBody(uploadDetails, x => x.FileId, x => x.FileName, x => x.FileType, x => x.DateCreated,  x => x.ProcessedTime, x => x.StatusDesc);
            }
            catch(Exception ex)
            {
                throw ex;
            }
            return KPIHtml;
        }

        private static string getTableBody<T>(IEnumerable<T> list, params Func<T, object>[] fxns)
        {

            StringBuilder sb = new StringBuilder();
            foreach (var item in list)
            {
                sb.Append("<TR>\n");
                foreach (var fxn in fxns)
                {
                    sb.Append("<TD>");
                    sb.Append(fxn(item));
                    sb.Append("</TD>");
                }
                sb.Append("</TR>\n");
            }

            return sb.ToString();
        }
    }
}