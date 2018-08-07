using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MyWebSite.Utility;
using System.Data;
using System.Text;

namespace MyWebSite.Core.DAL
{
    public class RevenueDAL
    {
        DBHelper dbRetail;

        /// <summary>
        /// contructor
        /// </summary>
        /// <param name="dbRtl"></param>
        public RevenueDAL(DBHelper dbRtl)
        {
            this.dbRetail = dbRtl;
        }

        public DataTable GetRYear()
        {
            try
            {
                //StringBuilder sbSql = new StringBuilder();

                //sbSql.Append("select distinct R_YEAR ");
                //sbSql.Append("  from MY_REVENUE ");
                //sbSql.Append(" where 1=1");

                string sbSql = @"select distinct R_YEAR 
                                   from MY_REVENUE
                                  where 1=1";

                DataTable dt = dbRetail.GetDataTable(sbSql.ToString(), CommandType.Text);

                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// 取得Revenue資料
        /// </summary>
        /// <returns></returns>
        public DataTable GetRevenueData(string rYear,string createDateFrom, string createDateTo)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();
                string rSql = string.Empty;

                sbSql.Append("select R_ID ");
                sbSql.Append("      ,R_YEAR ");
                sbSql.Append("      ,REVENUE ");
                sbSql.Append("      ,REMARK ");
                sbSql.Append("      ,CREATE_DATE ");
                sbSql.Append("  from MY_REVENUE ");
                sbSql.Append(" where 1=1");

                dbRetail.ClearParameter();

                if (!rYear.Equals(string.Empty))
                {

                    if (rYear.Contains(","))
                    {
                        List<string> valueList = rYear.Split(',').ToList<string>();
                        List<string> paramNames = new List<string>();
                        for (int i = 0; i < valueList.Count; i++)
                        {
                            var paramName = "yearParam" + i;
                            paramNames.Add("@" + paramName);
                            dbRetail.AddParameter(paramName, valueList[i]);
                        }
                        string paramList = string.Join(",", paramNames);
                        sbSql.AppendFormat(" and R_YEAR in ({0})", paramList);
                    }
                    else
                    {
                        sbSql.Append(" and R_YEAR = @rYear ");
                        dbRetail.AddParameter("rYear", rYear);
                    }

                }
                if (!createDateFrom.Equals(string.Empty))
                {
                    sbSql.Append(" and CREATE_DATE >= @createDateFrom ");
                    dbRetail.AddParameter("createDateFrom", createDateFrom);
                }
                if (!createDateTo.Equals(string.Empty))
                {
                    sbSql.Append(" and CREATE_DATE <= @createDateTo ");
                    dbRetail.AddParameter("createDateTo", createDateTo);
                }

                sbSql.Append(" order by R_YEAR asc ");

                rSql = sbSql.ToString();

                DataTable dt = dbRetail.GetDataTable(rSql, CommandType.Text);

                return dt;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 取得Revenue資料 只有年度的查詢
        /// </summary>
        /// <param name="rYear"></param>
        /// <returns></returns>
        public DataTable GetRevenueData(string rYear)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();
                string rSql = string.Empty;

                sbSql.Append("select R_ID ");
                sbSql.Append("      ,R_YEAR ");
                sbSql.Append("      ,REVENUE ");
                sbSql.Append("      ,REMARK ");
                sbSql.Append("      ,CREATE_DATE ");
                sbSql.Append("  from MY_REVENUE ");
                sbSql.Append(" where 1=1");

                dbRetail.ClearParameter();

                if (!rYear.Equals(string.Empty))
                {
                    sbSql.Append(" and R_YEAR = @rYear ");
                    dbRetail.AddParameter("rYear", rYear);
                }

                sbSql.Append(" order by R_YEAR asc ");

                rSql = sbSql.ToString();

                DataTable dt = dbRetail.GetDataTable(rSql, CommandType.Text);

                return dt;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 新增Revenue資料
        /// </summary>
        /// <param name="revenueYear">年度</param>
        /// <param name="revenueAmt">金額</param>
        /// <param name="remark">備註</param>
        /// <returns></returns>
        public bool AddRevenueData(string revenueYear, decimal revenueAmt, string remark)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();
                string rSql = string.Empty;

                sbSql.Append(" insert into MY_REVENUE ");
                sbSql.Append(" (R_YEAR,REVENUE,REMARK,CREATE_DATE) ");
                sbSql.Append(" values ");
                sbSql.Append(" (@revenueYear,@revenueAmt,@remark,@createDate)");

                dbRetail.ClearParameter();
                dbRetail.AddParameter("revenueYear", revenueYear);
                dbRetail.AddParameter("revenueAmt", revenueAmt);
                dbRetail.AddParameter("remark", remark);
                dbRetail.AddParameter("createDate", DateTime.Now);

                rSql = sbSql.ToString();

                if (dbRetail.ExecuteNonQuery(rSql, CommandType.Text) <= 0)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 更新Revenue資料
        /// </summary>
        /// <param name="revenueId"></param>
        /// <param name="revenueYear"></param>
        /// <param name="revenueAmt"></param>
        /// <param name="remark"></param>
        /// <returns></returns>
        public bool EditRevenueData(int revenueId, string revenueYear, decimal revenueAmt, string remark)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();
                string rSql = string.Empty;

                sbSql.Append(" update MY_REVENUE ");
                sbSql.Append(" set R_YEAR = @revenueYear ");
                sbSql.Append(" , REVENUE = @revenueAmt ");
                sbSql.Append(" , REMARK = @remark ");
                sbSql.Append(" where R_ID = @revenueId ");

                dbRetail.ClearParameter();
                dbRetail.AddParameter("revenueId", revenueId);
                dbRetail.AddParameter("revenueYear", revenueYear);
                dbRetail.AddParameter("revenueAmt", revenueAmt);
                dbRetail.AddParameter("remark", remark);

                rSql = sbSql.ToString();

                if (dbRetail.ExecuteNonQuery(rSql, CommandType.Text) <= 0)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 刪除Revenue資料
        /// </summary>
        /// <param name="revenueId"></param>
        /// <returns></returns>
        public bool DeleteRevenueData(int revenueId)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();
                string rSql = string.Empty;

                sbSql.Append(" delete MY_REVENUE ");
                sbSql.Append(" where R_ID = @revenueId ");

                dbRetail.ClearParameter();
                dbRetail.AddParameter("revenueId", revenueId);

                rSql = sbSql.ToString();

                if (dbRetail.ExecuteNonQuery(rSql, CommandType.Text) <= 0)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}