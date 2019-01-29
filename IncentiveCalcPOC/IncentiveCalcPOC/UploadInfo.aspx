<%@ Page Async="true" Title="" Language="C#" MasterPageFile="~/IncentiveCalc.Master" AutoEventWireup="true" CodeBehind="UploadInfo.aspx.cs" Inherits="IncentiveCalcPOC.UploadInfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>::Upload Files</title>
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
        <!-- END PAGE PLUGINS -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- PAGE CONTENT WRAPPER -->
                
            <div class="row">
                <div class="col-md-12">

                    <div class="col-md-6">

                    <div class="panel panel-default">
                        <div class="panel-body">
                            <h3>Select Upload File type</h3>
                                                                     
                            <%--<form enctype="multipart/form-data" class="form-horizontal"> --%>                                       
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <label>Select one option from below</label>   
                                            <asp:DropDownList ID="ddlFileType" runat="server" CssClass="form-control select">
                                            <asp:ListItem Text="CASA" Value="tbl_CASA"></asp:ListItem>
                                            <asp:ListItem Text="Credit Card" Value="tbl_CreditCard"></asp:ListItem>
                                            <asp:ListItem Text="BTD" Value="tbl_Insurance"></asp:ListItem>
                                        </asp:DropDownList> 
                                    </div>                                            
                                </div>                                        
                            <%--</form>--%>
                        </div>
                    </div>
                </div>
                        
                <div class="col-md-6">

                    <div class="panel panel-default">
                        <div class="panel-body">
                            <h3>File Upload</h3>
                                                                     
                            <%--<form enctype="multipart/form-data" class="form-horizontal"> --%>                                       
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <label>Upload File</label>
                                        <%--<input type="file" multiple class="file" data-preview-file-type="any"/>--%>
                                        <div class="choose_file"> 
                                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                                <ProgressTemplate>
                                                    <div class="modal">
                                                        <div class="center">
                                                            <img src="img/loader4.gif" />
                                                        </div>
                                                    </div>
                                                </ProgressTemplate>
                                            </asp:UpdateProgress> 
                                            <asp:ScriptManager ID="ScriptManager1" runat="server">
                                            </asp:ScriptManager>
                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                <ContentTemplate> 
                                                    <div class="row">   
                                                        <div class="col-md-9">                                                           
                                                            <asp:FileUpload ID="FileUpload1" runat="server" CssClass="filestyle" /> 
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Button ID="btn_FileUpload" CssClass="btn btn-success" runat="server" Text="Upload a File" OnClick="btnUpload_Click"  /> 
                                                        </div> 
                                                    </div> 
                                                      <div class="row">
                                                          <asp:Label ID="UploadDetails"  runat="server"></asp:Label>
                                                        </div>               
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:PostBackTrigger ControlID="btn_FileUpload" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                            </div>
                                    </div>
                                            
                                </div>
                                        
                            <%--</form>--%>
                        </div>
                    </div>
                </div>
                </div>
            </div>
                    
            <div class="row">
            <div class="col-md-12">
                            
                <!-- START DATATABLE EXPORT -->
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Full data</h3>
                        <div class="btn-group pull-right">
                            <button class="btn btn-danger dropdown-toggle" data-toggle="dropdown"><i class="fa fa-bars"></i> Export Data</button>
                            <ul class="dropdown-menu">                                            
                                            
                                <li><a href="#" onClick ="$('#customers2').tableExport({type:'csv',escape:'false'});"><img src='img/icons/csv.png' width="24"/> CSV</a></li>
                                <li><a href="#" onClick ="$('#customers2').tableExport({type:'excel',escape:'false'});"><img src='img/icons/xls.png' width="24"/> XLS</a></li>
                                <li><a href="#" onClick ="$('#customers2').tableExport({type:'pdf',escape:'false'});"><img src='img/icons/pdf.png' width="24"/> PDF</a></li>
                            </ul>
                        </div>                                    
                    </div>
                    <div class="panel-body">
                        <table id="customers2" class="table datatable">
                            <thead>
                                <tr>
                                    <th>Employee Code</th>
                                    <th>Employee Name</th>
                                    <th>Performance Score</th>
                                    <th>KPI Rating</th>
                                </tr>
                            </thead>
                            <tbody id="tb_KPIDetails" runat="server">
                            </tbody>
                                        
                        </table>                                    
                    </div>
                </div>
                <!-- END DATATABLE EXPORT -->                            
                            
                           
            </div>
            </div>
                    

        <!-- END PAGE CONTENT WRAPPER --> 
    <!--  SCRIPT START -->
    <script type="text/javascript">
            $(document).ready(function () {
                $("#UpdatePanel1").find("label").addClass("btn btn-warning");
                $("#UpdatePanel1").find("label").text("Select a file");

                if ($.fn.DataTable.isDataTable("#customers2")) {
                    $('#customers2').DataTable().destroy();
                }
                $('#customers2').DataTable({
                    dom: 'Bfrtip',
                    buttons: [
                        'copy', 'csv', 'excel', 'pdf', 'print'
                    ]
                });

            });
          
    </script>
    <!--  SCRIPT END -->
</asp:Content>

