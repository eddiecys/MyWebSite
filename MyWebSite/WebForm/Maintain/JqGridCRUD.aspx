<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JqGridCRUD.aspx.cs" Inherits="MyWebSite.WebForm.Maintain.JqGridCRUD" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../../Contents/CSS/MyCSS.css" rel="stylesheet" type="text/css" />
    <%--<link href="../../Contents/CSS/Default.css" rel="stylesheet" type="text/css" />--%>
    <link href="../../Contents/CSS/jQueryUI/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/jqGrid/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/jQueryLayout/jquery.layout.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/jQuery/jquery.js" type="text/javascript"></script>
    <%--<script src="../../Scripts/jQuery/jquery.migrate.js" type="text/javascript"></script>--%>
    <script src="../../Scripts/jQueryUI/jquery-ui.js" type="text/javascript"></script>
    <script src="../../Scripts/jQueryLayout/jquery.layout.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/i18n/grid.locale-en.js" type="text/javascript"></script>
    <%--<script src="../../Scripts/jQuery/jquery.url.js" type="text/javascript"></script>--%>
    <script src="../../Scripts/jQueryBlockUI/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../Scripts/MyScript.js" type="text/javascript"></script>
    

    <script type="text/javascript">
        function xalert(xinput) {
            alert("傳遞的訊息是：" + xinput);
        }

        var ClientIDs = {
            ddlRYear: '<%=ddlRYear.ClientID%>'
            , lbtnSearch: '<%=lbtnSearch.ClientID%>'
        };

        //參數
        var oPostData = { rYear: "", createDateFrom: "", createDateTo: "" }

        $(function () {
            //xalert("document.ready start");

            LoadDefault();

            setEvent();
            //xalert("document.ready end");
        });

        function setEvent() {

            // datepicker
            Setdatepicker($("#txtCreateDateFrom"));
            Setdatepicker($("#txtCreateDateTo"));

            // 按下Search button
            //$("#" + ClientIDs.lbtnSearch).click(function (e) {
            $("[id$=lbtnSearch]").click(function (e) {
                console.log("Click Search");
                e.preventDefault();
                queryData();
                
                //return false;
            });

            
        };

        //設定datepicker的屬性與檢查
        function Setdatepicker(obj) {
            //設定屬性
            //obj.datepicker("option", "dateFormat", "yy-mm-dd");
            obj.datepicker({
                dateFormat: "yy-mm-dd",
                changeMonth: true,
                changeYear: true,
                showOn: "both",//"button",
                buttonImage: "../../Contents/Images/calendar-icon.png",
                buttonImageOnly: true,
                buttonText: "Select date"
            }).blur(function () {
                // datepicker lose focus, 通常會搭配focus()使用
                checkDateFormat($(this));
            });
        }

        //檢查日期
        function checkDateFormat(item) {
            var val = item.val();
            if (val != "") {
                // 檢查日期格式 Check Date format mm/dd/yyyy
                var dateValid = checkDateFormat_ymd(val);
                if (!dateValid) {
                    showMsgFunc("'" + val + "' is not a valid date.<br />Please enter a valid date. <br />Ex: 2018-01-01", "Warning"
                        , function () {
                            item.val("");
                            item.focus();
                        });
                }
            }
        }
        // 檢查日期起迄
        function checkDateRange(fromValue, toValue) {
            var result = true;

            if (fromValue == '' || toValue == '') {
                result = true;
            } else if (fromValue > toValue) {
                result = false;
            }
            return result;
        }


        //重新Query
        function queryData() {

            //取得Query參數
            getPostParam();

            if (!checkDateRange($("#txtCreateDateFrom").val(), $("#txtCreateDateTo").val())) {
                ShowMsg("日期起迄錯誤!", "Warning");
            } else {
                // loadonce: true 後,datatype會變成local, 造成 trigger("reloadGrid") 無效, 都抓client data, 要重新把datatype:'json'
                $("#grid").jqGrid('setGridParam', { url: "JqGridCRUD.aspx/Query", mtype: 'POST', datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");
            }

            //GetData();

            return false;
        }

        //取得Query參數
        function getPostParam() {

            //var rYearValue = $("#" + ClientIDs.ddlRYear).val();
            var rYearValue = $("[id$=ddlRYear]").val();
            oPostData.rYear = rYearValue || "";

            oPostData.createDateFrom = $("[id$=txtCreateDateFrom]").val() || "";
            oPostData.createDateTo = $("[id$=txtCreateDateTo]").val() || "";
            //return oPostData;
        }

        function LoadDefault() {
            // 預設今天日期
            //$("#txtCreateDateFrom").val($.datepicker.formatDate('yy-mm-dd', new Date()));

            //ddl重新給值
            //清空options
            $("[id$=dl_ddl_R_YEAR]").empty();
            //一個一個加入
            $("[id$=ddlRYear]").find("option").each(function (index, item) {
                $("[id$=dl_ddl_R_YEAR]").append($('<option>', { value: item.value, text: item.text }))
            });
           //直接用複製的
            // $("[id$=ddlRYear] option").clone().appendTo($("[id$=dl_ddl_R_YEAR]"));
            //$("[id$=ddlRYear]").val("2000");

            var grid = $("#grid");
            grid.jqGrid({
                url: "JqGridCRUD.aspx/Query",
                datatype: "json",
                postData: oPostData,
                mtype: 'POST',
                ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
                serializeGridData: function (postData) {
                    return JSON.stringify(postData);
                },
                loadonce: true,
                jsonReader: {
                    repeatitems: false,
                    root: function (obj) { return eval(obj.d); },
                    page: function (obj) { return grid.jqGrid('getGridParam', 'page'); },
                    total: function (obj) { return Math.ceil(eval(obj.d).length / grid.jqGrid('getGridParam', 'rowNum')); },
                    records: function (obj) { return eval(obj.d).length; }
                },
                colNames: [' ', 'ID', 'YEAR', 'REVENUE', 'REMARK', 'CREATE_DATE'],
                colModel: [
                                { name: 'act', index: 'act', sortable: false, width: '45px', align: "center", formatter: EditLinkFormatter },
                                { name: 'R_ID', index: 'R_ID', sortable: false, width: '50px', align: "center" },
                                { name: 'R_YEAR', index: 'R_YEAR', sortable: true, width: '100px', align: "center" },
                                { name: 'REVENUE', index: 'REVENUE', sortable: true, width: '100px', align: "center", sorttype: "float" },
                                { name: 'REMARK', index: 'REMARK', sortable: false, width: '150px', align: "center" },
                                {
                                    name: 'CREATE_DATE', index: 'CREATE_DATE', sortable: false, width: '150px', align: "center", sorttype: "date"
                                    , formatter: "date", formatoptions: { srcformat: "Y-m-d", newformat: "Y-m-d" } //srcformat:DB的格式, newformat:要秀在畫面上的格式
                                }
                                //{ name: 'index', index: 'index', hidden: true }
                                ],
                multiselect: false,
                height: 'auto',
                autowidth: false,
                gridview: true,
                pager: '#pagerList',
                viewrecords: true,
                rowNum: 10,
                rowList: [5, 10, 20, 30, 50, 200],
                rownumbers: true,
                sortname: "R_YEAR",
                sortorder: "asc",
                loadError: function (xhr, status, error) {
                    var err = JSON.parse(xhr.responseText);
                    ShowMsg(err.Message, "Error");
                },
                onSelectRow: function (id) {
                    
                },
                gridComplete: function () {

                }
            });

            //新增按鈕
            grid.jqGrid('navGrid', "#pagerList", { edit: false, add: false, del: false, search: false, refresh: false, alertzIndex: 1005 })
                    .navButtonAdd("#pagerList", {
                        id: "btnAdd", caption: "", buttonicon: "ui-icon-plus", title: "新增",//default buttonicon: ui-icon-newwin
                        onClickButton: function (e) {
                            ClearDialog();
                            OpenDialog("Add", "");
                        }
                    });

            grid.on("click", ".ui-icon-pencil", function (e) {
                var rowid = $(e.target).data("rowid");
                OpenDialog("Mod", rowid);
            });

            grid.on("click", ".ui-icon-trash", function (e) {//type=click
                //onAction = true;   // ???
                var rowid = $(e.target).data("rowid"); //e.target 指 span.ui-icon.ui-icon-trash

                $("#confirmDialogContent").html('確認刪除此筆資料嗎?').dialog({
                    title: 'Confirm',
                    autoOpen: false,
                    modal: true,
                    buttons: {
                        'OK': function () {
                            var oPostData = { act: "Del", index: "", param: "" }
                            oPostData.index = $("#grid").jqGrid('getRowData', rowid).R_ID;
                            Save(oPostData);

                            $(this).dialog('close');
                        },
                        Cancel: function () {
                            $(this).dialog('close');
                        }
                    }
                }).dialog("open");

                // 使用瀏覽器內建的popup window
                //if (confirm('Are you sure you want to delete this row?')) {
                //    var oPostData = { act: "Del", index: "", param: "" }
                //    //oPostData.index = $("#grid").jqGrid('getRowData', rowid).index;
                //    oPostData.index = $("#grid").jqGrid('getRowData', rowid).R_ID;
                //    Save(oPostData);
                //}
            });
        }

        function EditLinkFormatter(cellValue, options, rowObject) {
            var copybtn = "<div id='edit_" + options.rowId + "' class='ui-state-hover' style='margin:2px; float:left;' >"
                              + "<span class='ui-icon ui-icon-pencil' style='cursor:pointer;' data-rowid='" + options.rowId + "' title='編輯'></span></div>";
            var delbtn = "<div id='del_" + options.rowId + "' class='ui-state-hover' style='margin:2px; float:left;' >"
                             + "<span class='ui-icon ui-icon-trash' style='cursor:pointer;' data-rowid='" + options.rowId + "' title='刪除'></span></div>";

            return copybtn + delbtn;
        }

        function OpenDialog(act, rowid) {
            //若是修改則將Grid資料帶到dialog
            if (act == "Mod") {
                FillDialog(rowid);
            }

            //這裡使用了 jQuery ui 的 dialog function出現對話框 
            $("#divDialog").dialog({
                width: 300, //ie7 這裡的 width 不能設為 auto, ie8 以上可使用
                height: "auto",
                zIndex: 1, //z-index 數字越大的在越上面，反之則在越下面，可以設定為正數或負數，正數代表離你越近，負數則代表離你越遠。
                title: (act=="Mod") ? "修改資料" : "新增資料", //對話框的title
                autoOpen: false,
                closeOnEscape: true,
                modal: true, //modal dialog 的用途是讓你不能點擊對話窗以外的區塊，一定要完成眼前的 dialog 之後才能繼續存取網頁。
                buttons: {
                    //'確認': function () {
                    'Submit': function () {
                        var oPostData = { act: "", index: "", param: "" }
                        oPostData.act = act;
                        if (act == "Mod") {
                            //oPostData.index = $("#grid").jqGrid('getRowData', rowid).index;
                            oPostData.index = $("#grid").jqGrid('getRowData', rowid).R_ID;
                        }
                        //oPostData.param = JSON.stringify($("#divDialog input:text").serializeArray());
                        //divDialog 取出所有輸入型態為 text, select 欄位,serializeArray轉為java srcipt的物件陣列,stringify再序列化為JSON字串  
                        oPostData.param = JSON.stringify($("#divDialog input:text,#divDialog select").serializeArray());
                        //divDialog所有可輸入的
                        //oPostData.param = JSON.stringify($("#divDialog :input").serializeArray());
                        Save(oPostData);
                        $(this).dialog('close');
                    },
                    'Cancel': function () {
                        $(this).dialog('close');
                    }
                }
            });

            $("#divDialog").dialog("open");
        }

        function FillDialog(rowid) {
            var row = $("#grid").jqGrid('getRowData', rowid);
            //text box直接綁定欄位內容
            $("#divDialog").find('input')
                               .each(function () {
                                   // 取得id後去除 dl_ 的wording 去mapping colModel中的name
                                   var colName = $(this)[0].id.replace("dl_", "");
                                   $(this).val(row[colName]);
                               });
            //下拉選單
            $("#divDialog").find('select')
                   .each(function () {
                       // 取得id後去除 dl_ddl_ 的wording 去mapping colModel中的name
                       var colName = $(this)[0].id.replace("dl_ddl_", "");
                       $(this).val(row[colName]);
                   });
            //$("[id$=dl_ddl_R_YEAR]").val(row["R_YEAR"]);
            
        }

        function ClearDialog() {
            //清空所有欄位
            $("#divDialog").find('input').each(function () { $(this).val(''); });
            $("#divDialog").find('select').each(function () { $(this).val(''); });
        }

        function Save(oPostData) {
            $.ajax({
                type: "POST",
                url: "JqGridCRUD.aspx/Save",
                data: JSON.stringify(oPostData),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function () {

                },
                complete: function () {

                },
                success: function (data, textStatus, jqXHR) {
                    if (data.d.type == "Success") {
                        //ShowMsg(data.d.message, data.d.type);

                        $("#grid").jqGrid("GridUnload");  // 將整個grid remove, 再重新loadDefault, 沒有這個資料不會更新
                        LoadDefault();                    // 在相同的地方建立grid

                        //queryData();
                    }
                    else {
                        ShowMsg(data.d.message, data.d.type);
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    var err = JSON.parse(jqXHR.responseText);
                    ShowMsg(err.Message, "System Error");
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="div_bg" align="center" style="padding: 0 0px 0 0">
            <div id="divContentArea" class="Content_Small_no_Position" align="center">
                <p id="p1"></p>
                <div style="width: 95%" align="left">
                    <table>
                        <tr>
                            <td style="width:20%;" class="TD_Title">
                                <asp:Label ID="lblTitleRYear" runat="server" Text="Revenue Year:"></asp:Label>
                            </td>
                            <td >
                                <asp:DropDownList ID="ddlRYear" runat="server" width="100px" class="FormElement ui-widget-content ui-corner-all "></asp:DropDownList>
                            </td>
                            <td  style="width:20%;">
                            </td>
                            <td >
                            </td>
                            <td style="width:12%;">
                                <asp:LinkButton ID="lbtnSearch" runat="server" CssClass="btn" Text="Search"></asp:LinkButton>
                                <%--<button type="button2" id="lbtnSearch" class="ui-button ui-widget ui-corner-all">Search</button>--%>
                            </td>
                        </tr>
                        <tr >
                            <td style="width:20%;" class="TD_Title">
                                <asp:Label ID="lblCreateDateFrom" runat="server" Text="CreateDate From:"></asp:Label>
                            </td>
                            <td >
                                <input id="txtCreateDateFrom" type="text" style="width:100px;" class=" ui-widget-content ui-corner-all " />
                            </td>
                            <td style="width:20%;" class="TD_Title">
                                <asp:Label ID="lblCreateDateTo" runat="server" Text="To:"></asp:Label>
                            </td>
                            <td >
                                <input id="txtCreateDateTo" type="text" style="width:100px;" class=" ui-widget-content ui-corner-all " />
                            </td>
                            <td style="width:12%;">
                            </td>
                        </tr>
                    </table>
                </div>
                <p></p>
                <div style="width: 95%" align="left" >
                    <table id="grid">
                    </table>
                    <div id="pagerList">
                    </div>
                    <%--<input type="hidden" id="source" runat="server" />--%>
                </div>

                <div id="divDialog" style="display: none;" class="ui-jqdialog-content ui-widget-content">
                    <table class="EditTable" border="0" cellpadding="3" cellspacing="3">
                        <tr>
                            <td class="CaptionTD">YEAR
                            </td>
                            <td>
                                <select name="R_YEAR" id="dl_ddl_R_YEAR" class="FormElement ui-widget-content ui-corner-all " ></select>
                            </td>
                        </tr>
<%--                        <tr>
                            <td class="CaptionTD">YEAR
                            </td>
                            <td>
                                <input type="text" name="R_YEAR" id="dl_R_YEAR" class="FormElement ui-widget-content ui-corner-all " />
                            </td>
                        </tr>--%>
                        <tr>
                            <td class="CaptionTD">REVENUE
                            </td>
                            <td>
                                <input type="text" name="REVENUE" id="dl_REVENUE" class="FormElement ui-widget-content ui-corner-all" />
                            </td>
                        </tr>
                        <tr>
                            <td class="CaptionTD">REMARK
                            </td>
                            <td>
                                <input type="text" name="REMARK" id="dl_REMARK" class="FormElement ui-widget-content ui-corner-all" />
                            </td>
                        </tr>
                    </table>
                </div>

                <div id="commonDialogContent" style="display: none; font-size: 12pt;">
                </div>

                <div id="confirmDialogContent" style="display: none; font-size: 12pt;">
                </div>
            </div>
        </div>
    </form>
</body>
</html>
