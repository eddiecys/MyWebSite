using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MyWebSite.Utility;
using System.Data;
using MyWebSite.Core.DAL;
using MyWebSite.Core.Entity;

namespace MyWebSite.Core.BLL
{
    public class SalesDetailBLL
    {
        DBHelper dbRetail;

        /// <summary>
        /// constructor
        /// </summary>
        public SalesDetailBLL()
        {
            dbRetail = DBHelper.GetDB("EddieDBSQLServer");
        }

        public List<MyShippingTxnEntity> GetSalesDetailList(string dateFrom, string dateTo, string prodGroup, string cityName, string storeNo)
        {
            SalesDetailDAL sdDAL = new SalesDetailDAL(dbRetail);
            var SalesDeatilList = sdDAL.GetSalesDetailList(dateFrom, dateTo, prodGroup, cityName, storeNo);
            
            return SalesDeatilList;
        }

        public DataTable GetProdGroupData()
        {
            SalesDetailDAL sdDAL = new SalesDetailDAL(dbRetail);
            DataTable dt = sdDAL.GetProdGroupData();

            return dt;
        }

        public DataTable GetSalesDatailData(string dateFrom, string dateTo, string prodGroup, string cityName, string storeNo)
        {
            SalesDetailDAL sdDAL = new SalesDetailDAL(dbRetail);
            DataTable dt = sdDAL.GetSalesDetailData(dateFrom, dateTo, prodGroup, cityName, storeNo);

            return dt;
        }

        public DataTable GetSalesDatailData()
        {
            SalesDetailDAL sdDAL = new SalesDetailDAL(dbRetail);
            DataTable dt = sdDAL.GetSalesDetailData("", "", "", "", "");

            return dt;

        }

        public DataTable GetStoreData(string cityName)
        {
            SalesDetailDAL sdDAL = new SalesDetailDAL(dbRetail);
            DataTable dt = sdDAL.GetStoreData(cityName);

            return dt;
        }

    }
}