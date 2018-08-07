using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace MyWebSite.Handler
{
    /// <summary>
    /// fileUpload 的摘要描述
    /// </summary>
    public class fileUpload : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {

            try
            {
                //上傳圖片檔案
                //先宣告一個變數等等放檔案名稱
                string fileName = "";

                HttpFileCollection files = context.Request.Files;
                //context.Response.Write(files.Count);

                //判斷傳過來的fileData中有沒有夾帶檔案
                if (files.Count > 0)
                {
                    //如果有的話再把該檔案放進HttpPostedFile屬性中
                    HttpPostedFile file = files[0];
                    //FileName是C#的函數，可以取檔案名稱 , Path.GetFileName 可以解決IE取得檔名加上路徑問題
                    fileName = Path.GetFileName(file.FileName);
                    //用SaveAs的方法上傳圖片到指定的資料夾, 若沒有目錄則系統會自行建立
                    file.SaveAs(context.Server.MapPath("~/UploadTemp/" + fileName));
                }
            }
            catch (Exception ex)
            {
 //               LogHelper.Error(ex.Message, ex);
                throw ex;
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