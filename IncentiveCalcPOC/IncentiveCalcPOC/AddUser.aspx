<%@ Page Async="true" Title="::Add User" enableEventValidation="false" Language="C#"  MasterPageFile="~/IncentiveCalc.Master" AutoEventWireup="true" CodeBehind="AddUser.aspx.cs" Inherits="IncentiveCalcPOC.AddUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>::Add User</title>
    <!-- THIS PAGE PLUGINS -->    
        <script type='text/javascript' src='js/plugins/icheck/icheck.min.js'></script>
        <script type="text/javascript" src="js/plugins/bootstrap/bootstrap-datepicker.js"></script>                
        <script type="text/javascript" src="js/plugins/bootstrap/bootstrap-file-input.js"></script>
        <script type="text/javascript" src="js/plugins/bootstrap/bootstrap-select.js"></script>
        <script type="text/javascript" src="js/plugins/tagsinput/jquery.tagsinput.min.js"></script>
        <script type="text/javascript" src="js/plugins/mcustomscrollbar/jquery.mCustomScrollbar.min.js"></script>
        
        <script type="text/javascript" src="js/plugins/dropzone/dropzone.min.js"></script>
        <script type="text/javascript" src="js/plugins/fileinput/fileinput.min.js"></script>        
        <script type="text/javascript" src="js/plugins/filetree/jqueryFileTree.js"></script>
         <script type="text/javascript" src="js/plugins/datatables/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="js/plugins/tableexport/tableExport.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-filestyle/2.1.0/bootstrap-filestyle.js"></script>
        <style>.kv-fileinput-upload {display:none;}</style>
        <!-- END PAGE PLUGINS -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- PAGE CONTENT WRAPPER -->
    <div class="page-content-wrap">
                
        <div class="row">
            <div class="col-md-12">
                            
                <div class="form-horizontal">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title"><strong>Add User</strong></h3>
                        <ul class="panel-controls">
                            <%--                            <li><a href="http://webjungle.in/incentive-calculator/formpage.html#" class="panel-remove"><span class="fa fa-times"></span></a></li>--%>
                            <asp:Label ID="ResultLbl" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                        </ul>
                    </div>

                    <div class="panel-body">
                        <%--            <div class="form-horizontal" >--%>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Email:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-pencil"></span></span>
                                        <asp:TextBox ID="EmailTxtBox" runat="server" TextMode="Email" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Password:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-unlock-alt"></span></span>
                                        <asp:TextBox ID="PwdTxtBox" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Re-Enter Password:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-unlock-alt"></span></span>
                                        <asp:TextBox ID="ReEnterPwdTxtBox" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">First Name:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-pencil"></span></span>
                                        <asp:TextBox ID="FirstNameTxtBox" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Last Name:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-pencil"></span></span>
                                        <asp:TextBox ID="LastNameTxtBox" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Designation:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-pencil"></span></span>
                                        <asp:TextBox ID="DesignationTxtBox" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Profile Image File:</label>
                                <div class="col-md-6 col-xs-12">
                                   <%-- <div class="choose_file"> --%>
                                        <asp:FileUpload ID="ProfilePicFileUpld" runat="server" CssClass="file" /> 
                                   <%-- </div>--%>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Role:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span ></span></span>
                                        <asp:DropDownList ID="RoleDdl" runat="server" CssClass="form-control select"></asp:DropDownList>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Is Active:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
<%--                                        <span class="input-group-addon"><span ></span></span>--%>
<%--                                        <asp:CheckBox ID="EnabledChkBox" runat="server" Text="Enabled" />--%>
                                        
                                        <asp:RadioButtonList ID="IsActiveRadioBtnList" runat="server" CssClass="radio-inline ">
                                            <asp:ListItem Selected="True" Value="true">Yes</asp:ListItem>
                                            <asp:ListItem Value="false">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                        
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-md-offset-2 col-md-10">
                                </div> 
                            </div>

                    </div>

                    <div style="float:left; margin-bottom:20px; margin-left:200px;">                                                                
                        <asp:Button ID="AddUserBtn" runat="server" Text="Add User" OnClick="AddUserBtn_Click" OnClientClick="return validateInput();" />
                    </div>

                </div>
            </div>
        </div>
    </div>

  </div>                                            

<script type="text/javascript">
    function validateInput() {

        var inputTxt1 = document.getElementById("<%=EmailTxtBox.ClientID%>").value.trim();
        if(inputTxt1 == "")
        {
            alert('Email cannot be blank');
            document.getElementById("<%=EmailTxtBox.ClientID%>").focus();
            return false;
        }
        inputTxt1 = document.getElementById("<%=PwdTxtBox.ClientID%>").value.trim();
        if(inputTxt1 == "")
        {
            alert('Password cannot be blank');
            document.getElementById("<%=PwdTxtBox.ClientID%>").focus();
            return false;
        }
        var inputTxt2 = document.getElementById("<%=ReEnterPwdTxtBox.ClientID%>").value.trim();
        if (inputTxt1 != inputTxt2)
        {
            alert('Password entered is not the same');
            document.getElementById("<%=PwdTxtBox.ClientID%>").focus();
            return false;
        }
        inputTxt1 = document.getElementById("<%=FirstNameTxtBox.ClientID%>").value.trim();
        if (inputTxt1 == "")
        {
            alert('First name cannot be blank');
            document.getElementById("<%=FirstNameTxtBox.ClientID%>").focus();
            return false;
        }
        return true;
    }
</script>
      
</asp:Content>

