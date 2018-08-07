<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="EditTest.aspx.cs" Inherits="MyWebSite.WebForm.Maintain.EditTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../Contents/CSS/jQueryUI/jquery-ui.css" rel="stylesheet" type="text/css" />
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

            var gvPopup = $("#gvPopup");
            //alert('開始執行');
            gvPopup.jqGrid({
                url: "EditTest.aspx/GetData",   //設定取得資料的Web Service/Method
                //editurl: "EditInline.aspx",
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
                    page: function (obj) { return gvPopup.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / gvPopup.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
                    records: function (obj) { return eval(obj.d).length; }                  // the total records from the query
                },
                colNames: [ //定義欄位的顯示名稱
                         'ID'
                         , 'YEAR'
                         , 'REVENUE'
                         , 'REMARK'
                         , 'CREATE_DATE'
                ],
                colModel: [ //定義欄位格式 (ex. 寬度，排序，對齊，編輯等等功能)，name屬性必須要與後端回傳的欄位名稱相同
                        { name: 'R_ID', index: 'R_ID', fixed: true, width: 50, align: "right", sorttype: "number", sortable: false },
                        { name: 'R_YEAR', index: 'R_YEAR', fixed: true, width: 100, editable: true, editoptions: { size: 10 }, editrules: { required: true }, sortable: true },
                        { name: 'REVENUE', index: 'REVENUE', fixed: true, width: 100, editable: true, align: "right", sorttype: "number" },
                        { name: 'REMARK', index: 'REMARK', fixed: true, width: 150, editable: true },
                        { name: 'CREATE_DATE', index: 'CREATE_DATE', fixed: true, width: 150 }
                ],

                //caption: "jqGrid Example 2",    //標題列顯示的文字, 沒有設定時就沒有標題列

                loadonce: true,                 //是否只載入一次,若這個設成false，而分頁又沒有自己控制的話，那麼分頁就無法使用了
                pager: "#pgPopup",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 5,                     //每頁預設顯示資料筆數, 預設20筆
                rowList: [5, 10, 20, 30, 50, 200], //每頁最多可以顯示幾筆
                rownumbers: true,               //是否顯示資料的列編號
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


                , editurl: "../../Handler/Revenue.ashx"

            });

            gvPopup.jqGrid('navGrid', '#pgPopup', { edit: true, add: true, del: true, search: false, refresh: false },
                                                    {
                                                        closeAfterEdit: true, closeOnEscape: true, recreateForm: false, reloadAfterSubmit: false,
                                                        beforeShowForm: function (form) {
                                                            centerDialog("#editmod" + gvPopup[0].id);
                                                            // alert("Start");
                                                        },
                                                        afterSubmit: function (response, postdata) {
                                                            // 有錯誤直接秀出Error
                                                            if (response.responseText !== "") {
                                                                alert(response.responseText);
                                                                return [false, "編輯錯誤"];
                                                            }
                                                            else {
                                                                //成功重新整理Grid
                                                                gvPopup.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                                                return [true, ''];
                                                            }
                                                        }
                                                        //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                                        , editData: {
                                                            rID: function () {
                                                                var row_id = gvPopup.jqGrid('getGridParam', 'selrow');
                                                                var value = gvPopup.jqGrid('getCell', row_id, 'R_ID');
                                                                return value;
                                                            }
                                                        }

                                                    },    //EditOptions,
                                                    {
                                                        closeAfterAdd: true, closeOnEscape: true, recreateForm: false,
                                                        beforeShowForm: function (form) {
                                                            centerDialog("#addmod" + gvPopup[0].id);
                                                        },
                                                        afterSubmit: function (response, postdata) {
                                                            // 有錯誤直接秀出Error
                                                            if (response.responseText !== "") {
                                                                alert(response.responseText);
                                                                return [false, "新增錯誤"];
                                                            }
                                                            else {
                                                                //成功重新整理Grid
                                                                gvPopup.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
                                                                return [true, ''];
                                                            }
                                                        }
                                                    },    //AddOptions,
                                                    {
                                                        closeAfterDel: true, closeOnEscape: true, recreateForm: false,
                                                        afterSubmit: function (response, postdata) {
                                                            // 有錯誤直接秀出Error
                                                            if (response.responseText !== "") {
                                                                alert(response.responseText);
                                                                return [false, "刪除錯誤"];
                                                            }
                                                            else {
                                                                //成功重新整理Grid
                                                                gvPopup.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                                                return [true, ''];
                                                            }
                                                        }
                                                        //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                                        , delData: {
                                                            rID: function () {
                                                                var row_id = gvPopup.jqGrid('getGridParam', 'selrow');
                                                                var value = gvPopup.jqGrid('getCell', row_id, 'R_ID');
                                                                return value;
                                                            }
                                                        }

                                                    },    //DelOptions
                                                    {});



            var gvPopup2 = $("#gvPopup2");
            //alert('開始執行');
            gvPopup2.jqGrid({
                url: "EditTest.aspx/GetData",   //設定取得資料的Web Service/Method
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
                    page: function (obj) { return gvPopup2.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / gvPopup2.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
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
                                keys: true, //editformbutton=true:跳出視窗做編輯(要設定keys: true), editformbutton=false:inline edit中做編輯      
                                editformbutton: true,
                                editbutton: true,
                                delbutton: true,
                                editOptions: {
                                    //width: 500,
                                    //viewPagerButtons: false,
                                    closeOnEscape: true,
                                    closeAfterEdit: true,
                                    reloadAfterSubmit: false,
                                    beforeShowForm: function (form) {
                                        centerDialog("#editmod" + gvPopup2[0].id);
                                    },
                                    afterSubmit: function (response, postdata) {
                                        // 有錯誤直接秀出Error
                                        if (response.responseText !== "") {
                                            alert(response.responseText);
                                            return [false, "編輯錯誤"];
                                        }
                                        else {
                                            //成功重新整理Grid
                                            gvPopup2.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                            //alert("Eddie Edit");
                                            return [true, ''];
                                        }
                                    }
                                    //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                    , editData: {
                                        rID: function () {
                                            var row_id = gvPopup2.jqGrid('getGridParam', 'selrow');
                                            var value = gvPopup2.jqGrid('getCell', row_id, 'R_ID');
                                            return value;
                                        }
                                    }
                                },
                                delOptions: {
                                    closeAfterDel: true, closeOnEscape: true,// recreateForm: false,
                                    afterSubmit: function (response, postdata) {
                                        // 有錯誤直接秀出Error
                                        if (response.responseText !== "") {
                                            alert(response.responseText);
                                            return [false, "刪除錯誤"];
                                        }
                                        else {
                                            //成功重新整理Grid
                                            gvPopup2.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                            //alert("Eddie Delete");
                                            return [true, ''];
                                        }
                                    }
                                    //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                    , delData: {
                                        rID: function () {
                                            var row_id = gvPopup2.jqGrid('getGridParam', 'selrow');
                                            var value = gvPopup2.jqGrid('getCell', row_id, 'R_ID');
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
                pager: "#pgPopup2",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 5,                     //每頁預設顯示資料筆數, 預設20筆
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

            gvPopup2.jqGrid('navGrid', '#pgPopup2', { edit: false, add: true, del: false, search: false, refresh: false },
                                                    {},    //EditOptions,
                                                    {
                                                        closeAfterAdd: true, closeOnEscape: true,// recreateForm: false,
                                                        beforeShowForm: function (form) {
                                                            centerDialog("#addmod" + gvPopup2[0].id);
                                                        },
                                                        afterSubmit: function (response, postdata) {
                                                            // 有錯誤直接秀出Error
                                                            if (response.responseText !== "") {
                                                                alert(response.responseText);
                                                                return [false, "新增錯誤"];
                                                            }
                                                            else {
                                                                //成功重新整理Grid
                                                                gvPopup2.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
                                                                //alert("Eddie Add");
                                                                return [true, ''];
                                                            }
                                                        }
                                                    },    //AddOptions,
                                                    {},    //DelOptions
                                                    {});



            //var lastID;
            var gvInline = $("#gvInline");
            gvInline.jqGrid({
                url: "EditTest.aspx/GetData",   //設定取得資料的Web Service/Method
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
                    page: function (obj) { return gvInline.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / gvInline.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
                    records: function (obj) { return eval(obj.d).length; }                  // the total records from the query
                },
                colNames: [ //定義欄位的顯示名稱
                         'Del'
                         // ''
                         ,'ID'
                         , 'YEAR'
                         , 'REVENUE'
                         , 'REMARK'
                         , 'CREATE_DATE'
                ],
                colModel: [ //定義欄位格式 (ex. 寬度，排序，對齊，編輯等等功能)，name屬性必須要與後端回傳的欄位名稱相同
                        {
                            name: 'act', index: 'axt', width: 55, fixed: true, sortable: false, resize: false, formatter: 'actions',
                            formatoptions: {
                                //editformbutton=true:跳出視窗做編輯(要設定keys: true), editformbutton=false:inline edit中做編輯      
                                keys: true,
                                editformbutton: false,
                                editbutton: true,
                                delbutton: true,
                                // Edit 時,額外傳入欄位
                                extraparam: {
                                    rID: function () {
                                        var row_id = gvInline.jqGrid('getGridParam', 'selrow');
                                        var value = gvInline.jqGrid('getCell', row_id, 'R_ID');
                                        return value;
                                    }
                                },                                
                                //editformbutton=false時, editOptions裡面的事件不會觸發
                                //editOptions: {},

                                delOptions: {
                                    closeAfterDel: true, closeOnEscape: true,// recreateForm: false,
                                    afterSubmit: function (response, postdata) {
                                        // 有錯誤直接秀出Error
                                        if (response.responseText !== "") {
                                            alert(response.responseText);
                                            return [false, "刪除錯誤"];
                                        }
                                        else {
                                            //成功重新整理Grid
                                            gvInline.jqGrid('setGridParam', { url: "EditTest.aspx/GetData", datatype: 'json', postData: oPostData }).trigger("reloadGrid");
                                            //alert("Eddie Delete");
                                            return [true, ''];
                                        }
                                    }
                                    //只有editable的欄位才能傳遞到handler中去, 所以Key欄位要自行處理
                                    , delData: {
                                        rID: function () {
                                            var row_id = gvInline.jqGrid('getGridParam', 'selrow');
                                            var value = gvInline.jqGrid('getCell', row_id, 'R_ID');
                                            return value;
                                        }
                                    }
                                }
                            }
                        },
                        //{ name: "key", index: "key", hidden: true, editrules: { edithidden: false }, editable: true }, //如果要再Pageer頁面上做編輯，務必加上該行
                        { name: 'R_ID', index: 'R_ID', fixed: true, width: 50, align: "right", sorttype: "number", sortable: false},
                        { name: 'R_YEAR', index: 'R_YEAR', fixed: true, width: 100, editable: true, editoptions: { size: 10 }, editrules: { required: true }, sortable: true },
                        { name: 'REVENUE', index: 'REVENUE', fixed: true, width: 100, editable: true, align: "right", sorttype: "number" },
                        { name: 'REMARK', index: 'REMARK', fixed: true, width: 150, editable: true },
                        { name: 'CREATE_DATE', index: 'CREATE_DATE', fixed: true, width: 150 }
                ],

                //caption: "jqGrid Example 2",    //標題列顯示的文字, 沒有設定時就沒有標題列

                loadonce: true,                 //是否只載入一次,若這個設成false，而分頁又沒有自己控制的話，那麼分頁就無法使用了
                pager: "#pgInline",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 5,                     //每頁預設顯示資料筆數, 預設20筆
                rowList: [5, 10, 20, 30, 50, 200], //每頁最多可以顯示幾筆
                rownumbers: true,               //是否顯示資料的列編號
                viewrecords: true,              //是否顯示總筆數

                height: "auto",                 //jqGrid的高度, height:1000 or height: "auto"

                sortname: "R_YEAR",             //預設排序欄位名稱, 若是datatype不是local, 則只會有排序的icon, 資料還是以後端sql為主
                sortorder: "asc"               //預設排序方式asc升冪，desc降冪
                //multiselect: false,            //是否可以多選
                //gridview: true,                  //資料量大時可加快讀取速度, 但限制是不可用treeGrid, subGrid, or the afterInsertRow event

                //loadComplete: function (rowid) {                 //資料載入完成的Function，可透過此Function自訂表格的顏色等客製化的功能
                
                //, onSelectRow: function (id) {
                //    if (id && id !== lastID) {
                //        gvInline.restoreRow(lastID);
                //        gvInline.editRow(id, true);
                //        lastID = id;
                //    }
                //}
                , editurl: "../../Handler/Revenue.ashx"
                , error: function (XMLHttpRequest, textStatus, errorThrown) {
                    debugger;
                }
                
            });
            gvInline.jqGrid('navGrid', '#pgInline', { edit: false, add: false, del: false, search: false, refresh: false }
            );
            gvInline.jqGrid('inlineNav', '#pgInline', {
                edit: true,
                add: true,
                save: true,
                cancel: true,
                editParams: {
                    keys: true,
                    //oneditfunc: null,
                    successfunc: function (val) {
                        if (val.responseText !== "") {
                            alert(val.responseText);
                            
                        } else {
                            alert("Edit Success");
                            $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger("reloadGrid");
                        }
                    },
                    //url: "../../Handler/Revenue.ashx",
                    extraparam: {
                        rID: function () {
                            var row_id = gvInline.jqGrid('getGridParam', 'selrow');
                            var value = gvInline.jqGrid('getCell', row_id, 'R_ID');
                            return value;
                        },
                    },
                    //aftersavefunc: null,
                    //errorfunc: null,
                    //afterrestorefunc: null,
                    restoreAfterError: true,
                    mtype: "POST"                    
                },
                addParams: {
                    useDefValues: true,
                    addRowParams: {
                        keys: true,
                        extraparam: {},
                        //oneditfunc: function () { alert(""); },
                        successfunc: function (val) {
                            if (val.responseText != "") {
                                alert(val.responseText);
                            } else {
                                alert("Add Success");
                                $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger("reloadGrid");
                            }
                        }
                    },

                }
            }
            );

            // 按下Search button
            $("#" + ClientIDs.lbtnSearch).click(function (e) {

                var rYearValue = $("#" + ClientIDs.ddlRYear).val();

                oPostData.rYear = rYearValue || "";

                // loadonce: true 後,datatype會變成local, 造成 trigger("reloadGrid") 無效, 都抓client data, 要重新把datatype:'json'
                gvPopup.jqGrid('setGridParam', { datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");

                //上面的語法可以拆成下面兩各語法
                //gvPopup.setGridParam( { datatype: 'json', postData: oPostData, page: 1 });
                //gvPopup.trigger("reloadGrid");

                gvPopup2.jqGrid('setGridParam', { datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
                gvInline.jqGrid('setGridParam', { datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");

                return false;
            });

            function getRowValue(rowId) {

                var rowData = $('#gvInline').jqGrid('getRowData', rowId);
                // I have added oper to rowData object because in server side function I am checking with type of operation I am going to do. 
                // BY default we get edit ,but here we are doing some workaround so will not get it ,so need to add this "oper" 
                //rowData.oper = "edit";

                //var rIDvalue = $('#gvInline').jqGrid('getCell', rowId, 'R_ID');
                //var pData = JSON.stringify({
                //    category: "category1",
                //    itemNo: "itemNO1",
                //    factory: "factory1"
                //});
                ////var pData = JSON.stringify({ data: rowData });
                //var finalData = $.extend(true, postData, { rID: rIDvalue });
                //alert("JSON serialized jqGrid data:\n" + pData);
                //alert("StartSave");

                //$.ajax({
                //    url: "../../Handler/Revenue.ashx",// same url that used for editurl
                //    type: "POST",
                //    contentType: "application/json; charset=utf-8",
                //    data: JSON.stringify(rowData),
                //    //cache: false,
                //    dataType: "json",                    
                //    success: function (data) {
                //        alert('Record Upadted successfully');
                //    //    $("#gvInline").trigger("reloadGrid")//to reload grid after successfull

                //    },
                //    error: function (result) {
                //    //    $("#gvInline").trigger("reloadGrid")//to reload grid after error.
                //        alert('error');
                //    }
                //});



            };

        });



    </script>


</head>
<body>
    <form id="form1" runat="server">
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
        <p>EditData in pager</p>
        <div style="width: 95%">
            <table id="gvPopup">
            </table>
            <div id="pgPopup">
            </div>
        </div>
        <p></p>
        <p>EditData in each row</p>
        <div style="width: 95%">
            <table id="gvPopup2">
            </table>
            <div id="pgPopup2">
            </div>
        </div>
        <p></p>
        <p>EditData inline</p>
        <div style="width: 95%">
            <table id="gvInline">
            </table>
            <div id="pgInline">
            </div>
        </div>

    </form>
</body>
</html>

