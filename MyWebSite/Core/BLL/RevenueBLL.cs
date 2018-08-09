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
    public class RevenueBLL
    {
        DBHelper dbRetail;

        /// <summary>
        /// constructor
        /// </summary>
        public RevenueBLL()
        {
            dbRetail = DBHelper.GetDB("EddieDBSQLServer");
        }

        public List<MyRevenueEntity> GetRevenueDataDapper(string rYear, string createDateFrom, string createDateTo)
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);
            var RevenueList = rvDAL.GetRevenueDataDapper(rYear, createDateFrom, createDateTo);

            return RevenueList;
        }

        public bool SaveRevenueDataDapper(string act, int revenueId, string revenueYear, decimal revenueAmt, string remark)
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);

            var RevenueEntityRecord = new MyRevenueEntity();
            RevenueEntityRecord.R_ID = revenueId;
            RevenueEntityRecord.R_YEAR = revenueYear;
            RevenueEntityRecord.REVENUE = revenueAmt;
            RevenueEntityRecord.REMARK = remark;
            RevenueEntityRecord.CREATE_DATE = DateTime.Now;

            bool rFlag = rvDAL.SaveRevenueDataDapper(act, RevenueEntityRecord);

            return rFlag;
        }

        public DataTable GetRevenueData(string rYear, string createDateFrom, string createDateTo)
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);
            DataTable dt = rvDAL.GetRevenueData(rYear, createDateFrom, createDateTo);

            return dt;
        }

        public DataTable GetRevenueData(string rYear)
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);
            DataTable dt = rvDAL.GetRevenueData(rYear);

            return dt;
        }

        public DataTable GetRYear()
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);
            DataTable dt = rvDAL.GetRYear();

            return dt;
        }

        public bool AddRevenueData(string revenueYear, decimal revenueAmt, string remark)
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);
            bool rFlag = rvDAL.AddRevenueData(revenueYear, revenueAmt, remark);

            return rFlag;
        }

        public bool EditRevenueData(int revenueId, string revenueYear, decimal revenueAmt, string remark)
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);
            bool rFlag = rvDAL.EditRevenueData(revenueId,revenueYear, revenueAmt, remark);

            return rFlag;
        }

        public bool DeleteRevenueData(int revenueId)
        {
            RevenueDAL rvDAL = new RevenueDAL(dbRetail);
            bool rFlag = rvDAL.DeleteRevenueData(revenueId);

            return rFlag;
        }

    }
}