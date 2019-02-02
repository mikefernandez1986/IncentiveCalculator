<%@ Page Async="true" Title="::Add Role" enableEventValidation="false" Language="C#" MasterPageFile="~/IncentiveCalc.Master" AutoEventWireup="true" CodeBehind="AddRole.aspx.cs" Inherits="IncentiveCalcPOC.AddRole" %>
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
                        <h3 class="panel-title"><strong>Add Role</strong></h3>
                        <ul class="panel-controls">
                            <asp:Label ID="ResultLbl" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                        </ul>
                    </div>

                    <div class="panel-body">

                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Name:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-pencil"></span></span>
                                        <asp:TextBox ID="RoleNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Description:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-pencil"></span></span>
                                        <asp:TextBox ID="RoleDescTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Access Level:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span ></span></span>
                                        <asp:DropDownList ID="AccessLvlDdl" runat="server" CssClass="form-control select"></asp:DropDownList>
                                    </div>                                            
                                    <%--<span class="help-block">This is sample of text field</span>  --%>                                
                                </div>
                            </div>


                    </div>

                    <div style="float:left; margin-bottom:20px; margin-left:200px;">                                                                
                        <asp:Button ID="AddRoleBtn" runat="server" Text="Add Role" CssClass="btn btn-success" OnClientClick="return validateInput();" OnClick="AddRoleBtn_Click" />
                    </div>

                </div>
            </div>
        </div>
    </div>

  </div>                                            

<script type="text/javascript">
    function validateInput() {

        var inputTxt1 = document.getElementById("<%=RoleNameTextBox.ClientID%>").value.trim();
        if(inputTxt1 == "")
        {
            alert('Name cannot be blank');
            document.getElementById("<%=RoleNameTextBox.ClientID%>").focus();
            return false;
        }
        return true;
    }
</script>
      
</asp:Content>

