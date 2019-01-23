<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadData.aspx.cs" Inherits="IncentiveCalcPOC.UploadData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>File Uplaod</title>
    <style type="text/css">
        .upload-btn-wrapper {
          position: relative;
          overflow: hidden;
          display: inline-block;
        }

        .btn {
          border: 2px solid gray;
          color: gray;
          background-color: white;
          padding: 8px 20px;
          border-radius: 8px;
          font-size: 20px;
          font-weight: bold;
        }

        .upload-btn-wrapper input[type=file] {
          font-size: 100px;
          position: absolute;
          left: 0;
          top: 0;
          opacity: 0;
        }
        .table {display:block; }
        .row { display:block; margin:10px;}
        .cell {display:inline-block; width:200px;}
        .choose_file {
            position: relative;
            display: inline-block;   
            font: normal 14px Myriad Pro, Verdana, Geneva, sans-serif;
            color: #7f7f7f;
            margin-top: 2px;
            background: white
        }
        .choose_file input[type="file"]{
            -webkit-appearance:none; 
            position:absolute;
            top:0;
            left:0;
            opacity:0;
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
    <div class="table">
       <div class="row">
          <div class="cell">
             Please select the file type
          </div>
          <div class="cell">
             <asp:DropDownList ID="ddlFileType" runat="server">
                <asp:ListItem Enabled="true" Text="Please Select" Value="-1"></asp:ListItem>
                <asp:ListItem Text="CASA" Value="tbl_CASA"></asp:ListItem>
                <asp:ListItem Text="Credit Card" Value="tbl_CreditCard"></asp:ListItem>
                <asp:ListItem Text="BTD" Value="tbl_Insurance"></asp:ListItem>
            </asp:DropDownList>
          </div>          
       </div>
        <div class="row">
          <div class="cell">
             Upload the file
          </div>
          <div class="cell">
          <div class="choose_file">  
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                        <asp:Button ID="btn_FileUpload" CssClass="" runat="server" Text="Upload a File" OnClick="btnUpload_Click" />
                        <asp:FileUpload ID="FileUpload1" runat="server" /> 
                    
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="btn_FileUpload" />
                </Triggers>
            </asp:UpdatePanel>
          </div>
          </div>          
       </div>
    </div>
       <asp:Label ID="UploadDetails" runat="server" Text=""></asp:Label>
        <br />
       <asp:Button runat="server" ID="btn_Save" OnClick="btn_Save_Click" Text="Save File" /> 

    </form>
</body>
</html>
