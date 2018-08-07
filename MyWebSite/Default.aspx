<%@ Page Title="" Language="C#" MasterPageFile="~/WebForm/MasterPage/DefaultSite.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MyWebSite.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentArea" runat="server">
    <div id="DivDefaultPage">
        <h2>測試</h2>
        <table style="width:80%" >
            <tr><td>Show Data </td></tr>
            <tr style="height:40px">
                <td ><a class="btn" href="WebForm/Query/SalesDetailFixed.aspx">SalesDetail 固定資料</a></td>
            </tr>
            <tr style="height:40px">
                <td><a class="btn" href="WebForm/Query/SalesDetail.aspx">SalesDetail 資料庫</a></td>
            </tr>
            <tr><td>Edit Data </td></tr>
            <tr style="height:40px">
                <td><a class="btn" href="WebForm/Maintain/EditInline.aspx">Inline編輯 資料庫(ajax說明)</a></td>
            </tr>
            <tr style="height:40px">
                <td><a class="btn" href="WebForm/Maintain/EditTest.aspx">測試編輯 資料庫</a></td>
            </tr>
            <tr style="height:40px">
                <td><a class="btn" href="WebForm/Maintain/EditFull.aspx">EditFull</a></td>
            </tr>
            <tr style="height:40px">
                <td><a class="btn" href="WebForm/Maintain/JqGridCRUD.aspx">人傑的範例 資料庫</a></td>
            </tr>
            <tr><td>Test Ajax</td></tr>
            <tr style="height:40px">
                <td><a class="btn" href="WebForm/Query/DemoTest.aspx">Ajax測試</a></td>
            </tr>

        </table>
    </div>


</asp:Content>
