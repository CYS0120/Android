<%@Language="VBScript" CODEPAGE="65001" %>
<%
  Response.CharSet="utf-8"
  Session.codepage="65001"
  Response.codepage="65001"
  Response.ContentType="text/html;charset=utf-8"
%>
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" File="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include virtual="/api/include/aspJSON1.18.asp"-->
<%
	Function FncIsBlank(str)
		If IsEmpty(str) Or IsNull(str) Or Trim(str &"") = "" Then
			FncIsBlank = true
		Else
			FncIsBlank = false
		End If 
	End Function 

	Function GetIPADDR()
		GetIP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
		If FncIsBlank(GetIP) Then
			GetIP = Request.ServerVariables("HTTP_CLIENT_IP")
			If FncIsBlank(GetIP) Then
				GetIP = Request.ServerVariables("REMOTE_ADDR")
			End If
		End If
		GetIPADDR = GetIP
	End Function

	Function InjRequest(Vname)
		Vname = Trim(request("" & Vname & ""))
		Vname = FncInjection(Vname)
		InjRequest = Vname
	End Function 

	' DB Injection 처리
	Function FncInjection(CheckValue)
		If Not(CheckValue = "" Or IsNull(CheckValue)) Then 
			CheckValue = Replace(CheckValue, "'", "''")
			CheckValue = Replace(CheckValue, "--", "")
			CheckValue = Replace(CheckValue, "1=1", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "sp_", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "xp_", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "@variable", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "@@variable", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "exec", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "sysobject", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "convert", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "syscolumns", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "<script", "", 1, -1, 1)
			CheckValue = Replace(CheckValue, "</script", "", 1, -1, 1)
		End If 
		FncInjection = CheckValue
	End Function 

	REG_IP	= GetIPADDR()
	branch_id	= InjRequest("branch_id")
	pickup_discount = InjRequest("pickup_discount")

	json_data = "{""brand_cd"":""01"", ""user_ip"":""" & REG_IP & """, ""branch_id"":""" & branch_id & """, ""add"":{""pickup_discount"":" & pickup_discount & "}}"

	ServerHost		= "40.82.154.186,1433"
	UserName		= "sa_homepage"
	UserPass		= "home123!@#"
	DatabaseName	= "BBQ"

	Set dbconn = Server.CreateObject("ADODB.Connection")
	strConnection = "Provider=SQLOLEDB;Persist Security Info=False;User ID="& UserName &";passWord="& UserPass &";Initial Catalog="& DatabaseName &";Data Source="& ServerHost &""
	dbconn.Open strConnection

	Dim aCmd : Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "UP_BT_BRANCH_UPDATE"

		.Parameters.Append .CreateParameter("@JSON", adVarChar, adParamInput, 8000, json_data)
		.Parameters.Append .CreateParameter("@OUT", adVarChar, adParamOutput, 8000)
		.Execute

		OUT = .Parameters("@OUT").Value
	End With
	Set aCmd = Nothing

	Set oJson = New aspJSON
	oJson.loadJSON(OUT)
	result = oJson.data("result")
	For Each fail In oJSON.data("fail_list")
		Set this = oJSON.data("fail_list").item(fail)
		result_msg = ""
		result_msg = result_msg & this.item("desc") & " - "
		result_msg = result_msg & this.item("value") & "\n"
	Next

	If result = "fail" Then
		result = "{""result"":""99"", ""result_msg"":""수정되지 않았습니다.\n\n[원인]\n" & result_msg & """}"
	ElseIf result = "succ" Then
		result = "{""result"":""00"", ""result_msg"":""수정되었습니다.""}"
	End If

	dbconn.Close
	Set dbconn = Nothing

	Response.Write result
	Response.End
%>
