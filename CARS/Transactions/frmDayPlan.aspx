<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmDayPlan.aspx.vb" Inherits="CARS.frmDayPlan" MasterPageFile="~/MasterPage.Master"%>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#<%=txtPlanSeq.ClientID%>').hide();
            $('#<%=lblPlanSeq.ClientID%>').hide();
            var debug = true;
            if (debug) {
                console.log('Debug is active');
            }
            $.datepicker.setDefaults($.datepicker.regional["no"]);

            $('#<%=txtPlanDate.ClientID%>').datepicker({
                //showWeek: true,
                //showOn: "button",
                //buttonImage: "../images/calendar_icon.gif",
                // buttonImageOnly: true,
                // buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: "dd/mm/yy"

            });
            $('#<%=txtPlanDTFrom.ClientID%>').datepicker({
                //showWeek: true,
                //showOn: "button",
                //buttonImage: "../images/calendar_icon.gif",
                // buttonImageOnly: true,
                // buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: "dd/mm/yy"

            });
            $('#<%=txtPlanDTTo.ClientID%>').datepicker({
                //showWeek: true,
                //showOn: "button",
                //buttonImage: "../images/calendar_icon.gif",
                // buttonImageOnly: true,
                // buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: "dd/mm/yy"

            });
            $('#<%=txtStartTime.ClientID%>').change(function (e) {
                fnValidateStTime();
            });
            $('#<%=txtEndTime.ClientID%>').change(function (e) {
                fnValidateEdTime();
            });
            function fnValidateStTime() {
                if ($('#<%=txtStartTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtStartTime.ClientID%>'));
                }
            }
            function fnValidateEdTime() {
                if ($('#<%=txtEndTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtEndTime.ClientID%>'));
                }
            }

            //savePlanDet();

        });
        var debug = true;
        var dpurl = '<%=System.Configuration.ConfigurationManager.AppSettings("DayPlanUrl")%>'
        function savePlanDet() {
            $.support.cors = true;
            //$.mobile.allowCrossDomainPages = true;
            var userId = '<%= Session("UserID")%>';
            var customer = collectGroupData('submit');
            $.ajax({
                type: "GET",
                contentType: "application/json;charset=utf-8",
                jsonpCallback: "logResults",
                dataType: "JSONP",
                //url: "http://localhost:53020/DPService.svc/InsertUserDetails?mechanicInfo=" + JSON.stringify(customer) + "&loginId=" + userId,
                //url: "http://localhost:53020/DPService.svc/InsertUserDetails?mechanicInfo=" + JSON.stringify(customer) + "&loginId=" + userId,
                url: dpurl + "/InsertUserDetails?mechanicInfo=" + JSON.stringify(customer) + "&loginId=" + userId,
                success: function (Result) {
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    $('#<%=RTlblError.ClientID%>').text(Result.InsertUserDetailsResult[0].Message);

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function logResults(data) {
            if (data.responseStatus == "200")
                console.log("Success");
            else
                console.log("Fail");
        }
       

        function collectGroupData(dataTag) {
            dataCollection = {};
            $('[data-' + dataTag + ']').each(function (index, elem) {
                var st = $(elem).data(dataTag);
                var dv = '';
                var elemType = $(elem).prop('nodeName');
                switch (elemType) {
                    case 'INPUT':
                        dv = $(elem).val();
                        break;
                    case 'TEXTAREA':
                        dv = $(elem).val();
                        break;
                    case 'SELECT':
                        dv = $(elem).val();
                        break;
                    case 'LABEL':
                        dv = $(elem).html();
                        break;
                    case 'SPAN':
                        if ($(elem).children('input').is(':checked')) {
                            dv = '1';
                        } else {
                            dv = '0';
                        }
                        break;
                    default:
                        dv = '01';
                }
                if (debug) {
                    console.log(index + ' Added ' + dataTag + ': ' + st + ' with value: ' + dv + ' and type: ' + elemType);
                }
                dataCollection[st] = dv;
            });
            return dataCollection;
        }

        function searchPlanDet() {
            var result = fnClientValidate();
            if (result == true) {
                $.support.cors = true;
                //$.mobile.allowCrossDomainPages = true;
                var userId = '<%= Session("UserID")%>';
                var mechanic = collectGroupData('rg-submit');
                var grid = $("#dgdPlanDet");
                var mydata;
                grid.jqGrid({
                    datatype: "local",
                    data: mydata,
                    colNames: ['IdPlanSeq', 'DepartmentId', 'IdMechanic', 'PlanDate', 'PlanTimeFrom', 'PlanTimeTo', 'Description', 'Title',''],
                    colModel: [
                             { name: 'IdPlanSeq', index: 'IdPlanSeq', width: 90, hidden:true},
                             { name: 'DeptId', index: 'DeptId', width: 150 },
                             { name: 'MechanicId', index: 'MechanicId', width: 100 },
                             { name: 'PlanDate', index: 'PlanDate', width: 200 },
                             { name: 'PlanTimeFrom', index: 'WareHouseSubsideryName', width: 200 },
                             { name: 'PlanTimeTo', index: 'PlanTimeTo', width: 200 },
                             { name: 'Description', index: 'Description', width: 200 },
                             { name: 'Title', index: 'Title', width: 200 },
                             { name: 'IdPlanSeq', index: 'IdPlanSeq', formatter: edtMech }
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerPlanDet'),
                    rowNum: 5,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    autoWidth: true,
                    shrinkToFit: true,
                    caption: "",
                    async: false, //Very important,
                    subgrid: false

                });

                $.ajax({
                    type: "GET",
                    contentType: "application/json;charset=utf-8",
                    jsonpCallback: "logResults",
                    dataType: "JSONP",
                    //url: "http://localhost:53020/DPService.svc/InsertUserDetails?mechanicInfo=" + JSON.stringify(customer) + "&loginId=" + userId,
                    url: dpurl + "/FetchMechanicDetails?objUserDet=" + JSON.stringify(mechanic) + "&loginId=" + userId,
                    success: function (data) {
                        jQuery("#dgdPlanDet").jqGrid('clearGridData');

                        for (i = 0; i < data.FetchMechanicDetailsResult.length; i++) {
                            mydata = data.FetchMechanicDetailsResult;
                            jQuery("#dgdPlanDet").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        // $('#<%=RTlblError.ClientID%>').text(Result.FetchMechanicDetailsResult[0]);

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                // jQuery("#dgdImportList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                $("#dgdPlanDet").jqGrid("hideCol", "subgrid");
            }
        }
        function fnClientValidate() {
            if (!(gfi_CheckEmpty($('#<%=txtPlanDTFrom.ClientID%>'), '0126'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtPlanDTTo.ClientID%>'), '0126'))) {
                return false;
            }

            return true;
        }

        function edtMech(cellvalue, options, rowObject) {
            var idPlanSeq = rowObject.IdPlanSeq.toString();
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=edtMechDet(" + "'" + idPlanSeq + "'" + "); />";
            return edit;
        }

        function edtMechDet(idPlanSeq) {
            $('#<%=txtPlanSeq.ClientID%>').show();
            $('#<%=lblPlanSeq.ClientID%>').show();
            $.support.cors = true;
            $.ajax({
                type: "GET",
                contentType: "application/json;charset=utf-8",
                jsonpCallback: "logResults",
                dataType: "JSONP",
                //url: "http://localhost:53020/DPService.svc/InsertUserDetails?mechanicInfo=" + JSON.stringify(customer) + "&loginId=" + userId,
                url: dpurl + "/LoadMechanicDetails?idPlanSeq=" + idPlanSeq,
                success: function (data) {
                    if (data.LoadMechanicDetailsResult.length != 0) {
                        $('#<%=txtPlanSeq.ClientID%>').val(data.LoadMechanicDetailsResult[0].IdPlanSeq);
                        $('#<%=txtDept.ClientID%>').val(data.LoadMechanicDetailsResult[0].DeptId);
                        $('#<%=txtMechanicId.ClientID%>').val(data.LoadMechanicDetailsResult[0].MechanicId);
                        $('#<%=txtPlanDate.ClientID%>').val(data.LoadMechanicDetailsResult[0].PlanDate);
                        $('#<%=txtStartTime.ClientID%>').val(data.LoadMechanicDetailsResult[0].PlanTimeFrom);
                        $('#<%=txtEndTime.ClientID%>').val(data.LoadMechanicDetailsResult[0].PlanTimeTo);
                        $('#<%=txtDesc.ClientID%>').val(data.LoadMechanicDetailsResult[0].Description);
                        $('#<%=txtTitle.ClientID%>').val(data.LoadMechanicDetailsResult[0].Title);
                    }
                }
                });
        }

        function delPlanDetail() {
            var idPlanseq = "";
            $('#dgdPlanDet input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idPlanseq = $('#dgdPlanDet tr ')[row].cells[2].innerHTML.toString();
                }
            });

            if (idPlanseq != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    delPlanDet();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function delPlanDet() {
            $.support.cors = true;
            var row;
            var idPlanseq;
            var resultmsg = "";
            $('#dgdPlanDet input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idPlanSeq = $('#dgdPlanDet tr ')[row].cells[2].innerHTML.toString();
                    $.ajax({
                        type: "GET",
                        contentType: "application/json;charset=utf-8",
                        jsonpCallback: "logResults",
                        dataType: "JSONP",
                        //url: "http://localhost:53020/DPService.svc/InsertUserDetails?mechanicInfo=" + JSON.stringify(customer) + "&loginId=" + userId,
                        url: dpurl + "/DelMechanicDetails?idPlanSeq=" + idPlanSeq,
                        success: function (data) {
                            debugger;
                            var result = data.DelMechanicDetailsResult;
                            result = idPlanSeq + ' ' + result;
                            resultmsg += result
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=RTlblError.ClientID%>').text(resultmsg);
                            jQuery("#dgdPlanDet").jqGrid('clearGridData');
                            searchPlanDet();

                        },
                        error: function (result) {
                            alert("Error");
                        }
                    });
                }

            });

        }
      
    </script>
  <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Day Plan"></asp:Label>
    <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
       <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
            <asp:HiddenField ID="hdnMode" runat="server" />
</div>
    <div id="divCfInvDetails" class="ui raised segment signup inactive">
         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A2" runat="server" class="active item">Insert Mechanic Details </a>  
         </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
             <asp:Label ID="lblDeptId" runat="server" Text="DepartmentId" Width="180px"></asp:Label>
              <asp:TextBox ID="txtDept" runat="server" Width="200px" data-submit="DeptId" ></asp:TextBox>
            <asp:Label ID="lblPlanSeq" runat="server" Text="IdPlanSeq" Width="180px"></asp:Label>
              <asp:TextBox ID="txtPlanSeq" runat="server" Width="200px" data-submit="IdPlanSeq"  ></asp:TextBox>
          </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <asp:Label ID="lblMechanicId" runat="server" Text="MechanicId" Width="180px"></asp:Label>
              <asp:TextBox ID="txtMechanicId" runat="server" Width="200px" data-submit="MechanicId"  ></asp:TextBox>
              <asp:Label ID="lblStartTime" runat="server" Text="startTime" Width="180px"></asp:Label>
              <asp:TextBox ID="txtStartTime" runat="server" Width="200px" data-submit="PlanTimeFrom" ></asp:TextBox>       
     </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <asp:Label ID="lblEndTime" runat="server" Text="EndTime" Width="180px"></asp:Label>
              <asp:TextBox ID="txtEndTime" runat="server" Width="200px" data-submit="PlanTimeTo" ></asp:TextBox>
              <asp:Label ID="lblPlanDate" runat="server" Text="PlanDate" Width="180px"></asp:Label>
              <asp:TextBox ID="txtPlanDate" runat="server" Width="200px" data-submit="PlanDate" ></asp:TextBox>       
     </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <asp:Label ID="lblDesc" runat="server" Text="Description" Width="180px" ></asp:Label>
              <asp:TextBox ID="txtDesc" runat="server" Width="200px" data-submit="Description" ></asp:TextBox>
              <asp:Label ID="lblTitle" runat="server" Text="Title" Width="180px"></asp:Label>
              <asp:TextBox ID="txtTitle" runat="server" Width="200px" data-submit="Title" ></asp:TextBox>       
     </div>
         <div style="text-align:center">
                <input id="Button1" runat="server" class="ui button"  value="Save" type="button" onclick="savePlanDet()"/></div>
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A1" runat="server" class="active item">Fetch Mechanic Details </a>  
         </div>
        <div style="padding:0.5em"></div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <asp:Label ID="lblMech" runat="server" Text="MechanicId" Width="180px"></asp:Label>
              <asp:TextBox ID="txtMech" runat="server" Width="200px" data-rg-submit="MechanicId"  ></asp:TextBox>
              <asp:Label ID="lblPlanDTFrom" runat="server" Text="PlanDateFrom" Width="180px"></asp:Label><span class="mand">*</span>
              <asp:TextBox ID="txtPlanDTFrom" runat="server" Width="200px" data-rg-submit="PlanDateFrom" ></asp:TextBox>       
     </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
             <asp:Label ID="lblPlanDTTo" runat="server" Text="PlanDateTo" Width="180px"></asp:Label><span class="mand">*</span>
              <asp:TextBox ID="txtPlanDTTo" runat="server" Width="200px" data-rg-submit="PlanDateTo" ></asp:TextBox>
          </div>
         <div style="text-align:center">
                <input id="btnSearch" runat="server" class="ui button"  value="Search" type="button" onclick="searchPlanDet()"/>
            </div>
         <div style="padding:0.5em"></div>
        <div>
             <table id="dgdPlanDet"></table>
               <div id="pagerPlanDet"></div>
         </div>
        <div style="text-align:center">
                <input id="btnDelete" runat="server" class="ui button"  value="Delete" type="button" onclick="delPlanDetail()"/>
            </div>
</div>
    </asp:Content>
