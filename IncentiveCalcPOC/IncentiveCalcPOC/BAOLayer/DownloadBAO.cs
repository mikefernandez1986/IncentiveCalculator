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
    public class DownloadBAO
    {
        DownloadDAO DAO = new DownloadDAO();
        public string getFileDownloadDetails(string FileType)
        {
            string KPIHtml = "";
            try
            {
                List<DownloadEntities> uploadDetails = new List<DownloadEntities>();
                uploadDetails = DAO.GetINCInfo(FileType);
                if(FileType != "Cumulative")
                {
                    KPIHtml = getTableBody(uploadDetails, x => x.emp_No, x => x.emp_Name, x => x.Product, x => x.AchievedTarget,
                                                      x => x.TargetStatus, x => x.TotalPoints, x => x.KPIRating, x => x.PropsedPayAmount,
                                                      x => x.ActualPayAmount, x => x.RetainedLoyalityAmt, x => x.PAYOUTCODE);
                }
                else
                {
                    KPIHtml = getTableBody(uploadDetails, x => x.emp_No, x => x.emp_Name, x => x.Product, x => x.KPIRating
                                                        , x => x.TotalPoints, x => x.PropsedPayAmount,
                                                      x => x.ActualPayAmount, x => x.RetainedLoyalityAmt);
                }
                
            }
            catch (Exception ex)
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