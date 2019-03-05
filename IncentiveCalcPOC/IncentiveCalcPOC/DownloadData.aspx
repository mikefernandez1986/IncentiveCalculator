<%@ Page Title="" Language="C#" MasterPageFile="~/IncentiveCalc.Master" AutoEventWireup="true" CodeBehind="DownloadData.aspx.cs" Inherits="IncentiveCalcPOC.DownloadData" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="js/plugins/bootstrap/bootstrap-select.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <%--<script type="text/javascript" src="js/plugins/tableexport/tableExport.js"></script>--%>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.4/js/dataTables.buttons.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.4/js/buttons.flash.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/pdfmake.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/vfs_fonts.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.4/js/buttons.html5.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.4/js/buttons.print.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-filestyle/2.1.0/bootstrap-filestyle.js"></script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- PAGE CONTENT WRAPPER -->
                
            <div class="row">
                <div class="col-md-12">

                    <div class="col-md-12">

                    <div class="panel panel-default">
                        <div class="panel-body">
                            <h3>Select Download File type</h3>
                                                                     
                            <div class="form-horizontal">                                    
                                <div class="form-group">
                                    <div class="col-md-9">
                                        <label>Select one option from below</label>   
                                            <asp:DropDownList ID="ddlFileType" runat="server" CssClass="form-control select">
                                            </asp:DropDownList> 
                                    </div> 
                                    <div class="col-md-3" >
                                         <label style="visibility:hidden">Select one option from below</label>  
                                        <asp:Button ID="btn_FileDownload" CssClass="btn btn-success" runat="server" Text="Get Incentive Details"  OnClick="btn_FileDownload_Click"  /> 
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
            
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title"><span id="spnproductName" runat="server" class="spnTitle"></span> Details for the month of <span id="prevmonth" runat="server"></span></h3>
                        <div class="btn-group pull-right" id="export">
                            
                        </div>
                                                        
                    </div>
                    <div class="panel-body">
                        <table id="customers2" class="table datatable">
                            <thead id="th_ProductDetails" runat="server">
                                <%--<tr><th>Employee No</th><th>Employee Name</th><th>Product</th><th>Achived Target Value</th><th>Target Status</th><th>Total Points</th><th>Propsed Pay Amount</th><th>Actual Pay Amount(75%)</th><th>Retained Amount(25%)</th><th>Payout Code</th></tr>--%>
                            </thead>
                            <tbody id="tb_ProductDetails" runat="server">
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
                var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];;
                var date = new Date();

                if ($.fn.DataTable.isDataTable("#customers2")) {
                    $('#customers2').DataTable().destroy();
                }
                var table = $('#customers2').DataTable({
                    //"scrollX": true
                });

                var buttons = new $.fn.dataTable.Buttons(table, {
                    buttons: [
                         {
                             extend: 'excelHtml5',
                             text: '<img src="img/icons/xls.png" width="24"/> Download as Excel',
                             titleAttr: 'Excel',
                             title: $(".spnTitle").text()+ months[date.getMonth() - 1] + '_' + date.getFullYear()
                         }
                    ]
                }).container().appendTo($('#export'));
                

            });
          
    </script>
    <!--  SCRIPT END -->
    

        
</asp:Content>