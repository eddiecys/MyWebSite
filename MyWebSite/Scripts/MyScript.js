String.prototype.trim = function () { return this.replace(/(^\s*)|(\s*$)/g, ""); } //去除頭尾空白
String.prototype.lTrim = function () { return this.replace(/(^\s*)/g, ""); }       //去除左側（頭）空白
String.prototype.rTrim = function () { return this.replace(/(\s*$)/g, ""); }       //去除右側（尾）空白
String.prototype.Trim = function () { return this.lTrim().rTrim(); }                //利用LTrim、RTrim來實做的trim

//去除字串結尾的字元
String.prototype.trimEnd = function (c) {
    c = c ? c : ' ';
    var i = this.length - 1;
    for (; i >= 0 && this.charAt(i) == c; i--);
    return this.substring(0, i + 1);
}

////可在Javascript中使用如同C#中的string.format
//String.format = function () {
//    var s = arguments[0];
//    for (var i = 0; i < arguments.length - 1; i++) {
//        var reg = new RegExp("\\{" + i + "\\}", "gm");
//        s = s.replace(reg, arguments[i + 1]);
//    }

//    return s;
//}

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

//取得Parent Window URL Parameter
$.extend({
    getParentUrlVars: function () {
        var vars = [], hash;
        var hashes = window.parent.location.href.trimEnd('#').slice(window.parent.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    },
    getParentUrlVar: function (name) {
        return $.getParentUrlVars()[name];
    }
});

// jqGrid dialog 置中
function centerDialog(elementID) {
    var dlgDiv = $(elementID);
    var dlgWidth = dlgDiv.width();
    var dlgHeight = dlgDiv.height();
    var windowWidth = $(window).width();
    var windowtHeight = $(window).height();
    dlgDiv.css("top", Math.round((windowtHeight - dlgHeight) / 2) + "px");
    dlgDiv.css("left", Math.round((windowWidth - dlgWidth) / 2) + "px");
}

function IsNullOrEmpty(str) {
    return !str || !/[^\s]+/.test(str);
}

function FilterInt(value) {
    if (/^(\+)?([0-9]+)$/.test(value))
        return Number(value);
    return NaN;
}

function FilterFloat(value) {
    if (/^(\+)?([0-9]+(\.[0-9]+)?)$/.test(value))
        return Number(value);
    return NaN;
}

function FilterFloatForOne(value) {
    if (/^(\+)?([0-9]+(\.[0-9])?)$/.test(value))
        return Number(value);
    return NaN;
}

//取得整数时，不保留小数位，如，2.999，保留2位小数，返回 3
//num：待四舍五入数值，len：保留小数位数
function GetRound(num, len) {
    return Math.round(num * Math.pow(10, len)) / Math.pow(10, len);
}
//保留小数位的四舍五入，如，2.999，保留2位小数，返回 3.00
//num：待四舍五入数值，len：保留小数位数
function GetRoundDd(num, len) {
    return num.toFixed(len);
}

//Show message 按下OK才去導頁, 沒傳URL就不導頁
function ShowMsg(message, title, redirectURL) {
    $("#commonDialogContent").html(message).dialog({
        title: title,
        modal: true,
        close: function (event, uk) {
            if (redirectURL != undefined && redirectURL != "") {
                var isInIframe = parent !== window;
                if (isInIframe) {
                    window.parent.location.href = redirectURL;
                } else {
                    window.location.href = redirectURL;
                }
            }
        },
        buttons: {
            'OK': function () {
                $(this).dialog('close');
            }
        }
    });
}

//Show message 按下OK才去執行function
function showMsgFunc(message, title, fn) {
    $("#commonDialogContent").html(message).dialog({
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

//可在Javascript中使用如同C#中的string.format 網路上找的自訂函式
//使用方式 : var fullName = String.format('Hello. My name is {0} {1}.', 'FirstName', 'LastName');
String.format = function () {

    var s = arguments[0];
    if (s == null) return "";

    for (var i = 0; i < arguments.length - 1; i++) {
        var reg = getStringFormatPlaceHolderRegEx(i);
        s = s.replace(reg, (arguments[i + 1] == null ? "" : arguments[i + 1]));
    }

    return cleanStringFormatResult(s);
}
//可在Javascript中使用如同C#中的string.format (對jQuery String的擴充方法)
//使用方式 : var fullName = 'Hello. My name is {0} {1}.'.format('FirstName', 'LastName');
String.prototype.format = function () {

    var txt = this.toString();

    for (var i = 0; i < arguments.length; i++) {
        var exp = getStringFormatPlaceHolderRegEx(i);
        txt = txt.replace(exp, (arguments[i] == null ? "" : arguments[i]));
    }

    return cleanStringFormatResult(txt);
}
//讓輸入的字串可以包含{}
function getStringFormatPlaceHolderRegEx(placeHolderIndex) {
    return new RegExp('({)?\\{' + placeHolderIndex + '\\}(?!})', 'gm')
}
//當format格式有多餘的position時，就不會將多餘的position輸出
//ex:
// var fullName = 'Hello. My name is {0} {1} {2}.'.format('firstName', 'lastName');
// 輸出的 fullName 為 'firstName lastName', 而不會是 'firstName lastName {2}'
function cleanStringFormatResult(txt) {

    if (txt == null) return "";

    return txt.replace(getStringFormatPlaceHolderRegEx("\\d+"), "");
}



