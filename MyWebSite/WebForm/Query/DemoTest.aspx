<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DemoTest.aspx.cs" Inherits="MyWebSite.WebForm.Query.DemoTest" 
    validateRequest="false" enableEventValidation="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../Contents/CSS/jQueryUI/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/jqGrid/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/jQueryCollapse/jquery.collapse.css" rel="stylesheet" type="text/css"/>
    <link href="../../Contents/CSS/Tooltipster/tooltipster.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/jQueryBlockUI/jquery.blockUI.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/jQuerySelect2/select2.css" rel="stylesheet" type="text/css" />
    <link href="../../Contents/CSS/MyCSS.css" rel="stylesheet" type="text/css" />
    
    <script src="../../Scripts/jQuery/jquery.js" type="text/javascript"></script>
    <script src="../../Scripts/jQueryUI/jquery-ui.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../Scripts/jqGrid/i18n/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../Scripts/jQueryCollapse/jquery.collapse.js" type="text/javascript"></script>
    <script src="../../Scripts/Tooltipster/jquery.tooltipster.js" type="text/javascript"></script>
    <script src="../../Scripts/jQueryBlockUI/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuerySelect2/select2.js" type="text/javascript"></script>
    <script src="../../Scripts/jQueryTablednd/jquery.tablednd.js" type="text/javascript"></script>
    <script src="../../Scripts/MyScript.js" type="text/javascript"></script>
    <script src="../../Scripts/common.js" type="text/javascript"></script>

    <script type="text/javascript">

        var ClientIDs = {
            //#region -- Set HiddenField --
            hdnParameterA: '<%=hdnParameterA.ClientID%>',
            hdnParameterB: '<%=hdnParameterB.ClientID%>',
            hdnParameterC: '<%=hdnParameterC.ClientID%>'
        }

        var oData = { name: "", sex: "" };
        oData.name = "Eddie";
        oData.sex = "男";

        var oYear = { dimYear: "2012" };
        var AreaName;
        var CityName;
        //Grid參數
        var oPostData = { dateFrom: "", dateTo: "", prodGroup: "", cityName: "", storeNo: "" }
        var storeDefaultOptions;

        $(document).ready(function () {

            setEventTab1();

            setEventTab7();

            setEventTab6();

            setTab();

            setCollapse();

            //Active tooltip
            $('.tooltip').tooltipster();
            
            resetDLL($("#ddlCity"));
            resetDLL($("#ddlTown"));
            
            LoadSalesGrid();

            storeDefaultOptions = $("#ddlStore").html();

            LoadLocalGrid();

            // Initialise the table 拖拉
            $("#table-1").tableDnD();

        });

        function setEventTab1() {
            $("#btnTest1").click(function (e) {
                btnTest1String();

                //不想要Button做Postback，記得要加入下面之一行或return false, jquery的 preventDefault();
                //e.preventDefault();
                //禁用按钮的提交 (後端的 event)
                return false;
            });

            $("p").click(function () {
                $(this).hide();
            });

            $("#btnTest4").click(function () {
                //"slow"、"fast" 或毫秒
                $("#p1").hide(1000);
            });

            $("#btnTest5").click(function () {
                $("#p1").show().append(" New Test ").css("background-color", "red").css("color", "blue");
            });

            $("#btnTest6").click(function () {
                $("#p1").toggle();
            });

            $("#btnTest3").click(function () {
                btnTest3StaticList();

                //禁用按钮的提交 
                return false;
            });

            $("#btnTest2").click(function () {
                btnTest2DatatableDDL();

                //禁用按钮的提交 
                return false;
            });

            //下拉選單2改變
            $("#ddlYear2").change(function () {
                ddlChangeRadioBtn();
            });

            $("#ddlArea").change(function () {
                changeArea();
            });

            $("#ddlCity").change(function () {
                changeCity();
            });

            //過濾JSON資料
            $('#btnFilterJSON').click(function () {
                filterJSONString();

                return false;
            });
        }

        function setEventTab7() {
            $("#btnExcel").click(function () {
                //alert("aspx click");
                exportExcel();

                return false;
            });

            $("#btnQuery").click(function (e) {
                e.preventDefault();
                queryJsonGrid();
                //return false;
            });

            $("#btnGetRecord").click(function () {
                if ($("#gvSalesDetail").getDataIDs().length === 0) //目前頁面的筆數
                    alert("No Data Found");
                return false;
            });

            $("#ddlProdGroup").change(function () {
                changeProdGroup();
            });

            $("#ddlCityName").change(function () {
                //alert($('option:selected', this).text());

                changeCityName();
            });

            $("#ddlStore").change(function () {
                changeStore();
            });
        }

        function setEventTab6() {
            $("#btnLocalQuery").click(function (event) {
                event.preventDefault();
                queryLocalGrid();
            });

            //單選
            $("#ddlYearSingle").select2({
                placeholder: "請選擇一個年度",
                allowClear: true,
            });

            //多選
            $("#ddlYearMultiple").select2({
                placeholder: "請選擇年度",
                allowClear: true,     
                //multiple: "multiple", //寫在這會造成預設第一個option會被選取
                width: "350px",
                closeOnSelect: false
            });

            $("#btnShowSelect2Value").click(function (e) {
                e.preventDefault();
                alert($("#ddlYearMultiple").val()||"");
            });

        }

        function setTab() {
            //=========== Tab start ===============================
            //tabs設定, 先切到tab2 => tab1
            $("#tabs").tabs({ active: 1 }).tabs({ active: 5 });

            //disable 第4,6 tab
            //$("#tabs").tabs({ disabled: [3,5] });     //options 多個tab要用options
            //$("#tabs").tabs( "option", "disabled", [ 3, 5 ] );   //options 多個tab要用options
            $("#tabs").tabs("disable", 3).tabs("disable", 1);    //methods 單一tab

            //tab隱藏時的特效,小寫  highlight, fade, fold, explode .... http:///api.jqueryui.com/category/effects/
            //$("#tabs").tabs("option", "hide", { effect: "explode", duration: 1000 });

            $("#tabs").tabs({
                beforeActivate: function (event, ui) {
                    if (ui.newPanel.attr("id") === "tab2") {
                        $("#tab2p").empty().html("gogogo");

                    }
                    else if (ui.newPanel.attr("id") === "tab3") {
                        //將src綁定到iframe, 也就是tab裡面直接連結其他 aspx的內容
                        //var queryStr = "?formno=" + sFormNo;
                        var url = ui.newPanel.data("src");// + queryStr;
                        ui.newPanel.find("iframe").attr("src", url);
                    }
                }
            });

            $("#btnEnableTab").click(function () {
                //取得目前是哪個tab active, 若目前是點在tab2回傳1
                //var target = $("#tabs").tabs("option", "active");
                //取得目前是哪個tab active, 若目前是tab4,tabl5 disable回傳3,4
                var target = $("#tabs").tabs("option", "disabled") + '';
                //alert(target);
                //將目前取得的tab全部enable
                var eTar = target.split(',');
                $(eTar).each(function (index, item) {
                    //alert(eTar[index]);
                    $("#tabs").tabs("enable", parseInt(item));
                });

                //找到li 下 a的href是#tab5的上一階li 移除隱藏的style
                $('li a[href="#tab5"]').parent().removeAttr("style");

                return false;
            });
            //=========== Tab end ===============================

        }

        function setCollapse() {
            //#region -- 縮合整個架構 --
            var content = new jQueryCollapse($("#content"), { query: ".collapsible" });
            //listen for close/open all
            $('#closeAll').click(function (event) {
                content.close();
            });
            $('#openAll').click(function (event) {
                content.open();
            });
            //預設全部開啟, 或是在HTML的class使用open指定哪個section預設開啟
            //content.open();
            //content.open(2); 開啟第三個section
            //#endregion -- 縮合整個架構 --
        }

        function btnTest1String() {
            $.ajax({
                //要用post方式 
                type: "Post",
                //方法所在页面和方法名 
                url: "DemoTest.aspx/SayHello",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                //data: oData,
                data: JSON.stringify(oData),
                //傳入參數名稱與順序要一模一樣
                //data: "{'str':'我是','str2':'XXX'}",
                success: function (data) {
                    //返回的数据用data.d获取内容 
                    alert("Success:" + data.d);
                },
                error: function (xhr, status, error) {
                    var err = JSON.parse(xhr.responseText);
                    alert("Error:" + err.Message);
                }
            });
            //.done(function () {
            //    alert("Done!");
            //});
        }

        function btnTest3StaticList() {
            $.ajax({
                type: "Post",
                url: "DemoTest.aspx/GetArray",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //插入前先清空ul 
                    $("#list").html("");

                    //递归获取数据 
                    $(data.d).each(function () {
                        //插入结果到li里面 
                        $("#list").append("<li>" + this + "</li>");
                    });

                    //alert(data.d);

                    //所有div隱藏
                    //$("div").hide();
                },
                error: function (err) {
                    alert(err);
                }
            });

        }

        function btnTest2DatatableDDL() {
            $.ajax({
                type: "Post",
                url: "DemoTest.aspx/GetStr",
                data: JSON.stringify(oYear),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {

                    $("#ttbJSONString").text(data.d);

                    //json string to json object
                    var resp = JSON.parse(data.d);

                    //alert(resp[0]["YearMonthKey"]);

                    $("#list").html("");
                    var rYear = {};// = {year: ""};
                    $(resp).each(function (index, item) {
                        //$("#list").append('<li>' + item.YearMonthKey + ':' + item.QuarterName + '</li>');
                        //$("#list").append(String.format("<li>{2} {0}:{1}</li>", item.YearMonthKey, item.QuarterName, index));
                        rYear[index] = item.YearMonthKey;
                    });

                    //呼叫函式產生ddl
                    setSelectOptions($("#ddlYear"), rYear, ["4"]);

                    //產生ddl
                    $.each(rYear, function (key, value) {
                        //加在最後一個node
                        $("#ddlYear2").append($('<option></option>').val(key).text(value));
                    });
                    //在第4個位置後加上Test選項
                    $("#ddlYear2 option:eq(3)").after($('<option></option>').val("111").text("Test"));
                    //選取第5個
                    $("#ddlYear2 option:eq(4)").attr("selected", true);
                    //目前選擇的index
                    //alert($('#ddlYear2 option:selected').index());
                    //目前選取的item刪除, 也就是剛剛新增的Test刪除
                    $("#ddlYear2 option:selected").remove();
                    //下拉選單全部清空
                    //$("#ddlYear2").empty();


                },
                error: function (err) {
                    alert(err);
                }
            });
        }

        function filterJSONString() {

            if ($("#ttbJSONString").text() === "") {
                alert("須先取得前端資料");
                return false;
            }

            // MultiLine 的 textbox 不可以用val()取值, 可以用html()或是text()
            var oriJSON = JSON.parse($("#ttbJSONString").html());
            //alert($('#ttbFilterString').val());

            // 使用jquery 的 grep 取出符合的資料
            var filterJSON = $.grep(oriJSON, function (item, index) { return item.QuarterName === $('#ttbFilterString').val() });

            $("#ttbJOSNFilterString").val(JSON.stringify(filterJSON));

            //object轉string再轉object
            var resp = JSON.parse(JSON.stringify(filterJSON));

            //第一個Array的JSON的YearMonthKey
            //alert(resp[0].YearMonthKey);
            //array順排序(字串)
            //resp.sort(function (a, b) { return (a.YearMonthKey > b.YearMonthKey) - (a.YearMonthKey < b.YearMonthKey) });
            //array逆排序(字串)
            resp.sort(function (a, b) { return (a.YearMonthKey < b.YearMonthKey) - (a.YearMonthKey > b.YearMonthKey) });

            $("#ttbJOSNFilterString").val(JSON.stringify(resp));

            var ddlMonth = $("#ddlFilterMonth")
            ddlMonth.empty();
            $(resp).each(function (index, item) {
                ddlMonth.append($('<option></option>').val(item.YearMonthKey).text(item.YearMonthKey));
                //alert(item.YearMonthKey + " " + item.QuarterName);
            });
        }

        function exportExcel() {
            $.ajax({
                type: "Post",
                url: "DemoTest.aspx/GetExcelData",
                //data: JSON.stringify(oYear),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {

                    $("<form>", { action: "../../Handler/ExportDT2Excel.ashx", method: "post" })
                        .append($("<input>", { type: "hidden", name: "DTdata", value: data.d }),
                                $("<input>", { name: "criteria", value: "criteria" }),
                                $("<input>", { name: "filename", value: "ExportFile" }))
                        .appendTo('body').submit().remove();

                },
                error: function (err) {
                    alert(err);
                }

            })
        }

        //下拉選單自定函式
        function setSelectItem() {
            //alert($("#ddlYear").val());
            //alert($("#ddlYear option:selected").text());

            //使用name與value設定checked
            //$("input:radio[name='gender'][value='Male']").prop("checked", "checked");

            //有value時, 設定checked
            //$("[name=gender]").val(["Male"]);

            //無value但有ID, 設定checked
            $("#rbtMale").prop("checked", true);

        }

        function resetDLL(myDLL)
        {
            myDLL.empty().append($('<option></option>').val('').text('------------'));
        }

        function ddlChangeRadioBtn() {
            //取出選取的Text
            //alert($("#ddlYear2 option:selected").text());

            var $radios = $("input:radio[name='gender']");

            //// prop 會抓取目前的狀態, DOM的屬性回傳bool , string, number 等
            //alert("rbtMale prop: " + $("#rbtMale").prop("checked"));
            //alert("rbtFemale prop: " + $("#rbtFemale").prop("checked"));
            //// attr 只會抓取html最初設定的狀態, HTML的特性且只會回傳字串
            //alert("rbtMale attr: " + $("#rbtMale").attr("checked")); 
            //alert("rbtFemale attr: " + $("#rbtFemale").attr("checked")); 

            //if ($radios.filter("[value='Female']").is(":checked") === false)
            //if ($("#rbtFemale").is(":checked") === false)
            //if ($("input:radio[name='gender']:checked").val() !== "Female
            if ($("#rbtFemale").prop("checked") === false) {
                //alert($("#rbtFemale").prop("checked"));

                //秀出目前是哪個選項checked
                //alert("目前選取" + $("input:radio[name='gender']:checked").val());

                //將radio button Female設定checked
                //$("input:radio[name='gender'][value='Female']").prop("checked", true);
                $("#rbtFemale").prop("checked", true);

                //可以用attr去設定checked, 但不要用attr去判斷是否checked, 只要有設定checked屬性就會回傳checked不管是否true或false
                //$("#rbtFemale").attr("checked", "checked");


                //只有改變radio選項時才將 ddlYear2 同步給 ddlYear
                $("#ddlYear option[value=" + $("#ddlYear2 option:selected").val() + "]").prop("selected", true);

                //$("#ddlYear").prop("disabled", true);

            }
        }

        function changeArea()
        {
            resetDLL($("#ddlCity"));
            resetDLL($("#ddlTown"));

            AreaName = $("#ddlArea option:selected").val();

            if (AreaName.length === 0)
                return false;
            
            var oData = "{'areaName':'" + AreaName + "'}";

            $.ajax({
                type: "Post",
                url: "DemoTest.aspx/getCityData",
                data: oData,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert(data.d);
                    //json string to json object
                    var resp = JSON.parse(data.d);

                    //array順排序(數字)
                    //resp.sort(function (a, b) { return a.CityID - b.CityID });
                    //array逆排序(數字)
                    resp.sort(function (a, b) { return b.CityID - a.CityID });

                    $(resp).each(function (index, item) {
                        $("#ddlCity").append($('<option></option>').val(item.CityID).text(item.CityName));
                    });
                },
                error: function (err) {
                    alert("Error: " + err);
                }
            });
        }

        function changeCity()
        {
            resetDLL($("#ddlTown"));

            CityName = $("#ddlCity option:selected").text();

            // CityID
            //alert($("#ddlCity option:selected").val());

            if (CityName.length === 0)
                return false;

            var oData = "{'areaName':'" + AreaName + "','cityName':'" + CityName + "'}";

            $.ajax({
                type: "Post",
                url: "DemoTest.aspx/getTownData",
                data: oData,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert(data.d);
                    //json string to json object
                    var resp = JSON.parse(data.d);

                    //array順排序(數字)
                    resp.sort(function (a, b) { return a.GeographyID - b.GeographyID });

                    $(resp).each(function (index, item) {
                        $("#ddlTown").append($('<option></option>').val(item.GeographyID).text(item.TownName));
                    });
                },
                error: function (err) {
                    alert("Error: " + err);
                }
            });

        }

        //Grid的篩選
        function changeCityName() {

            var strCityName = ($("#ddlCityName option:selected").text() === "全部") ? "" : $("#ddlCityName option:selected").text();
            oPostData.storeNo = "";
            oPostData.cityName = strCityName;
　　　　　　　
　          //是否使用前端的過濾方式
            var isJquery = true;

            //使用前端JQuery去過濾store ddl
            if (isJquery == true) {
                //將ddlStore的選單還原為一開始的全部資料
                $("#ddlStore").html(storeDefaultOptions);
                if (strCityName == "")
                    return;

                //value包含H的刪除, 使用*=
                //$("#ddlStore [value*=('H')]").remove();
                //alert($("#ddlStore [value='" + "H0010" + "']").val() + "");

                //text包含city的移除
                //$("#ddlStore option:contains(" + strCityName + ")").remove();
                //text不包含city的移除
                $("#ddlStore option:not(:contains(" + strCityName + "))").remove();
                //加到第一筆
                $("#ddlStore").prepend($('<option></option>').val('').text('全部'));
            }
            //使用ajax去後端db過濾store ddl
            else
            {
                $("#ddlStore").empty().append($('<option></option>').val('').text('全部'));
                var oData = "{'cityName':'" + strCityName + "'}";
                //alert(oData);
                $.ajax({
                    type: "Post",
                    url: "DemoTest.aspx/getStoreJson",
                    data: oData,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        //alert(data.d);
                        //json string to json object
                        var resp = JSON.parse(data.d);

                        $(resp).each(function (index, item) {
                            $("#ddlStore").append($('<option></option>').val(item.StoreNo).text(item.StoreName + "(" + item.CityName + ")"));
                        });
                    },
                    error: function (err) {
                        alert("Error: " + err);
                    }
                });
            }
            

        }

        function changeStore() {
            var ObjStore = $("#ddlStore option:selected");
            if (ObjStore.index() === 0)
            {
                oPostData.storeNo = "";
                return false;
            }

            oPostData.storeNo = ObjStore.val();

        }

        function changeProdGroup() {
            //alert($("#ddlProdGroup option:selected").index() + "");
            if ($("#ddlProdGroup option:selected").index() === 0)
                oPostData.prodGroup = "";
            else
                oPostData.prodGroup = $("#ddlProdGroup option:selected").val();
        }

        function LoadSalesGrid() {

            var urlPath;
            if ($("#" + ClientIDs.hdnParameterA).val() === 'Y')
                urlPath = "InitGrid";
            else
                urlPath = "QueryGrid";

            var sdgrid = $("#gvSalesDetail");
            //alert('開始執行');
            //debugger;
            sdgrid.jqGrid({
                url: "DemoTest.aspx/" + urlPath,  //設定取得資料的Web Service/Method
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
                    page: function (obj) { return sdgrid.jqGrid('getGridParam', 'page'); }, // the number of the requested page
                    total: function (obj) { return Math.ceil(eval(obj.d).length / sdgrid.jqGrid('getGridParam', 'rowNum')); },  // the total pages of the query
                    records: function (obj) { return eval(obj.d).length; }                  // the total records from the query
                },
                colNames: [ //定義欄位的顯示名稱
                         //''
                        // , ''
                         'Seq'
                         , 'OrderDate'
                         , 'OrderNo'
                         , 'StoreNo'
                         , 'StoreName'
                         , 'ProdGroup'
                         , 'ProdName'
                         , 'Qty'
                         , 'Price'
                         , 'Amt'
                         , 'CreateDate'
                ],
                colModel: [ //定義欄位格式 (ex. 寬度，排序，對齊，編輯等等功能)，name屬性必須要與後端回傳的欄位名稱相同
                        //{
                        //    name: 'act', width: 20, fixed: true, sortable: false, resize: false//, formatter: 'actions',
                        //},
                       // { name: "key", index: "key", hidden: true, editrules: { edithidden: false }, editable: true }, //如果要再Pageer頁面上做編輯，務必加上該行
                        { name: 'TxnSeq', index: 'TxnSeq', fixed: true, width: 50, align: "right", sorttype: "number" },
                        { name: 'OrderDate', index: 'OrderDate', fixed: true, width: 60, editable: true, formatter: "date", formatoptions: { srcformat: "Y-m-d", newformat: "Y/m/d" } },
                        { name: 'TxnNumber', index: 'TxnNumber', fixed: true, width: 80, align: "left", sorttype: "number" },
                        { name: 'StoreNo', index: 'StoreNo', fixed: true, width: 50 },
                        { name: 'StoreName', index: 'StoreName', fixed: true, width: 90 },
                        { name: 'ProdCode', index: 'ProdCode', editable: true, width: 80},
                        { name: 'ProdName', index: 'ProdName', fixed: true, width: 140 },
                        { name: 'TxnQty', index: 'TxnQty', align: "right", sorttype: "number", editable: true, width: 50 },
                        { name: 'Price', index: 'Price', align: "right", sorttype: "number", editable: true, width: 50 },
                        { name: 'Amt', index: 'Amt', align: "right", sorttype: "number", width: 50 },
                        { name: 'CreateDate', index: 'CreateDate', formatter: "date", formatoptions: { srcformat: "ISO8601Long", newformat: "Y-m-d H:i:s" }, width: 110 } //待確認時間格式
                ],

                //caption: "jqGrid Example 2",    //標題列顯示的文字, 沒有設定時就沒有標題列

                loadonce: true,                 //是否只載入一次,若這個設成false，而分頁又沒有自己控制的話，那麼分頁就無法使用了
                pager: "#pgSalesDetail",        //分頁區塊名稱,對應到分頁<div>的id，
                rowNum: 15,                     //每頁預設顯示資料筆數, 預設20筆
                rowList: [15, 30, 50, 200], //每頁最多可以顯示幾筆
                //rownumbers: true,               //是否顯示資料的列編號
                viewrecords: true,              //是否顯示總筆數

                height: "auto",                 //jqGrid的高度, height:1000 or height: "auto"
                width: 880,                  //jqGrid的寬度
                //autowidth: true,                //是否自動寬度
                //shrinkToFit: false,           //預設為true, 設定為false可將每個欄位的寬度固定, 產生grid內部的橫向捲軸

                loaddui: "block",               //是否顯示loadtext, disable:不顯示 enable:顯示預設"Loading..." block:顯示客製的文字 
                loadtext: "重新整理中..",       //查詢或排序時的wording, 預設是Loading...

                sortname: "TxnSeq",             //預設排序欄位名稱
                sortorder: "asc",              //預設排序方式asc升冪，desc降冪
                //multiselect: false            //是否可以多選
                gridview: true,                  //資料量大時可加快讀取速度, 但限制是不可用treeGrid, subGrid, or the afterInsertRow event

                //loadComplete:                 //資料載入完成的Function，可透過此Function自訂表格的顏色等客製化的功能,ajax完成後的事件
                //gridComplete:function() {     //將所有資料讀進grid後的事件,   $("#list").clearGridData();會觸發gridComplete
                //    // 防止水平方向上出现滚动条  
                //    removeHorizontalScrollBar();  
                //}
                loadBeforeSend: function () {
                    if ($("#" + ClientIDs.hdnParameterA).val() != 'Y')
                        $.blockUI();
                },
                gridComplete: function () {
                    if ($("#" + ClientIDs.hdnParameterA).val() != 'Y')
                        $.unblockUI();
                },
                loadComplete: function () {
                    //$.unblockUI();
                    //var ids = sdgrid.jqGrid('getDataIDs'); //取得所有ids單一頁面  
                    //alert(ids.length);
                }
            });
            sdgrid.jqGrid('navGrid', '#pgSalesDetail', { edit: false, add: false, del: false, search: false, refresh: false },
                                                    {},    //EditOptions,
                                                    {},    //AddOptions,
                                                    {},    //DelOptions
                                                    {});

        }

        function LoadLocalGrid() {
            //alert($("[id$=hdnParameterB]").val() || "[]");
            var grid = $("#gvLocal");
            

            grid.jqGrid({
                data: $.parseJSON($("[id$=hdnParameterB]").val() || "[]"),
                datatype: "local",
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
                colNames: ['R_ID', 'YEAR', 'REVENUE', 'REMARK', 'CREATE_DATE'],
                colModel: [
                            { name: 'R_ID', index: 'R_ID', sortable: false, width: '50px', align: "center" },
                            { name: 'R_YEAR', index: 'R_YEAR', sortable: true, width: '100px', align: "center" },
                            { name: 'REVENUE', index: 'REVENUE', sortable: true, width: '100px', align: "center", sorttype: "float" },
                            { name: 'REMARK', index: 'REMARK', sortable: false, width: '150px', align: "center" },
                            {
                                name: 'CREATE_DATE', index: 'CREATE_DATE', sortable: false, width: '150px', align: "center", sorttype: "date"
                                , formatter: "date", formatoptions: { srcformat: "Y-m-d", newformat: "Y-m-d" } //srcformat:DB的格式, newformat:要秀在畫面上的格式
                            }
                ],
                multiselect: false,
                //height: 'auto',
                height: 215, //小於15筆高度出現垂直卷軸
                autowidth: false,
                gridview: true,
                pager: '#pgLocal',
                viewrecords: true,
                rowNum: 15,
                rowList: [ 15, 30, 50, 200],
                rownumbers: true,
                sortname: "R_YEAR",
                sortorder: "desc",
                caption: 'Caption here',
                overlay: false,
                loadError: function (xhr, status, error) {
                    var err = JSON.parse(xhr.responseText);
                    ShowMsg(err.Message, "Error");
                }
                //,
                //onSelectRow: function (id) {

                //},
                //gridComplete: function () {

                //}
            });

            grid.jqGrid('navGrid', "#pgLocal", { edit: false, add: false, del: false, search: false, refresh: false, alertzIndex: 1005 })
                                .navButtonAdd("#pgLocal", {
                                    id: "btnLocalExcel", caption: "", buttonicon: "ui-icon-bookmark", title: "Export",//default buttonicon: ui-icon-newwin
                                    onClickButton: function (e) {
                                        alert("Excel out...");
                                    }
                                });

        }

        function queryJsonGrid() {
            $("#" + ClientIDs.hdnParameterA).val('N');
            //alert($("#" + ClientIDs.hdnParameterA).val());

            $("#gvSalesDetail").jqGrid('setGridParam', { url: "DemoTest.aspx/QueryGrid", mtype: 'POST', datatype: 'json', postData: oPostData, page: 1 }).trigger("reloadGrid");

        }

        function queryLocalGrid() {
            var yearValue = ($("#rbtYearSingle").prop("checked") == true) ? $("#ddlYearSingle :selected").val() || "" : $("#ddlYearMultiple").val() || "";

            //alert("{rYear:'" + yearValue + "'}");
            //沒選
            if (yearValue == "")
            {
                alert("請先選擇 " + (($("#rbtYearSingle").prop("checked") == true) ? "單選" : "多選") + " 的年度");
                return;
            }

            $.ajax({
                type: "Post",
                url: "DemoTest.aspx/getRevenueJSON",
                //data: "{rYear:'" + $("#ddlRevenueYear :selected").val() + "'}",
                data: "{rYear:'" + yearValue + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert(data.d || "[]");

                    //將array json string轉為json物件, 建議使用原生
                    var localData = JSON.parse(data.d);  //原生
                    //var localData = $.parseJSON(data.d); //jquery, 會去使用原生的在加上錯誤判斷

                    //要先clearGridData() , 不然datatype:local會將資料append在原本的資料前面
                    $("#gvLocal").clearGridData().jqGrid('setGridParam', { data: localData, page: 1 }).trigger("reloadGrid");
                },
                error: function (err) {
                    alert("Error: " + err);
                }
            });

        }


        //第一個是在真的filebox中設定onchange
        //讓真的filebox接收到檔案時，可以同步把檔案路徑名稱放進假的textbox中
        //不然真的filebox被隱藏了，使用者也無法看到自己選擇了哪個檔案。
        function inFalseFilebox(obj, id) {

            $('#' + id).val(obj.value);
            $('#filePath').text(obj.value);

        }

        //第二個是點擊按鈕後的上傳檔案事件
        function fileUpload(id) {
            //取得該filebox中的檔案資料：
            var files = document.getElementById(id).files;
            //用JQ也可以寫成：
            // var files = $('#'+id)[0].files;

            //再來將剛剛取得的檔案資料放進FormData裡
            var fileData = new FormData();
            //files[0].name會回傳包含副檔名的檔案名稱
            //所以要做檔案類型的判斷也可以用file[0].name做
            fileData.append(files[0].name, files[0]);

            // alert(files[0].name);

            //之後送ashx做處理
            $.ajax({
                url: "../../Handler/fileUpload.ashx",
                type: "post",
                data: fileData,
                contentType: false,   // 告诉jQuery不要去設置Content-Type
                processData: false,　　// 告诉jQuery不要去處理發送的數據
                async: false,
                success: function () {
                    //跳訊息提示
                    alert('上傳成功!');
                    //清掉假filebox中的內容
                    document.getElementById('false_fileBox').value = '';
                },
                error: function (xhr, status, error) {
                    var err = JSON.stringify(xhr);
                    alert(err);
                }
            });
        }


        
    </script>


</head>
<body>
    <form id="form1" runat="server">
    <asp:HiddenField ID="hdnParameterA" runat="server" />
    <asp:HiddenField ID="hdnParameterB" runat="server" />
    <asp:HiddenField ID="hdnParameterC" runat="server" />

    <asp:Button ID="btnEnableTab" runat="server" class="btn tooltip" Title="show me the tooltip" Text="EnableTabs" />
    <div id="tabs" style="width: 920px; height: 550px; overflow: auto; margin-left: auto; margin-right: auto">
        <ul>
            <li><a href="#tab1">1 ajax練習操作</a></li>
            <li><a href="#tab2">2 收合 tooltip</a></li>
            <li><a href="#tab3">3 連結page</a></li>
            <li><a href="#tab4">4 disableTab </a></li>
            <li style="display: none"><a href="#tab5">5 隱藏</a></li>
            <li><a href="#tab6">6 Grid Local & Select2</a></li>
            <li><a href="#tab7">7 Grid Json & Excel</a></li>
        </ul>
        <div id="tab1">
            <table style="width: 90%; height: 90%; overflow: auto; margin-left: auto; margin-right: auto">
                <tr><td>
                    <asp:DropDownList ID="ddlLanguage" runat="server">
                        <asp:ListItem Value="zh-TW">中文</asp:ListItem>
                        <asp:ListItem Value="en-US">英文</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="lbLanguage" runat="server" Text=""></asp:Label>

                    <div>
                        <asp:Button ID="btnTest1" runat="server" Text="ajax傳入物件" />
                        <asp:Button ID="btnTest3" runat="server" Text="ajax回傳陣列" />
                        <p>If you click on me, I will disappear.</p>
                    </div>
                    <div id="list"></div>
            
                    <p id="p1" style="color:red">Test123</p>
                    <div>
                        <button type="button" id="btnTest4">Hide</button>
                        <input id="btnTest5" type="button" value="Show" />
                        <input id="btnTest6" type="button" value="Toggle" />
                    </div>
                    <br />

                    <div>
                        <asp:Button ID="btnTest2" runat="server" Text="ajax取得資料庫資料放入ddl(前端)" />
                        <asp:DropDownList ID="ddlYear" runat="server" AutoPostBack="false" onchange="setSelectItem()"></asp:DropDownList>
                        <asp:DropDownList ID="ddlYear2" runat="server"></asp:DropDownList>
                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Lang, Male %>"></asp:Label>
                        <input type="radio" id="rbtMale" name="gender" value="Male" checked="checked" />
                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Lang, Female %>"></asp:Label>
                        <input type="radio" id="rbtFemale" name="gender" value="Female" />
                    </div>
                    <br/>
                    <asp:Label ID="Label4" runat="server" Text="篩選JSON中Quarter字串"></asp:Label>
                    <asp:TextBox ID="ttbFilterString" runat="server" class=" ui-widget-content ui-corner-all ">第4季</asp:TextBox>
                    <input type="button" id="btnFilterJSON" value="Filter JSON" />
                    <asp:DropDownList ID="ddlFilterMonth" runat="server"></asp:DropDownList>
                    <br/>
                    <asp:TextBox ID="ttbJSONString" runat="server" Height="100px" width="40%" TextMode="MultiLine"></asp:TextBox>
                    <asp:TextBox ID="ttbJOSNFilterString" runat="server" Height="100px" width="40%" TextMode="MultiLine"></asp:TextBox>
                    <br/>
            
                </td></tr>
                <tr><td>
                    <asp:Label ID="Label3" runat="server" Text="下拉選單連動, Area後端邦定, City前端ajax, Town前端ajax"></asp:Label><br/>
                    <asp:DropDownList ID="ddlArea" runat="server" Width="100px" class="ui-widget-content ui-corner-all"></asp:DropDownList>
                    <asp:DropDownList ID="ddlCity" runat="server" Width="100px" class="ui-widget-content ui-corner-all"></asp:DropDownList>
                    <asp:DropDownList ID="ddlTown" runat="server" Width="100px" class="ui-widget-content ui-corner-all"></asp:DropDownList>
                </td></tr>
                <tr><td>


                </td></tr>
            </table>
        </div>
        <div id="tab2">
            <a href="#" id="openAll" class="tooltip" title="Expand All">展開全部</a> | <a href="#" id="closeAll" title="Collapse All">收合全部</a>
            <br />
            <br />
            <div id="content">
                <div class="collapsible open tooltip" id="section1" title ="1 info"> One Information </div>
                <span class="tooltip" title="This is my span's tooltip message!">Some text 移過來秀tooltip</span>
                <ul>
                    <li>Apple</li>
                    <li>Pear</li>
                    <li>Orange</li>
                </ul>
                <div class="collapsible tooltip" id="section2" title ="2 info"> Two Information </div>
                <ul>
                    <li>Apple2</li>
                    <li>Pear2</li>
                    <li>Orange2</li>
                </ul>
                <div class="collapsible" id="section3"> Three Information </div>
                <ul>
                    <li>Apple3</li>
                    <li>Pear3</li>
                    <li>Orange3</li>
                </ul>
            </div>
        </div>
        <div id="tab3" data-src="<%=ResolveClientUrl("~/WebForm/Maintain/JqGridCRUD.aspx")%>">
            <iframe id="iJqGridGRUD" width="100%" height="520px" frameborder="0" border="0" cellspacing="0" ></iframe>
        </div>
        <div id="tab4">
            <table id="table-1" cellspacing="0" cellpadding="2">
                <tr id="1"><td>1</td><td>One</td><td>some text</td></tr>
                <tr id="2"><td>2</td><td>Two</td><td>some text</td></tr>
                <tr id="3"><td>3</td><td>Three</td><td>some text</td></tr>
                <tr id="4"><td>4</td><td>Four</td><td>some text</td></tr>
                <tr id="5"><td>5</td><td>Five</td><td>some text</td></tr>
                <tr id="6"><td>6</td><td>Six</td><td>some text</td></tr>
            </table>
        </div>
        <div id="tab5">
            <!--這一行是假的filebox-->
            <input id="false_fileBox" name="false_fileBox" placeholder="點此選擇檔案" type="text"/>
            <!--這一行是被隱藏起來的真filebox，用css將opacity(不透明度)設為0，再用margin(外邊距)給調整到與上方的textbox重疊的位置style="margin-top: -27px; margin-bottom: 8px; width: 100%; opacity: 0;"-->
            <input id="fileBox" name="fileBox" onchange="inFalseFilebox(this,'false_fileBox')" style="margin-top: -27px; margin-bottom: 8px;" type="file" class="file" accept=".pdf,.xls,.xlsx"/>

            <!--上傳按鈕，會用他來觸發檔案上傳的事件-->
            <button type="button" onclick="fileUpload('fileBox')">上傳</button>
            <br/>
            <br/>
            <!-- Label 標籤有一個奇特的特性，只要他包在任何 Input 標籤外面，點擊 Label 就等於點擊 Input -->
            <label class="btn" style="cursor:pointer">
                <input id="upload_img" type="file" style="display:none;" accept=".pdf,.xls,.xlsx" onchange="inFalseFilebox(this,'false_fileBox')"/>
                <!-- 這裡可以放一個icon <i class="fa fa-photo"></i>, 在接文字  -->
                 選擇檔案
            </label>
            <label id="filePath"></label>
        </div>
        <div id="tab6">
            <table style="width:90%;  margin-left: auto; margin-right: auto;" border="0">
                <tr>
                    <td class="TD_Title" style="width:160px">
                        年度(原生)
                    </td>
                    <td style="width:160px">
                        <asp:DropDownList ID="ddlRevenueYear" runat="server" style="width:150px;" class=" ui-widget-content ui-corner-all "></asp:DropDownList>
                    </td>
                    <td style="width:160px">
                        
                    </td>
                    <td style="width:160px">
                        
                    </td>
                    <td></td>
                </tr>                
                <tr>
                    <td class="TD_Title">
                        年度(單選Select2)
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlYearSingle" runat="server" Style="width: 150px;" ></asp:DropDownList>
                    </td>
                    <td colspan="2">
                        
                    </td>
                    <td style="text-align:right; ">
                        <asp:Label ID="lblSingle" runat="server" Text="單選"></asp:Label>
                        <input type="radio" id="rbtYearSingle" name="YearOption" value="Single" checked="checked" style="cursor:pointer;"/>
                        <asp:Label ID="lblMultiple" runat="server" Text="多選"></asp:Label>
                        <input type="radio" id="rbtYearMultiple" name="YearOption" value="Multiple" style="cursor:pointer;"/>
                    </td>
                </tr>
                <tr>
                    <td class="TD_Title">
                        年度(多選Select2)
                    </td>
                    <td colspan="3">
                        <asp:DropDownList ID="ddlYearMultiple" runat="server"　 multiple="multiple"></asp:DropDownList>
                        <asp:Button ID="btnShowSelect2Value" runat="server" class="btn" Text="秀出Select2值" style="cursor:pointer;" />
                    </td>
                    <td style="text-align:right; ">
                        <asp:Button ID="btnLocalQuery" runat="server" class="btn" Text="查詢" style="cursor:pointer;" />
                    </td>
                </tr>
            </table>
            <asp:Panel ID="Panel1" runat="server" GroupingText="Local Data" Height ="300px">
                <table id="gvLocal">
                </table>
                <div id="pgLocal">
                </div>
            </asp:Panel>
        </div>
        <div id="tab7">
            <table style="width:90%;  margin-left: auto; margin-right: auto;" border="0">
                <tr>
                    <td style="width:15%;" class="TD_Title">
                        縣市
                    </td>
                    <td style="width:25%;">
                        <asp:DropDownList ID="ddlCityName" runat="server" Width="150px" class="ui-widget-content ui-corner-all"></asp:DropDownList>
                    </td>
                    <td style="width:15%;"  class="TD_Title">
                        店名
                    </td>
                    <td style="width:25%;">
                        <asp:DropDownList ID="ddlStore" runat="server" Width="150px" class="ui-widget-content ui-corner-all"></asp:DropDownList>
                    </td>
                    <td style="width:20%;">
                        
                    </td>
                </tr>
                <tr>
                    <td class="TD_Title">
                        分類
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlProdGroup" runat="server" Width="150px" class="ui-widget-content ui-corner-all"></asp:DropDownList>
                    </td>
                    <td>
                        
                    </td>
                    <td>
                        
                    </td>
                    <td>
                        
                    </td>
                    <td style="text-align:right">
                        <asp:Button ID="btnQuery" runat="server" class="btn" Text="查詢" />
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Button ID="btnExcel" runat="server" class="btn" Text="匯出Excel全部資料" />
                    </td>
                    <td colspan="3">
                        &nbsp;
                    </td>
                    <td>
                        <asp:Button ID="btnGetRecord" runat="server" class="btn" Text="是否有資料" />
                    </td>
                </tr>
            </table>

            <table id="gvSalesDetail">
            </table>
            <div id="pgSalesDetail">
            </div>

        </div>
    </div>
    </form>
</body>
</html>

