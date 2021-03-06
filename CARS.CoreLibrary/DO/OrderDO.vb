﻿Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data.Common

Public Class OrderDO
    Dim objDB As Database
    Dim ConnectionString As String

    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub


    '**********************************************************************
    '  Name of Method         		:	GetOrder()
    '  Description            		:	This function is used to fetch the 
    '                                    vehicle details
    '  Input Params           		:	VehReg
    '  Output Params          		:	dataset
    '  I/O Params             		:   -   
    '  Globals Used           		:	-
    '  Routines Called        		:	-
    '***********************************************************************
    Public Function GetOrder(ByVal orderNo As String) As DataSet
        Try
            Dim dsOrder As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SAMPLE_ORDER_FETCH")
                objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, orderNo)
                dsOrder = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsOrder
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Order_Search(ByVal q As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_ORDER_SEARCH")
                objDB.AddInParameter(objcmd, "@ID_SEARCH", DbType.String, q)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Delete_Order(ByVal WoNo As String) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_DELETE")
                objDB.AddInParameter(objcmd, "@IV_WONumber", DbType.String, WoNo)
                objDB.AddOutParameter(objcmd, "@OV_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objcmd, "@OV_CntDelete", DbType.String, 500)
                objDB.AddOutParameter(objcmd, "@OV_DeletedCfg", DbType.String, 500)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    'strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + commonUtil.NullCheck(objDB.GetParameterValue(objcmd, "@ov_CntDelete").ToString) + "," + commonUtil.NullCheck(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg").ToString)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))))
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
