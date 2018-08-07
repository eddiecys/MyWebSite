using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MyWebSite.Utility;
using System.Data;
using MyWebSite.Core.DAL;

namespace MyWebSite.Core.BLL
{
    public class ExtendBLL
    {
        DBHelper dbRetail;

        /// <summary>
        /// constructor
        /// </summary>
        public ExtendBLL()
        {
            dbRetail = DBHelper.GetDB("EddieDBSQLServer");
        }

        public DataTable GetYearQuarterData(string rYear)
        {
            ExtendDAL rvDAL = new ExtendDAL(dbRetail);
            DataTable dt = rvDAL.GetYearQuarterData(rYear);

            return dt;
        }

        public DataTable GetAreaData()
        {
            ExtendDAL rvDAL = new ExtendDAL(dbRetail);
            DataTable dt = rvDAL.GetAreaData();

            return dt;
        }

        public DataTable GetCityByArea(string areaName)
        {
            ExtendDAL rvDAL = new ExtendDAL(dbRetail);
            DataTable dt = rvDAL.GetCityByArea(areaName);

            return dt;
        }

        public DataTable GetTownByAreaAndCity(string areaName, string cityName)
        {
            ExtendDAL rvDAL = new ExtendDAL(dbRetail);
            DataTable dt = rvDAL.GetTownByAreaAndCity(areaName, cityName);

            return dt;
        }

    }
}