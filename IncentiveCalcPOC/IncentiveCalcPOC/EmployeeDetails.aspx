<%@ Page Title="" Language="C#" MasterPageFile="~/IncentiveCalc.Master" AutoEventWireup="true" CodeBehind="EmployeeDetails.aspx.cs" Inherits="IncentiveCalcPOC.EmployeeDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>::User Info</title>
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrap">
                
        <div class="row">
            <div class="col-md-12">
                            
                <div class="form-horizontal">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title"><strong>Employee Details</strong></h3>
                        
                    </div>

                    <div class="panel-body">

                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Employee No:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-ban"></span></span>
                                        <asp:TextBox ID="txt_EmpNo" runat="server" CssClass="form-control" Enabled="false" style="color:black;"></asp:TextBox>
                                    </div>                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Name:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-ban"></span></span>
                                        <asp:TextBox ID="txt_EmpName" runat="server" CssClass="form-control" Enabled="false" style="color:black;"></asp:TextBox>
                                    </div>                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Date of Joining:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-ban"></span></span>
                                        <asp:TextBox ID="txt_DOJ" runat="server" CssClass="form-control" Enabled="false" style="color:black;"></asp:TextBox>
                                    </div>                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Designation:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-ban"></span></span>
                                        <asp:TextBox ID="txt_Role" runat="server" CssClass="form-control" Enabled="false" style="color:black;"></asp:TextBox>
                                    </div>                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Department:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-ban"></span></span>
                                        <asp:TextBox ID="txt_dept" runat="server" CssClass="form-control" Enabled="false" style="color:black;"></asp:TextBox>
                                    </div>                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Division:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-ban"></span></span>
                                        <asp:TextBox ID="txt_Div" runat="server" CssClass="form-control" Enabled="false" style="color:black;"></asp:TextBox>
                                    </div>                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Branch:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <span class="input-group-addon"><span class="fa fa-ban"></span></span>
                                        <asp:TextBox ID="txt_Branch" runat="server" CssClass="form-control" Enabled="false" style="color:black;"></asp:TextBox>
                                    </div>                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 col-xs-12 control-label">Profile Image:</label>
                                <div class="col-md-6 col-xs-12">                                            
                                    <div class="input-group">
                                        <div class="choose_file">                                             
                                            <asp:ScriptManager ID="ScriptManager1" runat="server">
                                            </asp:ScriptManager>
                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                <ContentTemplate> 
                                                    
                                                        <div class="col-md-9">                                                           
                                                            <asp:FileUpload ID="ImgFu" runat="server" CssClass="file"  /> 
                                                        </div>
                                                        <div class="col-md-3" style="margin-left:-20px;">
                                                            <asp:Button ID="btn_ImgUpload" CssClass="btn btn-success" runat="server" Text="&uArr; Upload Image" OnClick="btnImg_Click"  /> 
                                                        </div> 
                                                                      
                                                </ContentTemplate>
                                                <Triggers> 
                                                    <asp:PostBackTrigger ControlID="btn_ImgUpload"  />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>                                 
                                </div>
                            </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

  </div>
</asp:Content>
