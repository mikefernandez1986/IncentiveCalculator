<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="IncentiveCalcPOC.LoginPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	    <meta charset="utf-8" />
        <title>::Login</title>
        <meta name="description" content="User login page" />
	    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes">
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
                  <asp:TextBox ID="EmailTxtBox" runat="server" class="user" placeholder="Username" Text="Username"  onFocus="this.value = '';" onBlur="if (this.value == '') {this.value = 'Username';}"></asp:TextBox>            
                 
                  
              </li>
              <li>
                <asp:TextBox ID="PwdTxtBox" runat="server"  TextMode="Password" placeholder="Password" class="lock" Text="Password" onFocus="this.value = '';" onBlur="if (this.value == '') {this.value = 'Password';}"></asp:TextBox>
                
              </li>
              
            </ul>
              <br />          
              <div class="submit">
                 <asp:Button runat="server" ID="LoginBtn"  OnClick="LoginBtn_Click" Text="Login" /><br />
                  <asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server" ControlToValidate="EmailTxtBox" ErrorMessage="User Name Required" ForeColor="Red"></asp:RequiredFieldValidator><br />
                  <asp:Label ID="InvalidLoginLbl" runat="server" ForeColor="#FF3300" Font-Size="12px" Text="User Name or Password entered is incorrect"></asp:Label>
				  <p align="center"><a href="forgot.aspx">Forgot Password?</a></p>
              </div>
          </form>
  
  
        </div>

        
        </div>
    </body>
</html>
