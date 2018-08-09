using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MyWebSite.Utility;
using System.Data;
using System.Text;
using System.Data.SqlClient;
using Dapper;
using MyWebSite.Core.Entity;

namespace MyWebSite.Core.DAL
{
    public class SalesDetailDAL
    {
        DBHelper dbRetail;

        /// <summary>
        /// constructor
        /// </summary>
        public SalesDetailDAL(DBHelper dbRtl)
        {
            this.dbRetail = dbRtl;
        }

        //使用Dapper將Entity跟DB mapping
        public List<MyShippingTxnEntity> GetSalesDetailList()
        {
            //var MyShippingTxnList;
            var conn = dbRetail.Connection;
            var MyShippingTxn = conn.Query<MyShippingTxnEntity>("select * from MY_SHIPPING_TXN_V").ToList();
//            var MyShippingTxn = conn.Query<MyShippingTxnEntity>("select TxnSeq,OrderDate,TxnNumber from MY_SHIPPING_TXN_V").ToList();

            return MyShippingTxn;
        }

        /// <summary>
        /// 取得Sales Detail資料
        /// </summary>
        /// <returns></returns>
        public DataTable GetSalesDetailData(string dateFrom, string dateTo, string prodGroup, string cityName, string storeNo)
        {
            try
            {

                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("select TOP 100000 TxnSeq");
                sbSql.Append("      ,OrderDate ");
                sbSql.Append("      ,TxnNumber ");
                sbSql.Append("      ,StoreNo ");
                sbSql.Append("      ,StoreName ");
                sbSql.Append("      ,ProdCode ");
                sbSql.Append("      ,ProdName");
                sbSql.Append("      ,TxnQty");
                sbSql.Append("      ,Price ");
                sbSql.Append("      ,Amt ");
                sbSql.Append("      ,CreateDate ");
                sbSql.Append("  from MY_SHIPPING_TXN_V ");
                //sbSql.Append("  where TxnSeq < 100000 ");
                sbSql.Append(" where  1=1 ");

                dbRetail.ClearParameter();

                if (!string.IsNullOrEmpty(dateFrom))
                {
                    sbSql.Append(" and OrderDate >= @dateFrom ");
                    dbRetail.AddParameter("dateFrom", dateFrom);
                }
                if (!string.IsNullOrEmpty(dateTo))
                {
                    sbSql.Append(" and OrderDate <= @dateTo ");
                    dbRetail.AddParameter("dateTo", dateTo);
                }
                if (!string.IsNullOrEmpty(prodGroup))
                {
                    sbSql.Append(" and ProdCode = @prodGroup ");
                    dbRetail.AddParameter("prodGroup", prodGroup);
                }
                if (!string.IsNullOrEmpty(cityName))
                {
                    sbSql.Append(" and CityName = @cityName ");
                    dbRetail.AddParameter("cityName", cityName);
                }
                if (!string.IsNullOrEmpty(storeNo))
                {
                    sbSql.Append(" and StoreNo = @storeNo ");
                    dbRetail.AddParameter("storeNo", storeNo);
                }
                sbSql.Append(" order by TxnSeq ");

                DataTable dt = dbRetail.GetDataTable(sbSql.ToString(), CommandType.Text);

                return dt;

            }
            catch(Exception ex)
            {
                throw ex;
            }

        }

        public DataTable GetProdGroupData()
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("select ProdGroup ");
                sbSql.Append("  from MY_PRODGROUP_V ");
                sbSql.Append(" where  1=1 ");

                DataTable dt = dbRetail.GetDataTable(sbSql.ToString(), CommandType.Text);

                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public DataTable GetStoreData(string cityName)
        {
            try
            {
                StringBuilder sbSql = new StringBuilder();

                sbSql.Append("select StoreNo, StoreName, CityName ");
                sbSql.Append("  from MY_STORE_V ");
                sbSql.Append(" where  1=1 ");
                if (!string.IsNullOrEmpty(cityName))
                {
                    sbSql.Append(" and CityName = @cityName ");
                    dbRetail.AddParameter("cityName", cityName);
                }
                sbSql.Append(" order by StoreNo ");
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