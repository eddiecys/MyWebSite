using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Numerics;

namespace MyWebSite.Core.Entity
{
    public class MyShippingTxnEntity
    {
        public MyShippingTxnEntity()
        {
            this.TxnSeq = 0;
            this.OrderDate = DateTime.Now;
            this.TxnNumber = string.Empty;
            this.StoreNo = string.Empty;
            this.StoreName = string.Empty;
            this.ProdCode = string.Empty;
            this.ProdName = string.Empty;
            this.TxnQty = 0;
            this.Price = 0;
            this.Amt = 0;
            this.CreateDate = DateTime.Now;
            this.GeographyID = 0;
            this.CityName = string.Empty;
        }

        public BigInteger TxnSeq { get; set; }

        public DateTime OrderDate { get; set; }

        public string TxnNumber { get; set; }

        public string StoreNo { get; set; }

        public string StoreName { get; set; }

        public string ProdCode { get; set; }

        public string ProdName { get; set; }

        public BigInteger TxnQty { get; set; }

        public float Price { get; set; }

        public float Amt { get; set; }

        public DateTime CreateDate { get; set; }

        public int GeographyID { get; set; }

        public string CityName { get; set; }


    }
}