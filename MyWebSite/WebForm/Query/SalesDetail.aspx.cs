using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MyWebSite.Core.BLL;
using MyWebSite.Utility;
using System.Web.Services;

namespace MyWebSite.WebForm.Query
{
    public partial class SalesDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {

            }
            //string jstr;
            //jstr = loadgvSalesDetail();

            //TextBox1.Text = jstr;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        public static string GetData()
        {
            //try
            //{
                SalesDetailBLL sdBLL = new SalesDetailBLL();
                DataTable dt;
                string jsonString = string.Empty;

                dt = sdBLL.GetSalesDatailData();

                // Convert to json string and Dispose
                //if (dt != null)
                //{
                    jsonString = JsonHelper.DataTableToJson(dt);
                //                    dt.Dispose();
                //                    dt = null;
                //}
                //                sdBLL = null;

                //TextBox1.Text = jsonString;
                if (!string.Equals(jsonString, string.Empty)){
                    return jsonString;
                }
                else {
                    return "";
                }
                
            //}
            //catch (Exception)
            //{
            //    throw;
            //}
            


        }
    }
}