<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" File="C:\Program Files\Common Files\System\ado\msado15.dll" -->
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
			'CheckValue = Replace(CheckValue, ";", "")
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
	json_data = "{""pickup_discount"":" & pickup_discount & "}"

	' Response.Write branch_id & " || " & pickup_discount & " || " & json_data & " || " & REG_IP
	' Response.End

	ServerHost		= "40.82.154.186,1433"
	UserName		= "sa_homepage"
	UserPass		= "home123!@#"
	DatabaseName	= "BBQ"

	Set dbconn = Server.CreateObject("ADODB.Connection")
	strConnection = "Provider=SQLOLEDB;Persist Security Info=False;User ID="& UserName &";passWord="& UserPass &";Initial Catalog="& DatabaseName &";Data Source="& ServerHost &""
	dbconn.Open strConnection

	Dim aCmd : Set aCmd = Server.CreateObject("ADODB.Command")
	Dim aRs : Set aRs = Server.CreateObject("ADODB.RecordSet")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "UP_BT_BRANCH_UPDATE"

		.Parameters.Append .CreateParameter("@BRAND_CD", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@BRANCH_ID", adVarChar, adParamInput, 7, branch_id)
		.Parameters.Append .CreateParameter("@JSON", adVarChar, adParamInput, 8000, json_data)
		.Parameters.Append .CreateParameter("@USER_IP", adVarChar, adParamInput, 30, REG_IP)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		result = "[ 결과 ]"
		Do Until aRs.EOF
			CODE = Cstr(aRs("CODE"))
			COL_DESC = aRs("COL_DESC")
			COL_VALUE = aRs("COL_VALUE")

			If CODE = "00" Then
				result = result & Chr(13) & Chr(10) & "성공 | " & COL_DESC & " | " & COL_VALUE
			Else
				result = result & Chr(13) & Chr(10) &  "실패 | " & COL_DESC & " | " & COL_VALUE
			End If
			aRs.MoveNext
		Loop
	End If

	dbconn.Close
	Set aRs = Nothing
	Set dbconn = Nothing

	Response.Write "Y^" & result
	Response.End 
%>
