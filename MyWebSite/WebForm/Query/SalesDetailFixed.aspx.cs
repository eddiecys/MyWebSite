using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using MyWebSite.Utility;

namespace MyWebSite.WebForm.Query
{
    public partial class SalesDetailFixed : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetData()
        {                
            DataTable dt = new DataTable();
            dt.Columns.Add("UserID", typeof(string));
            dt.Columns.Add("UserName", typeof(string));
            dt.Columns.Add("Dept", typeof(string));

            for (int i = 1; i <= 25; i++)
            {
                DataRow dr = dt.NewRow();
                dr["UserID"] = "USER" + i.ToString().PadLeft(3, '0');
                dr["UserName"] = "P" + i.ToString().PadLeft(2, '0');
                dr["Dept"] = "D" + i.ToString().PadLeft(2, '0');
                dt.Rows.Add(dr);
            }

            string jsonStr = string.Empty;

            jsonStr = JsonHelper.DataTableToJson(dt);

            //jsonStr = JsonHelper.DataTableToJson4jqGrid(dv.ToTable(), "UserID");
            if(!string.Equals(jsonStr, string.Empty)){
                return jsonStr;
            }
                else {
                return "";
            }
            //return jsonStr;
        }

    }
}