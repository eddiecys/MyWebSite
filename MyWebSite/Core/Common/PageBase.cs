using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Web.Services;
using System.Threading;
using System.Globalization;


namespace MyWebSite.Core.Common
{
    /// <summary>
    /// 定義每一支頁面會共用的部份，在每一支頁面的程式都會繼承此類別
    /// </summary>
    public class PageBase : System.Web.UI.Page
    {
        #region Property
        /// <summary>
        /// 登入者相關資訊的物件(EX:使用者帳號，使用者是什麼角色..)
        /// </summary>
        //public UserInfoEntity UserInfo
        //{
        //    get
        //    {
        //        return UMask.Core.Bll.Authority.GetUserInfo();
        //    }
        //}

        ///// <summary>
        ///// 設定該頁面是否需要檢查權限
        ///// </summary>
        //public bool IsCheckPage
        //{
        //    get;
        //    set;
        //}
        #endregion

        /// <summary>
        /// 處理載入Script的動作
        /// </summary>
        /// <param name="e"></param>
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            StringBuilder sbAppendHeaderElement = new StringBuilder();
            sbAppendHeaderElement.Append("<div id=\"commonDialogContent\" style=\"display:none;font-size: 12pt;\"></div>");
            sbAppendHeaderElement.Append("<div id=\"confirmDialogContent\" style=\"display:none;font-size: 12pt;\"></div>");
            sbAppendHeaderElement.Append("<input id=\"hdnLogPage\" type=\"hidden\" value=\"" + ResolveClientUrl(Request.ServerVariables["URL"] + "/WriteLog") + "\" />");
            sbAppendHeaderElement.Append("<textarea id=\"ui_path_log\" name=\"ui_path_log\" style=\"display:none\"></textarea>");

            Literal litAppendHeaderElement = new Literal();
            litAppendHeaderElement.Text = sbAppendHeaderElement.ToString();
            Page.Form.Controls.AddAt(0, litAppendHeaderElement);
        }

        /// <summary>
        /// 處理畫面載入時的權限檢查
        /// </summary>
        /// <param name="e"></param>
        //protected override void OnLoad(EventArgs e)
        //{
        //    if (IsCheckPage)
        //    {
        //        List<string> roleList = this.UserInfo.RoleList;

        //        if (roleList.Count > 0)
        //        {
        //            bool checkResult = UMask.Core.Bll.Authority.CheckPage(roleList);

        //            if (checkResult == false)
        //            {
        //                Response.Redirect("~/WebForm/SystemManage/AccessDenied.aspx");
        //            }
        //        }
        //        else
        //        {
        //            Response.Redirect("~/WebForm/SystemManage/AccessDenied.aspx");
        //        }
        //    }
        //    base.OnLoad(e);
        //}

        private void GenerateMessageScript(string title, string message, string redirectURL, string dialogWidth)
        {
            string guid = System.Guid.NewGuid().ToString();
            string msg = message;
            StringBuilder text = new StringBuilder();
            string currentPageURL = Request.Url.ToString();
            string widthOption = string.Empty;
            string closeOperation = "$(this).dialog(\"close\");";
            string closeWithRedirectOperation = "var isReload='" + currentPageURL + "'=='" + redirectURL + "';var isInIframe = parent !== window;if (isInIframe && !isReload) {window.parent.location.href=\"" + redirectURL + "\"}else{window.location.href=\"" + redirectURL + "\"}";

            if (dialogWidth != string.Empty)
            {
                widthOption = ",width:" + dialogWidth + ",height:200";
            }
            else
            {
                widthOption = ",width:500,height:200";
            }

            text.AppendLine("$(function() { ");
            if (redirectURL == string.Empty)
            {
                text.AppendLine("$(\"#commonDialogContent\").html(\"" + msg + "\").dialog({title:'" + title + "'" + widthOption + ", modal: true, buttons: {\"OK\":function(){" + closeOperation + "}} });");
            }
            else
            {
                text.AppendLine("$(\"#commonDialogContent\").html(\"" + msg + "\").dialog({title:'" + title + "'" + widthOption + ", modal: true, close: function(event,uk){" + closeWithRedirectOperation + "}, buttons: {\"OK\":function(){" + closeOperation + "}} });");
            }
            text.AppendLine("});");
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), guid, text.ToString(), true);
        }

        /// <summary>
        /// 顯示訊息
        /// </summary>
        /// <param name="message">訊息內容</param>
        /// <param name="messageType">訊息種類</param>
        public void ShowMsg(string message, SystemEnum.MessageType messageType)
        {
            string title = string.Empty;

            switch (messageType)
            {
                case SystemEnum.MessageType.Information:
                    title = "Information";
                    break;
                case SystemEnum.MessageType.Warning:
                    title = "Warning Message";
                    break;
                case SystemEnum.MessageType.Error:
                    title = "Error Message";
                    break;
                default:
                    break;
            }

            GenerateMessageScript(title, message, string.Empty, string.Empty);
        }

        /// <summary>
        /// 顯示訊息，並在按下 OK 按鈕之後導頁至指定的 URL
        /// </summary>
        /// <param name="message">訊息內容</param>
        /// <param name="messageType">訊息種類</param>
        /// <param name="redirectURL">導頁的URL</param>
        public void ShowMsg(string message, SystemEnum.MessageType messageType, string redirectURL)
        {
            string title = string.Empty;

            switch (messageType)
            {
                case SystemEnum.MessageType.Information:
                    title = "Information";
                    break;
                case SystemEnum.MessageType.Warning:
                    title = "Warning Message";
                    break;
                case SystemEnum.MessageType.Error:
                    title = "Error Message";
                    break;
                default:
                    break;
            }

            GenerateMessageScript(title, message, redirectURL, string.Empty);
        }

        /// <summary>
        /// 顯示訊息，並在按下 OK 按鈕之後導頁至指定的 URL(可指定dialog寬度)
        /// </summary>
        /// <param name="message">訊息內容</param>
        /// <param name="messageType">訊息種類</param>
        /// <param name="redirectURL">導頁的URL</param>
        /// <param name="dialogWidth">dialog寬度</param>
        public void ShowMsg(string message, SystemEnum.MessageType messageType, string redirectURL, string dialogWidth)
        {
            string title = string.Empty;

            switch (messageType)
            {
                case SystemEnum.MessageType.Information:
                    title = "Information";
                    break;
                case SystemEnum.MessageType.Warning:
                    title = "Warning Message";
                    break;
                case SystemEnum.MessageType.Error:
                    title = "Error Message";
                    break;
                default:
                    break;
            }

            GenerateMessageScript(title, message, redirectURL, dialogWidth);
        }

        /// <summary>
        /// ASP.NET預設的Unload事件
        /// </summary>
        /// <param name="e"></param>
        protected override void OnUnload(EventArgs e)
        {
            base.OnUnload(e);
        }

        /// <summary>
        /// 切換多國語系的處理
        /// </summary>
        //protected override void InitializeCulture()
        //{
        //    string lang = string.Empty;

        //    if (Request["ctl00$ddlLanguage"] != null)
        //    {
        //        lang = Request.Form["ctl00$ddlLanguage"];
        //    }
        //    else if (Request.Cookies["lang"] != null)
        //    {
        //        lang = Request.Cookies["lang"].Value;
        //    }
        //    else
        //    {
        //        lang = "en-US";
        //    }

        //    if (lang != string.Empty)
        //    {
        //        Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(lang);
        //        Thread.CurrentThread.CurrentUICulture = new CultureInfo(lang);
        //    }
        //    else
        //    {
        //        lang = "en-US";
        //    }

        //    //將語系設定存到Cookie
        //    HttpCookie cookie = new HttpCookie("lang");
        //    cookie.Value = lang;
        //    Response.Cookies.Add(cookie);


        //    base.InitializeCulture();
        //}

        /// <summary>
        /// 處理Client端Log
        /// </summary>
        /// <param name="clientValue"></param>
        /// <param name="formNo"></param>
        /// <param name="docVer"></param>
        //[WebMethod]
        //public static void WriteLog(string clientValue, string formNo, string docVer)
        //{
        //    string strFile = formNo + "_" + docVer.Replace(".", "_") + "_" + Authority.GetUserInfo().UserID + "_" + DateTime.Now.ToString("yyyy_MM_dd") + ".txt";
        //    string strFolder = @"~\ClientLog\" + DateTime.Now.Year.ToString() + @"\" + DateTime.Now.Month.ToString().PadLeft(2, '0');

        //    if (!Directory.Exists(HttpContext.Current.Server.MapPath(strFolder)))
        //    {
        //        Directory.CreateDirectory(HttpContext.Current.Server.MapPath(strFolder));
        //    }

        //    if (!File.Exists(HttpContext.Current.Server.MapPath(strFolder + @"\" + strFile)))
        //    {
        //        using (StreamWriter sw = new StreamWriter(HttpContext.Current.Server.MapPath(strFolder + @"\" + strFile), true, System.Text.Encoding.Default))
        //        {
        //            // 欲寫入的文字資料 ~
        //            sw.WriteLine("ip(remoteAddr): " + HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString());
        //            sw.WriteLine("");
        //            sw.WriteLine("browser(header_User-Agent): " + HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"].ToString());
        //            sw.WriteLine("");
        //            sw.WriteLine("language(header_Accept-Encoding): " + HttpContext.Current.Request.ServerVariables["HTTP_ACCEPT_ENCODING"].ToString());
        //            sw.WriteLine("");
        //            sw.WriteLine("language(header_Accept-Language): " + HttpContext.Current.Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"].ToString());
        //            sw.WriteLine("");
        //            sw.WriteLine("---------------------------------------------------------------------------------------------------");
        //            sw.Write(clientValue);
        //        }
        //    }
        //    else
        //    {
        //        using (StreamWriter sw = new StreamWriter(HttpContext.Current.Server.MapPath(strFolder + @"\" + strFile), true, System.Text.Encoding.Default))
        //        {
        //            sw.Write(clientValue);
        //        }
        //    }

        //}


    }
}