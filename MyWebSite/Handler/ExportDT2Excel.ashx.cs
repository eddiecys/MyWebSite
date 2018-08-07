using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using MyWebSite.Utility;
using System.IO;

namespace MyWebSite.Handler
{
    /// <summary>
    /// ExportDT2Excel 的摘要描述
    /// </summary>
    public class ExportDT2Excel : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");

            context.Response.ContentType = "text/plain";
            string DTdata = context.Request["DTdata"];
            string criteria = context.Request.Form["criteria"];
            string filename = context.Request.Form["filename"];
            //string filename = HttpContext.Current.Server.UrlPathEncode(context.Request.Form["filename"]); //中文檔名

            DataTable dt = JsonHelper.JsonToDataTable(DTdata);
            bool bUtility = true;

            if (bUtility)
            {
                #region 蓬益
                ExportUtility exportUtility = new ExportUtility();
                exportUtility.Data = dt;
                exportUtility.SheetName = filename;
                //exportUtility.FileName = filename + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";
                exportUtility.FileName = filename + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";
                //exportUtility.ExportExcel(); // closedXML
                exportUtility.ExportExcelNPOI();
                #endregion
            }
            else
            {
                MemoryStream ms = NPOIHelper.RenderDataTableToExcel(dt) as MemoryStream;
                context.Response.Clear();

                // xlsx
                //context.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                // xls
                //context.Response.ContentType = "application/vnd.ms-excel";

                // 設定強制下載標頭。 
                //Response.AddHeader("Content-Disposition", String.Format("attachment; filename=\"{0}\"", fileName));
                context.Response.AddHeader("Content-Disposition", "attachment; filename= ExportFile.xls");
                // 輸出檔案。
                context.Response.BinaryWrite(ms.ToArray());
                ms.Close();
                ms.Dispose();
                context.Response.End();
            }



        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}