using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Collections.Specialized;
//using System.Globalization;
using MyWebSite.Core.BLL;
using MyWebSite.Utility;
using System.Globalization;


namespace MyWebSite.Handler
{
    /// <summary>
    /// Revenue 的摘要描述
    /// </summary>
    public class Revenue : IHttpHandler
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public void ProcessRequest(HttpContext context)
        {
            //不让浏览器缓存
            //context.Response.Buffer = true;
            //context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1);
            //context.Response.AddHeader("pragma", "no-cache");
            //context.Response.AddHeader("cache-control", "");
            //context.Response.CacheControl = "no-cache";
            //context.Response.ContentType = "text/plain";

            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            NameValueCollection forms = context.Request.Form;
            string strOperation = forms.Get("oper");
            string strResponse = string.Empty;
            if (strOperation == null) //oper = null which means its first load.
            {
                ////1.get the sample data
                //DataTable dt = GetAccountInfo();
                ////2.convert to json
                //string jsonRes = GetJson(dt);
                //context.Response.Write(jsonRes);
            }
            else if (strOperation == "del")
            {
                try
                {
                    int rId = Convert.ToInt16(forms.Get("rID"));

                    RevenueBLL rvBLL = new RevenueBLL();
                    bool result = false;

                    result = rvBLL.DeleteRevenueData(rId);

                    if (!result)
                    {
                        strResponse = "Failed";
                    }

                    rvBLL = null;

                    context.Response.Write(strResponse);
                }
                catch (Exception ex)
                {
                    context.Response.Write(ex.ToString());
                    //MessageBox.Show(ex.ToString());
                    //throw;
                }

            }
            else if (strOperation == "add")
            {
                try
                {
                    string rYear = forms.Get("R_YEAR").ToString();
                    //float revenue = Convert.ToSingle(forms.Get("REVENUE"));
                    decimal revenue = Convert.ToDecimal(forms.Get("REVENUE"));
                    string remark = forms.Get("REMARK").ToString();

                    RevenueBLL rvBLL = new RevenueBLL();
                    bool result = false;

                    result = rvBLL.AddRevenueData(rYear, revenue, remark);

                    if (!result)
                    {
                        strResponse = "Failed";
                    }
                    
                    rvBLL = null;
                   
                    context.Response.Write(strResponse);
                }
                catch (Exception ex)
                {
                    context.Response.Write(ex.ToString());
                    //MessageBox.Show(ex.ToString());
                    //throw;
                }
                
            }
            // strOperation == "edit"
            else
            {
                try
                {
                    int rId = Convert.ToInt16(forms.Get("rID"));
                    string rYear = forms.Get("R_YEAR").ToString();
                    //float revenue = Convert.ToSingle(forms.Get("REVENUE"));
                    //float revenue = float.Parse(forms.Get("REVENUE"), NumberStyles.Any);
                    decimal revenue = Convert.ToDecimal(forms.Get("REVENUE"));
                    string remark = forms.Get("REMARK").ToString();

                    RevenueBLL rvBLL = new RevenueBLL();
                    bool result = false;

                    result = rvBLL.EditRevenueData(rId, rYear, revenue, remark);

                    if (!result)
                    {
                        strResponse = "Failed";
                    }

                    rvBLL = null;

                    context.Response.Write(strResponse);
                }
                catch (Exception ex)
                {
                    context.Response.Write(ex.ToString());
                    //MessageBox.Show(ex.ToString());
                    //throw;
                }

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