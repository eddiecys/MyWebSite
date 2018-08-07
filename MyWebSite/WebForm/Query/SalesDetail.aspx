<%@ Page Title="" Language="C#" MasterPageFile="~/WebForm/MasterPage/DefaultSite.Master" AutoEventWireup="true" CodeBehind="SalesDetail.aspx.cs" Inherits="MyWebSite.WebForm.Query.SalesDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--    <link rel="stylesheet" type="text/css" href="<%=ResolveClientUrl("~/Contents/CSS/jqGrid/ui.jqgrid.css")%>" />

    <script type="text/javascript" src="<%=ResolveClientUrl("~/Scripts/jQuery/jquery.js")%>"></script>
    <script type="text/javascript" src="<%=ResolveClientUrl("~/Scripts/jqGrid/jquery.jqGrid.min.js")%>"></script>
    <script type="text/javascript" src="<%=ResolveClientUrl("~/Scripts/jqGrid/i18n/grid.locale-en.js")%>"></script>--%>

    <link href="../../Contents/CSS/jqGrid/ui.jqgrid.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/jQuery/jquery.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/jquery.jqGrid.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/i18n/grid.locale-en.js" type="text/javascript"></script>


    <script type="text/javascript">
        function centerDialog(elementID) {
            var dlgDiv = $(elementID);
            var dlgWidth = dlgDiv.width();
            var dlgHeight = dlgDiv.height();
            var windowWidth = $(window).width();
            var windowtHeight = $(window).height();
            dlgDiv.css("top", Math.round((windowtHeight - dlgHeight) / 2) + "px");
            dlgDiv.css("left", Math.round((windowWidth - dlgWidth) / 2) + "px");
        }

        $(document).ready(function () {
            //var NumOfRow = Math.floor(($(window).height() - 120) / 24);

            var sdgrid = $("#gvSalesDetail");
            //alert('開始執行');
            //debugger;
            sdgrid.jqGrid({
                url: "SalesDetail.aspx/GetData",  //設定取得資料的Web Service/Method
                datatype: "json",                 //資料回傳的類型，有json,xml,local
                //postData: oPostData,              //傳入Web Service/Method的參數, 其大小寫及順序要與後端的參數一模一樣
                mtype: 'POST',                    //ajax的類型，有GET和POST
                ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
                serializeGridData: function (postData) {
                    return JSON.stringify(postData);
                },
                jsonReader: {                     //jqgrid讀取json的時候，需要配置jsonReader才能讀取。
                    repeatitems: false,           //預設是true，表示回傳的json的內容會按照順序回傳，設定false，不照順序讓jsonReader是用搜尋name去塞入對應的
                    root: function (obj) { return eval(obj.d); },                           // the root tag for the grid
                    page: function (obj) { return sdgrid.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / sdgrid.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
                    records: function (obj) { return eval(obj.d).length; }                  // the total records from the query
                },
                colNames: [ //定義欄位的顯示名稱
                         ''
                        // , ''
                         ,'TxnSeq'
                         , 'OrderDate.'
                         , 'TxnNumber.'
                         , 'StoreNo'
                         , 'StoreName'
                         , 'ProdCode'
                         , 'ProdName'
                         , 'TxnQty'
                         , 'Price'
                         , 'Amt'
                         , 'CreateDate'
                ],
                colModel: [ //定義欄位格式 (ex. 寬度，排序，對齊，編輯等等功能)，name屬性必須要與後端回傳的欄位名稱相同
                        {
                            name: 'act', width: 55, fixed: true, sortable: false, resize: false//, formatter: 'actions',
                            //formatoptions: {keys: true,editformbutton: true}
                            //formatoptions:{
                            //    keys: true, // we want use [Enter] key to save the row and [Esc] to cancel editing.
                            //    editformbutton: true, //editformbutton=true:跳出視窗做編輯(要設定keys: true), editformbutton=false:inline edit中做編輯 
                            //    editbutton: true,
                            //    editOptions: {
                            //        url: "SalesDetail.aspx//EditData",
                            //        ajaxEditOptions: { contentType: "application/json" },
                            //        serializeEditData: function (postData) {
                            //            return JSON.stringify(postData);
                            //        },
                            //        closeOnEscape: true,
                            //        closeAfterAdd: true,
                            //        reloadAfterSubmit: false,
                            //        viewPagerButtons: false,
                            //        closeAfterEdit: true,
                            //        beforeShowForm: function (form) {
                            //            centerDialog("#editmod" + sdgrid[0].id);
                            //        }
                            //    }


                            //}

                        },
                       // { name: "key", index: "key", hidden: true, editrules: { edithidden: false }, editable: true }, //如果要再Pageer頁面上做編輯，務必加上該行
                        { name: 'TxnSeq', index: 'TxnSeq', fixed: true, width: 60, align: "right", sorttype: "number" },
                        { name: 'OrderDate', index: 'OrderDate', fixed: true, width: 120, editable: true, formatter: "date", formatoptions: { srcformat: "Y-m-d", newformat: "Y/m/d" } },
                        { name: 'TxnNumber', index: 'TxnNumber', fixed: true, width: 100, align: "right", sorttype: "number" },
                        { name: 'StoreNo', index: 'StoreNo', fixed: true, width: 120, editable: true },
                        { name: 'StoreName', index: 'StoreName' },
                        { name: 'ProdCode', index: 'ProdCode', editable: true },
                        { name: 'ProdName', index: 'ProdName' },
                        { name: 'TxnQty', index: 'TxnQty', align: "right", sorttype: "number", editable: true },
                        { name: 'Price', index: 'Price', align: "right", sorttype: "number", editable: true },
                        { name: 'Amt', index: 'Amt', align: "right", sorttype: "number"},
                        { name: 'CreateDate', index: 'CreateDate', formatter: "date", formatoptions: { srcformat: "ISO8601Long", newformat: "Y-m-d H:i:s" } } //待確認時間格式
                ],

                //caption: "jqGrid Example 2",    //標題列顯示的文字, 沒有設定時就沒有標題列

                loadonce: true,                 //是否只載入一次,若這個設成false，而分頁又沒有自己控制的話，那麼分頁就無法使用了
                pager: "#pgSalesDetail",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 10,                     //每頁預設顯示資料筆數, 預設20筆
                rowList: [10, 20, 30, 50, 200], //每頁最多可以顯示幾筆
                //rownumbers: true,               //是否顯示資料的列編號
                viewrecords: true,              //是否顯示總筆數

                height: "auto",                 //jqGrid的高度, height:1000 or height: "auto"
                //width: 1200,                  //jqGrid的寬度
                autowidth: true,                //是否自動寬度
                //shrinkToFit: false,           //預設為true, 設定為false可將每個欄位的寬度固定, 產生grid內部的橫向捲軸

                loaddui: "block",               //是否顯示loadtext, disable:不顯示 enable:顯示預設"Loading..." block:顯示客製的文字 
                loadtext: "重新整理中..",       //查詢或排序時的wording, 預設是Loading...

                sortname: "TxnSeq",             //預設排序欄位名稱
                sortorder: "asc",              //預設排序方式asc升冪，desc降冪
                //multiselect: false            //是否可以多選
                gridview: true                  //資料量大時可加快讀取速度, 但限制是不可用treeGrid, subGrid, or the afterInsertRow event

                //loadComplete:                 //資料載入完成的Function，可透過此Function自訂表格的顏色等客製化的功能
                //gridComplete:function() {
                //    // 防止水平方向上出现滚动条  
                //    removeHorizontalScrollBar();  
                //}
            });
            sdgrid.jqGrid('navGrid', '#pgSalesDetail', { edit: false, add: false, del: false, search: false, refresh: false },
                                                    {},    //EditOptions,
                                                    {},    //AddOptions,
                                                    {},    //DelOptions
                                                    {});

        });




    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentArea" runat="server">
    <div id="divSalesDetail" style="width: auto; padding: 10px; font-size: 12px">
        <asp:Label ID="Label1" runat="server" Text="SalesDetail資料庫"></asp:Label>
        <a class="btn" href="../../Default.aspx">回首頁</a>
    </div>
    <div style="width: 95%">
        <table id="gvSalesDetail">
        </table>
        <div id="pgSalesDetail">
        </div>
    </div>
</asp:Content>
