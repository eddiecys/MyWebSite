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
    public partial class EditFull : System.Web.UI.Page
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

                //第一筆資料空的
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
        public static string GetData(string R_YEAR)
        {
            try
            {
                RevenueBLL rvBLL = new RevenueBLL();
                DataTable dt;
                string jsonString = string.Empty;

                dt = rvBLL.GetRevenueData(R_YEAR);

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
        /// <param name="revenueYear"></param>
        /// <param name="revenueAmt"></param>
        /// <param name="remark"></param>
        /// <returns></returns>
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
        public object AddRevenue(string oper, string id, string revenueYear, decimal revenueAmt, string remark)
        {
            try
            {
                RevenueBLL rvBLL = new RevenueBLL();
                string msg;
                bool result = false;

                result = rvBLL.AddRevenueData(revenueYear, revenueAmt, remark);
                if (result)
                {
                    msg = "Successfully";
                }
                else
                {
                    msg = "Failed";
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