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
using System.Web.Script.Services;

namespace MyWebSite.WebForm.Maintain
{
    public partial class EditTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.GetRYear();
            }

        }

        private void GetRYear()
        {
            try
            {
                RevenueBLL rvBLL = new RevenueBLL();
                DataTable dt = rvBLL.GetRYear();
                ddlRYear.DataTextField = "R_YEAR";
                ddlRYear.DataValueField = "R_YEAR";
                ddlRYear.DataSource = dt;
                ddlRYear.DataBind();

                ddlRYear.Items.Insert(0, new ListItem(string.Empty, string.Empty));
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// 讀取資料
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
        public static string GetData(string rYear)
        {
            try
            {
                RevenueBLL rvBLL = new RevenueBLL();
                DataTable dt;
                string jsonString = string.Empty;

                dt = rvBLL.GetRevenueData(rYear);
                //                dt = rvBLL.GetRevenueData("");

                // Convert to json string and Dispose
                if (dt != null)
                {
                    jsonString = JsonHelper.DataTableToJson(dt);

                    dt.Dispose();
                    dt = null;
                }
                rvBLL = null;

                return jsonString;
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// 新增資料
        /// </summary>
        /// <param name="oper"></param>
        /// <param name="id"></param>
        /// <param name="revenueYear"></param>
        /// <param name="revenueAmt"></param>
        /// <param name="remark"></param>
        /// <returns></returns>
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]//, UseHttpGet = false)]
        public object AddRevenue()//string revenueYear)//, float revenueAmt, string remark)
        {
            try
            {
                RevenueBLL rvBLL = new RevenueBLL();
                string msg;
                bool result = false;

                result = rvBLL.AddRevenueData("111", 0, "123");//revenueYear, revenueAmt, remark);
                if (result)
                {
                    msg = "Add Successfully";
                }
                else
                {
                    msg = "Add Failed";
                }


                rvBLL = null;
                return new { message = msg, title = "AddData" };
            }
            catch (Exception)
            {
                throw;
            }
        }



    }


}