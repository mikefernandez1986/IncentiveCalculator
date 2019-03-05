<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="IncentiveCalcPOC.LoginPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	    <meta charset="utf-8" />
        <title>::Login</title>
        <meta name="description" content="User login page" />
	    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
	    <link href="css/login.css" rel='stylesheet' type='text/css' />

    </head>
    <body>
        <div class="loginarea">
        <div class="login">
          <div class="ribbon-wrapper h2 ribbon-red">
            <div class="ribbon-front">
              <h2>User Login</h2>
            </div>
            <div class="ribbon-edge-topleft2"></div>
            <div class="ribbon-edge-bottomleft"></div>
          </div>
          <form id="form1" runat="server">
            <ul>
              <li>
                  <asp:TextBox ID="EmailTxtBox" runat="server" class="text" placeholder="Username" Text="User name"  onFocus="this.value = '';" onBlur="if (this.value == '') {this.value = 'User name';}"></asp:TextBox>            
                  <a href="#" class=" icon user"></a> 
                  <span style="margin-left:10px">
                    <asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server" ControlToValidate="EmailTxtBox" ErrorMessage="User Name Required" ForeColor="Red"></asp:RequiredFieldValidator>
                </span>
              </li>
              <li>
                <asp:TextBox ID="PwdTxtBox" runat="server"  TextMode="Password" class="form-control" Text="Password" onFocus="this.value = '';" onBlur="if (this.value == '') {this.value = 'Password';}"></asp:TextBox>
                <a href="#" class=" icon lock"></a>
              </li>
              <li>
                  <asp:Label ID="InvalidLoginLbl" runat="server" ForeColor="#FF3300" Text="User Name or Password entered is incorrect"></asp:Label>
              </li>
            </ul>              
              <div class="submit">
                 <asp:Button runat="server" ID="LoginBtn"  OnClick="LoginBtn_Click" Text="Login" />
              </div>
          </form>
  
  
        </div><br />

        <p align="center"><a href="forgot.aspx">Forgot Password?</a></p>
        </div>
    </body>
</html>
