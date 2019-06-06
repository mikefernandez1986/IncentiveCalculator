<%@ Page Title="" Language="C#" MasterPageFile="~/IncentiveCalc.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IncentiveCalcPOC.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>::Dashboard</title>
    <script src="js/Chart.bundle.js"></script>
	<script src="js/utils.js"></script>
    
    <script>
        Chart.pluginService.register({
            beforeDraw: function (chart) {
                if (chart.config.options.elements.center) {
                    //Get ctx from string
                    var ctx = chart.chart.ctx;

                    //Get options from the center object in options
                    var centerConfig = chart.config.options.elements.center;
                    var fontStyle = centerConfig.fontStyle || 'Arial';
                    var txt = centerConfig.text;
                    var color = centerConfig.color || '#000';
                    var sidePadding = centerConfig.sidePadding || 20;
                    var sidePaddingCalculated = (sidePadding / 100) * (chart.innerRadius * 2)
                    //Start with a base font of 30px
                    ctx.font = "30px " + fontStyle;

                    //Get the width of the string and also the width of the element minus 10 to give it 5px side padding
                    var stringWidth = ctx.measureText(txt).width;
                    var elementWidth = (chart.innerRadius * 2) - sidePaddingCalculated;

                    // Find out how much the font can grow in width.
                    var widthRatio = elementWidth / stringWidth;
                    var newFontSize = Math.floor(30 * widthRatio);
                    var elementHeight = (chart.innerRadius * 2);

                    // Pick a new font size so it will not be larger than the height of label.
                    var fontSizeToUse = Math.min(newFontSize, elementHeight);

                    //Set font settings to draw it correctly.
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    var centerX = ((chart.chartArea.left + chart.chartArea.right) / 2);
                    var centerY = ((chart.chartArea.top + chart.chartArea.bottom) / 2);
                    ctx.font = fontSizeToUse + "px " + fontStyle;
                    ctx.fillStyle = color;

                    //Draw text in center
                    ctx.fillText(txt, centerX, centerY);
                }
            }
        });

		
		$(document).ready(function () {

		    var config = {
		        type: 'doughnut',
		        data: {
		            datasets: [{
		                data: $(".achivedData_value").val().replace(/,\s*$/, "").split(","),
		                backgroundColor: $(".achivedData_color").val().replace(/,\s*$/, "").split(","),
		                label: 'KPI',
		                borderWidth: 1,
		                hoverBackgroundColor: $(".achivedData_color").val().replace(/,\s*$/, "").split(","),
		                hoverBorderColor: '#fff',
		                hoverBorderWidth: 2
		            }],
		            labels: $(".achivedData_labels").val().replace(/,\s*$/, "").split(",")
		        },
		        options: {
		            responsive: true,
		            maintainAspectRatio: false,
		            legend: {
		                display: false
		            },
		            legendCallback: function (chart) {
		                // Return the HTML string here.
		                console.log(chart.data.datasets);
		                console.log(chart.data.datasets[0].data[0]);
		                var text = [];
		                text.push('<table style="width:90%" class="details">');
		                text.push('<tr class="dottedborder"><td class="leftFloat" colspan="2"><label class="innerlabel">Detailed Breakup</label></td></tr>');
		                for (var i = 0; i < chart.data.datasets[0].data.length; i++) {
		                    text.push('<tr class="dottedborder" id="legend-1-' + i + '-item" onclick="updateDatasetKPI(event, ' + '\'' + i + '\'' + ')"><td class="leftFloat"><span class="innerSpan" style="background-color:' + chart.data.datasets[0].backgroundColor[i] + '"></span>');
		                    if (chart.data.labels[i]) {
		                        text.push('<label class="innerlabel">' + chart.data.labels[i] + '</label></td>');
		                    }
		                    text.push('<td class="rightFloat"><label class="innerlabel">' + chart.data.datasets[0].data[i] + '</label></td>');
		                    text.push('</tr>');
		                }
		                text.push('</table>');

		                return text.join("");
		            },
		            title: {
		                display: false,
		                text: 'KPI Rating'
		            },
		            animation: {
		                animateScale: true,
		                animateRotate: true
		            },
		            tooltips: {
		                enabled: true
		            },
		            elements: {
		                center: {
		                    text: "KPI Value : " + $(".achivedData_KPI").val(),
		                    color: '#FF6384', // Default is #000000
		                    fontStyle: 'Arial', // Default is Arial
		                    sidePadding: 20 // Defualt is 20 (as a percentage)
		                }
		            }
		        }
		    };

		    var config1 = {
		        type: 'doughnut',
		        data: {
		            datasets: [{
		                data: $(".targetData_value").val().replace(/,\s*$/, "").split(","),
		                backgroundColor: $(".targetData_color").val().replace(/,\s*$/, "").split(","),
		                label: 'Target',
		                borderWidth: 1,
		                hoverBackgroundColor: $(".achivedData_color").val().replace(/,\s*$/, "").split(","),
		                hoverBorderColor: '#fff',
		                hoverBorderWidth: 2
		            }],
		            labels: $(".targetData_labels").val().replace(/,\s*$/, "").split(",")
		        },
		        options: {
		            responsive: true,
		            maintainAspectRatio: false,
		            legend: {
		                display: false
		            },
		            legendCallback: function (chart) {
		                // Return the HTML string here.
		                console.log(chart.data.datasets);
		                console.log(chart.data.datasets[0].data[0]);
		                var text = [];
		                text.push('<table style="width:90%" class="details">');
		                text.push('<tr class="dottedborder"><td class="leftFloat" colspan="2"><label class="innerlabel">Details</label></td></tr>');
		                for (var i = 0; i < chart.data.datasets[0].data.length; i++) {
		                    text.push('<tr class="dottedborder" id="legend-' + i + '-item" onclick="updateDataset(event, ' + '\'' + i + '\'' + ')"><td class="leftFloat"><span class="innerSpan" style="background-color:' + chart.data.datasets[0].backgroundColor[i] + '"></span>');
		                    if (chart.data.labels[i]) {
		                        text.push('<label class="innerlabel">' + chart.data.labels[i] + '</label></td>');
		                    }
		                    text.push('<td class="rightFloat"><label class="innerlabel">' + chart.data.datasets[0].data[i] + '</label></td>');
		                    text.push('</tr>');
		                }
		                text.push('</table>');

		                return text.join("");
		            },
		            title: {
		                display: false,
		                text: 'KPI Targets'
		            },
		            animation: {
		                animateScale: true,
		                animateRotate: true
		            },
		            elements: {
		                center: {
		                    text: $(".targetData_Plan").val(),
		                    color: '#FF6384', // Default is #000000
		                    fontStyle: 'Arial', // Default is Arial
		                    sidePadding: 30 // Defualt is 20 (as a percentage)
		                }
		            }
		        }
		    };

			$.ajax({
			    type: "POST",
			    url: "Dashboard.aspx/GetIncentiveInfo",
			    //data: dataValue,
			    contentType: 'application/json; charset=utf-8',
			    dataType: 'json',
			    error: function (XMLHttpRequest, textStatus, errorThrown) {
			        alert("Request: " + XMLHttpRequest.toString() + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
			    },
			    success: function (result) {
			        var ctx = document.getElementById('chart-performance').getContext('2d');
			        window.myDoughnut1 = new Chart(ctx, config);
			        $("#do_legend1").html(window.myDoughnut1.generateLegend());
			        var ctx1 = document.getElementById('chart-expected').getContext('2d');
			        window.myDoughnut = new Chart(ctx1, config1);
			        $("#do_legend").html(window.myDoughnut.generateLegend());
			      //  $(".page-content-wrap").css("height", "100%");
			    }
			});
		});
		var colorNames = Object.keys(window.chartColors);
		// Show/hide chart by click legend
		updateDataset = function (e, datasetIndex) {
		    var index = datasetIndex;
		    var ci = e.view.myDoughnut;
		    var meta = ci.getDatasetMeta(0);
		    var result = (meta.data[datasetIndex].hidden == true) ? false : true;

		    console.log((e.path[2].id));
		    if (result == true) {
		        meta.data[datasetIndex].hidden = true;
		       
		        $('#' + e.path[2].id).addClass("strikeout");
		        //$('#' + e.path[0].id).css("text-decoration", "line-through");
		    } else {
		        //$('#' + e.path[0].id).css("text-decoration", "");
		        $('#' + e.path[2].id).removeClass("strikeout");
		        meta.data[datasetIndex].hidden = false;
		    }

		    ci.update();
		};

		updateDatasetKPI = function (e, datasetIndex) {
		    var index = datasetIndex;
		    var ci = e.view.myDoughnut1;
		    var meta = ci.getDatasetMeta(0);
		    console.log(('#' + e.path[0].id));
		    var result = (meta.data[datasetIndex].hidden == true) ? false : true;
		    if (result == true) {
		        meta.data[datasetIndex].hidden = true;

		        $('#' + e.path[2].id).addClass("strikeout");
		        //$('#' + e.path[0].id).css("text-decoration", "line-through");
		    } else {
		        //$('#' + e.path[0].id).css("text-decoration", "");
		        $('#' + e.path[2].id).removeClass("strikeout");
		        meta.data[datasetIndex].hidden = false;
		    }

		    ci.update();
		};
		

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div style="float:right; margin-bottom:10px;">
                <asp:Button runat="server" ID="btn_downloadEmpInfo" CssClass="btn btn-success" Text="Download Your Incentive Details " OnClick="btn_downloadEmpInfo_Click" />
            </div>
        </div>
    </div>
      <!-- START WIDGETS -->                    
                    <div class="row">
                        <div class="col-md-3">                            
                            <!-- START WIDGET SLIDER -->
                            <div class="widget widget-default widget-item-icon" style="background:#0093ae;">
                                  <div class="widget-item-left">
                                <div class="widget-int num-count" id="dvTotalPoints" runat="server"></div>
                                </div>                           
                                <div class="widget-data" style="margin-top: 22px;">
                                    
                                    <div class="widget-title">Total Points Acumulated</div>
                                   <%-- <div class="widget-subtitle">In your mailbox</div>--%>
                                </div>      
                                
                            </div>      
                            <!-- END WIDGET SLIDER -->
                            
                        </div>
                        <div class="col-md-3">
                            
                            <!-- START WIDGET MESSAGES -->
                            <div class="widget widget-default widget-item-icon" style="background:#ff9f40;">
                                 <div class="widget-item-left">
                                  <div class="widget-int num-count" id="dvAvgKPI"  runat="server"></div>
                                </div>                      
                                <div class="widget-data" style="margin-top: 22px;">
                                    
                                    <div class="widget-title">Average KPI achieved</div>
                                    <%--<div class="widget-subtitle">In your mailbox</div>--%>
                                </div>      
                                
                            </div>                            
                            <!-- END WIDGET MESSAGES -->
                            
                        </div>
                        <div class="col-md-3">
                            
                            <!-- START WIDGET REGISTRED -->
                            <div class="widget widget-default widget-item-icon" style="background:#ff6384;">
                                 <div class="widget-item-left">
                                   <div class="widget-int num-count" id="dvPayout"  runat="server"></div>
                                </div>
                                <div class="widget-data" style="margin-top: 22px;">
                                    
                                    <div class="widget-title">Payout for this month</div>
                                    <%--<div class="widget-subtitle">On your website</div>--%>
                                </div>
                                                        
                            </div>                            
                            <!-- END WIDGET REGISTRED -->
                            
                        </div>
                        <div class="col-md-3">
                            
                            <!-- START WIDGET REGISTRED -->
                            <div class="widget widget-default widget-item-icon" style="background:#9966ff;">
                                <div class="widget-item-left">
                                     <div class="widget-int num-count" id="dvRetention"  runat="server"></div>
                                </div>
                                <div class="widget-data" style="margin-top: 22px;">
                                    <div class="widget-title">Total Retention Amount</div>
                                    <%--<div class="widget-subtitle">On your website</div>--%>
                                </div>
                                                            
                            </div>                            
                            <!-- END WIDGET REGISTRED -->
                            
                        </div>   
                    </div>
                    <!-- END WIDGETS -->   
    <div class="row">
        <div class="col-md-6">
            <!-- START USERS ACTIVITY BLOCK -->
            <div class="panel panel-default">
                <div class="panel-heading" style="align-items:center">
                    <h3 class="panel-title">KPI Targets</h3>                                
                </div>
                <div class="panel-body">
                    <div id="canvas-holder1">
			            <canvas id="chart-expected"  style="width:375px; height:375px;"></canvas>
                        
		            </div>  
                    <div id="do_legend"></div>                  
		        </div>
            </div>
        </div>
        <div class="col-md-6">
            <!-- START USERS ACTIVITY BLOCK -->
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"> Performance Information</h3>                                
                </div>
                <div class="panel-body">
                    <div id="canvas-holder">
			            <canvas id="chart-performance" style="width:375px; height:375px;"></canvas>
		            </div>
                    <div id="do_legend1">
                        
                    </div>                                 
                </div>
            </div>
        </div>            						
    </div>
    <div>
        <input id="achivedData_value" type="hidden" class="achivedData_value" runat="server" value="" />
        <input id="achivedData_color" type="hidden" class="achivedData_color" runat="server" value="" />
        <input id="achivedData_labels" type="hidden" class="achivedData_labels" runat="server" value="" />
        <input id="achivedData_KPI" type="hidden" class="achivedData_KPI" runat="server" value="" />
        <input id="targetData_value" type="hidden" class="targetData_value" runat="server" value="" />
        <input id="targetData_color" type="hidden" class="targetData_color" runat="server" value="" />
        <input id="targetData_labels" type="hidden" class="targetData_labels" runat="server" value="" />
        <input id="targetData_Plan" type="hidden" runat="server" class="targetData_Plan" value="" />
    </div>
</asp:Content>

