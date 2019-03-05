<%@ Page Title="" Language="C#" MasterPageFile="~/IncentiveCalc.Master" AutoEventWireup="true" CodeBehind="UploadInfo.aspx.cs" Inherits="IncentiveCalcPOC.UploadInfo" Async="true" %>
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
        <style>.kv-fileinput-upload {display:none;}</style>
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
                                                                     
                            <div class="form-horizontal">                                    
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <label>Select one option from below</label>   
                                            <asp:DropDownList ID="ddlFileType" runat="server" CssClass="form-control select">
                                            <%--<asp:ListItem Text="CASA" Value="tbl_CASA"></asp:ListItem>
                                            <asp:ListItem Text="Credit Card" Value="tbl_CreditCard"></asp:ListItem>
                                            <asp:ListItem Text="BTD" Value="tbl_Insurance"></asp:ListItem>--%>
                                        </asp:DropDownList> 
                                    </div>                                            
                                </div>                                        
                           </div>
                        </div>
                    </div>
                </div>
                        
                <div class="col-md-6">

                    <div class="panel panel-default">
                        <div class="panel-body">
                            <h3>File Upload</h3>
                                                                     
                            <div class="form-horizontal">                                    
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <label>Upload File</label>
                                        <%--<input type="file" multiple class="file" data-preview-file-type="any"/>--%>
                                        <div class="choose_file">                                             
                                            <asp:ScriptManager ID="ScriptManager1" runat="server">
                                            </asp:ScriptManager>
                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                <ContentTemplate> 
                                                    <div class="row">   
                                                        <div class="col-md-9">                                                           
                                                            <asp:FileUpload ID="FileUpload1" runat="server" CssClass="file" /> 
                                                        </div>
                                                        <div class="col-md-3" style="margin-left:-20px;">
                                                            <asp:Button ID="btn_FileUpload" CssClass="btn btn-success" runat="server" Text="&uArr; Upload a File" OnClick="btnUpload_Click"  /> 
                                                        </div> 
                                                    </div>                  
                                                </ContentTemplate>
                                                <Triggers> 
                                                    <asp:PostBackTrigger ControlID="btn_FileUpload"  />
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
                    
            <div class="row">
            <div class="col-md-12">
            <!-- START DATATABLE EXPORT -->
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">               
                <Triggers>
                    <asp:PostBackTrigger ControlID="btn_Refresh"  />
                </Triggers>
                <ContentTemplate>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Uploaded File Info</h3>
                        <div style="float:right">
                            <asp:Button runat="server" ID="btn_Refresh" Text="Refresh" CssClass="btn btn-success"  OnClick="btn_Refresh_Click"/>
                        </div>
                        <%--<div class="btn-group pull-right">
                            <button class="btn btn-danger dropdown-toggle" data-toggle="dropdown"><i class="fa fa-bars"></i> Export Data</button>
                            <ul class="dropdown-menu">                                            
                                            
                                <li><a href="#" onClick ="$('#customers2').tableExport({type:'csv',escape:'false'});"><img src='img/icons/csv.png' width="24"/> CSV</a></li>
                                <li><a href="#" onClick ="$('#customers2').tableExport({type:'excel',escape:'false'});"><img src='img/icons/xls.png' width="24"/> XLS</a></li>
                                <li><a href="#" onClick ="$('#customers2').tableExport({type:'pdf',escape:'false'});"><img src='img/icons/pdf.png' width="24"/> PDF</a></li>
                            </ul>
                        </div>  --%>                                  
                    </div>
                    <div class="panel-body">
                        <table id="customers2" class="table datatable">
                            <thead>
                                <tr>
                                    <th>FileId</th>
                                    <th>File Name</th>
                                    <th>File Type</th>
                                    <th>Date Created</th>
                                    <th>Processed Time</th>
                                    <th>Status Desc</th>
                                </tr>
                            </thead>
                            <tbody id="tb_KPIDetails" runat="server">
                            </tbody>
                                        
                        </table>                                    
                    </div>
                </div>
                
                </ContentTemplate>                            
            </asp:UpdatePanel>             
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
                    "order": [[ 2, "desc" ]],
                    //dom: 'Bfrtip',
                    //buttons: [
                    //    'copy', 'csv', 'excel', 'pdf', 'print'
                    //],
                    "columnDefs": [
                        {
                            "targets": [0],
                            "visible": false,
                            "searchable": false
                        }
                    ]
                });

            });
          
    </script>
    <!--  SCRIPT END -->
    
    <script>
            $(function(){
                $("#file-simple").fileinput({
                        showUpload: false,
                        showCaption: false,
                        browseClass: "btn btn-danger",
                        fileType: "any"
                });            
                $("#filetree").fileTree({
                    root: '/',
                    script: 'assets/filetree/jqueryFileTree.aspx',
                    expandSpeed: 100,
                    collapseSpeed: 100,
                    multiFolder: false                    
                }, function(file) {
                    alert(file);
                }, function(dir){
                    setTimeout(function(){
                        page_content_onresize();
                    },200);                    
                });                
            });            
        </script>
        
</asp:Content>