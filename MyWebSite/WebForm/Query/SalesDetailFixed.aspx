<%@ Page Title="" Language="C#" MasterPageFile="~/WebForm/MasterPage/DefaultSite.Master" AutoEventWireup="true" CodeBehind="SalesDetailFixed.aspx.cs" Inherits="MyWebSite.WebForm.Query.SalesDetailFixed" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" type="text/css" href="<%=ResolveClientUrl("~/Contents/CSS/jqGrid/ui.jqgrid.css")%>" />

    <script type="text/javascript" src="<%=ResolveClientUrl("~/Scripts/jQuery/jquery.js")%>"></script>
    <script type="text/javascript" src="<%=ResolveClientUrl("~/Scripts/jqGrid/jquery.jqGrid.js")%>"></script>
    <script type="text/javascript" src="<%=ResolveClientUrl("~/Scripts/jqGrid/i18n/grid.locale-en.js")%>"></script>

 
 <%--   <link href="../../Contents/CSS/jqGrid/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src="../../Contents/JavaScripts/jQuery/jquery.js" type="text/javascript"></script>
    <script src="../../Contents/JavaScripts/jqGrid/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../Contents/JavaScripts/jqGrid/i18n/grid.locale-en.js" type="text/javascript"></script>--%>

    <script type="text/javascript">
        $(function () {
            var grid = $("#gvSalesDetail");
            grid.jqGrid({
                url: "SalesDetailFixed.aspx/GetData",
                //url: "SalesDetail.aspx/GetData",
                datatype: "json",
                mtype: 'POST',
                loadonce: true,
                ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
                serializeGridData: function (postData) {
                    return JSON.stringify(postData);
                },
                jsonReader: {
                    repeatitems: false,
                    root: function (obj) { return eval(obj.d); },
                    page: function (obj) { return grid.jqGrid('getGridParam', 'page'); },
                    total: function (obj) { return Math.ceil(eval(obj.d).length / grid.jqGrid('getGridParam', 'rowNum')); },
                    records: function (obj) { return eval(obj.d).length; }
                },
                colNames: ['', 'User ID', 'User Name', 'Department'],
                colModel: [
                        { name: 'act', width: 55, fixed: true, sortable: false, resize: false, formatter: 'actions' },
                        { name: 'UserID', index: 'UserID'},
                        { name: 'UserName', index: 'UserName' },
                        { name: 'Dept', index: 'Dept' }
                        //{ name: 'pos_station_id', index: 'pos_station_id', sortable: false },
                        //{ name: 'ordernumber', index: 'ordernumber', sortable: false },
                        //{ name: 'orderlinenumber', index: 'orderlinenumber', sortable: false }
                ],
                height: 'auto',
                width: 600,
                rowNum: 10,
                gridview: true,
                rownumbers: true,
                rowList: [10, 20, 30, 50],
                pager: '#pgSalesDetail',
                viewrecords: true,
                sortname: 'UserID',
                sortorder: "asc",
                caption: "jqGrid Example 1",
                headtitles: true,
                multiselect: false,
                editurl: "SalesDetail.aspx"
                //overlay: false,
                //loadComplete: function () {
                //    var ids = grid.jqGrid('getDataIDs');
                //    for (var i = 0; i < ids.length; i++) {
                //        var id = ids[i];
                //        var rowData = grid.jqGrid('getRowData', id);

                //        if (rowData.UserID == "USER003") {
                //            $('#gvSalesDetail #jDeleteButton_' + id).remove();
                //        }
                //        if (rowData.UserName == "P06") {
                //            $('#gvSalesDetail #jEditButton_' + id).remove();
                //        }
                //        if (rowData.UserID == "USER009") {
                //            $('#gvSalesDetail #jEditButton_' + id).remove();
                //            $('#gvSalesDetail #jDeleteButton_' + id).remove();
                //        }
                //    }
                //}
            });
            $("#gvSalesDetail").jqGrid('navGrid', '#pgSalesDetail', { edit: false, add: true, del: false, search: false, refresh: false },
             {},
              {
                  closeAfterAdd: true,
                  reloadAfterSubmit: false,
                  beforeShowForm: function (form) {
                      centerDialog("#editmod" + grid[0].id);
                  }
            });
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentArea" runat="server">
    <div id="divSalesDetailFixed" style="padding: 10px; font-size: 12px">
        <asp:Label ID="Label1" runat="server" Text="SalesDetail固定資料"></asp:Label>
        <a class="btn" href="../../Default.aspx">回首頁</a>
    </div>

    <table id="gvSalesDetail">
    </table>
    <div id="pgSalesDetail">
    </div>
</asp:Content>
