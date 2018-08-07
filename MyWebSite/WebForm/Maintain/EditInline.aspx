<%@ Page Title="" Language="C#" MasterPageFile="~/WebForm/MasterPage/DefaultSite.Master" AutoEventWireup="true" CodeBehind="EditInline.aspx.cs" Inherits="MyWebSite.WebForm.Maintain.EditInline" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="../../Contents/CSS/jqGrid/ui.jqgrid.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/jQuery/jquery.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/i18n/grid.locale-en.js" type="text/javascript"></script>

    <script type="text/javascript">
        var ClientIDs = {
            ddlRYear: '<%=ddlRYear.ClientID%>',
            lbtnSearch: '<%=lbtnSearch.ClientID%>'
        };

        function centerDialog(elementID) {
            var dlgDiv = $(elementID);
            var dlgWidth = dlgDiv.width();
            var dlgHeight = dlgDiv.height();
            var windowWidth = $(window).width();
            var windowtHeight = $(window).height();
            dlgDiv.css("top", Math.round((windowtHeight - dlgHeight) / 2) + "px");
            dlgDiv.css("left", Math.round((windowWidth - dlgWidth) / 2) + "px");
        };

        $(document).ready(function () {
            var oPostData = {
                rYear: ""
            }

            var gvInline = $("#gvInline");
            //alert('開始執行');
            gvInline.jqGrid({
                url: "EditInline.aspx/GetData",   //設定取得資料的Web Service/Method
                //editurl: "EditInline.aspx",
                datatype: "json",                 //資料回傳的類型，有json,xml,local
                postData: oPostData,              //傳入Web Service/Method的參數, 其大小寫及順序要與後端的參數一模一樣
                mtype: 'POST',                    //ajax的類型，有GET和POST
                ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
                serializeGridData: function (postData) {
                    return JSON.stringify(postData);
                },
                jsonReader: {                     //jqgrid讀取json的時候，需要配置jsonReader才能讀取。
                    repeatitems: false,           //預設是true，表示回傳的json的內容會按照順序回傳，設定false，不照順序讓jsonReader是用搜尋name去塞入對應的
                    root: function (obj) { return eval(obj.d); },                           // the root tag for the grid
                    page: function (obj) { return gvInline.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / gvInline.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
                    records: function (obj) { return eval(obj.d).length; }                  // the total records from the query
                },
                colNames: [ //定義欄位的顯示名稱
                         //''
                         //,''
                          'ID'
                         , 'YEAR'
                         , 'REVENUE'
                         , 'REMARK'
                         , 'CREATE_DATE'
                ],
                colModel: [ //定義欄位格式 (ex. 寬度，排序，對齊，編輯等等功能)，name屬性必須要與後端回傳的欄位名稱相同
                        //{
                        //    name: 'act', width: 55, fixed: true, sortable: false, resize: false, formatter: 'actions',
                        //    formatoptions: {
                        //        editbutton: false,
                        //        delbutton: false,
                        //        keys: true,
                        //        editformbutton: false,
                        //        delOptions: {
                        //            beforeShowForm: function (form) {
                        //                centerDialog("#delmod" + gvInline[0].id);
                        //            }
                        //        }
                        //    }
                        //},
                        //{ name: "key", index: "key", hidden: true, editrules: { edithidden: false }, editable: true }, //如果要再Pageer頁面上做編輯，務必加上該行
                        { name: 'R_ID', index: 'R_ID', fixed: true, width: 50, align: "right", sorttype: "number", sortable: false },
                        { name: 'R_YEAR', index: 'R_YEAR', fixed: true, width: 100, editable: true, editoptions: { size: 10 }, editrules: { required: true }, sortable: true },
                        { name: 'REVENUE', index: 'REVENUE', fixed: true, width: 100, editable: true, align: "right", sorttype: "number" },
                        { name: 'REMARK', index: 'REMARK', fixed: true, width: 150, editable: true },
                        { name: 'CREATE_DATE', index: 'CREATE_DATE', fixed: true, width: 150, editable: true }
                ],

                //caption: "jqGrid Example 2",    //標題列顯示的文字, 沒有設定時就沒有標題列

                //loadonce: true,                 //是否只載入一次,若這個設成false，而分頁又沒有自己控制的話，那麼分頁就無法使用了
                pager: "#pgInline",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 5,                     //每頁預設顯示資料筆數, 預設20筆
                rowList: [5, 10, 20, 30, 50, 200], //每頁最多可以顯示幾筆
                //rownumbers: true,               //是否顯示資料的列編號
                viewrecords: true,              //是否顯示總筆數

                height: "auto",                 //jqGrid的高度, height:1000 or height: "auto"
                //width: 650,                  //jqGrid的寬度
                //autowidth: true,                //是否自動寬度
                //shrinkToFit: false,           //預設為true, 設定為false可將每個欄位的寬度固定, 產生grid內部的橫向捲軸

                //loaddui: "block",               //是否顯示loadtext, disable:不顯示 enable:顯示預設"Loading..." block:顯示客製的文字 
                //loadtext: "重新整理中..",       //查詢或排序時的wording, 預設是Loading...

                sortname: "R_YEAR",             //預設排序欄位名稱, 若是datatype不是local, 則只會有排序的icon, 資料還是以後端sql為主
                sortorder: "asc"               //預設排序方式asc升冪，desc降冪
                //multiselect: false,            //是否可以多選
                //gridview: true,                  //資料量大時可加快讀取速度, 但限制是不可用treeGrid, subGrid, or the afterInsertRow event

                //loadComplete:                 //資料載入完成的Function，可透過此Function自訂表格的顏色等客製化的功能

                //, onSelectRow: function () {
                //    var rowId = gvInline.jqGrid('getGridParam', 'selrow');
                //    alert(rowId);
                //}
                //loadComplete : function () {
                //    gvInline.jqGrid('setGridParam', { datatype: 'local' });
                //},
                //onPaging : function(which_button) {
                //    gvInline.jqGrid('setGridParam', { datatype: 'json' });
                //}
                //loadError: function (jqXHR, textStatus, errorThrown) {
                //alert('HTTP status code: ' + jqXHR.status + '\n' +
                //      'textStatus: ' + textStatus + '\n' +
                //      'errorThrown: ' + errorThrown);
                //alert('HTTP message body (jqXHR.responseText): ' + '\n' + jqXHR.responseText);
                //}
                //, editurl: "EditInline.aspx"
            });

            gvInline.jqGrid('navGrid', '#pgInline', { edit: false, add: true, del: false, search: false, refresh: false },
                                                    {},    //EditOptions,
                                                    {

                                                        //closeAfterAdd: true,//Closes the add window after add
                                                        //afterSubmit: function (response, postdata) {
                                                        //    if (response.responseText == "") {

                                                        //        gvInline.jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                                                        //        return [true, '']
                                                        //    }
                                                        //    else {
                                                        //        gvInline.jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                                                        //        return [false, response.responseText]
                                                        //    }
                                                        //}


                                                        ////url: "EditInline.aspx/AddRevenue",
                                                        //////datatype: 'json',
                                                        //ajaxEditOptions: { contentType: "application/json" },
                                                        //serializeEditData: function (postData) {
                                                        //    return JSON.stringify(postData);
                                                        //},
                                                        //closeOnEscape: true, closeAfterAdd: true, recreateForm: false,
                                                        //beforeShowForm: function (form) {
                                                        //    centerDialog("#editmod" + gvInline[0].id);
                                                        //    // alert("StartAdd");
                                                        //},
                                                        ////afterComplete: function (response) {
                                                        ////    var resp = $.parseJSON(response.responseText).d;
                                                        ////    alert(resp.message);                                                            
                                                        ////}
                                                        //afterSubmit: function (response, postdata) {
                                                        //    var revenueYear = $('#R_YEAR').val();
                                                        //    var revenueAmt = $('#REVENUE').val();
                                                        //    var remark = $('#REMARK').val();
                                                        //    alert(revenueYear);

                                                        //    return [true, ''];
                                                        //}

                                                    },    //AddOptions,
                                                    {},    //DelOptions
                                                    {});


            // 按下Search button
            $("#" + ClientIDs.lbtnSearch).click(function (e) {

                var rYearValue = $("#" + ClientIDs.ddlRYear).val();

                oPostData.rYear = rYearValue || "";

                // loadonce: true 後,datatype會變成local, 造成 trigger("reloadGrid") 無效, 都抓client data, 要重新把datatype:'json'
                gvInline.jqGrid('setGridParam', { datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");

                //上面的語法可以拆成下面兩各語法
                //gvInline.setGridParam( { datatype: 'json', postData: oPostData, page: 1 });
                //gvInline.trigger("reloadGrid");
                return false;
            });

        });



    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentArea" runat="server">
    <div id="divEditInline" style="width: auto; padding: 10px; font-size: 12px">
        <asp:Label ID="Label1" runat="server" Text="Edit Inline資料庫"></asp:Label>
        <a class="" href="../../Default.aspx">回首頁</a>
    </div>
    <p></p>
    <div style="width: 95%" align="left">
        <table>
            <tr>
                <td>
                    <asp:Label ID="lblTitleRYear" runat="server" Text="Revenue Year"></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="ddlRYear" runat="server">
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:LinkButton ID="lbtnSearch" runat="server" CssClass="btn" Text="Search"></asp:LinkButton>
                </td>
            </tr>
        </table>
    </div>
    <p></p>
    <div style="width: 95%">
        <table id="gvInline">
        </table>
        <div id="pgInline">
        </div>
    </div>


</asp:Content>
