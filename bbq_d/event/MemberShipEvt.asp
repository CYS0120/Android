<!--#include virtual="/api/include/utf8.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
		Response.Write "E^잘못된 접근방식입니다"
		Response.End 
	End If

    If Not CheckLogin() Then
		Response.Write "L^로그인 후 참여 가능합니다"
		Response.End
    End If

	If Date > "2019-05-20" Then 
		Response.Write "E^종료된 이벤트 입니다"
		Response.End
	End If 

	REG_IP = Request.ServerVariables("REMOTE_ADDR")

	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_event_point_check"

		.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))
		.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
		.Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 15, REG_IP)
		.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

		.Execute

		errCode = .Parameters("@ERRCODE").Value
		errMsg = .Parameters("@ERRMSG").Value
	End With
	Set aCmd = Nothing

	dbconn.close
	Set dbconn = Nothing

	Response.Write "Y^" & errMsg
	Response.End
%>