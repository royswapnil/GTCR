<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmWOSearchPopup.aspx.vb" Inherits="CARS.frmWOSearchPopup" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WO Search Popup</title>
    <script type="text/javascript" src="../Scripts/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-ui-1.11.4.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui-i18n.min.js"></script>
    <script type="text/javascript" src="../semantic/semantic.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-migrate-1.2.1.js"></script>
    <script type="text/javascript" src="../javascripts/grid.locale-no.js"></script>
    <script type="text/javascript" src="../javascripts/jquery.jqGrid.js"></script>
    <script type="text/javascript" src="../javascripts/jquery.jqGrid.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery.jqGrid.src.js"></script>
    <script type="text/javascript" src="../javascripts/json2-min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../javascripts/Msg.js"></script>
    <link href="../Content/ui.jqgrid.css" rel="stylesheet" />
    <link href="../Content/themes/base/all.css" rel="stylesheet" />
    <link href="../Content/semantic.css" rel="stylesheet" />
    <link href="../CSS/cars.css" rel="stylesheet" type="text/css" />
    <script src="../Scripts/jquery.contextMenu.min.js"></script>
    <link href="../CSS/jquery.contextMenu.min.css" rel="stylesheet" type="text/css"  />
    <script src="../Scripts/cars.js"></script>
    <%--<script src="../Scripts/jquery-ui-1.11.4.js"></script>--%>
    <script type="text/javascript">
      $(document).ready(function () {
          var fn;

          $('#moSearch').on('keyup', function () {
              console.log('called keyup for: ' + $(this).prop('id'));
              if (fn) {
                  clearTimeout(fn);
              }
              fn = setTimeout(function () {
                  fetchOrder($('#moSearch').val());
                  console.log($('#moSearch').val());
              }, 200);
          });

          $('#mcSearch').on('keyup', function () {
              console.log('called keyup for: ' + $(this).prop('id'));
              if (fn) {
                  clearTimeout(fn);
              }
              fn = setTimeout(function () {
                  fetchCustomer($('#mcSearch').val());
                  console.log($('#mcSearch').val());
              }, 200);
          });

          $('#mvSearch').on('keyup', function () {
              console.log('called keyup for: ' + $(this).prop('id'));
              if (fn) {
                  clearTimeout(fn);
              }
              fn = setTimeout(function () {
                  fetchVehicle($('#mvSearch').val());
                  console.log($('#mvSearch').val());
              }, 200);
          });

          $('#msSearch').on('keyup', function () {
              console.log('called keyup for: ' + $(this).prop('id'));
              if (fn) {
                  clearTimeout(fn);
              }
              fn = setTimeout(function () {
                  fetchSparePart($('#msSearch').val());
                  console.log($('#msSearch').val());
              }, 200);
          });

          var getUrlParameter = function getUrlParameter(sParam) {
              var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                  sURLVariables = sPageURL.split('&'),
                  sParameterName,
                  i;

              for (i = 0; i < sURLVariables.length; i++) {
                  sParameterName = sURLVariables[i].split('=');

                  if (sParameterName[0] === sParam) {
                      return sParameterName[1] === undefined ? true : sParameterName[1];
                  }
              }
          };
          var searchType = getUrlParameter('Search');
                

          if (searchType == "Order")
          {
              var txt_Order = window.parent.document.getElementById('ctl00_cntMainPanel_txtOrder').value;
              var s = txt_Order;
              var inp = $('#moSearch');
              inp.val(s).focus();
              console.log(inp.val());
              $('#idOrder').removeClass('hidden');
              $('#idCustomer').addClass('hidden');
              $('#idVehicle').addClass('hidden');
              $('#idSpare').addClass('hidden');
              fetchOrder(s);

          }
            
          if (searchType == "Customer") {
              var txt_Customer = window.parent.document.getElementById('ctl00_cntMainPanel_txtCustomer').value;
              var s = txt_Customer;
              $('#idCustomer').removeClass('hidden');
              $('#idOrder').addClass('hidden');
              $('#idVehicle').addClass('hidden');
              $('#idSpare').addClass('hidden');
              fetchCustomer(s);

          }

          if (searchType == "Vehicle") {
              var txt_Vehicle = window.parent.document.getElementById('ctl00_cntMainPanel_txtVehicle').value;
              var s = txt_Vehicle;
              $('#idCustomer').addClass('hidden');
              $('#idOrder').addClass('hidden');
              $('#idVehicle').removeClass('hidden');
              $('#idSpare').addClass('hidden');
              fetchVehicle(s);

          }

          if (searchType == "Spare") {
              var txt_Vehicle = window.parent.document.getElementById('ctl00_cntMainPanel_txtSpare').value;
              var s = txt_Vehicle;
              $('#idCustomer').addClass('hidden');
              $('#idOrder').addClass('hidden');
              $('#idVehicle').addClass('hidden');
              $('#idSpare').removeClass('hidden');
              fetchVehicle(s);

          }
        
     

          //var txt_Customer = window.parent.document.getElementById('ctl00_cntMainPanel_txt_Customer').value;
          //var sCust = txt_Customer;
          //if (sCust != undefined || sCust != "") {
          //    $('#idCustomer').removeClass('hidden');
          //    fetchCustomer(sCust);
          //}

           function fetchOrder(s) {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
               // console.log("Running fetchOrders");
                var grd_Order = $("#grdOrder");
                var order_Data;
                grd_Order.jqGrid("clearGridData");
                grd_Order.jqGrid({
                    datatype: "local",
                    data: order_Data,
                    colNames: ['ORDNO', 'IDCust', 'CustName', 'CustAdd', 'CustZip', 'CustPhone', 'InvNo', 'InvDate', 'VehRef', 'VehReg', 'Prefix', 'WOSeries', 'PayType', 'OrderType', 'Status'],
                    colModel: [{ name: 'ORDNO', index: 'ORDNO', sorttype: "string", classes: 'wosearchpointer', width: 75 },
                                { name: 'IDCUSTOMER', index: 'IDCUSTOMER', sorttype: "string", classes: 'wosearchpointer', width: 100 },
                                { name: 'CUSTOMER', index: 'CUSTOMER', sorttype: "string", classes: 'wosearchpointer', width: 150 },
                                { name: 'CUSTADD1', index: 'CUSTADD1', sorttype: "string", classes: 'wosearchpointer', width: 150 },
                                { name: 'CUSTZIP', index: 'CUSTZIP', sorttype: "string", classes: 'wosearchpointer', width: 50 },
                                { name: 'CUSTPHONEMOBILE', index: 'CUSTPHONEMOBILE', sorttype: "string", classes: 'wosearchpointer', width: 100 },
                                { name: 'InvNo', index: 'InvNo', sorttype: "string", classes: 'wosearchpointer', width: 100 },
                                { name: 'InvDate', index: 'InvDate', sorttype: "string", classes: 'wosearchpointer', width: 100 },
                                { name: 'REFNO', index: 'REFNO', sorttype: "string", classes: 'wosearchpointer', width: 100 },
                                { name: 'REGNO', index: 'REGNO', sorttype: "string", classes: 'wosearchpointer', width: 100 },
                                { name: 'PREFIX', index: 'PREFIX',  sorttype: "string",hidden:true },
                                { name: 'WOSeries', index: 'WOSeries',  sorttype: "string", hidden: true },
                                { name: 'PayType', index: 'PayType', sorttype: "string", hidden: true },
                                { name: 'OrderType', index: 'OrderType', sorttype: "string", hidden: true },
                                { name: 'STATUS', index: 'STATUS',  sorttype: "string", hidden: true }
                                ],
                    pager: jQuery('#pagerOrd'),
                    hidegrid: false,
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    viewrecords: true,
                    height: 350,
                    async: false, //Very important,
                    subGrid: false,
                    autoWidth: true,
                    shrinkToFit: true,
                    sortorder: "desc",
                    sortname: 'ORDNO'
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmWOSearchPopup.aspx/Order_Search",
                    data: "{q: '" + s + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        for (i = 0; i < data.d.length; i++) {
                            order_Data = data;
                           // console.log(order_Data.d[i]);
                            grd_Order.jqGrid('addRowData', i + 1, order_Data.d[i]);
                        }
                        jQuery("#grdOrder").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    }
                });               
            }

          

          function fetchCustomer(s) {
              var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
              console.log("Running fetchCustomer");
              var grd_Customer = $("#grdCustomer");
              var customer_Data;
              grd_Customer.jqGrid("clearGridData");
              grd_Customer.jqGrid({
                  datatype: "local",
                  data: customer_Data,
                  colNames: ['CustNo', 'CUST_NAME', 'ADDRESS', 'ZIPCODE', 'CITY', 'annen adresse'],
                  colModel: [{ name: 'ID_CUSTOMER', index: 'ID_CUSTOMER', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'CUST_NAME', index: 'CUST_NAME', width: 250, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'CUST_PERM_ADD1', index: 'CUST_PERM_ADD1', width: 150, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'ID_CUST_PERM_ZIPCODE', index: 'ID_CUST_PERM_ZIPCODE', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'CUST_PERM_CITY', index: 'CUST_PERM_CITY', width: 150, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'CUST_VISIT_ADDRESS', index: 'CUST_VISIT_ADDRESS', width: 150, sorttype: "string", classes: 'wosearchpointer' }],
                  gridview: true,
                  hidegrid: false,
                  viewrecords: true,
                  multselect: true,
                  height: 350,
                  autoWidth: true,
                  shrinkToFit: true,
                  sortorder: "desc",
                  sortname: 'CustNo',
                  caption: "S&oslash;keresultat",
                  async: false,
                  pager: jQuery('#pagerCustomer'),
                  rowNum: pageSize,//can fetch from webconfig
                  rowList: 5
              });

              $.ajax({
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  url: "frmWOSearch.aspx/Customer_Search",
                  data: "{q: '" + s + "'}",
                  dataType: "json",
                  async: false,//Very important
                  success: function (data) {
                      for (i = 0; i < data.d.length; i++) {
                          customer_Data = data;
                          console.log(customer_Data.d[i]);
                          grd_Customer.jqGrid('addRowData', i + 1, customer_Data.d[i]);
                      }
                      grd_Customer.setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                  }
              });

          }


          function fetchVehicle(s) {
              var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
              console.log("Running fetchVehicles");
              var grd_Vehicle = $("#grdVehicle");
              var vehicle_Data;
              grd_Vehicle.jqGrid("clearGridData");
              grd_Vehicle.jqGrid({
                  datatype: "local",
                  data: vehicle_Data,
                  colNames: ['VehRegNo', 'IntNo', 'VehVin', 'Make', 'ModelType', 'CustomerName'],
                  colModel: [{ name: 'VehRegNo', index: 'VehRegNo', width: 100, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'IntNo', index: 'IntNo', width: 100, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'VehVin', index: 'VehVin', width: 200, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'Make', index: 'Make', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'ModelType', index: 'ModelType', width: 150, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'CustomerName', index: 'CustomerName', width: 200, sorttype: "string", classes: 'wosearchpointer' }],
                  viewrecords: true,
                  hidegrid: false,
                  gridview: true,
                  multselect: true,
                  height: 350,
                  autoWidth: true,
                  shrinkToFit: true,
                  sortorder: "desc",
                  sortname: 'VehRegNo',
                  caption: "S&oslash;keresultat",
                  async: false,
                  pager: jQuery('#pagerVehicle'),
                  rowNum: pageSize,//can fetch from webconfig
                  rowList: 5

              });

              $.ajax({
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  url: "frmWOSearch.aspx/Vehicle_Search",
                  data: "{q: '" + s + "'}",
                  dataType: "json",
                  async: false,//Very important
                  success: function (data) {
                      for (i = 0; i < data.d.length; i++) {
                          vehicle_Data = data;
                          console.log(vehicle_Data.d[i]);
                          grd_Vehicle.jqGrid('addRowData', i + 1, vehicle_Data.d[i]);
                      }
                      grd_Vehicle.setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                  }
              });
          }

          function fetchSparePart(s) {
              var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
              console.log("Running fetchSpareParts");
              var grd_Spare = $("#grdSpare");
              var spare_Data;
              grd_Spare.jqGrid("clearGridData");
              grd_Spare.jqGrid({
                  datatype: "local",
                  sortable: true,
                  data: spare_Data,
                  colNames: ['Make', 'SpareNo', 'SpareDesc', 'StockQty', 'Location', 'Costprice', 'Salesprice', 'Warehouse'],
                  colModel: [{ name: 'ID_MAKE', index: 'Make', width: 60, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'ID_ITEM', index: 'SpareNo', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'ITEM_DESC', index: 'SpareDesc', width: 200, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'ITEM_AVAIL_QTY', index: 'StockQty', width: 60, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'LOCATION', index: 'Location', width: 100, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'COST_PRICE1', index: 'Costprice', width: 100, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'ITEM_PRICE', index: 'Salesprice', width: 100, sorttype: "string", classes: 'wosearchpointer' },
                              { name: 'ID_WH_ITEM', index: 'Warehouse', width: 100, sorttype: "string", classes: 'wosearchpointer' }],
                  viewrecords: true,
                  hidegrid: false,
                  gridview: true,
                  multselect: true,
                  height: 350,
                  autoWidth: true,
                  shrinkToFit: true,
                  sortorder: "asc",
                  sortname: 'ID_ITEM',
                  caption: "S&oslash;keresultat",
                  async: false,
                  pager: jQuery('#pagerSpare'),
                  rowNum: pageSize,//can fetch from webconfig
                  rowList: 5

              });

              $.ajax({
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  url: "frmWOSearch.aspx/SparePart_Search",
                  data: "{q: '" + s + "'}",
                  dataType: "json",
                  async: false,//Very important
                  success: function (data) {
                      for (i = 0; i < data.d.length; i++) {
                          spare_Data = data;
                          console.log(spare_Data.d[i]);
                          grd_Spare.jqGrid('addRowData', i + 1, spare_Data.d[i]);
                      }
                      grd_Spare.setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                  }
              });
          }

          //Order Click
          jQuery("#grdOrder").click(function (e) {
              var el = e.target;
              if (el.nodeName !== "TD") {
                  el = $(el, this.rows).closest("td");
              }
              var iCol = $(el).index();
              var nCol = $(el).siblings().length;
              var row = $(el, this.rows).closest("tr.jqgrow");
              if (row.length > 0) {
                  var rowId = row[0].id;
                  var woNo = row[0].cells['11'].title;
                  var woPr = row[0].cells['10'].title;
                  var mode = 'Edit';
                  var flag = encodeURIComponent('Ser');

                  woNo = encodeURIComponent(woNo);
                  // var uri = '../Transactions/frmWOHead.aspx?Wonumber=' + encodeURIComponent(woNo) + "&WOPrefix=" + encodeURIComponent(woPr) + "&Mode=" + encodeURIComponent(mode) + "&TabId=" + 2 + "&Flag=" + encodeURIComponent(flag) + "&blWOsearch=true";
                  //window.location.replace("../Transactions/frmWOHead.aspx?Wonumber=" + woNo + "&WOPrefix=" + woPr + "&Mode=" + mode + "&TabId=" + 2 + "&Flag=" + flag + "&blWOsearch=" + true);
                  window.parent.window.location.assign("../Transactions/frmWOJobDetails.aspx?Wonumber=" + woNo + "&WOPrefix=" + woPr + "&Mode=" + mode + "&TabId=" + 2 + "&Flag=" + flag + "&blWOsearch=" + true);
                  
              }

          });

          //Customer Click
          jQuery("#grdCustomer").click(function (e) {
              var el = e.target;
              if (el.nodeName !== "TD") {
                  el = $(el, this.rows).closest("td");
              }
              var iCol = $(el).index();
              var nCol = $(el).siblings().length;
              var row = $(el, this.rows).closest("tr.jqgrow");
              if (row.length > 0) {
                  var rowId = row[0].id;
                  var customerId = row[0].cells['1'].title;
                  window.parent.window.location.assign("../Master/frmCustomerDetail.aspx?cust=" + customerId);
              }

          });

          //Vehicle Click
          jQuery("#grdVehicle").click(function (e) {
              var el = e.target;
              if (el.nodeName !== "TD") {
                  el = $(el, this.rows).closest("td");
              }
              var iCol = $(el).index();
              var nCol = $(el).siblings().length;
              var row = $(el, this.rows).closest("tr.jqgrow");
              if (row.length > 0) {
                  var rowId = row[0].id;
                  var vehRegNo = row[0].cells['1'].title;
                  var vehRefNo = "";
                  window.parent.window.location.assign("../master/frmVehicleDetail.aspx?refno=" + vehRefNo + "&regno=" + vehRegNo);
              }

          });

          //Spare grid Click
          jQuery("#grdSpare").click(function (e) {
              var el = e.target;
              if (el.nodeName !== "TD") {
                  el = $(el, this.rows).closest("td");
              }
              var iCol = $(el).index();
              var nCol = $(el).siblings().length;
              var row = $(el, this.rows).closest("tr.jqgrow");
              if (row.length > 0) {
                  var rowId = row[0].id;
                  var item = row[0].cells['2'].title;
                  var make = row[0].cells['1'].title;
                  var wh = row[0].cells['8'].title;
                  var flag = encodeURIComponent('Ser');


                  // var uri = '../Transactions/frmWOHead.aspx?Wonumber=' + encodeURIComponent(woNo) + "&WOPrefix=" + encodeURIComponent(woPr) + "&Mode=" + encodeURIComponent(mode) + "&TabId=" + 2 + "&Flag=" + encodeURIComponent(flag) + "&blWOsearch=true";
                  //window.location.replace("../Transactions/frmWOHead.aspx?Wonumber=" + woNo + "&WOPrefix=" + woPr + "&Mode=" + mode + "&TabId=" + 2 + "&Flag=" + flag + "&blWOsearch=" + true);
                  window.parent.window.location.assign("../ss3/LocalSPDetail.aspx?id_make=" + make + "&id_item=" + item + "&id_wh_item=" + wh);

              }

          });

          $(function () {
              $.contextMenu({
                  selector: '#grdOrder tr',
                  callback: function (key, options) {
                      var m = "clicked: " + key;
                      window.console && console.log(m) || alert(m);
                  },
                  items: {
                      "edit": {
                          name: "Invoice",
                          callback: function (key, opt) {
                              var orderNo = $(this)[0].cells['11'].title;
                              var orderPr = $(this)[0].cells['10'].title;
                              var custId = $(this)[0].cells['1'].title;
                              var invNo = $(this)[0].cells['6'].title;
                              var payType = $(this)[0].cells['12'].title;
                              var orderType = $(this)[0].cells['13'].title;
                              var status = $(this)[0].cells['14'].title;
                              var flgBkOrd = "false";

                              if (status == "INV") {
                                  alert("Order is already Invoiced")
                              } else if (status != "RINV") {
                                  alert("Set the Ord status to RINV before Invoice.")
                              }
                              else if (status == "RINV") {
                                  invoiceOrder(orderNo, orderPr, custId, invNo, flgBkOrd, payType, orderType);
                                  fetchOrder($('#moSearch').val());
                              }
                          }
                      },
                      "Delete": {
                          name: "Delete",
                          callback: function (key, opt) {
                              DelOrder($(this)[0])
                              fetchOrder($('#moSearch').val())
                          }
                      },
                      "ViewPdf": {
                          name: "ViewPdf",
                          callback: function (key, opt) {
                              var orderNo = $(this)[0].cells['11'].title;
                              var orderPr = $(this)[0].cells['10'].title;
                              var custId = $(this)[0].cells['1'].title;
                              var invNo = $(this)[0].cells['6'].title;
                              var payType = $(this)[0].cells['12'].title;
                              if (invNo != "") {
                                  openPdf(orderNo, orderPr, custId, invNo);
                              }
                              else {
                                  alert("No invoice to view");
                              }
                          }
                      }
                  }
              });

              $('.context-menu-one').on('click', function (e) {
                  console.log('clicked', this);
              });
          });

          function openPdf(orderNo, orderPr, custId, invNo) {
              $.ajax({
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  url: "frmWOSearchPopup.aspx/OpenPdf",
                  data: "{orderNo: '" + orderNo + "',orderPr:'" + orderPr + "',custId:'" + custId + "',invNo:'" + invNo + "'}",
                  dataType: "json",
                  async: false,//Very important
                  success: function (data) {
                      var result = data.d.split(',');
                      if (result[0] == "Err") {
                          alert(result[1]);
                      }
                      else {
                          var Url = result[1]; //"../Reports/frmShowReports.aspx?ReportHeader=YF8c/MYCthcdMZ0D0ra6EQ==&InvoiceType=YF8c/MYCthcdMZ0D0ra6EQ==&Rpt=GPwu6EpyNgg8JACPpv3cVA==&scrid=" + orderPr + orderNo + "&JobCardSett=1"
                          window.open(Url, 'Reports', "menubar=no,location=no,status=no,scrollbars=yes,resizable=yes");
                      }

                  }
              });
          }

          function invoiceOrder(orderNo, orderPr, custId, invNo, flgBkOrd, payType, orderType) {
              $.ajax({
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  url: "frmWOSearchPopup.aspx/InvoiceOrder",
                  data: "{orderNo: '" + orderNo + "',orderPr:'" + orderPr + "',custId:'" + custId + "',invNo:'" + invNo + "',flgBkOrd:'" + flgBkOrd + "',payType:'" + payType + "',orderType:'" + orderType + "'}",
                  dataType: "json",
                  async: false,//Very important
                  success: function (data) {
                      var result = data.d.split(',');
                      if (result[0] == "Err") {
                          alert(result[1]);
                      }
                      else if (result[0] == "Confirm") {
                          var cf = confirm(result[1]);
                          if (cf) {
                              flgBkOrd = "true"
                              invoiceOrder(orderNo, orderPr, custId, invNo, flgBkOrd, payType, orderType)
                          }
                          else {
                              return false;
                          }
                      }
                      else {
                          var Url = result[1]; //"../Reports/frmShowReports.aspx?ReportHeader=YF8c/MYCthcdMZ0D0ra6EQ==&InvoiceType=YF8c/MYCthcdMZ0D0ra6EQ==&Rpt=GPwu6EpyNgg8JACPpv3cVA==&scrid=" + orderPr + orderNo + "&JobCardSett=1"
                          window.open(Url, 'Reports', "menubar=no,location=no,status=no,scrollbars=yes,resizable=yes");
                      }

                  }
              });

          }

          function DelOrder(grd) {
              var orderxml;
              var orderxmls = "";
              var woNum = grd.cells['11'].title;
              var woPr = grd.cells['10'].title;
              orderxml = '<WO><WONumber>' + woNum + '</WONumber><WOPrefix>' + woPr + '</WOPrefix></WO>'
              orderxml = "<ROOT>" + orderxml + "</ROOT>"
              $.ajax({
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  url: "frmWOSearchPopup.aspx/DeleteOrd",
                  data: "{q: '" + orderxml + "'}",
                  dataType: "json",
                  async: false,//Very important
                  success: function (data) {
                      var msg = data.d[1] + data.d[2];
                      if (data.d[0] == "DEL") {
                          systemMSG('success', msg, 4000);
                      }
                      else if (data.d[0] == "NDEL") {
                          systemMSG('error', msg, 4000);
                      }
                  }
              });

          }
           
        }); //end of reaady

    </script>
    </head>
    <body>
    <form id="form1" runat="server">
     <asp:HiddenField ID="hdnPageSize" runat="server"  Value="5"/>
        <div id="searchPanels">
            <asp:Label ID="RTlblError" runat="server" CssClass="lblErr"></asp:Label>
            <div id="idOrder" class="hidden">
                <div class="ui form">
                    <div class="field">
                        <input id="moSearch" class="popupSearch" type="text" placeholder="Order search (ordernumber, customer number, vehicle registration, phone number...)" autocomplete="off"/>
                    </div>
                </div>
                <div style="overflow:auto">
                    <table id="grdOrder"></table>
                    <div id="pagerOrd"></div>
                </div>
                 <div style="padding:0.5em"></div>
                <div class="ui grid">
                    <div class="one wide column">
                        <div class="ui form">
                        </div>
                    </div>
                    <div class="five wide column">
                        <div class="ui form">
                            <asp:CheckBoxList ID="cbSortSpecific" runat="server">
                                <asp:ListItem Text="Kun åpne ordre" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Vis splitt" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Kun reklamasjoner" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Kun klar for fakt." Value="3"></asp:ListItem>
                                <asp:ListItem Text="Vis kun splitt" Value="4"></asp:ListItem>
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="five wide column">
                        <asp:CheckBoxList ID="cbSortStatus" runat="server">
                            <asp:ListItem Text="Tilbud" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Faktura" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Kreditnota" Value="2"></asp:ListItem>
                        </asp:CheckBoxList>
                        <asp:Button ID="btnStandard" runat="server" Text="Standard" CssClass="ui btn" TabIndex="11" />
                    </div>
                    <div class="five wide column">
                        <div class="ui form">
                            <asp:Button ID="btnAll" runat="server" Text="Alle" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="btnSearch2" runat="server" Text="Tøm" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="btnEmpty" runat="server" Text="Standard" CssClass="ui btn" TabIndex="11" />
                            <asp:CheckBox ID="CheckBox1" Text="Add-on" runat="server" TabIndex="0" CssClass="sr-only"></asp:CheckBox><br />
                        </div>
                    </div>
                </div>
            </div>


            <div id="idCustomer" class="hidden">
                <div class="ui form">
                    <div class="field">
                        <label class="sr-only">Kjøretøysøk</label>
                        Søk etter Kundenr, navn, Telefonnr, Adresse, Kjøretøy, etc.
                                                <input id="mcSearch" type="text" placeholder="Kundenr, navn, Telefonnr, Adresse, Kjøretøy, etc." autocomplete="off"/>
                    </div>
                </div>
                <div style="overflow:auto">
                    <table id="grdCustomer"></table>
                    <div id="pagerCustomer"></div>
                </div>
                 <div style="padding:0.5em"></div>
                <div class="ui grid">
                    <div class="one wide column">
                        <div class="ui form">
                        </div>
                    </div>
                    <div class="seven wide column">
                        <div class="ui form">
                            
                        </div>
                    </div>
                    <div class="three wide column">
                        <asp:CheckBoxList ID="CheckBoxList1" runat="server">
                            <asp:ListItem Text="Private kunder" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Prospekts" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Firma kunder" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Vis fakt. adr." Value="3"></asp:ListItem>
                        </asp:CheckBoxList>
                    </div>

                    <div class="five wide column">
                        <div class="ui form">
                            <asp:Button ID="Button1" runat="server" Text="Alle" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="Button2" runat="server" Text="Tøm" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="Button3" runat="server" Text="Standard" CssClass="ui btn" TabIndex="11" />
                            <asp:CheckBox ID="CheckBox2" Text="Add-on" runat="server" TabIndex="0" CssClass="sr-only"></asp:CheckBox><br />
                        </div>
                    </div>
                </div>
            </div>
           <div id="idVehicle" class="hidden">
                <div class="ui form">
                    <div class="field">
                        <label class="sr-only">Kjøretøysøk</label>
                        Søk etter regnr, internnr, chassisnr, kundenummer, etc.
                                                <input id="mvSearch" type="text" placeholder="Regnr, Internnr, Chassisnr, Kundenummer, Kundenavn, etc." autocomplete="off" />
                    </div>
                </div>
                <div style="overflow:auto">
                    <table id="grdVehicle"></table>
                    <div id="pagerVehicle"></div>
                </div>
                <div style="padding:0.5em"></div>
                <div class="ui grid">
                    <div class="one wide column">
                        <div class="ui form">
                        </div>
                    </div>
                    <div class="five wide column">
                        <div class="ui form">
                            <asp:RadioButtonList ID="sortVehicles" runat="server">
                                <asp:ListItem Text="Kjøretøy på lager" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Nye på lager" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Brukte på lager" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="five wide column">
                        <asp:CheckBoxList ID="vehicleTypes" runat="server">
                            <asp:ListItem Text="Nye kjøretøy" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Brukte biler" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Brukte maskiner" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Leiebiler på lager" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Kjøretøy ventet inn" Value="4"></asp:ListItem>
                        </asp:CheckBoxList>
                    </div>

                    <div class="five wide column">
                        <div class="ui form">
                            <asp:Button ID="all" runat="server" Text="Alle" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="empty" runat="server" Text="Tøm" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="standard" runat="server" Text="Standard" CssClass="ui btn" TabIndex="11" />
                            <asp:CheckBox ID="chkAddOn" Text="Add-on" runat="server" TabIndex="0" CssClass="sr-only"></asp:CheckBox><br />
                        </div>
                    </div>
                </div>

            </div>
            <div id="idSpare" class="hidden">
                <div class="ui form">
                    <div class="field">
                        <label class="sr-only">Varesøk</label>
                        Søk etter varenr, navn, fabrikat, leverandør, lokasjon etc.
                        <input id="msSearch" type="text" placeholder="Søk etter varenr, navn, fabrikat, leverandør, lokasjon etc." autocomplete="off" />
                    </div>
                </div>
                <div style="overflow:auto">
                    <table id="grdSpare"></table>
                    <div id="pagerSpare"></div>
                </div>
                 <div style="padding:0.5em"></div>
                <div class="ui grid">
                    <div class="one wide column">
                        <div class="ui form">
                        </div>
                    </div>
                    <div class="five wide column">
                        <div class="ui form">

                        </div>
                    </div>
                    <div class="five wide column">
                        <asp:CheckBoxList ID="cbStockItemChoices" runat="server">
                            <asp:ListItem Text="Kun varer med beholdning" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Kun varer med lagerkontroll og beh." Value="1"></asp:ListItem>
                            <asp:ListItem Text="Kun varer uten kontroll med beh." Value="2"></asp:ListItem>
                        </asp:CheckBoxList>
                    </div>

                    <div class="five wide column">
                        <div class="ui form">
                            <asp:Button ID="Button4" runat="server" Text="Alle" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="Button5" runat="server" Text="Tøm" CssClass="ui btn" TabIndex="11" /><br />
                            <asp:Button ID="Button6" runat="server" Text="Standard" CssClass="ui btn" TabIndex="11" />
                            <asp:CheckBox ID="CheckBox3" Text="Add-on" runat="server" TabIndex="0" CssClass="sr-only"></asp:CheckBox><br />
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </form>
</body>
    </html>

