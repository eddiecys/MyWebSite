using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using MyWebSite.Core.BLL;
//using MyWebSite.Core.DAL;
using MyWebSite.Utility;
using System.IO;
using MyWebSite.Core.Common;

namespace MyWebSite.WebForm.Query
{
    public partial class DemoTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                lbLanguage.Text = Page.UICulture;//查看網頁的語系

                #region ddl binding
                ddlArea.DataTextField = "AreaName";
                ddlArea.DataValueField = "AreaName";
                ddlArea.DataSource = getAreaData();
                ddlArea.DataBind();
                ddlArea.Items.Insert(0, new ListItem { Text = "請選擇", Value = "" });

                ddlCityName.DataTextField = "CityName";
                ddlCityName.DataValueField = "CityName";
                ddlCityName.DataSource = getCityData();
                ddlCityName.DataBind();
                ddlCityName.Items.Insert(0, new ListItem { Text = "全部", Value = "" });

                DataTable dtStore = getStoreData("");
                for (int i = 0; i < dtStore.Rows.Count; i++)
                {
                    ddlStore.Items.Add(new ListItem( string.Format("{0}({1})",dtStore.Rows[i]["StoreName"].ToString(), dtStore.Rows[i]["CityName"].ToString()), dtStore.Rows[i]["StoreNo"].ToString()));
                } 
                ddlStore.Items.Insert(0, new ListItem { Text = "全部", Value = "" });

                ddlProdGroup.DataTextField = "ProdGroup";
                ddlProdGroup.DataValueField = "ProdGroup";
                ddlProdGroup.DataSource = GetProdGroup();
                ddlProdGroup.DataBind();
                ddlProdGroup.Items.Insert(0, new ListItem { Text = "全部", Value = "" });

                RevenueBLL rvBLL = new RevenueBLL();
                DataTable dt = rvBLL.GetRYear();
                ddlRevenueYear.DataTextField = "R_YEAR";
                ddlRevenueYear.DataValueField = "R_YEAR";
                ddlRevenueYear.DataSource = dt;
                ddlRevenueYear.DataBind();

                ddlYearSingle.DataTextField = "R_YEAR";
                ddlYearSingle.DataValueField = "R_YEAR";
                ddlYearSingle.DataSource = dt;
                ddlYearSingle.DataBind();
                ddlYearSingle.Items.Insert(0, new ListItem { Text = "", Value = "" });

                ddlYearMultiple.DataTextField = "R_YEAR";
                ddlYearMultiple.DataValueField = "R_YEAR";
                ddlYearMultiple.DataSource = dt;
                ddlYearMultiple.DataBind();
                //ddlYearMultiple.Items.Insert(0, new ListItem { Text = "Select an option", Value = "-1" });
                #endregion

                //btnEnableTab.ToolTip = "Save Data";

                this.hdnParameterA.Value = "Y";
                this.hdnParameterB.Value = JsonHelper.DataTableToJson(getRevenueData("", "", ""));
            }
        }

        //protected override void InitializeCulture()
        //{
        //    if (Request.Form["ddlLanguage"] != null)
        //        Page.UICulture = Request.Form["ddlLanguage"];
        //}

        private DataTable getAreaData()
        {
            ExtendBLL eBLL = new ExtendBLL();
            DataTable dtData = eBLL.GetAreaData();

            return dtData;
        }

        private DataTable GetProdGroup()
        {
            SalesDetailBLL eBLL = new SalesDetailBLL();
            DataTable dtData = eBLL.GetProdGroupData();

            return dtData;
        }

        private DataTable getCityData()
        {
            ExtendBLL eBLL = new ExtendBLL();
            DataTable dtData = eBLL.GetCityByArea("");

            return dtData;
        }

        private DataTable getStoreData(string cityName)
        {
            SalesDetailBLL eBLL = new SalesDetailBLL();
            DataTable dtData = eBLL.GetStoreData(cityName);

            return dtData;
        }

        private DataTable getRevenueData(string rYear, string createDateFrom, string createDateTo)
        {
            RevenueBLL rvBLL = new RevenueBLL();
            DataTable dt = rvBLL.GetRevenueData(rYear, createDateFrom, createDateTo);
            rvBLL = null;

            return dt;
        }

        [WebMethod]
        public static string getRevenueJSON(string rYear)
        {
            RevenueBLL rvBLL = new RevenueBLL();
            DataTable dt = rvBLL.GetRevenueData(rYear, "", "");
            rvBLL = null;

            return JsonHelper.DataTableToJson(dt);
        }

        [WebMethod]
        public static string getStoreJson(string cityName)
        {
            SalesDetailBLL eBLL = new SalesDetailBLL();
            DataTable dtData = eBLL.GetStoreData(cityName);

            return JsonHelper.DataTableToJson(dtData);
        }

        [WebMethod]
        public static string getCityData(string areaName)
        {
            ExtendBLL eBLL = new ExtendBLL();
            DataTable dtData = eBLL.GetCityByArea(areaName);

            return JsonHelper.DataTableToJson(dtData);
        }
        [WebMethod]
        public static string getTownData(string areaName, string cityName)
        {
            ExtendBLL eBLL = new ExtendBLL();
            DataTable dtData = eBLL.GetTownByAreaAndCity(areaName, cityName);

            return JsonHelper.DataTableToJson(dtData);
        }


        [WebMethod]
        public static string SayHello(string name, string sex)
        {
            return string.Format("Hello {0}, 您是{1}生!",name, sex);
        }

        [WebMethod]
        public static string GetStr(string dimYear)
        {
            ExtendBLL eBLL = new ExtendBLL();
            DataTable dtData = eBLL.GetYearQuarterData(dimYear);

            return JsonHelper.DataTableToJson(dtData);

        }

        [WebMethod]
        public static List<string> GetArray()
        {
            List<string> li = new List<string>();

            for (int i = 0; i < 5; i++)
                li.Add(i + "");

            return li;
        }

        [WebMethod]
        public static string InitGrid()
        {
             return "[]";
        }

        [WebMethod]
        public static string QueryGrid(string dateFrom, string dateTo, string prodGroup, string cityName, string storeNo)
        {
            try
            {
                //if (initFlag == "Y")
                //    return "[]";

                SalesDetailBLL sdBLL = new SalesDetailBLL();
                DataTable dt;
                string jsonString = string.Empty;

                dt = sdBLL.GetSalesDatailData(dateFrom, dateTo, prodGroup, cityName, storeNo);

                // Convert to json string and Dispose
                if (dt != null)
                {
                    //jsonString = JsonHelper.JsonSerializer(dt);  
                    jsonString = JsonHelper.DataTableToJson(dt);
                    dt.Dispose();
                    dt = null;
                }
                //  sdBLL = null;

                //TextBox1.Text = jsonString;
                if (!string.Equals(jsonString, string.Empty))
                {
                    return jsonString;
                }
                else
                {
                    return "[]";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        [WebMethod]
        public static string QueryGridDapper(string dateFrom, string dateTo, string prodGroup, string cityName, string storeNo)
        {
            try
            {
                SalesDetailBLL sdBLL = new SalesDetailBLL();
                string jsonString = JsonHelper.ObjToJson(sdBLL.GetSalesDetailList(dateFrom, dateTo, prodGroup, cityName, storeNo));

                return jsonString;

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }



        [WebMethod]
        public static string GetExcelData()
        {
            try
            {
                SalesDetailBLL sdBLL = new SalesDetailBLL();
                DataTable dt;
                string jsonString = string.Empty;

                dt = sdBLL.GetSalesDatailData();

                // Convert to json string and Dispose
                if (dt != null)
                {
                    //jsonString = JsonHelper.JsonSerializer(dt);  
                    jsonString = JsonHelper.DataTableToJson(dt);
                    dt.Dispose();
                    dt = null;
                }
                //  sdBLL = null;

                //TextBox1.Text = jsonString;
                if (!string.Equals(jsonString, string.Empty))
                {
                    return jsonString;
                }
                else
                {
                    return "[]";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 此Event目前沒有用, 因為會postback
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        //public void btnExcel_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        //string guid = System.Guid.NewGuid().ToString();
        //        //ScriptManager.RegisterClientScriptBlock(this, GetType(), guid, "alert('cs click');", true);

        //        #region Excel action
        //        SalesDetailBLL sdBLL = new SalesDetailBLL();
        //        DataTable dt;
        //        dt = sdBLL.GetSalesDatailData();
        //        string jsonString = string.Empty;

        //        // Export to Excel
        //        //System.IO.Stream stream = NPOIHelper.RenderDataTableToExcel(dt);
        //        //Dictionary<string, System.IO.Stream> relatedLayerFile = new Dictionary<string, System.IO.Stream>() { { "Related Layer.xls", stream } };
        //        //NPOIHelper.RenderDataTableToExcel(dt, @"D:\test.xls");   //test

        //        //string fileName = Server.UrlPathEncode("中文ExportFile.xls");

        //        MemoryStream ms = NPOIHelper.RenderDataTableToExcel(dt) as MemoryStream;
        //        Response.Clear();

        //        // 設定強制下載標頭。 
        //        //Response.AddHeader("Content-Disposition", String.Format("attachment; filename=\"{0}\"", fileName));
        //        Response.AddHeader("Content-Disposition", "attachment; filename= ExportFile.xls");
        //        // 輸出檔案。
        //        Response.BinaryWrite(ms.ToArray());
        //        Response.End();
        //        ms.Close();
        //        ms.Dispose();

        //        #endregion

        //    }
        //    catch (Exception ex)
        //    {

        //        throw ex;
        //    }

        //}




    }
}