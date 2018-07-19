Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.IO
Imports System.Drawing
Imports System.Web.Script.Serialization.JavaScriptSerializer
Imports System.Object
Imports System.MarshalByRefObject
Imports System.Net.WebRequest
Imports System.Net.HttpWebRequest
Imports System.Net.HttpWebResponse
Imports System.Net
Imports System.Web
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls.WebParts
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS.Services
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports System.Threading
Imports System.Globalization
Imports CARS.CoreLibrary.CARS
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmDayPlan
    Inherits System.Web.UI.Page
    Shared objDayPlanService As New CARS.CoreLibrary.CARS.Services.DayPlan.DayPlan
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared OErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared loginName As String
    Shared objCustBo As New CustomerBO
    Shared objCommonUtil As New Utilities.CommonUtility
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    <WebMethod()>
    Public Shared Function InsertPlanJobDet(ByVal MechanicId As String, ByVal StartTime As String, ByVal EndTime As String, ByVal PlanDate As String, ByVal DeptId As String, ByVal Description As String, ByVal Title As String) As String
        Dim strResult As String
        Dim dsReturnValStr As String = ""
        Dim dt_plan As String = objCommonUtil.GetDefaultDate_MMDDYYYY(PlanDate)
        Try
            strResult = objDayPlanService.Insert_PlanJobDet(MechanicId, StartTime, EndTime, dt_plan, DeptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmDayPlan", "InsertPlanJobDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
End Class