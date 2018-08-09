using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MyWebSite.Utility;
using System.Data;
using System.Text;
using Dapper;
using MyWebSite.Core.Entity;
using System.Data.Common;

namespace MyWebSite.Core.DAL
{
    public class RevenueDAL
    {
        DBHelper dbRetail;
        private DbConnection conn;

        /// <summary>
        /// contructor
        /// </summary>
        /// <param name="dbRtl"></param>
        public RevenueDAL(DBHelper dbRtl)
        {
            this.dbRetail = dbRtl;
            this.conn = this.dbRetail.Connection;
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

        //使用Dapper
        public List<MyRevenueEntity> GetRevenueDataDapper(string rYear, string createDateFrom, string createDateTo)
        {
            try
            {
                //var conn = dbRetail.Connection;

                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("select R_ID");
                sbSql.Append("      ,R_YEAR ");
                sbSql.Append("      ,REVENUE ");
                sbSql.Append("      ,REMARK ");
                sbSql.Append("      ,CREATE_DATE ");
                sbSql.Append("  from MY_REVENUE ");
                sbSql.Append(" where 1=1");

                List<string> rYearList = new List<string>();
                if (!rYear.Equals(string.Empty))
                {
                    if (rYear.Contains(","))
                    {
                        rYearList = rYear.Split(',').ToList<string>();
                        
                        sbSql.Append(" and R_YEAR in  @rYearList");
                    }
                    else
                    {
                        sbSql.Append(" and R_YEAR = @rYear ");
                    }
                }
                if (!createDateFrom.Equals(string.Empty))
                {
                    sbSql.Append(" and CREATE_DATE >= @createDateFrom ");
                }
                if (!createDateTo.Equals(string.Empty))
                {
                    sbSql.Append(" and CREATE_DATE <= @createDateTo ");
                }
                sbSql.Append(" order by R_YEAR asc ");

                var SQLParam = new { rYear = rYear, createDateFrom = createDateFrom, createDateTo = createDateTo, rYearList = rYearList };
                

                var MyRevenueTxn = conn.Query<MyRevenueEntity>(sbSql.ToString(), SQLParam).ToList();

                //    //或是用不傳入entity使用弱型別, 會回傳IEnumerable<dynamic>, 欄位名稱要自己打且大小寫要符合, 在程式跑起來才知道錯誤
                //    //如果只需要一個或兩個欄位, 不想定義entity, 可以用下面方式
                //    //var MyRevenueTxn = conn.Query("select * from MY_REVENUE").ToList();
                //
                //foreach (var item in MyRevenueTxn)
                //{
                //    //因為conn.Query有傳入強型別的Entity, 所以item. 可以用帶出entity定義的欄位名稱, 在開發階段就可以知道錯誤
                //    var result = item.R_YEAR + item.REVENUE;
                //}

                return MyRevenueTxn;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //使用Dapper
        public bool SaveRevenueDataDapper(string act, MyRevenueEntity RevenueEntityRecord)
        {
            // 也可以傳入entity的集合,  List<MyRevenueEntity> RevenueEntityRecords
            //List<MyRevenueEntity> RevenueEntityRecords = new List<MyRevenueEntity>();

            try
            {
                StringBuilder sbSql = new StringBuilder();

                if (act == "Add")
                {
                    sbSql.Append(" insert into MY_REVENUE ");
                    sbSql.Append(" (R_YEAR,REVENUE,REMARK,CREATE_DATE) ");
                    sbSql.Append(" values ");
                    sbSql.Append(" (@R_YEAR,@REVENUE,@REMARK,@CREATE_DATE) ");
                }
                else if (act == "Mod")
                {
                    sbSql.Append(" update MY_REVENUE ");
                    sbSql.Append(" set R_YEAR = @R_YEAR ");
                    sbSql.Append(" , REVENUE = @REVENUE ");
                    sbSql.Append(" , REMARK = @REMARK ");
                    sbSql.Append(" where R_ID = @R_ID ");
                }
                else if (act == "Del")
                {
                    sbSql.Append(" delete MY_REVENUE ");
                    sbSql.Append(" where R_ID = @R_ID ");
                }

                //如果是一次多筆可以傳入List<Entity>
                //if (conn.Execute(sbSql.ToString(), RevenueEntityRecords) <= RevenueEntityRecords.Count)
                if (conn.Execute(sbSql.ToString(), RevenueEntityRecord) <= 0)
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