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
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Namespace CARS.Services.DayPlan
    Public Class DayPlan
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function Insert_PlanJobDet(ByVal MechanicId As String, ByVal StartTime As String, ByVal EndTime As String, ByVal PlanDate As String, ByVal DeptId As String) As String
            Dim strResult As String = ""
            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                Dim dpserv As New ServiceReference1.DPServiceClient
                Dim dplan As New ServiceReference1.UserDetails()
                dplan.MechanicId = MechanicId
                dplan.PlanDate = PlanDate
                dplan.PlanTimeFrom = StartTime
                dplan.PlanTimeTo = EndTime
                dplan.DepartmnetId = DeptId
                strResult = dpserv.InsertUserDetails(dplan)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.DayPlan", "Insert_PlanJobDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
    End Class
End Namespace


