<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="EditFull.aspx.cs" Inherits="MyWebSite.WebForm.Maintain.EditFull" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../Contents/CSS/jQueryUI/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/jqGrid/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/Default.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/jQuery/jquery.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/i18n/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../Scripts/jQueryBlockUI/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../Scripts/common.js" type="text/javascript"></script>

    <script type="text/javascript">
        var ClientIDs = {
            ddlRYear: '<%=ddlRYear.ClientID%>',
            lbtnSearch: '<%=lbtnSearch.ClientID%>'
        };

        var oPostData = {
            R_YEAR: ""
        }


        $(document).ready(function () {

            setEvent();

            GetData();

        });

        function setEvent() {

            // 按下Search button
            //$("#" + ClientIDs.lbtnSearch).click(function (e) {
            $("[id$=lbtnSearch]").click(function (e) {
                //e.preventDefault();
                queryData();
                return false;
            });
            

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

        function GetData() {
            loadGridData();

            //getPostParam();

            //$.ajax({
            //    url: "EditFull.aspx/GetData",
            //    dataType: "json",
            //    data: JSON.stringify(oPostData), //param
            //    contentType: "application/json; charset=utf-8",
            //    type: "POST",
            //    success: function (response) {
            //        //alert(response.d);
            //        loadGridDataLocal(response.d);

            //        //var obj = JSON.parse(response.d);
            //        //gridColumns = obj.displayColumns;
            //        //gridColumnDefinition = getcolModelDef(gridColumns);
            //        //loadjqGridWM(obj, gridColumnDefinition);
            //        //loadjqGrid(dataUrl, gridColumnDefinition, postData);
            //    },
            //    beforeSend: function () {
            //        showBlockUI();
            //    },
            //    complete: function () {
            //        hideBlockUI();
            //    },
            //    error: function (jqXHR, textStatus, errorThrown) {
            //        var err = JSON.parse(jqXHR.responseText);
            //        showMsgDialog("System Error", err.Message);
            //    }
            //});

        }

        function loadGridDataLocal(gridData) {
            var gvData = $("#gvData");
            //alert('開始執行');
            gvData.jqGrid({
                data: JSON.parse(gridData),
                //url: "EditFull.aspx/GetData",   //設定取得資料的Web Service/Method
                datatype: "local",                 //資料回傳的類型，有json,xml,local
                //postData: oPostData,              //傳入Web Service/Method的參數, 其大小寫及順序要與後端的參數一模一樣
                //mtype: 'POST',                    //ajax的類型，有GET和POST
                //ajaxGridOptions: {
                //    contentType: 'application/json; charset=utf-8'
                //},
                //serializeGridData: function (postData) {
                //    return JSON.stringify(postData);
                //},
                jsonReader: {                     //jqgrid讀取json的時候，需要配置jsonReader才能讀取。
                    repeatitems: false,           //預設是true，表示回傳的json的內容會按照順序回傳，設定false，不照順序讓jsonReader是用搜尋name去塞入對應的
                    root: function (obj) { return eval(obj.d); },                           // the root tag for the grid
                    page: function (obj) { return gvData.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / gvData.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
                    records: function (obj) { return eval(obj.d).length; }                  // the total records from the query
                },
                colNames: [ //定義欄位的顯示名稱
                         'Actions'
                         //,''
                         , 'ID'
                         , 'YEAR'
                         , 'REVENUE'
                         , 'REMARK'
                         , 'CREATE_DATE'
                ],
                colModel: [ //定義欄位格式 (ex. 寬度，排序，對齊，編輯等等功能)，name屬性必須要與後端回傳的欄位名稱相同
                        {
                            name: 'act', width: 55, fixed: true, sortable: false, resize: false, formatter: 'actions',
                            formatoptions: {
                                keys: true,
                                editformbutton: true,//editformbutton=true:跳出視窗做編輯(要設定keys: true), editformbutton=false:inline edit中做編輯 
                                editbutton: true,
                                delbutton: true,
                                editOptions: {
                                    //width: 500,
                                    //viewPagerButtons: false,
                                    closeOnEscape: true,
                                    closeAfterEdit: true,
                                    reloadAfterSubmit: false,
                                    beforeShowForm: function (form) {
                                        centerDialog("#editmod" + gvData[0].id);
                                    },
                                    afterSubmit: function (response, postdata) {
                                        // 有錯誤直接秀出Error
                                        if (response.responseText !== "") {
                                            alert(response.responseText);
                                            return [false, "編輯錯誤"];
                                        }
                                        else {
                                            //成功重新整理Grid
                                            gvData.jqGrid('setGridParam', { url: "EditFull.aspx/GetData", datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                            //alert("Eddie Edit");
                                            return [true, ''];
                                        }
                                    }
                                    //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                    , editData: {
                                        rID: function () {
                                            var row_id = gvData.jqGrid('getGridParam', 'selrow');
                                            var value = gvData.jqGrid('getCell', row_id, 'R_ID');
                                            return value;
                                        }
                                    }
                                },
                                delOptions: {
                                    closeAfterDel: true, closeOnEscape: true,// recreateForm: false,
                                    beforeShowForm: function (form) {
                                        centerDialog("#delmod" + gvData[0].id);
                                    },
                                    afterSubmit: function (response, postdata) {
                                        // 有錯誤直接秀出Error
                                        if (response.responseText !== "") {
                                            alert(response.responseText);
                                            return [false, "刪除錯誤"];
                                        }
                                        else {
                                            //成功重新整理Grid
                                            gvData.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                            //alert("Eddie Delete");
                                            return [true, ''];
                                        }
                                    }
                                    //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                    , delData: {
                                        rID: function () {
                                            var row_id = gvData.jqGrid('getGridParam', 'selrow');
                                            var value = gvData.jqGrid('getCell', row_id, 'R_ID');
                                            return value;
                                        }
                                    }
                                    //onclickSubmit: function (options, postdata) {
                                    //    var rowid = postdata[this.id + "_id"]; // like "list_id"
                                    //    return {
                                    //        myParam: $(this).jqGrid("getCell", rowid, "colName")
                                    //    };
                                    //}
                                }
                            }
                        },
                        //{ name: "key", index: "key", hidden: true, editrules: { edithidden: false }, editable: true }, //如果要再Pageer頁面上做編輯，務必加上該行
                        { name: 'R_ID', index: 'R_ID', fixed: true, width: 50, align: "right", sorttype: "number", sortable: false },
                        { name: 'R_YEAR', index: 'R_YEAR', fixed: true, width: 100, editable: true, editoptions: { size: 10 }, editrules: { required: true }, sortable: true },
                        { name: 'REVENUE', index: 'REVENUE', fixed: true, width: 100, editable: true, align: "right", sorttype: "number" },
                        { name: 'REMARK', index: 'REMARK', fixed: true, width: 150, editable: true },
                        { name: 'CREATE_DATE', index: 'CREATE_DATE', fixed: true, width: 150 }
                ],

                //caption: "jqGrid Example 2",    //標題列顯示的文字, 沒有設定時就沒有標題列

                loadonce: true,                 //是否只載入一次,若這個設成false，而分頁又沒有自己控制的話，那麼分頁就無法使用了
                pager: "#pgData",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 10,                     //每頁預設顯示資料筆數, 預設20筆
                rowList: [5, 10, 20, 30, 50, 200], //每頁最多可以顯示幾筆
                rownumbers: true,               //是否顯示資料的列編號
                viewrecords: true,              //是否顯示總筆數

                height: "auto",                 //jqGrid的高度, height:1000 or height: "auto"

                sortname: "R_YEAR",             //預設排序欄位名稱, 若是datatype不是local, 則只會有排序的icon, 資料還是以後端sql為主
                sortorder: "asc"               //預設排序方式asc升冪，desc降冪
                //multiselect: false,            //是否可以多選
                //gridview: true,                  //資料量大時可加快讀取速度, 但限制是不可用treeGrid, subGrid, or the afterInsertRow event

                //loadComplete:                 //資料載入完成的Function，可透過此Function自訂表格的顏色等客製化的功能

                , editurl: "../../Handler/Revenue.ashx"

            });

            gvData.jqGrid('navGrid', '#pgData', { edit: false, add: true, del: false, search: false, refresh: false },
                                                    {},    //EditOptions,
                                                    {
                                                        closeAfterAdd: true, closeOnEscape: true,// recreateForm: false,
                                                        beforeShowForm: function (form) {
                                                            centerDialog("#editmod" + gvData[0].id);
                                                        },
                                                        afterSubmit: function (response, postdata) {
                                                            // 有錯誤直接秀出Error
                                                            if (response.responseText !== "") {
                                                                //console.log("新增錯誤");
                                                                alert(response.responseText);
                                                                return [false, "新增錯誤"];
                                                            }
                                                            else {
                                                                //console.log("新增成功");
                                                                //成功重新整理Grid
                                                                //gvData.jqGrid('setGridParam', { url: "EditFull.aspx/GetData", datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
                                                                gvData.jqGrid('setGridParam', { datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
                                                                //alert("Eddie Add");
                                                                return [true, ''];
                                                            }
                                                        }
                                                    },    //AddOptions,
                                                    {},    //DelOptions
                                                    {});


        }

        function loadGridData() {
            var gvData = $("#gvData");
            //alert('開始執行');
            gvData.jqGrid({
                url: "EditFull.aspx/GetData",   //設定取得資料的Web Service/Method
                datatype: "json",                 //資料回傳的類型，有json,xml,local
                postData: oPostData,              //傳入Web Service/Method的參數, 其大小寫及順序要與後端的參數一模一樣
                mtype: 'POST',                    //ajax的類型，有GET和POST
                ajaxGridOptions: {
                    contentType: 'application/json; charset=utf-8'
                },
                serializeGridData: function (postData) {
                    return JSON.stringify(postData);
                },
                jsonReader: {                     //jqgrid讀取json的時候，需要配置jsonReader才能讀取。
                    repeatitems: false,           //預設是true，表示回傳的json的內容會按照順序回傳，設定false，不照順序讓jsonReader是用搜尋name去塞入對應的
                    root: function (obj) { return eval(obj.d); },                           // the root tag for the grid
                    page: function (obj) { return gvData.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / gvData.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
                    records: function (obj) { return eval(obj.d).length; }                  // the total records from the query
                },
                colNames: [ //定義欄位的顯示名稱
                         'Actions'
                         //,''
                         , 'ID'
                         , 'YEAR'
                         , 'REVENUE'
                         , 'REMARK'
                         , 'CREATE_DATE'
                ],
                colModel: [ //定義欄位格式 (ex. 寬度，排序，對齊，編輯等等功能)，name屬性必須要與後端回傳的欄位名稱相同
                        {
                            name: 'act', width: 55, fixed: true, sortable: false, resize: false, formatter: 'actions',
                            formatoptions: {
                                keys: true,
                                editformbutton: true,//editformbutton=true:跳出視窗做編輯(要設定keys: true), editformbutton=false:inline edit中做編輯 
                                editbutton: true,
                                delbutton: true,
                                editOptions: {
                                    //width: 500,
                                    //viewPagerButtons: false,
                                    closeOnEscape: true,
                                    closeAfterEdit: true,
                                    reloadAfterSubmit: false,
                                    beforeShowForm: function (form) {
                                        centerDialog("#editmod" + gvData[0].id);
                                    },
                                    afterSubmit: function (response, postdata) {
                                        // 有錯誤直接秀出Error
                                        if (response.responseText !== "") {
                                            alert(response.responseText);
                                            return [false, "編輯錯誤"];
                                        }
                                        else {
                                            //成功重新整理Grid
                                            gvData.jqGrid('setGridParam', { url: "EditFull.aspx/GetData", mtype: 'POST', datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                            //alert("Eddie Edit");
                                            return [true, ''];
                                        }
                                    }
                                    //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                    , editData: {
                                        rID: function () {
                                            var row_id = gvData.jqGrid('getGridParam', 'selrow');
                                            var value = gvData.jqGrid('getCell', row_id, 'R_ID');
                                            return value;
                                        }
                                    }
                                },
                                delOptions: {
                                    closeAfterDel: true, closeOnEscape: true,// recreateForm: false,
                                    beforeShowForm: function (form) {
                                        centerDialog("#delmod" + gvData[0].id);
                                    },
                                    afterSubmit: function (response, postdata) {
                                        // 有錯誤直接秀出Error
                                        if (response.responseText !== "") {
                                            alert(response.responseText);
                                            return [false, "刪除錯誤"];
                                        }
                                        else {
                                            //成功重新整理Grid
                                            gvData.jqGrid('setGridParam', { url: "EditFull.aspx/GetData", mtype: 'POST', datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                            alert("Eddie Delete");
                                            return [true, ''];
                                        }
                                    }
                                    //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                    , delData: {
                                        rID: function () {
                                            var row_id = gvData.jqGrid('getGridParam', 'selrow');
                                            var value = gvData.jqGrid('getCell', row_id, 'R_ID');
                                            return value;
                                        }
                                    }
                                    //onclickSubmit: function (options, postdata) {
                                    //    var rowid = postdata[this.id + "_id"]; // like "list_id"
                                    //    return {
                                    //        myParam: $(this).jqGrid("getCell", rowid, "colName")
                                    //    };
                                    //}
                                }
                            }
                        },
                        //{ name: "key", index: "key", hidden: true, editrules: { edithidden: false }, editable: true }, //如果要再Pageer頁面上做編輯，務必加上該行
                        { name: 'R_ID', index: 'R_ID', fixed: true, width: 50, align: "right", sorttype: "number", sortable: false },
                        { name: 'R_YEAR', index: 'R_YEAR', fixed: true, width: 100, editable: true, editoptions: { size: 10 }, editrules: { required: true }, sortable: true },
                        { name: 'REVENUE', index: 'REVENUE', fixed: true, width: 100, editable: true, align: "right", sorttype: "number" },
                        { name: 'REMARK', index: 'REMARK', fixed: true, width: 150, editable: true },
                        { name: 'CREATE_DATE', index: 'CREATE_DATE', fixed: true, width: 150 }
                ],

                //caption: "jqGrid Example 2",    //標題列顯示的文字, 沒有設定時就沒有標題列

                loadonce: true,                 //是否只載入一次,若這個設成false，而分頁又沒有自己控制的話，那麼分頁就無法使用了
                pager: "#pgData",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 10,                     //每頁預設顯示資料筆數, 預設20筆
                rowList: [5, 10, 20, 30, 50, 200], //每頁最多可以顯示幾筆
                rownumbers: true,               //是否顯示資料的列編號
                viewrecords: true,              //是否顯示總筆數

                height: "auto",                 //jqGrid的高度, height:1000 or height: "auto"

                sortname: "R_YEAR",             //預設排序欄位名稱, 若是datatype不是local, 則只會有排序的icon, 資料還是以後端sql為主
                sortorder: "asc"               //預設排序方式asc升冪，desc降冪
                //multiselect: false,            //是否可以多選
                //gridview: true,                  //資料量大時可加快讀取速度, 但限制是不可用treeGrid, subGrid, or the afterInsertRow event

                //loadComplete:                 //資料載入完成的Function，可透過此Function自訂表格的顏色等客製化的功能

                , editurl: "../../Handler/Revenue.ashx"

            });

            gvData.jqGrid('navGrid', '#pgData', { edit: false, add: true, del: false, search: false, refresh: false },
                                                    {},    //EditOptions,
                                                    {
                                                        closeAfterAdd: true, closeOnEscape: true,// recreateForm: false,
                                                        beforeShowForm: function (form) {
                                                            centerDialog("#editmod" + gvData[0].id);
                                                        },
                                                        afterSubmit: function (response, postdata) {
                                                            // 有錯誤直接秀出Error
                                                            if (response.responseText !== "") {
                                                                //console.log("新增錯誤");
                                                                alert(response.responseText);
                                                                return [false, "新增錯誤"];
                                                            }
                                                            else {
                                                                //console.log("新增成功");
                                                                //成功重新整理Grid
                                                                //gvData.jqGrid('setGridParam', { url: "EditFull.aspx/GetData", datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
                                                                gvData.jqGrid('setGridParam', { mtype: 'POST', datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
                                                                //alert("Eddie Add");
                                                                return [true, ''];
                                                            }
                                                        }
                                                    },    //AddOptions,
                                                    {},    //DelOptions
                                                    {});


        }

        //重新Query
        function queryData() {
            
            //取得Query參數
            getPostParam();

            // loadonce: true 後,datatype會變成local, 造成 trigger("reloadGrid") 無效, 都抓client data, 要重新把datatype:'json'
            $("#gvData").jqGrid('setGridParam', { url: "EditFull.aspx/GetData", mtype: 'POST', datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
            
            //GetData();

            return false;
        }

        //取得Query參數
        function getPostParam() {
            var rYearValue = $("#" + ClientIDs.ddlRYear).val();
            oPostData.R_YEAR = rYearValue || "";
            //return oPostData;
        }


    </script>


</head>
<body>
    <form id="form1" runat="server">
        <div id="divEditInline" style="width: auto; padding: 10px; font-size: 12px">
            <asp:Label ID="Label1" runat="server" Text="Edit 資料庫"></asp:Label>
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
        <p>EditData in each row</p>
        <div style="width: 95%">
            <table id="gvData">
            </table>
            <div id="pgData">
            </div>
        </div>

    </form>
</body>
</html>

