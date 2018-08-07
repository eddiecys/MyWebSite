using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MyWebSite.Utility;
using System.Data;
using System.Text;

namespace MyWebSite.Core.DAL
{
    public class ExtendDAL
    {
        DBHelper dbRetail;

        /// <summary>
        /// contructor
        /// </summary>
        /// <param name="dbRtl"></param>
        public ExtendDAL(DBHelper dbRtl)
        {
            this.dbRetail = dbRtl;
        }

        public DataTable GetYearQuarterData(string rYear)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("SELECT DISTINCT YearMonthKey, QuarterName");
                sbSql.Append("  FROM DIM_Date");
                sbSql.Append(" WHERE 1=1 ");
                dbRetail.ClearParameter();
                if (!string.IsNullOrWhiteSpace(rYear))
                {
                    sbSql.Append(" and YearKey = @rYear ");
                    dbRetail.AddParameter("rYear", rYear);
                }
                DataTable dt = dbRetail.GetDataTable(sbSql.ToString(), CommandType.Text);

                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetAreaData()
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("SELECT AreaName");
                sbSql.Append("  FROM DIM_GeographyTW");
                sbSql.Append(" WHERE AreaName <> '未分類' ");
                sbSql.Append(" GROUP BY AreaName ");
                sbSql.Append(" order by Max(geographyID) ");
                DataTable dt = dbRetail.GetDataTable(sbSql.ToString(), CommandType.Text);

                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetCityByArea(string areaName)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("SELECT DISTINCT CityID, CityName");
                sbSql.Append("  FROM DIM_GeographyTW");
                sbSql.Append(" WHERE 1=1 ");
                dbRetail.ClearParameter();
                if (!string.IsNullOrWhiteSpace(areaName))
                {
                    sbSql.Append(" and AreaName = @areaName ");
                    dbRetail.AddParameter("areaName", areaName);
                }
                DataTable dt = dbRetail.GetDataTable(sbSql.ToString(), CommandType.Text);

                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetTownByAreaAndCity(string areaName, string cityName)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("SELECT GeographyID, TownName");
                sbSql.Append("  FROM DIM_GeographyTW");
                sbSql.Append(" WHERE 1=1 ");
                dbRetail.ClearParameter();
                if (!string.IsNullOrWhiteSpace(areaName))
                {
                    sbSql.Append(" and AreaName = @areaName ");
                    dbRetail.AddParameter("areaName", areaName);
                }
                if (!string.IsNullOrWhiteSpace(cityName))
                {
                    sbSql.Append(" and CityName = @cityName ");
                    dbRetail.AddParameter("cityName", cityName);
                }
                DataTable dt = dbRetail.GetDataTable(sbSql.ToString(), CommandType.Text);

                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}