<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="LocalSPDetail.aspx.vb" Inherits="CARS.LocalSPDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="server">


    <script type="text/javascript">
       
        function overlay(state, mod) {
            $('body').focus();
            if (mod == "") {
                $('.modal').addClass('hidden');
            }
            else {
                $('#' + mod).removeClass('hidden');
            }
            if (state == "") {
                $('.overlayHide').toggleClass('ohActive');
            } else if (state == "on") {
                $('.overlayHide').addClass('ohActive');
            } else {
                $('.overlayHide').removeClass('ohActive');
            }
        }


        $(document).ready(function () {
            var debug = true;
            loadInit();
           
            function loadInit() {
                setTab('SpareInfo');
                loadMakeCode();
                loadUnitItem();

            }

            $('#btnSpareSave').on('click', function (e) {
               
                console.log('button clicked');
                if (requiredFields(true, 'data-submit') === true) {
                    $(this).addClass('loading');
                    saveSparePart();
                    
                }
            });

            
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
                    dataCollection[st] = $.trim(dv);
                });
                return dataCollection;
            }

            /* MODAL FUNCTIONS */
            $(document).bind('keydown', function (e) { // BIND ESCAPE TO CLOSE
                if (e.which == 27) {
                    overlay('off', '');
                }
            });
            $(".modClose").on('click', function (e) {
                overlay('off', '');
            });



            function setTab(cTab) {
                var regState = true;
                var tabID = "";
                tabID = $(cTab).data('tab') || cTab; // Checks if click or function call
                var tab;
                (tabID == "") ? tab = cTab : tab = tabID;

                $('.tTab').addClass('hidden'); // Hides all tabs
                $('#tab' + tabID).removeClass('hidden'); // Shows target tab and sets active class
                $('.cTab').removeClass('tabActive'); // Removes the tabActive class for all 
                $("#btn" + tabID).addClass('tabActive'); // Sets tabActive to clicked or active tab
                (tab == 'SpareInfo') ? regState = false : regState = true; // Check for current tab
               
            }

            $('.cTab').on('click', function (e) {
                debugger;
                setTab($(this));
            });



            $('.modClose').on('click', function () {
                $('#modNewVehicle').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                $('#btnSaveVehicle').prop('disabled', true);
            });

            

            

          

            //Autocomplete for zip codes
            $('#<%=txtCustVisitZip.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmVehicleDetail.aspx/GetZipCodes",
                        data: "{'zipCode':'" + $('#<%=txtCustVisitZip.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[3],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0],
                                    country: item.split('-')[1],
                                    state: item.split('-')[2],
                                    city: item.split('-')[3],
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error Response ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtCustVisitZip.ClientID%>").val(i.item.val);
                    $("#<%=txtCustVisitPlace.ClientID%>").val(i.item.city);
                },
            });

            $('#<%=txtCustBillZip.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmVehicleDetail.aspx/GetZipCodes",
                        data: "{'zipCode':'" + $('#<%=txtCustBillZip.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[3],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0],
                                    country: item.split('-')[1],
                                    state: item.split('-')[2],
                                    city: item.split('-')[3],
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error Response ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtCustBillZip.ClientID%>").val(i.item.val);
                    $("#<%=txtCustBillPlace.ClientID%>").val(i.item.city);
                },
            });

            $('#<%=cbCustSameAdd.ClientID%>').on('click', function () {

                if ($('#<%=cbCustSameAdd.ClientID%>').is(':checked')) {
                    $('#<%=txtCustBillAdd.ClientID%>').val($('#<%=txtCustAdd1.ClientID%>').val());
                    $('#<%=txtCustBillZip.ClientID%>').val($('#<%=txtCustVisitZip.ClientID%>').val());
                    $('#<%=txtCustBillPlace.ClientID%>').val($('#<%=txtCustVisitPlace.ClientID%>').val());

                };

            });

           

          

           

            
               
            function FetchModelId(make, model) {
                var modelId = "";

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmVehicleDetail.aspx/FetchModel",
                    data: "{'IdMake':'" + make + "','Model':'" + model + "'}",
                    //data: {},
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        modelId = data.d.toString();
                    }
                });

                return modelId;
            }

            function loadMakeCode() {
                $.ajax({
                    type: "POST",
                    url: "LocalSPDetail.aspx/LoadMakeCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpMakeCodes.ClientID%>').empty();
                        $('#<%=drpMakeCodes.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpMakeCodes.ClientID%>').append($("<option></option>").val(value.Id_Make_Veh).html(value.MakeName));

                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function loadUnitItem() {
                $.ajax({
                    type: "POST",
                    url: "LocalSPDetail.aspx/loadUnitItem",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpAdvUnitItem.ClientID%>').empty();
                        $('#<%=drpAdvUnitItem.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpAdvUnitItem.ClientID%>').append($("<option></option>").val(value.ID_UNIT_ITEM).html(value.UNIT_DESC));

                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            /* ------------------------------------------------------------------
                       SPARE PART SEARCH FUNCTIONS
                        -------------------------------------------------------------------*/
            var imake, iid, iwh;
            $('#<%=txtInfoSpareSearch.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LocalSPDetail.aspx/SparePart_Search",
                        data: "{q:'" + $('#<%=txtInfoSpareSearch.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtInfoSpareSearch.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager. Opprette ny?', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    imake = item.ID_MAKE;
                                    iid = item.ID_ITEM;
                                    iwh = '1';
                                    return {
                                        label: item.ID_MAKE + " - " + item.ID_ITEM + " " + item.ITEM_DESC + " " + item.LOCATION,
                                        val: item.ID_ITEM,
                                        value: item.ITEM_DESC
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    //window.location.replace("../master/frmCustomerDetail.aspx?cust=" + i.item.ID_ITEM);
                    FetchSparePartDetails(iid, imake, iwh);
                    $('#<%=txtInfoSpareSearch.ClientID%>').val('');
                    $('#<%=txtInfoSpareSearch.ClientID%>').focus();

                }
            });

            function FetchSparePartDetails(ID_ITEM_ID, ID_ITEM_MAKE, ID_ITEM_WH) {
                cpChange = '';
                $.ajax({
                    type: "POST",
                    url: "LocalSPDetail.aspx/FetchItemsDetail",
                    data: "{ID_ITEM_ID: '" + ID_ITEM_ID + "', ID_ITEM_MAKE: '" + ID_ITEM_MAKE +"', ID_ITEM_WH: '" + ID_ITEM_WH + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        console.log(data.d);
                            
                        $('#<%=txtSpareNo.ClientID%>').val(data.d.ID_ITEM);
                        $('#<%=txtSpareDesc.ClientID%>').val(data.d.ITEM_DESC);
                        $('#<%=drpMakeCodes.ClientID%>').val(data.d.ID_MAKE);
                        $('#<%=txtInfoSupplier.ClientID%>').val(data.d.ID_SUPPLIER_ITEM);
                        $('#<%=txtInfoSupplierName.ClientID%>').val(data.d.SUP_Name);
                        $('#<%=txtInfoNetPrice.ClientID%>').val(data.d.ID_ITEM);
                        $('#<%=txtInfoDiscountCode.ClientID%>').val(data.d.ITEM_DISC_CODE);
                        $('#<%=txtInfoLocation.ClientID%>').val(data.d.LOCATION);
                        $('#<%=txtInfoAltLocation.ClientID%>').val(data.d.ALT_LOCATION);
                        $('#<%=txtInfoAnnotation.ClientID%>').val(data.d.ANNOTATION);
                        $('#<%=txtAdvUnit.ClientID%>').val(data.d.PACKAGE_QTY);
                        $('#<%=txtInfoWeight.ClientID%>').val(data.d.WEIGHT);
                        $('#<%=txtInfoStockQuantity.ClientID%>').val(data.d.ITEM_AVAIL_QTY);
                        $('#<%=txtInfoBasisPrice.ClientID%>').val(data.d.BASIC_PRICE);
                        $('#<%=txtInfoBasisPriceNok.ClientID%>').val(data.d.BASIC_PRICE);
                        $('#<%=txtInfoLastCost.ClientID%>').val(data.d.LAST_COST_PRICE);
                        $('#<%=txtInfoLastCostNok.ClientID%>').val(data.d.LAST_COST_PRICE);
                        $('#<%=txtInfoCostPrice.ClientID%>').val(data.d.AVG_PRICE);
                        $('#<%=txtInfoCostPriceNok.ClientID%>').val(data.d.AVG_PRICE);
                        $('#<%=txtInfoNetPrice.ClientID%>').val(data.d.ID_ITEM);
                        $('#<%=txtInfoNetPriceNok.ClientID%>').val(data.d.ID_ITEM);
                        $('#<%=txtInfoSalesPrice.ClientID%>').val(data.d.ITEM_PRICE);
                        $('#<%=txtInfoSalesPriceNok.ClientID%>').val(data.d.ITEM_PRICE);
                        $('#<%=txtInfoIncludeVat.ClientID%>').val(data.d.ITEM_PRICE);
                        $('#<%=txtInfoText.ClientID%>').val(data.d.TEXT);
                        if (data.d.FLG_STOCK_ITEM === true) {
                            $("#<%=cbInfoStockControl.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoStockControl.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_OBSOLETE_SPARE === true) {
                            $("#<%=cbInfoDeadStock.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoDeadStock.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_LABELS === true) {
                            $("#<%=cbInfoEtiquette.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoEtiquette.ClientID%>").prop('checked', false);
                        }
                            
                        if (data.d.FLG_VAT_INCL === true) {
                            $("#<%=cbInfoVatIncluded.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoVatIncluded.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_BLOCK_AUTO_ORD === true) {
                            $("#<%=cbInfoAutoPurchase.ClientID%>").prop('checked', false);
                        } else {
                            $("#<%=cbInfoAutoPurchase.ClientID%>").prop('checked', true);
                        }
                        if (data.d.FLG_ALLOW_DISCOUNT === true) {
                            $("#<%=cbInfoDiscountLegal.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoDiscountLegal.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_AUTO_ARRIVAL === true) {
                            $("#<%=cbInfoAutoArrival.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoAutoArrival.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_OBTAIN_SPARE === true) {
                            $("#<%=cbInfoObtainSpare.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoObtainSpare.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_AUTOADJUST_PRICE === true) {
                            $("#<%=cbInfoAutoPriceAdjustment.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoAutoPriceAdjustment.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_REPLACEMENT_PURCHASE === true) {
                            $("#<%=cbInfoAllowPurchaseReplacments.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoAllowPurchaseReplacments.ClientID%>").prop('checked', false);
                        }
                        if (data.d.FLG_EFD === true) {
                            $("#<%=cbInfoNotEnvFee.ClientID%>").prop('checked', false);
                        } else {
                            $("#<%=cbInfoNotEnvFee.ClientID%>").prop('checked', true);
                        }
                        if (data.d.FLG_SAVE_TO_NONSTOCK === true) {
                            $("#<%=cbInfoSaveToNonstock.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbInfoSaveToNonstock.ClientID%>").prop('checked', false);
                        }
                        //ADVANCED TAB
                        $('#<%=txtAdvMinPurchase.ClientID%>').val(data.d.MIN_STOCK);
                        $('#<%=txtAdvMaxPurchase.ClientID%>').val(data.d.MAX_STOCK);
                        $('#<%=drpAdvUnitItem.ClientID%>').val(data.d.ID_UNIT_ITEM);
                        $('#<%=txtAdvLastCostBuy.ClientID%>').val(data.d.LAST_BUY_PRICE);
                        $('#<%=txtAdvLastIRDate.ClientID%>').val(data.d.DT_LAST_BUY);

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                
            };

            

            

            //autocomplete for listing of the supplier
            var imake, iid, iwh;
            $('#<%=txtInfoSupplier.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LocalSPDetail.aspx/SparePart_Search",
                        data: "{q:'" + $('#<%=txtInfoSupplier.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtInfoSupplier.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i leveradør register. Opprette ny?', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    imake = item.ID_MAKE;
                                    iid = item.ID_ITEM;
                                    iwh = '1';
                                    return {
                                        label: item.ID_MAKE + " - " + item.ID_ITEM + " " + item.ITEM_DESC + " " + item.LOCATION,
                                        val: item.ID_ITEM,
                                        value: item.ID_ITEM + " - " + item.ITEM_DESC + " " + item.ID_MAKE
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    //window.location.replace("../master/frmCustomerDetail.aspx?cust=" + i.item.ID_ITEM);
                    FetchSparePartDetails(iid, imake, iwh);
                }
            });
            

            function loadCustomerGroup() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadCustomerGroup",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpCustGroup.ClientID%>').empty();
                        $('#<%=drpCustGroup.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpCustGroup.ClientID%>').append($("<option></option>").val(value.ID_CUST_GROUP).html(value.ID_CUST_GROUP_DESC));

                             });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                     }

            function saveSparePart() {
                var spare = collectGroupData('submit');
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "LocalSPDetail.aspx/InsertSparePart",
                    //data: "{'SparePart': '" + spare.ID_ITEM + "'}",
                    data: "{SparePart:'" + spare + "'}",
                    dataType: "json",
                    //async: false,//Very important
                    success: function (data) {
                        $('.loading').removeClass('loading');
                        if (data.d[0] == "INSFLG") {
                            systemMSG('success', 'The spare part has been saved!', 4000);
                   
                            spare = data.d[1];
                            setSaveVar();
                            if (window.opener != undefined && window.opener != null && !window.opener.closed) {
                                <%--var idModel;
                                 var make = $('#<%=drpMakeCodes.ClientID%>').val();
                                 var model = $('#<%=cmbModelForm.ClientID%> :selected')[0].innerText;--%>
                               
                            }
                        }
                        else if (data.d[0] == "UPDFLG") {
                            systemMSG('success', 'Spare Part post has been updated!', 4000);
                            setSaveVar();
                        }
                        else if (data.d[0] == "ERRFLG") {
                            systemMSG('error', 'An error occured while trying to save the spare part, please check input data.', 4000);
                        }
                        
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }
           

        function setSaveVar() {
            sparevar = collectGroupData('submit');
        }
        function checkSaveVar() {
            contvar = collectGroupData('submit');
            //if (JSON.stringify(custvar) === JSON.stringify(contvar)) {
            if(objectEquals(sparevar, contvar)){
                return true;
            }
            else {
                return false;
            }
        }
        function clearSaveVar() {
            sparevar = {};
        }
           
        });
         
  
    </script>
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <div class="overlayHide">
        <asp:Label ID="RTlblError" runat="server" CssClass="lblErr" meta:resourcekey="RTlblErrorResource1"></asp:Label>
    </div>
    <div id="systemMessage" class="ui message"> </div>
    <div class="ui grid">
        <div id="tabFrame" class="sixteen wide column">
            <input type="button" id="btnSpareInfo" value="Vareinformasjon" class="cTab ui btn" data-tab="SpareInfo" />
            <input type="button" id="btnAdvanced" value="Avansert" class="cTab ui btn" data-tab="Advanced" />
            <input type="button" id="btnSpareHistory" value="Varehistorikk" class="cTab ui btn" data-tab="SpareHistory" />
            <input type="button" id="btnSpareSold" value="Vareomsetning" class="cTab ui btn" data-tab="SpareSold" />
            <input type="button" id="btnSpareImages" value="Varebilder" class="cTab ui btn" data-tab="SpareImages" />
        </div>
    </div>
    <div class="ui grid">
        <div class="sixteen wide column">
            <div class="ui form">
                <div class="fields">
                    
                    <div class="four wide field">
                        <label>
                            <asp:Label ID="lblSpareNo" Text="Varenummer" runat="server" meta:resourcekey="lblSpareNoResource1"></asp:Label></label>
                        <asp:TextBox ID="txtSpareNo" runat="server" Enabled="True" data-submit="ID_ITEM" meta:resourcekey="txtSpareNoResource1"></asp:TextBox>
                    </div>
                    <div class="four wide field">
                         <label>
                            <asp:Label ID="lblSpareDesc" Text="Betegnelse" runat="server" meta:resourcekey="lblSpareDescResource1"></asp:Label></label>
                        <asp:TextBox ID="txtSpareDesc" runat="server" data-submit="ITEM_DESC" meta:resourcekey="txtSpareDescResource1"></asp:TextBox>
                    </div>
                    <div class="two wide field">
                        <div class="four wide field">
                        <label>&nbsp;</label>
                        <div class="ui mini input">
                            <input type="button" id="btnNonStock" runat="server" class="ui btn mini" value="Non-stock" />
                        </div>
                    </div>
                    </div>

                    <div class="six wide field">
                                <label>
                                    <asp:Literal ID="liInfoSpareSearch" runat="server" Text="Search for spare part: (number, description, location etc...)"></asp:Literal>
                                </label>
                          <asp:TextBox ID="txtInfoSpareSearch" runat="server" ></asp:TextBox>
                            </div>

                    <div class="four wide field">
                    
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tabSpareInfo" class="tTab">
        <div class="ui form stackable two column grid ">
            <div class="eight wide column">
                <%--left column--%>

                <h3 id="lblVehicleModel" runat="server" class="ui top attached tiny header">Spare details:</h3>
                <div class="ui attached segment">
                    <%--vehicle model panel--%>
                    <div class="fields">
                        <div class="six wide field">
                        
                    </div>
                    <div class="six wide field">
                       
                    </div>
                    
                    </div>
                    <div class="fields">
                        <div class="four wide field">
                                <label id="lblInfoSpareGroup" runat="server">Varegruppe</label>
                                <asp:DropDownList ID="drpMakeCodes" CssClass="dropdowns" data-submit="ID_MAKE" runat="server" meta:resourcekey="drpMakeCodesResource1"></asp:DropDownList>
                            </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="Button1" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                        <div class="two wide field">
                            <label id="lblInfoSupplier" runat="server">Leverandør</label>
                            <asp:TextBox ID="txtInfoSupplier" runat="server" data-submit="ID_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="eight wide field">
                            <label>&nbsp;</label>            
                              <asp:TextBox ID="txtInfoSupplierName" runat="server" Enabled="false"></asp:TextBox>   
                            </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="Button2" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                        

                    </div>
                    <div class="fields">
                        <div class="two wide field">
                                <label id="lblInfoDiscountCode" runat="server">Rabattkode</label>
                                <asp:TextBox ID="txtInfoDiscountCode" runat="server" data-submit="ITEM_DISC_CODE_BUY" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                               
                            </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnInfoOpenDiscount" title="Open discount code list" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                        <div class="three wide field">
                                <label id="lblInfoLocation" runat="server">Lokasjon</label>
                                <asp:TextBox ID="txtInfoLocation" runat="server" data-submit="LOCATION" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>

                               
                            </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="Button4" title="Add vehicle" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                        <div class="three wide field">
                                <label id="lblInfoAltLocation" runat="server">Alt. lokasjon</label>
                                <asp:TextBox ID="txtInfoAltLocation" runat="server" data-submit="ALT_LOCATION" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="two wide field">
                                <label id="lblInfoWeight" runat="server">Vekt</label>
                                <asp:TextBox ID="txtInfoWeight" runat="server" data-submit="WEIGHT" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="two wide field">
                                <label id="lblInfoStockQuantity" runat="server">Lagerbeholdning</label>
                                <asp:TextBox ID="txtInfoStockQuantity" Enabled="false" runat="server" data-submit="ITEM_AVAIL_QTY" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                    </div>
                    <div class="fields">
                        <div class="ten wide field">
                                <label id="lblInfoAnnotation" runat="server">Anmerkninger</label>
                                <asp:TextBox ID="txtInfoAnnotation" runat="server" data-submit="ANNOTATION" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                               
                            </div> 
                        <div class="four wide field">
                                <label id="lblInfoRefund" runat="server">Pant nr.</label>
                                <asp:TextBox ID="txtInfoRefund" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div> 
                    </div>
                </div>
                
                <%--end vehicle model panel--%>

                <h3 id="lblVehicleInformation" runat="server" class="ui top attached tiny header">Replacements:</h3>
                <div class="ui attached segment">
                    <%--vehicle info panel--%>
                    <div class="fields">
                        <div class="six wide field">
                                <label id="lblInfoReplEarlierNo" runat="server">Earlier no.</label>
                                <asp:TextBox ID="txtInfoReplEarlierNo" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                               
                            </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnInfoReplEarlierNo" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                        <div class="six wide field">
                            <label id="lblInfoReplacementNo" runat="server">Replacement no.</label>
                            <asp:TextBox ID="txtInfoReplacementNo" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnInfoReplacementNo" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                         <div class="two wide field">
                             </div>

                    </div>
                    <div class="fields">
                        <%--har bruklt drop down fra ddlvehiclestatus fra frmvehicledetails--%>
                        <select id="ddlInfoReplacementList" runat="server" size="5" class="wide dropdownList"></select>
                    </div>
                </div>
                <%--end vehicle info panel--%>

                <%--end vehicle details panel--%>
            </div>
            <%--end left column--%>
            <div class="six wide column">
                <%--right column--%>
              
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Price details:</h3>
                    <div class="ui mini attached segment">
                         <div class="inline fields">
                            <%--Basis price /Veiledende pris--%>
                            <div class="four wide field">
                                
                            </div>
                            <div class="four wide field">
                               
                            </div>
                            <div class="four wide field">
                               <label>
                                    <asp:Label ID="lblInfoNOK" runat="server" Text="Nkr."></asp:Label>
                                </label>
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Basis price /Veiledende pris--%>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblInfoBasisPrice" runat="server"  Text="Basis price"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtInfoBasisPrice" Enabled="false" runat="server"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtInfoBasisPriceNok" runat="server" data-submit="BASIC_PRICE"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Last cost price/ siste kostpris--%>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblInfoLastCost" runat="server" Text="Last cost price"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtInfoLastCost" Enabled="false" runat="server" ></asp:TextBox>
                            </div>
                            <div class="four wide field">
                              <asp:TextBox ID="txtInfoLastCostNok" runat="server" data-submit="COST_PRICE1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Cost price/ kostpris--%>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblInfoCostPrice" runat="server" Text="Cost price"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtInfoCostPrice" Enabled="false" runat="server" ></asp:TextBox>
                            </div>
                            <div class="four wide field">
                              <asp:TextBox ID="txtInfoCostPriceNok" runat="server" data-submit="AVG_PRICE"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Net price/ nettopris--%>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblInfoNetPrice" runat="server" Text="Net price"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtInfoNetPrice" Enabled="false" runat="server" ></asp:TextBox>
                            </div>
                            <div class="four wide field">
                              <asp:TextBox ID="txtInfoNetPriceNok" runat="server" data-submit="COST_PRICE2"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                
                            </div>
                        </div>
                        <h3 class="ui dividing header">
                        </h3>
                        <div class="inline fields">
                            <%--Sales price/ salgspris--%>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblInfoSalesPrice" runat="server" Text="Sales price"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtInfoSalesPrice" Enabled="false" runat="server" ></asp:TextBox>
                            </div>
                            <div class="four wide field">
                              <asp:TextBox ID="txtInfoSalesPriceNok" runat="server" data-submit="ITEM_PRICE"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Sales price/ salgspris--%>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblInfoIncludeVat" runat="server" Text="Included VAT"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                               
                            </div>
                            <div class="four wide field">
                              <asp:TextBox ID="txtInfoIncludeVat" runat="server"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                
                            </div>
                        </div>
                    </div>
                </div>
                <h3 id="lblInfoParameters" runat="server" class="ui top attached tiny header">Parameters:</h3>
                 <div class="ui attached segment">
                <div class="fields">
                        <div class="four wide column">
                            <label>
                                <asp:CheckBox ID="cbInfoStockControl" runat="server" Width="200%" Text="Stock quantity control" data-submit="FLG_STOCKITEM" meta:resourcekey="cbSummerwheelsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbInfoDeadStock" runat="server" Width="200%" Text="Dead stock" data-submit="FLG_OBSOLETE_SPARE" meta:resourcekey="cbWinterwheelsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbInfoSaveToNonstock" runat="server" Width="200%" Text="Reg. på non-stock" data-submit="FLG_SAVE_TO_NONSTOCK" meta:resourcekey="cbWinterwheelsResource1" />
                            </label>
                            <div class="inline fields">
                            <div class="eight wide column">
                                <label>
                                    <asp:CheckBox ID="cbInfoEtiquette" runat="server" Width="200%" Text="Etiquette" data-submit="FLG_LABELS" meta:resourcekey="cbXenonResource1" />
                                </label>
                            </div>
                            <div class="eight wide column">
                                <input type="button" id="btnInfoPrintEtiquette" title="Print Etiquette for the chosen spare part" runat="server" class="ui btn mini" value="Print" />
                            </div>
                        </div>
                             
                    </div>

                    <div class="four wide column">
                            <label>
                                <asp:CheckBox ID="cbInfoVatIncluded" runat="server" Width="200%" Text="Vat included" data-submit="FLG_VAT_INCL" meta:resourcekey="cbServoResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbInfoAutoPurchase" runat="server" Width="200%" Text="Auto. purchase" data-submit="FLG_BLOCK_AUTO_ORD" meta:resourcekey="cbAirbagfrontResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbInfoDiscountLegal" runat="server" Width="200%" Text="Discount legal" data-submit="FLG_ALLOW_DISCOUNT" meta:resourcekey="cbAirbagsideResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbInfoAutoArrival" runat="server" Width="200%" Text="Auto. arrival" data-submit="FLG_AUTO_ARRIVAL" meta:resourcekey="cbSkylightResource1" />
                            </label>
                            
                        </div>
                    <div class="four wide column">
                            <label>
                                <asp:CheckBox ID="cbInfoObtainSpare" runat="server" Width="200%" Text="Skaffevare" data-submit="FLG_OBTAIN_SPARE" meta:resourcekey="cbABSbrakesResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbInfoAutoPriceAdjustment" runat="server" Width="200%" Text="Price adjustment" data-submit="FLG_AUTOADJUST_PRICE" meta:resourcekey="cbTractionResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbInfoAllowPurchaseReplacments" runat="server" Width="200%" Text="Allow purchase of replacements" data-submit="FLG_REPLACEMENT_PURCHASE" meta:resourcekey="cbAntiskidResource1" />
                            </label>
                        <label>
                                <asp:CheckBox ID="cbInfoNotEnvFee" runat="server" Width="200%" Text="Ikke miljøavgift" data-submit="FLG_EFD" meta:resourcekey="cbABSbrakesResource1" />
                            </label>
                          <div class="inline fields">
                            <div class="twelve wide column">
                              <asp:Literal ID="liInfoDiscountPercentage" Text="Discount %" runat="server"></asp:Literal>
                                </div>
                              <div class="four wide column">
                               <asp:TextBox ID="txtInfoDiscountPercentage" runat="server" data-submit="DISCOUNT"></asp:TextBox>
                                  </div>
                            </div>
                        
                    </div>

                </div>
            </div>
                <h3 id="H2" runat="server" class="ui top attached tiny header">Text:</h3>
                 <div class="ui attached segment">
                <div class="fields">
                    <asp:TextBox runat="server" ID="txtInfoText" TextMode="MultiLine" Rows="5" data-submit="TEXT" meta:resourcekey="txtPracticalLoadResource1"></asp:TextBox>
                </div>
            </div>
            </div>
        </div>
    </div>


    <%--End tab spareinfo--%>

    <%-- makeEdit Modal --%>
    <div id="modEditMake" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblEditMake" runat="server"></h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Nytt kjøretøy</label>
                    <div class="ui small info message">
                        <p id="lblEditMakeStatus" runat="server">Bilmerke status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="Label4" runat="server">Bilmerkeliste</label>
                                <select id="drpEditMakeList" runat="server" size="13" class="wide dropdownList"></select>
                                
                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeCode" Text="Fabrikatkode" runat="server" meta:resourcekey="lblEditMakeCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeCode" runat="server" meta:resourcekey="txtEditMakeCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeDescription" Text="Beskrivelse" runat="server" meta:resourcekey="lblEditMakeDescriptionResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeDescription" runat="server" meta:resourcekey="txtEditMakeDescriptionResource1"></asp:TextBox>
                                </div>
                                <div class="hidden">
				<div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakePriceCode" Text="Priskode" runat="server" meta:resourcekey="lblEditMakePriceCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakePriceCode" runat="server" meta:resourcekey="txtEditMakePriceCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeDiscount" Text="Rabatt" runat="server" meta:resourcekey="lblEditMakeDiscountResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeDiscount" runat="server" meta:resourcekey="txtEditMakeDiscountResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeVat" Text="Mva kode" runat="server" meta:resourcekey="lblEditMakeVatResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeVat" runat="server" meta:resourcekey="txtEditMakeVatResource1"></asp:TextBox>
                                </div>
                                </div>
                                <div class="two fields">
                                    <div class="field">
                                        <input type="button" id="btnEditMakeNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnEditMakeDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                                <div class="fields">
                                    &nbsp;    
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnEditMakeSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnEditMakeCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modGeneralAnnotation" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation</h2>
            <div class="modCloseGeneralAnnotation"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3 id="lblModAnnotation" runat="server">Annotation:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtGeneralAnnotation" TextMode="MultiLine" runat="server" meta:resourcekey="txtGeneralAnnotationResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveGeneralAnnotation" runat="server" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modGeneralNote" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblModNote" runat="server">Annotation</h2>
            <div class="modCloseGeneralNote"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Note</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtGeneralNote" TextMode="MultiLine" runat="server" meta:resourcekey="txtGeneralNoteResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" runat="server" id="btnSaveGeneralNote" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <%-- New tab for Tecnical --%>
    <div id="tabAdvanced" class="tTab">
       <div class="ui form stackable two column grid ">
            <div class="eight wide column">
                <%--left column--%>

                <h3 id="H3" runat="server" class="ui top attached tiny header">Advanced:</h3>
                <div class="ui attached segment">
                    <%--vehicle model panel--%>
                    <div class="fields">
                        <div class="six wide field">
                        
                    </div>
                    <div class="six wide field">
                       
                    </div>
                    
                    </div>
                    <div class="fields">
                        <div class="two wide field">
                                <label id="lblAdvSalesCode" runat="server">Omsetningskode</label>
                               <asp:TextBox ID="txtAdvSalesCode" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnAdvSalesCode" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                        <div class="two wide field">
                            <label id="lblAdvFrequenceCode" runat="server">Frekvenskode</label>
                            <asp:TextBox ID="txtAdvFrequenceCode" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnAdvFrequenceCode" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                    <div class="two wide field">
                            <label id="lblAdvReplacementCode" runat="server">Erstatningskode</label>
                            <asp:TextBox ID="txtAdvReplacementCode" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnAdvReplacementCode" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                         <div class="two wide field">
                            <label id="lblAdvCategory" runat="server">Kategori</label>
                            <asp:TextBox ID="txtAdvCategory" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>

                    </div>
                    <div class="fields">
                        <div class="two wide field">
                                <label id="lblAdvUnit" runat="server">Enhet</label>
                               <asp:TextBox ID="txtAdvUnit" runat="server" data-submit="PACKAGE_QTY" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="one wide field">
                           
                            </div>
                        <div class="two wide field">
                            <label id="lblAdvUnitDesc" runat="server">Enhet</label>
                           <asp:DropDownList ID="drpAdvUnitItem" CssClass="dropdowns" data-submit="ID_UNIT_ITEM" runat="server" meta:resourcekey="drpMakeCodesResource1"></asp:DropDownList>
                        </div>
                        <div class="one wide field">
                           
                            </div>
                        <div class="two wide field">
                            <label id="lblAdvWarehouse" runat="server">Lager</label>
                            <asp:TextBox ID="txtAdvWarehouse" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="one wide field">

                            </div>
                         <div class="two wide field">
                            <label id="lblAdvMaxSale" runat="server">Maks. salg</label>
                            <asp:TextBox ID="txtAdvMaxSale" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="eight wide field">
                                <label id="lblAdvBarcodeNo" runat="server">Strekkode nr.</label>
                                <asp:TextBox ID="txtAdvBarcodeNo" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                               
                            </div> 
                        <div class="seven wide field">
                                <label id="lblAdvSpareSubNo" runat="server">Vare subnr.</label>
                                <asp:TextBox ID="txtAdvSpareSubNo" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div> 
                        <div class="one wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnAdvSpareSubNo" runat="server" data-submit="ENV_ID_ITEM" class="ui btn mini" value=" + " />
                        </div>
                            </div>
                    </div>
                </div>
                
                <%--end vehicle model panel--%>

                <h3 id="H4" runat="server" class="ui top attached tiny header">Vare struktur / Cross liste:</h3>
                <div class="ui attached segment">
                    <%--vehicle info panel--%>
                    <div class="fields">
                        <%--har bruklt drop down fra ddlvehiclestatus fra frmvehicledetails--%>
                        <select id="drpAdvSpareStructure" runat="server" size="5" class="wide dropdownList">
                            <option>Tecdoc - spare name - Spare desc - Text - Quantity - Amount</option>
                        </select>
                        
                    </div>
                </div>
                <%--end vehicle info panel--%>

                <%--end vehicle details panel--%>
            </div>
            <%--end left column--%>
            <div class="six wide column">
                <%--right column--%>
              
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Bestillingsparametre:</h3>
                    <div class="ui mini attached segment">
                         <div class="inline fields">
                            <%--Basis price /Veiledende pris--%>
                            <div class="four wide field">
                                 <label>
                                    <asp:Label ID="lblAdvMinQty" runat="server" Text="Min. quantity"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtAdvMinQty" Text="0" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                               <label>
                                    <asp:Label ID="lblAdvBudgetConsumption" runat="server" Text="Budget consumption"></asp:Label>
                                </label>
                            </div>
                             <div class="four wide field">
                                  <asp:TextBox ID="txtAdvBudgetConsumptions" Text="0" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Basis price /Veiledende pris--%>
                            <div class="four wide field">
                                 <label>
                                    <asp:Label ID="lblAdvMinPurchase" runat="server"  Text="Min. purchase"></asp:Label>
                                </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtAdvMinPurchase" Text="0" runat="server" data-submit="MIN_STOCK" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                               <label>
                                    <asp:Label ID="lblAdvMaxPurchase" runat="server" Text="Max. purchase"></asp:Label>
                                </label>
                            </div>
                             <div class="four wide field">
                                  <asp:TextBox ID="txtAdvMaxPurchase" Text="0" runat="server" data-submit="MAX_STOCK" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <h3 id="H5" runat="server" class="ui top attached tiny header">In purchase order:</h3>
                 <div class="ui attached segment">
                    <div class="fields">
                        <div class="two wide field">
                                <label id="lblAdvQtyInPurchase" runat="server">Quantity</label>
                               <asp:TextBox ID="txtAdvQtyInPurchase" Text="0" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="four wide field">
                            <label id="lblAdvPurchaseDate" runat="server">Purchase date</label>
                            <asp:TextBox ID="txtAdvPurchaseDate" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                    <div class="four wide field">
                            <label id="lblAdvPurchaseNo" runat="server">Purchase no.</label>
                            <asp:TextBox ID="txtAdvPurchaseNo" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="two wide field">
                            <label>&nbsp;</label>
                               <div class="ui mini input">
                                <input type="button" id="btnAdvPurchaseNo" title="Go to inward register" runat="server" class="ui btn mini" value=" + " />
                        </div>
                            </div>

                         <div class="four wide field">
                            <label id="lblAdvArrivalDate" runat="server">Arrival date</label>
                            <asp:TextBox ID="txtAdvArrivalDate" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>

                    </div>
                     <div class="inline fields">
                            <%--Basis price /Veiledende pris--%>
                            <div class="three wide field">
                                 <label>
                                    <asp:Label ID="lblAdvLabeled" runat="server" Text="Labeled:"></asp:Label>
                                </label>
                            </div>
                            <div class="ten wide field">
                                <asp:TextBox ID="txtAdvLabeled" Text="" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <input type="button" id="btnAdvGeneratePurchaseOrder" title="Generate Purchase order" runat="server" class="ui btn mini" value="Generate" />
                        </div>
                    </div>
            </div>
                <h3 id="H6" runat="server" class="ui top attached tiny header">Last inward register:</h3>
                 <div class="ui attached segment">
                    <div class= "fields">
                        <div class="four wide field">
                                <label id="lblAdvLastIRQty" runat="server">Quantity</label>
                               <asp:TextBox ID="txtAdvLastIRQty" Text="0" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="four wide field">
                            <label id="lblAdbLastIRDate" runat="server">IR date</label>
                            <asp:TextBox ID="txtAdvLastIRDate" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                    <div class="four wide field">
                            <label id="lblAdvLastIRNo" runat="server">IR Number</label>
                            <asp:TextBox ID="txtAdvLastIRNo" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="four wide field">
                             <label id="lblAdvLastCostBuy" runat="server">Last Cost Price</label>
                            <asp:TextBox ID="txtAdvLastCostBuy" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                    </div>
            </div>
                 <h3 id="H7" runat="server" class="ui top attached tiny header">Last values:</h3>
                 <div class="ui attached segment">
                    <div class="fields">
                        <div class="four wide field">
                                <label id="lblAdvLastCountingDate" runat="server">Last counting date</label>
                               <asp:TextBox ID="txtAdvLastCountingDate" Text="" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="three wide field">
                            <label id="lblAdvCountingSignature" runat="server">Signature</label>
                            <asp:TextBox ID="txtAdvCountingSignature" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                    <div class="ten wide field">
                            <label id="lblAdvSignatureName" runat="server">Name</label>
                            <asp:TextBox ID="txtAdvSignatureName" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>

                    </div>
                    <div class="fields">
                        <div class="four wide field">
                                <label id="lblAdvLastSoldDate" runat="server">Last sold date</label>
                               <asp:TextBox ID="txtAdvLastSoldDate" Text="" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>
                        <div class="four wide field">
                            <label id="lblAdvLastBODate" runat="server">Last BO date</label>
                            <asp:TextBox ID="txtAdvLastBODate" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                    <div class="two wide field">
                            <label id="lblAdvQtySold" runat="server">Quantity</label>
                            <asp:TextBox ID="txtAdvQtySold" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="two wide field">
                            <label id="lblAdvQtyBO" runat="server">No. of BO</label>
                            <asp:TextBox ID="txtAdvQtyBO" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="threea wide field">
                            <label id="lblAdvQtyOffered" runat="server">Qty. offered</label>
                            <asp:TextBox ID="txtAdvQtyOffered" Text="0" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                    </div>
            </div>
            </div>
        </div>
            
    </div>

    <%-- New tab for Economy --%>
    <div id="tabSpareHistory" class="tTab">
        <div class="ui grid">

            <div class="two wide column">
                <div class="ui form">
                    <h3 id="lblContribution" class="ui top attached tiny header" runat="server">Bidrag:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesPriceExVat" runat="server">Salgspris eks. mva</label>
                                <asp:TextBox ID="txtEcoSalespriceNet" runat="server" meta:resourcekey="txtEcoSalespriceNetResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesFees" runat="server">Salgs salær</label>
                                <asp:TextBox ID="txtEcoSalesSale" runat="server" meta:resourcekey="txtEcoSalesSaleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesEquipment" runat="server">Sale equipment</label>
                                <asp:TextBox ID="txtEcoSalesEquipment" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoSalesEquipmentResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblRegistrationCosts" runat="server">Reg omkostninger</label>
                                <asp:TextBox ID="txtEcoRegCost" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoRegCostResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSubtractedDiscount" runat="server">- Rabatt</label>
                                <asp:TextBox ID="txtEcoDiscount" runat="server" meta:resourcekey="txtEcoDiscountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesPriceNet" runat="server">Netto Salgspris</label>
                                <asp:TextBox ID="txtEcoNetSalesPrice" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoNetSalesPriceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSubtractedCosts" runat="server">- Selvkost</label>
                                <asp:TextBox ID="txtEcoFixCost" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoFixCostResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblAssistSales" runat="server">Bidrag ved salg</label>
                                <asp:TextBox ID="txtEcoAssistSales" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoAssistSalesResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostAfterSale" runat="server">Cost after sale</label>
                                <asp:TextBox ID="txtEcoCostAfterSale" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoCostAfterSaleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblContributionToday" runat="server">Contributions today</label>
                                <asp:TextBox ID="txtEcoContributionsToday" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoContributionsTodayResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="two wide column">
                <div class="ui form">
                    <h3 id="lblVehiclePrice" class="ui top attached tiny header" runat="server">Bilpris:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesPriceGross" runat="server">Salgspris inkl. mva</label>
                                <asp:TextBox ID="txtEcoSalesPriceGross" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoSalesPriceGrossResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblRegistrationFee" runat="server">Reg. avgift</label>
                                <asp:TextBox ID="txtEcoRegFee" runat="server" meta:resourcekey="txtEcoRegFeeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblVatFromSalesprice" runat="server">MVA av salgspris</label>
                                <asp:TextBox ID="txtEcoVat" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoVatResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblTotalVehicleAmount" runat="server">Total bilpris</label>
                                <asp:TextBox ID="txtEcoVehTotAmount" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoVehTotAmountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblEquipmentAmount" runat="server">Bidrag utstyr</label>
                                <asp:TextBox ID="txtEcoEquipmentAmount" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoEquipmentAmountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWreckingAmount" runat="server">Vrakpant</label>
                                <asp:TextBox ID="txtEcoWreckingAmount" runat="server" meta:resourcekey="txtEcoWreckingAmountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblYearlyFee" runat="server">Årsavgift</label>
                                <asp:TextBox ID="txtEcoYearlyFee" runat="server" meta:resourcekey="txtEcoYearlyFeeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblInsurance" runat="server">Forsikring</label>
                                <asp:TextBox ID="txtEcoInsurance" runat="server" meta:resourcekey="txtEcoInsuranceResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="two wide column">
                <div class="ui form">
                    <h3 id="lblCosts" class="ui top attached tiny header" runat="server">Selvkost:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostPriceNet" runat="server">Inntakspris eks. mva</label>
                                <asp:TextBox ID="txtEcoCostPriceNet" runat="server" meta:resourcekey="txtEcoCostPriceNetResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblInsuranceBonus" runat="server">Oppnådd bonus</label>
                                <asp:TextBox ID="txtEcoInsuranceBonus" runat="server" meta:resourcekey="txtEcoInsuranceBonusResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostFee" runat="server">Inntaks salær</label>
                                <asp:TextBox ID="txtEcoInntakeSaler" runat="server" meta:resourcekey="txtEcoInntakeSalerResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostBeforeSale" runat="server">Påkost før salg</label>
                                <asp:TextBox ID="txtEcoCostBeforeSale" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoCostBeforeSaleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesProvision" runat="server">Selger provisjon</label>
                                <asp:TextBox ID="txtEcoSalesProvision" runat="server" meta:resourcekey="txtEcoSalesProvisionResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCommitDay" runat="server">Kommisjonsdager</label>
                                <asp:TextBox ID="txtEcoCommitDay" runat="server" meta:resourcekey="txtEcoCommitDayResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblAddedInterests" runat="server">Påløpte renter</label>
                                <asp:TextBox ID="txtEcoAddedInterests" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoAddedInterestsResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostEquipment" runat="server">Kost utstyr</label>
                                <asp:TextBox ID="txtEcoCostEquipment" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoCostEquipmentResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblTotalCost" runat="server">Selvkost</label>
                                <asp:TextBox ID="txtEcoTotalCost" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoTotalCostResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="ui grid">
            <div class="four wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Credit note/ taken in:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="six wide field">
                                <label>Credit note No</label>
                                <asp:TextBox ID="txtEcoCreditNote" runat="server" meta:resourcekey="txtEcoCreditNoteResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <input type="button" id="btnEcoShowCreditNote" class="ui btn" value="Vis" />
                            </div>
                            <div class="six wide field">
                                <label>Credit note date</label>
                                <asp:TextBox ID="txtEcoCreditDate" runat="server" meta:resourcekey="txtEcoCreditDateResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="four wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Invoice/ Sale:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="six wide field">
                                <label>Invoice No</label>
                                <asp:TextBox ID="txtEcoInvoiceNo" runat="server" meta:resourcekey="txtEcoInvoiceNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <input type="button" id="btnEcoShowInvoice" class="ui btn" value="Vis" />
                            </div>
                            <div class="six wide field">
                                <label>Credit note date</label>
                                <asp:TextBox ID="txtEcoInvoiceDate" runat="server" meta:resourcekey="txtEcoInvoiceDateResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="two wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Rebuy:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="twelve wide field">
                                <label>Date</label>
                                <asp:TextBox ID="txtEcoRebuy" runat="server" meta:resourcekey="txtEcoRebuyResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="six wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Turnover:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <label>Rebuy price</label>
                                <asp:TextBox ID="txtEcoRebuyPrice" runat="server" meta:resourcekey="txtEcoRebuyPriceResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Cost pr km.</label>
                                <asp:TextBox ID="txtEcoCostKm" runat="server" meta:resourcekey="txtEcoCostKmResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Turnover</label>
                                <asp:TextBox ID="txtEcoTurnover" runat="server" meta:resourcekey="txtEcoTurnoverResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Progress/Drift</label>
                                <asp:TextBox ID="txtEcoProgress" runat="server" meta:resourcekey="txtEcoProgressResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modNewCust" class="modal hidden">
        <div class="modHeader">
            <h2 id="H1" runat="server">New Customer</h2>
            <div class="modCloseCust"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <%-- <div class="ui form">
                    <div class="field">
                        <label class="sr-only">Nytt kjøretøy</label>
                        <div class="ui small info message">
                            <p id="P1" runat="server">Velg bilstatus før du går videre</p>
                        </div>
                    </div>
                </div>--%>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form ">
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="Label1" Text="Søk etter kunde (Tlf, navn, sted, etc.)" runat="server" meta:resourcekey="Label1Resource1"></asp:Label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <asp:TextBox ID="txtEniro" runat="server" meta:resourcekey="txtEniroResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnEniroFetch" runat="server" class="ui mini icon input" value="Fetch" style="width: 50%" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <label id="Label3" runat="server">Customer</label>
                                <select id="CustSelect" runat="server" size="13" class="wide dropdownList">
                                </select>

                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--TABCUSTOMER--%>
    <div id="tabSpareSold" class="tTab">
        <div class="ui grid">
            <div class="eleven wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Søk etter kunde:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <label>Customer No</label>
                                <asp:TextBox ID="txtCustNo" runat="server"  meta:resourcekey="txtCustNoResource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                                <label>Søk etter kunde (Tlf, navn, sted, etc.)</label>
                                <asp:TextBox ID="txtCustSearchEniro" runat="server" meta:resourcekey="txtCustSearchEniroResource1"></asp:TextBox>
                                <asp:Label ID="lblContactResults" runat="server" CssClass="lblContactResults" meta:resourcekey="lblContactResultsResource1"></asp:Label>
                            </div>
                            <div class="one wide field">
                                <label>EniroId</label>
                                <asp:Label ID="lblCustEniroId" runat="server"  meta:resourcekey="lblCustEniroIdResource1"></asp:Label>
                            </div>
                            <div class="three wide field">
                                <label>&nbsp;</label>
                                <div class="ui mini icon input">
                                    <%--<asp:Button runat="server" Text="Fetch" ID="btnSearchEniro" CssClass="ui btn" />--%>
                                    <input type="button" id="btnSearchEniro" runat="server" value="Fetch" class="ui btn mini" />

                                </div>

                            </div>

                        </div>
                    </div>

                    <h3 class="ui top attached tiny header">Customer information:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <label>First Name</label>
                                <asp:TextBox ID="txtCustFirstName" runat="server"  meta:resourcekey="txtCustFirstNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Middle Name</label>
                                <asp:TextBox ID="txtCustMiddleName" runat="server" meta:resourcekey="txtCustMiddleNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Last Name</label>
                                <asp:TextBox ID="txtCustLastName" runat="server"  meta:resourcekey="txtCustLastNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <div class="ui mini icon input">
                                    <input type="button" id="btnWarningMSG" class="ui btn" value="Anmerkninger?" />
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="six wide field">
                                <label>Visiting Address</label>
                                <asp:TextBox ID="txtCustAdd1" runat="server" meta:resourcekey="txtCustAdd1Resource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label>Zip code</label>
                                <asp:TextBox ID="txtCustVisitZip" runat="server"  meta:resourcekey="txtCustVisitZipResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Place</label>
                                <asp:TextBox ID="txtCustVisitPlace" runat="server" meta:resourcekey="txtCustVisitPlaceResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="six wide field">
                                <label>
                                    Billing Address (Same as above?
                                                <input type="checkbox" id="cbCustSameAdd" runat="server" />)</label>
                                <asp:TextBox ID="txtCustBillAdd" runat="server"  meta:resourcekey="txtCustBillAddResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label>Zip code</label>
                                <asp:TextBox ID="txtCustBillZip" runat="server"  meta:resourcekey="txtCustBillZipResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Place</label>
                                <asp:TextBox ID="txtCustBillPlace" runat="server" meta:resourcekey="txtCustBillPlaceResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="three wide field">
                                <label>Phone1</label>
                                <asp:TextBox ID="txtCustPhone" runat="server" meta:resourcekey="txtCustPhoneResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Phone2</label>
                                <asp:TextBox ID="txtCustPhone2" runat="server" meta:resourcekey="txtCustPhone2Resource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                                <label>Mail</label>
                                <asp:TextBox ID="txtCustMail" runat="server" meta:resourcekey="txtCustMailResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <div class="ui mini icon input">
                                    <input type="button" id="btnCustMail" runat="server" class="ui btn" value="Lagre kunde" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Previous information:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="six wide field">
                                <label>Previous owner</label>
                                <asp:TextBox ID="txtCustPrevOwner" runat="server" meta:resourcekey="txtCustPrevOwnerResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Selger inn</label>
                                <asp:TextBox ID="txtCustSalesmanIn" runat="server" meta:resourcekey="txtCustSalesmanInResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Selger ut</label>
                                <asp:TextBox ID="txtCustSalesmanOut" runat="server" meta:resourcekey="txtCustSalesmanOutResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Mechanic</label>
                                <asp:TextBox ID="txtCustMechanic" runat="server" meta:resourcekey="txtCustMechanicResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="five wide column">
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Betalingsdetaljer:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="eight wide field">
                                <label>Customer Group:</label>
                                <div class="ui mini icon input">
                                    <asp:DropDownList ID="drpCustGroup" CssClass="dropdowns" runat="server" meta:resourcekey="drpCustGroupResource1"></asp:DropDownList>
                                    <select id="ddlCustGrp" class="dropdowns">
                                        <option value="0">Kontantkunde</option>
                                        <option value="1">10 dager kreditt</option>
                                        <option value="2">30 dager kreditt</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label>Fødselsdato:</label>
                                <asp:TextBox ID="txtCustPersonNo" runat="server" meta:resourcekey="txtCustPersonNoResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label>Foretaksnr:</label>
                                <asp:TextBox ID="txtCustOrgNo" runat="server" meta:resourcekey="txtCustOrgNoResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="six wide field">
                                <label>Debt</label>
                                <asp:TextBox ID="txtCustDebt" runat="server" meta:resourcekey="txtCustDebtResource1"></asp:TextBox>
                            </div>
                            <div class="ten wide field">
                                <label>Creditor</label>
                                <asp:TextBox ID="txtCustCreditor" runat="server" meta:resourcekey="txtCustCreditorResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="ten wide field">
                                <label>Insurance name</label>
                                <asp:TextBox ID="txtCustInsurance" runat="server" meta:resourcekey="txtCustInsuranceResource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                            </div>
                        </div>
                    </div>
                </div>
                <br />
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Serviceavtale:
                        <input type="checkbox" id="cbServiceDeal" runat="server" style="width: 20px; height: 20px;" /></h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="five wide field">
                                <label>To date</label>
                                <asp:TextBox ID="txtCustToDate" runat="server" meta:resourcekey="txtCustToDateResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label>DealNo</label>
                                <asp:TextBox ID="txtCustDealNo" runat="server" meta:resourcekey="txtCustDealNoResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label>Period</label>
                                <asp:TextBox ID="txtCustServicePeriod" runat="server" meta:resourcekey="txtCustServicePeriodResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="five wide field">
                                <label>Price ex. Vat</label>
                                <asp:TextBox ID="txtCustServiceNetPrice" runat="server" meta:resourcekey="txtCustServiceNetPriceResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label>Yearly milage</label>
                                <asp:TextBox ID="txtCustServiceMileage" runat="server" meta:resourcekey="txtCustServiceMileageResource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tabSpareImages" class="tTab">
        <br />
        <h3 class="ui top attached tiny header">Bilopplysninger:</h3>
        <div class="ui attached segment">
            <div class="ui grid">
                <div class="four wide column">
                    <div class="ui form">

                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMake" runat="server">Merke</label>
                                <asp:TextBox ID="txtWebMake" runat="server" meta:resourcekey="txtWebMakeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebModel" runat="server">Modell</label>
                                <asp:TextBox ID="txtWebModel" runat="server" meta:resourcekey="txtWebModelResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebDescription" runat="server">Description</label>
                                <asp:TextBox ID="txtWebDesc" runat="server" meta:resourcekey="txtWebDescResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebGearbox" runat="server">Girkasse</label>
                                <asp:TextBox ID="txtWebGearBox" runat="server" meta:resourcekey="txtWebGearBoxResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebGearboxDescription" runat="server">Gir betegnelse</label>
                                <asp:TextBox ID="txtWebGearDesc" runat="server" meta:resourcekey="txtWebGearDescResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebTraction" runat="server">Hjuldrift</label>
                                <asp:TextBox ID="txtWebTraction" runat="server" meta:resourcekey="txtWebTractionResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebTractionDescription" runat="server">Hjulbeskrivelse</label>
                                <asp:TextBox ID="txtWebTractionDesc" runat="server" meta:resourcekey="txtWebTractionDescResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="two wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebModelYear" runat="server">Årsmodell</label>
                                <asp:TextBox ID="txtWebModelYear" runat="server" meta:resourcekey="txtWebModelYearResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebPrice" runat="server">Prisantydning</label>
                                <asp:TextBox ID="txtWebVehiclePrice" runat="server" meta:resourcekey="txtWebVehiclePriceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMileage" runat="server">Kilometerstand</label>
                                <asp:TextBox ID="txtWebMileage" runat="server" meta:resourcekey="txtWebMileageResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebFuel" runat="server">Drivstoff</label>
                                <asp:TextBox ID="txtWebFuelType" runat="server" meta:resourcekey="txtWebFuelTypeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebEffectBHP" runat="server">Effekt HK</label>
                                <asp:TextBox ID="txtWebBHP" runat="server" meta:resourcekey="txtWebBHPResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebCylinderLitres" runat="server">Sylinder ltr.</label>
                                <asp:TextBox ID="txtWebCylinderLtrs" runat="server" meta:resourcekey="txtWebCylinderLtrsResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="two wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebAsShown" runat="server" Text="As shown" meta:resourcekey="cbWebAsShownResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebInclYearlyFee" runat="server" Text="Incl. yearly fee" meta:resourcekey="cbWebInclYearlyFeeResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebinclRegFee" runat="server" Text="Incl. reg. fee" meta:resourcekey="cbWebinclRegFeeResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebInclRegCosts" runat="server" Text="Incl. Reg. costs" meta:resourcekey="cbWebInclRegCostsResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                &nbsp; 
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <input type="button" id="btnEquipment" runat="server" class="ui btn wide" value="Utstyr" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                &nbsp;  
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <input type="button" id="btnPublish" runat="server" class="ui btn wide" value="Publiser" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                &nbsp;  
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebPublish" runat="server" Text="Publish" meta:resourcekey="cbWebPublishResource1" />
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="four wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMainColor" runat="server">Hovedfarge</label>
                                <asp:TextBox ID="txtWebMainColor" runat="server" meta:resourcekey="txtWebMainColorResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebColorDescription" runat="server">Farge beskr.</label>
                                <asp:TextBox ID="txtWebColorDesc" runat="server" meta:resourcekey="txtWebColorDescResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebInteriorColor" runat="server">Interiør farge</label>
                                <asp:TextBox ID="txtWebInteriorColor" runat="server" meta:resourcekey="txtWebInteriorColorResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebChassi" runat="server">Karosseri</label>
                                <asp:TextBox ID="txtWebChassi" runat="server" meta:resourcekey="txtWebChassiResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblWebFirstTimeReg" runat="server">1. gang reg.</label>
                                <asp:TextBox ID="txtWebRegDate" runat="server" meta:resourcekey="txtWebRegDateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblWebRegno" runat="server">Regnr</label>
                                <asp:TextBox ID="txtWebRegNo" runat="server" meta:resourcekey="txtWebRegNoResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="five wide field">
                                <label id="lblWebDoorQty" runat="server">Antall dører</label>
                                <asp:TextBox ID="txtWebDoorQty" runat="server" meta:resourcekey="txtWebDoorQtyResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblWebSeatQty" runat="server">Antall seter</label>
                                <asp:TextBox ID="txtWebSeatQty" runat="server" meta:resourcekey="txtWebSeatQtyResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblWebOwnerQty" runat="server">Antall eiere</label>
                                <asp:TextBox ID="txtWebOwnerQty" runat="server" meta:resourcekey="txtWebOwnerQtyResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="four wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <b id="lblWebHeaderSalesPlace" runat="server">Sales place (where the car is):</b>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebAddress" runat="server">Address</label>
                                <asp:TextBox ID="txtWebAddress" runat="server" meta:resourcekey="txtWebAddressResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="four wide field">
                                <label id="lblWebZipcode" runat="server">Zipcode</label>
                                <asp:TextBox ID="txtWebZip" runat="server" meta:resourcekey="txtWebZipResource1"></asp:TextBox>
                            </div>
                            <div class="twelve wide field">
                                <label id="lblWebPlace" runat="server">Place</label>
                                <asp:TextBox ID="txtWebPlace" runat="server" meta:resourcekey="txtWebPlaceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebCountry" runat="server">Country</label>
                                <asp:TextBox ID="txtWebCountry" runat="server" meta:resourcekey="txtWebCountryResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <b id="lblWebHeaderContactPerson" runat="server">Contact person:</b>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebName" runat="server">Name</label>
                                <asp:TextBox ID="txtWebName" runat="server" meta:resourcekey="txtWebNameResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMail" runat="server">E-mail</label>
                                <asp:TextBox ID="txtWebMail" runat="server" meta:resourcekey="txtWebMailResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblWebPhone1" runat="server">Phone 1</label>
                                <asp:TextBox ID="txtWebPhone1" runat="server" meta:resourcekey="txtWebPhone1Resource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblWebPhone2" runat="server">Phone 2</label>
                                <asp:TextBox ID="txtWebPhone2" runat="server" meta:resourcekey="txtWebPhone2Resource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <input type="button" id="btnSpareSave" value="Save" class="cTab ui btn" />


    

   
</asp:Content>

