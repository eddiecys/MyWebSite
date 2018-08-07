using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MyWebSite.Core.Common
{
    /// <summary>
    /// 系統共用的列舉參數
    /// </summary>
    public class SystemEnum
    {
        /// <summary>
        /// 訊息的類別
        /// </summary>
        [Serializable]
        public enum MessageType : int
        {
            /// <summary>
            /// 一般資訊提示
            /// </summary>
            Information = 1,
            /// <summary>
            /// 警告訊息
            /// </summary>
            Warning = 2,
            /// <summary>
            /// 錯誤訊息
            /// </summary>
            Error = 3
        }

    }
}