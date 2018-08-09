using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MyWebSite.Core.BLL;
using MyWebSite.Core.DAL;

using MyWebSite.Utility;
using System.Web.Services;
using System.Web.Script.Services;

namespace MyWebSite.WebForm.Maintain
{
    public partial class JqGridCRUD : System.Web.UI.Page
    {
        //我沒有資料庫，所以定義全域static 變數，有資料庫直接取代即可
        //public static string Source;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //ScriptManager.RegisterClientScriptBlock(this, GetType(), "Button popup", "xalert('Page_Load notPostBack');", true);
                
                //if (source.Value.ToString() == "")
                //    GenerateSource();

                //下拉選單參數
                GetRYear();
            }
            
        }

        /// <summary>
        /// 
        /// </summary>
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

        [WebMethod]
        public static string Query(string rYear, string createDateFrom, string createDateTo)
        {
            //有資料庫修改以下程式即可
            //DataTable dt = new DataTable();
            //string sql = @"select * from table";
            //dt = GetFromDB(sql);
            //string jsonStr = "";
            //if (dt != null)
            //    jsonStr = Util.JsonHelper.DataTableToJson(dt);
            //if (dt != null)
            //{
            //    dt.Dispose();
            //    dt = null;
            //}
            //return jsonStr;

            RevenueBLL rvBLL = new RevenueBLL();
            DataTable dt;
            string jsonString = string.Empty;

            dt = rvBLL.GetRevenueData(rYear,createDateFrom, createDateTo);

            // Convert to json string and Dispose
            if (dt != null)
            {
                jsonString = JsonHelper.DataTableToJson(dt);

                dt.Dispose();
                dt = null;
            }
            rvBLL = null;

            return jsonString;

            //return Source;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
        public static object Save(string act, string index, string param)
        {

            //param 格式 [{"name":"R_YEAR","value":"1234"},{"name":"REVENUE","value":"2000"},{"name":"REMARK","value":"dfjdkfd"}]

            string type = "", message = "";

            try
            {
                //DataTable dtSource = JsonHelper.JsonToDataTable(Source);
                DataTable dtParam = JsonHelper.JsonToDataTable(param);

                RevenueBLL rvBLL = new RevenueBLL();
                bool result = false;

                if (act == "Add")
                {
                    //DataRow dr = dtSource.NewRow();
                    //dr["index"] = dtSource.Rows.Count > 0 ? (dtSource.AsEnumerable().Max(a => int.Parse(a["index"].ToString())) + 1).ToString() : "1";
                    //dr["col1"] = GetValueByName(dtParam, "col1");
                    //dr["col2"] = GetValueByName(dtParam, "col2");
                    //dr["col3"] = GetValueByName(dtParam, "col3");
                    //dtSource.Rows.Add(dr);

                    string revenueYear = GetValueByName(dtParam, "R_YEAR");
                    decimal revenueAmt = Convert.ToDecimal(GetValueByName(dtParam, "REVENUE"));
                    string remark = GetValueByName(dtParam, "REMARK");

                    result = rvBLL.AddRevenueData(revenueYear, revenueAmt, remark);
                    message = result ? "Add Successfully" : "Add Failed";

                    rvBLL = null;
                }
                else if (act == "Mod")
                {
                    //var row = dtSource.AsEnumerable().Where(a => a["index"].ToString() == index);
                    //if (row != null)
                    //{
                    //    row.First()["col1"] = GetValueByName(dtParam, "col1");
                    //    row.First()["col2"] = GetValueByName(dtParam, "col2");
                    //    row.First()["col3"] = GetValueByName(dtParam, "col3");
                    //}

                    int rId = Convert.ToInt32(index);
                    string revenueYear = GetValueByName(dtParam, "R_YEAR");
                    decimal revenueAmt = Convert.ToDecimal(GetValueByName(dtParam, "REVENUE"));
                    string remark = GetValueByName(dtParam, "REMARK");

                    //RevenueBLL rvBLL = new RevenueBLL();
                    //bool result = false;

                    result = rvBLL.EditRevenueData(rId, revenueYear, revenueAmt, remark);
                    message = result ? "Modify Successfully" : "Modify Failed";

                    rvBLL = null;
                }
                else if (act == "Del")
                {
                    //var row = dtSource.AsEnumerable().Where(a => a["index"].ToString() == index);
                    //if (row != null)
                    //{
                    //    dtSource.Rows.Remove(row.First());
                    //    dtSource.AcceptChanges();
                    //}

                    int rId = Convert.ToInt32(index);

                    //RevenueBLL rvBLL = new RevenueBLL();
                    //bool result = false;

                    result = rvBLL.DeleteRevenueData(rId);
                    message = result ? "Delete Successfully" : "Delete Failed";

                    rvBLL = null;
                }
                //Source = JsonHelper.DataTableToJson(dtSource);
                type = "Success";
            }
            catch (Exception ex)
            {
                type = "Error";
                message = ex.Message;
            }

            return new { type = type, message = message };
        }

        //private void GenerateSource()
        //{
        //    //建立Session 測試資料
        //    DataTable dt = new DataTable();
        //    dt.Columns.Add("index");
        //    dt.Columns.Add("col1");
        //    dt.Columns.Add("col2");
        //    dt.Columns.Add("col3");

        //    DataRow dr = dt.NewRow();
        //    dr["index"] = "1";
        //    dr["col1"] = "A1";
        //    dr["col2"] = "B1";
        //    dr["col3"] = "C1";
        //    dt.Rows.Add(dr);

        //    dr = dt.NewRow();
        //    dr["index"] = "2";
        //    dr["col1"] = "A2";
        //    dr["col2"] = "B2";
        //    dr["col3"] = "C2";
        //    dt.Rows.Add(dr);

        //    dr = dt.NewRow();
        //    dr["index"] = "3";
        //    dr["col1"] = "A3";
        //    dr["col2"] = "B3";
        //    dr["col3"] = "C3";
        //    dt.Rows.Add(dr);

        //    Source = JsonHelper.DataTableToJson(dt);
        //}

        public static string GetValueByName(DataTable source, string name)
        {
            // 弱型別datatable要使用 LINQ，必須透過 AsEnumerable() + DataRow.Field()
            var value = from row in source.AsEnumerable()
                        where row["name"].ToString().Trim() == name
                        select row;

            if (value.Count() > 0)
                return value.First()["value"].ToString().Trim();
            else
                return "";
        }
    }
}