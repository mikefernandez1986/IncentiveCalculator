<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GenerateKPI.aspx.cs" Inherits="IncentiveCalcPOC.GenerateKPI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Incentive Calculator</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
        
    <link rel="icon" href="img/logo.jpg" type="image/x-icon" />
    <!-- END META SECTION -->
    
    <!-- CSS INCLUDE -->        
    <link rel="stylesheet" type="text/css" id="theme" href="css/theme-default.css"/>
    <!-- EOF CSS INCLUDE -->   
    <!-- START PLUGINS -->
        <script type="text/javascript" src="js/plugins/jquery/jquery.min.js"></script>
        <script type="text/javascript" src="js/plugins/jquery/jquery-ui.min.js"></script>
        <script type="text/javascript" src="js/plugins/bootstrap/bootstrap.min.js"></script>
    <%--comments 1 --%>                
        <!-- END PLUGINS -->  
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" integrity="sha512-dTfge/zgoMYpP7QbHy4gWMEGsbsdZeCXz7irItjcC3sPUFtf0kuFbDz/ixG7ArTxmDjLXDmezHubeNikyKGVyQ==" crossorigin="anonymous" />
   
</head>
<body>
    <form id="form1" runat="server">
     <!-- START PAGE CONTAINER -->
        <div class="page-container">
            
            <!-- START PAGE SIDEBAR -->
            <div class="page-sidebar">
                <!-- START X-NAVIGATION -->
                <ul class="x-navigation">
                    <li class="xn-logo">
                        <a href="index.html"><img src="img/logo.jpg"></a>
                        <a href="#" class="x-navigation-control"></a>
                    </li>     
                    
                    <li class="xn-profile">
                        <a href="#" class="profile-mini">
                            <img src="img/logo.jpg" alt="John Doe"/>
                        </a>
                        <div class="profile">
                            <div class="profile-image">
                                <img src="assets/images/users/user.jpg" alt="John Doe"/>
                            </div>
                            <div class="profile-data">
                                <div class="profile-data-name">John Doe</div>
                                <div class="profile-data-title">Sales Executive</div>
                            </div>
                            <div class="profile-controls">
                                <a href="pages-profile.html" class="profile-control-left"><span class="fa fa-info"></span></a>
                                <a href="pages-messages.html" class="profile-control-right"><span class="fa fa-envelope"></span></a>
                            </div>
                        </div>                                                                        
                    </li>               
                   
                    <li class="active"><a href="index.html"><span class="fa fa-desktop"></span> <span class="xn-text">Dashboard</span></a> </li>                    
                    <li><a href="#"><span class="fa fa-user"></span> <span class="xn-text">Employee List</span></a></li>
                    
                    <li><a href="#"><span class="fa fa-user"></span> <span class="xn-text">Admin</span></a></li>   

					<li><a href="#"><span class="fa fa-user"></span> <span class="xn-text">Super Admin</span></a></li>   					
                    
                    
                </ul>
                <!-- END X-NAVIGATION -->
            </div>
            <!-- END PAGE SIDEBAR -->
            
            <!-- PAGE CONTENT -->
            <div class="page-content">
              
                <!-- START BREADCRUMB -->
                <ul class="breadcrumb">
                    <li><a href="#">Home</a></li>                    
                    <li class="active">Dashboard</li>
                </ul>
                <!-- END BREADCRUMB -->                       
                
                <!-- PAGE CONTENT WRAPPER -->
                <div class="page-content-wrap">
                
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
                    
                    
                </div>
                <!-- END PAGE CONTENT WRAPPER -->                                
            </div>            
            <!-- END PAGE CONTENT -->
        </div>
        <!-- END PAGE CONTAINER -->

        <!-- MESSAGE BOX-->
        <div class="message-box animated fadeIn" data-sound="alert" id="mb-signout">
            <div class="mb-container">
                <div class="mb-middle">
                    <div class="mb-title"><span class="fa fa-sign-out"></span> Log <strong>Out</strong> ?</div>
                    <div class="mb-content">
                        <p>Are you sure you want to log out?</p>                    
                        <p>Press No if youwant to continue work. Press Yes to logout current user.</p>
                    </div>
                    <div class="mb-footer">
                        <div class="pull-right">
                            <a href="pages-login.html" class="btn btn-success btn-lg">Yes</a>
                            <button class="btn btn-default btn-lg mb-control-close">No</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- END MESSAGE BOX-->
       
        
   <!-- START SCRIPTS -->
        
        
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
        <!-- END PAGE PLUGINS -->
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-filestyle/2.1.0/bootstrap-filestyle.js"></script>
        <!-- START TEMPLATE -->
        <script type="text/javascript" src="js/settings.js"></script>
        
        <script type="text/javascript" src="js/plugins.js"></script>        
        <script type="text/javascript" src="js/actions.js"></script>

        <!-- END TEMPLATE -->
        
        <script>
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
    <!-- END SCRIPTS -->   
    </form>
</body>
</html>
