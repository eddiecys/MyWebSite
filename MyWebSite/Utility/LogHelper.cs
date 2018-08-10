//Created By：Ares Jerry
//Created Date：2013/07/15

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;

namespace MyWebSite.Utility
{
    /// <summary>
    /// Summary description for LogHelper
    /// </summary>
    public static class LogHelper
    {
        private static readonly ILog Log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Debug Information Output
        /// LogType:Debug
        /// </summary>
        /// <param name="message">message</param>
        public static void Debug(object message)
        {
            Log.Debug(message);
        }

        /// <summary>
        /// Warning Information Output
        /// LogType:Info
        /// </summary>
        /// <param name="message">message</param>
        public static void Warn(object message)
        {
            Log.Warn(message);
        }

        /// <summary>
        /// Nomal Information Output
        /// LogType:Info
        /// </summary>
        /// <param name="message">message</param>
        public static void Info(string message)
        {
            Log.Info(message);
        }

        /// <summary>
        /// Error Information Output
        /// LogType:Error
        /// </summary>
        /// <param name="message">message</param>
        /// <param name="ex">exception</param>
        public static void Error(object message, Exception ex)
        {
            Log.Error(message, ex);
        }

        /// <summary>
        /// Fatal Information Output
        /// LogType:Error
        /// </summary>
        /// <param name="message">message</param>
        /// <param name="ex">exception</param>
        public static void Fatal(object message, Exception ex)
        {
            Log.Fatal(message, ex);
        }

    }
}