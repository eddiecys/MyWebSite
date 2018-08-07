//$(document).ready(function () {
    //Global Ajax Function - Start
    //$(document).ajaxStart(function () {
    //    $("#loadingMessage").show();
    //});

    //$(document).ajaxStop(function () {
    //    $("#loadingMessage").hide();
    //});

    //$(document).ajaxComplete(function (e, xhr, opts) {
    //    $("#loadingMessage").hide();
    //});

    //$(document).ajaxError(function (e, xhr, opts, ex) {
    //    $("#loadingMessage").hide();
    //    hideBlockUI();

    //    if (xhr.status == "590") {
    //        showMsg("Warning", "The connection has timed out.<br>Please log on again.", function () {
    //            var loginPageUrl = $("#loginPageUrl").val();
    //            window.location.replace(loginPageUrl);
    //        });
    //    } else {
    //        showMsg("Error", 'Sorry, <span style="color:red;">unexpected error(s)</span> occurred while processing your request.<br />Please contact system <span style="color:red;">administrator.</span>');
    //    }
    //});
    //Global Ajax Function - End
//});

/* 顯示modal訊息視窗 */
function showMsg(title, message, fn) {
    var msgModal = $('#msgModal');
    msgModal.find('#msgModalTitle').html(title);
    msgModal.find('#msgModalBody').html(message);
    msgModal.modal({
        backdrop: 'static',
        keyboard: false
    });
    msgModal.modal('show');

    setTimeout(function () {
        msgModal.find("#btnMsgModalClose").focus();
    }, 500);

    msgModal.find("#btnMsgModalClose , #btnMsgModalDismiss").off('click').click(function () {
        if (fn != undefined) {
            fn();
        }
        msgModal.modal("hide");
    });
}

/* 顯示modal確認視窗 */
function showConfirm(title, message, yesFn, noFn) {
    var confirmModal = $("#confirmModal");
    confirmModal.find("#confirmModalTitle").html(title);
    confirmModal.find("#confirmModalBody").html(message);
    confirmModal.modal({
        backdrop: 'static',
        keyboard: false
    });
    confirmModal.modal('show');

    setTimeout(function () {
        confirmModal.find("#btnConfirmModalYes").focus();
    }, 500);

    confirmModal.find("#btnConfirmModalYes").off('click').click(function () {
        yesFn();
        confirmModal.modal("hide");
    });
    confirmModal.find("#btnConfirmModalNo").off('click').click(function () {
        if (noFn != undefined) {
            noFn();
        }
        confirmModal.modal("hide");
    });
}

/* 顯示dialog訊息視窗 */
function showMsgDialog(title, message, fn) {
    $("#msgDialog").html(message).dialog({
        title: title,
        modal: true,
        close: function (event, uk) {
            if (fn != undefined) {
                fn();
            }
        },
        buttons: {
            'OK': function () {
                $(this).dialog('close');
            }
        }
    });
}

/* 顯示Dialog確認視窗 */
function showConfirmDialog(title, message, yesFn, noFn) {
    $("#confirmDialog").html(message).dialog({
        title: title,
        modal: true,
        buttons: {
            'OK': function () {
                yesFn();
                $(this).dialog('close');
            },
            Cancel: function () {
                if (noFn != undefined) {
                    noFn();
                }
                $(this).dialog("close");
            }
        }
    });
}

function showBlockUI() {
    $.blockUI({
        message: '<div><table style="padding:4px;"><tr><td class="BlockUIMessageIcon"></td><td style="font-size:20pt;"><b>Please wait...</b></td></tr></table></div>',
        baseZ: 2000
    });
}

function hideBlockUI() {
    $.unblockUI();
}

// Check Date format mm/dd/yyyy function
function checkDateFormat(dateString) {
    var regEx = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20|21|22|23|24)\d{2}$/;
    if (dateString == '' || dateString == null) {
        return true;
    }
    if (!dateString.match(regEx)) {
        return false;
    }
    var dateArray = dateString.split('/');
    if (dateArray.length !== 3) {
        return false;
    }

    var m = parseInt(dateArray[0], 10);
    var d = parseInt(dateArray[1], 10);
    var y = parseInt(dateArray[2], 10);
    var date = new Date(y, m - 1, d);
    if (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d) {
        return true;
    } else {
        return false;
    }
}

// Check Date format yyyy-mm-dd function
function checkDateFormat_ymd(dateString) {
    var regEx = /^(19|20|21|22|23|24)\d{2}\-(0[1-9]|1[0-2])\-(0[1-9]|1\d|2\d|3[01])$/;
    if (dateString == '' || dateString == null) {
        return true;
    }
    if (!dateString.match(regEx)) {
        return false;
    }
    var dateArray = dateString.split('-');
    if (dateArray.length !== 3) {
        return false;
    }

    var y = parseInt(dateArray[0], 10);
    var m = parseInt(dateArray[1], 10);
    var d = parseInt(dateArray[2], 10);
    var date = new Date(y, m - 1, d);
    if (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d) {
        return true;
    } else {
        return false;
    }
}


/* jqGrid相關script */
// 取得動態的grid欄位定義
function getcolModelDef(columnDef) {
    var colModel = [];
    $.each(columnDef, function (i, obj) {
        var columnWidth = 120;
        var item = {
            label: obj.ColumnName,
            name: obj.ColumnName,
            index: obj.ColumnName,
            width: columnWidth,
            sortable: true,
            align: 'left'
        };
        // number format
        if (obj.ColumnType == 'number' || obj.ColumnType == 'Double' ||
            obj.ColumnType == 'Decimal' ||
            obj.ColumnType == 'Int32' || obj.ColumnType == 'Int64') {
            item.width = 120;
            item.align = 'right';
            item.sorttype = 'number';
            //item.formatter = 'number';
            //item.formatoptions = {
            //    decimalSeparator: ".",
            //    thousandsSeparator: " ",
            //    decimalPlaces: 2,
            //    defaultValue: '0.00'
            //};
        };

        colModel.push(item);
    });

    return colModel;
}

/* jqGrid相關script End */

/* Dropdownlist相關script*/
// 產生select下拉選單
// mySelect: select的element(DOM)
// data: 選單資料，物件格式 {"value": "text", "value2": "text2"}
// selectedValue: 要設為選取的value清單，陣列格式 [ "value1", "value3" ]
function setSelectOptions(mySelect, data, selectedValue) {
    mySelect.empty();
    $.each(data, function (key, value) {
        mySelect.append($('<option></option>').val(key).text(value));
    });
    if (selectedValue != undefined) {
        $.each(selectedValue, function (idx, val) {
            mySelect.find('option[value="' + val + '"]').attr('selected', true);
        });
    }
}

// 產生select選單的字串
// ata: 選單資料，物件格式 {"value": "text", "value2": "text2"}
function getSelectOptions(data) {
    var options = '';
    $.each(data, function (key, value) {
        options += '<option value="' + key + '">' + value + '</option>';
    });
    return options;
}
/* Dropdownlist相關script End*/


//取得URL Parameter
$.extend({
    getUrlVars: function () {
        var vars = [], hash;
        var hashes = window.location.href.trimEnd('#').slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    },
    getUrlVar: function (name) {
        return $.getUrlVars()[name];
    }
});
