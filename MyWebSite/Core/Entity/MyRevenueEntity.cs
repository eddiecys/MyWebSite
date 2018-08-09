using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MyWebSite.Core.Entity
{
    public class MyRevenueEntity
    {
        public int R_ID { get; set; }

        public string R_YEAR { get; set; }

        public decimal REVENUE { get; set; }

        public string REMARK { get; set; }

        public DateTime CREATE_DATE { get; set; }

    }
}