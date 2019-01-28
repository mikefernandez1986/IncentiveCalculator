<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="IncentiveCalcPOC.LoginPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table style="width:100%;">
        <caption>User Login</caption>
        <tr>
            <td></td>
            <td></td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                User Email:
            </td>
            <td>
                <asp:TextBox ID="EmailTxtBox" runat="server" Width="180px"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server" ControlToValidate="EmailTxtBox" ErrorMessage="Email ID Required" ForeColor="Red"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Password:
            </td>
            <td>
                <asp:TextBox ID="PwdTxtBox" runat="server" Width="180px" TextMode="Password"></asp:TextBox>
            </td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <asp:Label ID="InvalidLoginLbl" runat="server" ForeColor="#FF3300" Text="Email or Password entered is incorrect"></asp:Label>
            </td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <asp:Button ID="LoginBtn" runat="server" OnClick="LoginBtn_Click" Text="Login" />
            </td>
            <td></td>
        </tr>
    </table>
    </div>
    </form>
</body>
</html>
