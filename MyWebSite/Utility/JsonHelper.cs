using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using System.IO;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
//using System.Runtime.Serialization.Json;

namespace MyWebSite.Utility
{


    /// <summary>
    /// Summary description for JsonHelper
    /// </summary>
    public static class JsonHelper
    {
        /// <summary>
        /// JSON Serialization
        /// </summary>
        //public static string JsonSerializer<T>(T t)
        //{
        //    DataContractJsonSerializer ser = new DataContractJsonSerializer(typeof(T));
        //    MemoryStream ms = new MemoryStream();
        //    ser.WriteObject(ms, t);
        //    string jsonString = Encoding.UTF8.GetString(ms.ToArray());
        //    ms.Close();
        //    return jsonString;
        //}
        ///// <summary>
        ///// JSON Deserialization
        ///// </summary>
        //public static T JsonDeserialize<T>(string jsonString)
        //{
        //    DataContractJsonSerializer ser = new DataContractJsonSerializer(typeof(T));
        //    MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(jsonString));
        //    T obj = (T)ser.ReadObject(ms);
        //    return obj;
        //}


        public static string DataTableToJson(DataTable dt)
        {
            string json = JsonConvert.SerializeObject(dt, Formatting.Indented);
            return json;
        }

        public static List<T> JsonToList<T>(string jsonStr)
        {
            List<T> objs = JsonConvert.DeserializeObject<List<T>>(jsonStr);
            return objs;
        }

        public static DataTable JsonToDataTable(string jsonStr)
        {
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(jsonStr);
            return dt;
        }

        public static string ObjToJson(Object obj)
        {
            string json = JsonConvert.SerializeObject(obj);
            return json;
        }

        public static string DataTableToJson4jqGrid(DataTable dt, string idColumnName)
        {
            JQGridObject jqGridObject = new JQGridObject();
            jqGridObject.page = 0;
            jqGridObject.total = 0;
            jqGridObject.records = dt.Rows.Count;

            List<string> cell;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                cell = new List<string>();

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    cell.Add(dt.Rows[i][j].ToString());
                }

                JQGridRow row = new JQGridRow()
                {
                    id = dt.Rows[i][idColumnName].ToString(),
                    cell = cell
                };
                jqGridObject.rows.Add(row);
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = 9000000;
            return js.Serialize(jqGridObject);
        }

        public static string DataTableToJson4FlexiGrid(DataTable dt, string idColumnName)
        {
            FlexigridObject flexigridObject = new FlexigridObject();
            flexigridObject.page = 1;
            flexigridObject.total = dt.Rows.Count;
            int cols = dt.Columns.Count;
            List<string> cell;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                cell = new List<string>();

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    cell.Add(dt.Rows[i][j].ToString());
                }

                FlexigridRow row = new FlexigridRow()
                {
                    id = dt.Rows[i][idColumnName].ToString(),
                    cell = cell
                };
                flexigridObject.rows.Add(row);
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = 9000000;
            return js.Serialize(flexigridObject);
        }
    }

    public class JQGridRow
    {
        public string id;
        public List<string> cell = new List<string>();
    }

    public class JQGridObject
    {
        public int page;
        public int total;
        public int records;
        public List<JQGridRow> rows = new List<JQGridRow>();
    }


    public class FlexigridRow
    {
        public string id;
        public List<string> cell = new List<string>();
    }

    public class FlexigridObject
    {
        public int page;
        public int total;
        public List<FlexigridRow> rows = new List<FlexigridRow>();
    }
}