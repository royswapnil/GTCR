﻿Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data.Common
'================================================================================='
''  Vehicle.vb
''  Implementation of the Class Vehicle
''  Generated by Enterprise Architect
''  Created on:      12-Jul-2006 04:23:13 PM
''  Original author: J.Krishnaveni


'Application            : MSG-ABS-10_DO                                           '       
'Module                 : Vehicle                                                 '   
'File                   :                                                         ' 
'Classes And Functions  :                                                         '
'Purpose                :                                                         '
'Author                 : Krishnaveni                                             '
'Date                   : 12-Jul-2006                                             '
'Copyright              :                                                         '       
'                                                                                 '                                                                                 
'================================================================================='
'================================================================================='
' Revision History                                                                '   
' Version No.       Date -              By -                    Explanation       ' 
'==================================================================================

Public Class VehicleDO
    Dim objDB As Database
    Dim ConnectionString As String

    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub
    Public Function GetVehicle(ByVal vehicleRegNo As String) As DataSet
        Try
            Dim dsVehicles As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SAMPLE_VEHICLE_FETCH")
                objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, vehicleRegNo)
                dsVehicles = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsVehicles
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Add_Vehicle(ByVal objVehBO As VehicleBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MAS_VEHICLE")
                objDB.AddInParameter(objcmd, "@IV_VEH_REG_NO", DbType.String, objVehBO.VehRegNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_INTERN_NO", DbType.String, objVehBO.IntNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_VIN", DbType.String, objVehBO.VehVin)
                objDB.AddInParameter(objcmd, "@IV_ID_MAKE_VEH", DbType.String, objVehBO.Make)
                objDB.AddInParameter(objcmd, "@IV_ID_MODEL_VEH", DbType.String, objVehBO.Model)
                objDB.AddInParameter(objcmd, "@IV_VEH_TYPE", DbType.String, objVehBO.VehicleType)
                objDB.AddInParameter(objcmd, "@IV_VEH_ERGN_DT", DbType.String, objVehBO.RegDate)
                objDB.AddInParameter(objcmd, "@ID_VEH_MILEAGE", DbType.Int32, objVehBO.Mileage)
                objDB.AddInParameter(objcmd, "@IV_VEH_MIL_REGN_DT", DbType.String, objVehBO.MileageRegDate)
                objDB.AddInParameter(objcmd, "@ID_VEH_HRS", DbType.Decimal, objVehBO.VehicleHrs)
                objDB.AddInParameter(objcmd, "@IV_VEH_HRS_ERGN_DT", DbType.String, objVehBO.VehicleHrsDate)
                objDB.AddInParameter(objcmd, "@II_VEH_MDL_YEAR", DbType.Int32, objVehBO.ModelYear) ' chk type
                objDB.AddInParameter(objcmd, "@IV_VEH_ANNOT", DbType.String, objVehBO.Annotation)
                objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, objVehBO.CreatedBy)
                objDB.AddInParameter(objcmd, "@IV_PICK", DbType.String, objVehBO.PickNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_REFNO", DbType.String, objVehBO.RefNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_NEW_USED", DbType.String, objVehBO.VehType)
                objDB.AddInParameter(objcmd, "@IV_VEH_STATUS", DbType.String, objVehBO.VehStatus)
                objDB.AddInParameter(objcmd, "@IV_VEH_MODEL_TYPE", DbType.String, objVehBO.ModelType)
                objDB.AddInParameter(objcmd, "@IV_VEH_REGYEAR", DbType.Int32, objVehBO.RegYear)
                objDB.AddInParameter(objcmd, "@IV_VEH_REG_DATE_NO", DbType.String, objVehBO.RegDateNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_LAST_REGDATE", DbType.String, objVehBO.LastRegDate)
                objDB.AddInParameter(objcmd, "@IV_VEH_DEREG_DATE", DbType.String, objVehBO.DeRegDate)
                objDB.AddInParameter(objcmd, "@IV_VEH_CATEGORY", DbType.String, objVehBO.Category)
                objDB.AddInParameter(objcmd, "@IV_VEH_MACHINE_W_HOURS", DbType.Boolean, objVehBO.Machine_W_Hrs)
                objDB.AddInParameter(objcmd, "@IV_VEH_COLOR", DbType.String, objVehBO.Color)
                objDB.AddInParameter(objcmd, "@IV_VEH_WARRANTY_CODE", DbType.String, objVehBO.Warranty_Code)
                objDB.AddInParameter(objcmd, "@IV_VEH_NET_WEIGHT", DbType.String, objVehBO.NetWeight)
                objDB.AddInParameter(objcmd, "@IV_VEH_TOT_WEIGHT", DbType.String, objVehBO.TotalWeight)
                objDB.AddInParameter(objcmd, "@IV_VEH_PROJECT_NO", DbType.String, objVehBO.Project_No)
                objDB.AddInParameter(objcmd, "@IV_VEH_LAST_CONTACT_DATE", DbType.String, objVehBO.Last_Contact_Date)
                objDB.AddInParameter(objcmd, "@IV_VEH_PRACTICAL_LOAD", DbType.String, objVehBO.Practical_Load)
                objDB.AddInParameter(objcmd, "@IV_VEH_MAX_ROOF_LOAD", DbType.String, objVehBO.Max_Rf_Load)
                objDB.AddInParameter(objcmd, "@IV_VEH_EARLIER_REGNO_1", DbType.String, objVehBO.Earlier_Regno_1)
                objDB.AddInParameter(objcmd, "@IV_VEH_EARLIER_REGNO_2", DbType.String, objVehBO.Earlier_Regno_2)
                objDB.AddInParameter(objcmd, "@IV_VEH_EARLIER_REGNO_3", DbType.String, objVehBO.Earlier_Regno_3)
                objDB.AddInParameter(objcmd, "@IV_VEH_EARLIER_REGNO_4", DbType.String, objVehBO.Earlier_Regno_4)
                objDB.AddInParameter(objcmd, "@II_ID_GROUP_VEH", DbType.String, objVehBO.VehGrp)
                objDB.AddInParameter(objcmd, "@IV_VEH_NOTE", DbType.String, objVehBO.Note)
                objDB.AddInParameter(objcmd, "@IV_VEH_MAKECODE_NO", DbType.String, objVehBO.MakeCodeNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_RICAMBINO", DbType.String, objVehBO.RicambiNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_ENGINE_NO", DbType.String, objVehBO.EngineNum)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_FUEL_CODE", DbType.String, objVehBO.FuelCode)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_FUEL_CARD", DbType.String, objVehBO.FuelCard)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_GEARBOX", DbType.String, objVehBO.GearBox_Desc)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_WH", DbType.String, objVehBO.WareHouse)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_KEYNO", DbType.String, objVehBO.KeyNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_DOOR_KEYNO", DbType.String, objVehBO.DoorKeyNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_CONTROL_FORM", DbType.String, objVehBO.ControlForm)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_INTERIOR_CODE", DbType.String, objVehBO.InteriorCode)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_PO", DbType.String, objVehBO.PurchaseNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_ADDON_GRP", DbType.String, objVehBO.AddonGroup)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_DATE_EXPECTED_IN", DbType.String, objVehBO.Date_Expected_In)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_TIRES", DbType.String, objVehBO.Tires)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_SERVICE_CATEGORY", DbType.String, objVehBO.Service_Category)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_NO_APPROVAL_NO", DbType.String, objVehBO.No_Approval_No)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_EU_APPROVAL_NO", DbType.String, objVehBO.Eu_Approval_No)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_VAN_NO", DbType.String, objVehBO.VanNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_PRODUCT_NO", DbType.String, objVehBO.ProductNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_ELCODE", DbType.String, objVehBO.ElCode)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_TAKEN_IN_DATE", DbType.String, objVehBO.Taken_In_Date)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_TAKEN_IN_MILEAGE", DbType.Int32, objVehBO.Taken_In_Mileage)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_DELIVERY_DATE", DbType.String, objVehBO.Delivery_Date)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_DELIVERY_MILEAGE", DbType.Int32, objVehBO.Delivery_Mileage)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_SERVICE_DATE", DbType.String, objVehBO.Service_Date)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_SERVICE_MILEAGE", DbType.Int32, objVehBO.Service_Mileage)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_CALL_IN_DATE", DbType.String, objVehBO.Call_In_Date)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_CALL_IN_MILEAGE", DbType.Int32, objVehBO.Call_In_Mileage)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_CLEANED_DATE", DbType.String, objVehBO.Cleaned_Date)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_TECHDOC_NO", DbType.String, objVehBO.TechDocNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_LENGTH", DbType.Int32, objVehBO.Length)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_WIDTH", DbType.Int32, objVehBO.Width)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_NOISE", DbType.String, objVehBO.Noise_On_Veh)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_EFFEKT_KW", DbType.Int32, objVehBO.EngineEff)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_PISTON_DISP", DbType.String, objVehBO.PisDisplacement)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_ROUNDS_PER_MINUTE", DbType.String, objVehBO.Rounds)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_USED_IMPORTED", DbType.Boolean, objVehBO.Used_Imported)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_PRESSURE_MECH_BRAKES", DbType.Boolean, objVehBO.Pressure_Mech_Brakes)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_TOWBAR", DbType.Boolean, objVehBO.Towbar)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_SERVICE_BOOK", DbType.Boolean, objVehBO.Service_Book)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_LAST_PKK_APPROVED", DbType.String, objVehBO.LastPKK_AppDate)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_NEXT_PKK", DbType.String, objVehBO.NxtPKK_Date)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_LAST_PKK_INVOICED", DbType.String, objVehBO.Last_PKK_Invoiced)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_CALL_IN_SERVICE", DbType.Boolean, objVehBO.Call_In_Service)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_CALL_IN_MONTH", DbType.Int32, objVehBO.Call_In_Month_Service)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_CALL_IN_SERVICE_MILEAGE", DbType.Int32, objVehBO.Call_In_Mileage_Service)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_DO_NOT_CALL_PKK", DbType.Boolean, objVehBO.Do_Not_Call_PKK)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_DEVIATIONS_PKK", DbType.String, objVehBO.Deviations_PKK)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_YEARLY_MILEAGE", DbType.Int32, objVehBO.Yearly_Mileage)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_RADIO_CODE", DbType.String, objVehBO.Radio_Code)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_START_IMMOBILIZER", DbType.String, objVehBO.Start_Immobilizer)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_QTY_KEYS", DbType.Int32, objVehBO.Qty_Keys)
                objDB.AddInParameter(objcmd, "@IV_VEH_TECH_KEYTAG_NO", DbType.String, objVehBO.KeyTagNo)
                'tabEconomy values
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_SALESPRICE_NET", DbType.Decimal, objVehBO.SalesPriceNet)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_SALARY", DbType.Decimal, objVehBO.SalesSale)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_SALES_EQUIPMENT", DbType.Decimal, objVehBO.SalesEquipment)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_REG_COSTS", DbType.Decimal, objVehBO.RegCosts)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_DISCOUNT", DbType.Int32, objVehBO.Discount)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_NET_SALESPRICE", DbType.Decimal, objVehBO.NetSalesPrice)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_FIX_COST", DbType.Decimal, objVehBO.FixCost)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_ASSIST_SALES", DbType.Decimal, objVehBO.AssistSales)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_COST_AFTER_SALES", DbType.Decimal, objVehBO.CostAfterSales)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_CONTRIBUTIONS_TODAY", DbType.Decimal, objVehBO.ContributionsToday)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_SALESPRICE_GROSS", DbType.Decimal, objVehBO.SalesPriceGross)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_REG_FEE", DbType.Decimal, objVehBO.RegFee)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_VAT", DbType.Decimal, objVehBO.Vat)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_TOTAL_AMOUNT", DbType.Decimal, objVehBO.TotAmount)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_WRECKING_AMOUNT", DbType.Decimal, objVehBO.WreckingAmount)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_YEARLY_FEE", DbType.Decimal, objVehBO.YearlyFee)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_INSURANCE", DbType.Decimal, objVehBO.Insurance)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_COSTPRICE_NET", DbType.Decimal, objVehBO.CostPriceNet)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_INSURANCE_BONUS", DbType.Int32, objVehBO.InsuranceBonus)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_COST_SALES", DbType.Decimal, objVehBO.CostSales)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_COST_BEFORE_SALE", DbType.Decimal, objVehBO.CostBeforeSale)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_SALES_PROVISION", DbType.Decimal, objVehBO.SalesProvision)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_COMMIT_DAYS", DbType.Int32, objVehBO.CommitDay)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_ADDED_INTERESTS", DbType.Decimal, objVehBO.AddedInterests)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_COST_EQUIPMENT", DbType.Decimal, objVehBO.CostEquipment)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_TOTAL_COST", DbType.Decimal, objVehBO.TotalCost)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_CREDITNOTE_NO", DbType.String, objVehBO.CreditNoteNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_DT_CREDITNOTE", DbType.String, objVehBO.CreditNoteDate)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_INVOICE_NO", DbType.String, objVehBO.InvoiceNo)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_DT_INVOICE", DbType.String, objVehBO.InvoiceDate)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_DT_REBUY", DbType.String, objVehBO.RebuyDate)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_REBUY_PRICE", DbType.Decimal, objVehBO.RebuyPrice)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_COST_PER_KM", DbType.Decimal, objVehBO.CostPerKm)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_TURNOVER", DbType.Decimal, objVehBO.Turnover)
                objDB.AddInParameter(objcmd, "@IV_VEH_ECO_PROGRESS", DbType.Decimal, objVehBO.Progress)
                'Customer tab values
                objDB.AddInParameter(objcmd, "@IV_ID_CUSTOMER_VEH", DbType.String, objVehBO.Id_Customer_Veh)
                'Trailer tab values
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE1", DbType.String, objVehBO.Axle1)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE2", DbType.String, objVehBO.Axle2)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE3", DbType.String, objVehBO.Axle3)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE4", DbType.String, objVehBO.Axle4)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE5", DbType.String, objVehBO.Axle5)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE6", DbType.String, objVehBO.Axle6)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE7", DbType.String, objVehBO.Axle7)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_AXLE8", DbType.String, objVehBO.Axle8)
                objDB.AddInParameter(objcmd, "@IV_VEH_TRA_DESC", DbType.String, objVehBO.TrailerDesc)
                'Certificate Tab values
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_STD_TIRES_FRONT", DbType.String, objVehBO.StdTyreFront)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_STD_TIRES_BACK", DbType.String, objVehBO.StdTyreBack)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MINLI_FRONT", DbType.String, objVehBO.MinLi_Front)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MINLI_BACK", DbType.String, objVehBO.MinLi_Back)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MIN_INPRESS_FRONT", DbType.String, objVehBO.Min_Inpress_Front)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MIN_INPRESS_BACK", DbType.String, objVehBO.Min_Inpress_Back)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_STD_RIM_FRONT", DbType.String, objVehBO.Std_Rim_Front)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_STD_RIM_BACK", DbType.String, objVehBO.Std_Rim_Back)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MIN_SPEED_FRONT", DbType.String, objVehBO.Min_Front)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MIN_SPEED_BACK", DbType.String, objVehBO.Min_Back)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MAX_TRACK_FRONT", DbType.String, objVehBO.Max_Tyre_Width_Frnt)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MAX_TRACK_BACK", DbType.String, objVehBO.Max_Tyre_Width_Bk)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_AXLE_PRESSURE_FRONT", DbType.String, objVehBO.AxlePrFront)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_AXLE_PRESSURE_BACK", DbType.String, objVehBO.AxlePrBack)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_QTY_AXLES", DbType.String, objVehBO.Axles_Number)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_AXLES_OPERATIONAL", DbType.String, objVehBO.Axles_Number_Traction)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_DRIVE_WHEEL", DbType.String, objVehBO.Wheels_Traction)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MAX_ROOF_LOAD", DbType.String, objVehBO.Max_Rf_Load)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_TRAILER_WITH_BRAKES", DbType.String, objVehBO.TrailerWth_Brks)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_TRAILER_WITHOUT_BRAKES", DbType.String, objVehBO.TrailerWthout_Brks)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MAX_LOAD_TOWBAR", DbType.String, objVehBO.Max_Wt_TBar)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_LENGTH_TOWBAR", DbType.String, objVehBO.Len_TBar)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_TOTAL_TRAILER_WEIGHT", DbType.String, objVehBO.TotalTrailerWeight)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_SEATS", DbType.String, objVehBO.Seats)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_VALID_FROM", DbType.String, objVehBO.ValidFrom)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_EU_VERSION", DbType.String, objVehBO.EU_Version)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_EU_VARIANT", DbType.String, objVehBO.EU_Variant)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_EURONORM", DbType.String, objVehBO.EU_Norm)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_CO2_EMISSION", DbType.String, objVehBO.CO2_Emission)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_MAKE_PARTICLE_FILTER", DbType.String, objVehBO.Make_Part_Filter)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_CHASSI", DbType.String, objVehBO.Chassi_Desc)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_IDENTITY", DbType.String, objVehBO.Identity_Annot)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_CERTIFICATE", DbType.String, objVehBO.Cert_Text)
                objDB.AddInParameter(objcmd, "@IV_VEH_CERT_ANNOTATION", DbType.String, objVehBO.Annot)


                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OV_RETREFNO", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString + "," + objDB.GetParameterValue(objcmd, "@OI_ID_VEH_SEQ").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_RETREFNO").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function Fetch_Vehicle_Details(ByVal vehicleRefNo As String, ByVal vehicleRegNo As String, ByVal vehicleSeqId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_DETAILS")
                If (vehicleRefNo.Length > 0) Then
                    objDB.AddInParameter(objcmd, "@VEH_REF_NO", DbType.String, vehicleRefNo)
                End If
                If (vehicleRegNo.Length > 0) Then
                    objDB.AddInParameter(objcmd, "@VEH_REG_NO", DbType.String, vehicleRegNo)
                End If
                objDB.AddInParameter(objcmd, "@VEH_SEQ", DbType.String, vehicleSeqId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Vehicle_Search(ByVal q As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_VEHICLE_SEARCH")
                objDB.AddInParameter(objcmd, "@ID_SEARCH", DbType.String, q)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function FetchNewUsedCodes() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_NEW_USED")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetNewUsedRefNo(ByVal refNo As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_NEW_USED_REFNO")
                objDB.AddInParameter(objcmd, "@REFNOVAL", DbType.String, refNo)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function SetNewUsedRefNo(ByVal refNoType As String, ByVal refNo As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_NEW_USED_REFNO_UPDATE")
                objDB.AddInParameter(objcmd, "@REFNOVAL", DbType.String, refNoType)
                objDB.AddInParameter(objcmd, "@REFNO", DbType.String, refNo)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchStatusCodes() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_STATUS")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchAllWarrantyCodes() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FetchAll_WarrantyCodes")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchAllMakeCodes() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_load_veh_make_code")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Fetch_VehGroup(ByVal VehGrp) As DataSet
        Try
            Dim dsVehGroup As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("usp_load_veh_grp")
                objDB.AddInParameter(objCMD, "@id", DbType.String, VehGrp)
                dsVehGroup = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsVehGroup
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Fetch_FuelCode(ByVal FuelCode) As DataSet
        Try
            Dim dsFuelCode As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_FUELCODE")
                objDB.AddInParameter(objCMD, "@id", DbType.String, FuelCode)
                dsFuelCode = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsFuelCode
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Fetch_WareHouse(ByVal WH) As DataSet
        Try
            Dim dsWareHouse As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MAS_DEPT_WH_FETCH")
                objDB.AddInParameter(objCMD, "@ID", DbType.String, WH)
                dsWareHouse = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsWareHouse
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_VehConfig() As DataSet
        Try
            Dim dsVehicleConfig As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MAS_Vehicle_GetConfig")
                dsVehicleConfig = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsVehicleConfig
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_VehModel(ByVal objVehBO As VehicleBO) As DataSet
        Try
            Dim dsVehicleMod As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MAS_Vehicle_GetModel")
                objDB.AddInParameter(objCMD, "@MakeCodeID", DbType.String, objVehBO.Id_Make_Veh)
                dsVehicleMod = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsVehicleMod
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchEditMake() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_ABS_MAKECODE")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetEditMake(ByVal makeId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_MAS_EDITMAKE")
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, makeId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Add_EditMake(ByVal objVehBO As VehicleBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_MAKE_INSERT")
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, objVehBO.MakeCode)
                objDB.AddInParameter(objcmd, "@ID_MAKE_NAME", DbType.String, objVehBO.MakeName)
                objDB.AddInParameter(objcmd, "@ID_MAKE_PRICECODE", DbType.String, objVehBO.Cost_Price)
                objDB.AddInParameter(objcmd, "@MAKEDISCODE", DbType.String, objVehBO.Description)
                objDB.AddInParameter(objcmd, "@MAKE_VATCODE", DbType.String, objVehBO.VanNo)

                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                'objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function
    Public Function Delete_EditMake(ByVal editMakeId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_MAS_MAKE")
                objDB.AddInParameter(objcmd, "@IV_EDITMAKE_CODE", DbType.String, editMakeId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function GetModel(ByVal objVehBO As VehicleBO) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_MODELGRP_SEQ")
                objDB.AddInParameter(objcmd, "@MakeCodeID", DbType.String, objVehBO.Id_Make_Veh)
                objDB.AddInParameter(objcmd, "@Model", DbType.String, objVehBO.Model_Desc)
                Return objDB.ExecuteDataSet(objcmd)
            End Using

        Catch ex As Exception
            Throw ex
        End Try

    End Function

End Class

