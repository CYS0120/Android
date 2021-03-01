<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
IDX		= InjRequest("IDX")

If FncIsBlank(IDX) Then 
	Response.Write "E^잘못된 접근방식입니다."
	Response.End
End If 

Sql = "Select * From TB_WEB_ORDER_SEND_MSG_LOG Where IDX=" & IDX
Set Sinfo = conn.Execute(Sql)
If Sinfo.Eof Then
	Response.Write "E^일치하는 내용이 없습니다."
	Response.End
End If

TP	= "AT" '알림톡
CD	= Sinfo("CD")
PARAM = Replace(Sinfo("SEND_MSG"),"'","''")
DEST_PHONE = Sinfo("DEST_PHONE")
SEND_PHONE = "15889282"

If TESTMODE = "Y" Then
	RET = "0000"
Else 
	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = conn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "GNSIS_SMS.GNSIS_SMS.DBO.PRC_SET_SMS_WEB_V2"

		.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, TP)
		.Parameters.Append .CreateParameter("@CD", adVarChar, adParamInput, 40, CD)
		.Parameters.Append .CreateParameter("@PARAM", adVarChar, adParamInput, 4000, PARAM)
		.Parameters.Append .CreateParameter("@DEST_PHONE", adVarChar, adParamInput, 20, DEST_PHONE)
		.Parameters.Append .CreateParameter("@SEND_PHONE", adVarChar, adParamInput, 20, SEND_PHONE)
		.Parameters.Append .CreateParameter("@RET", adVarChar, adParamOutput, 4)

		.Execute
		RET = .Parameters("@RET").value
	End With
	Set aCmd = Nothing
End If 

Sql = "	INSERT INTO TB_WEB_ORDER_SEND_MSG_LOG(ORDER_ID, ORDER_STATE, TARGET, DEST_PHONE, CD, SEND_MSG, SEND_RESULT, SEND_DTS)	" & _
	"	VALUES('"& Sinfo("ORDER_ID") &"', '"& Sinfo("ORDER_STATE") &"', '"& Sinfo("TARGET") &"', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
conn.Execute(Sql)

conn.Close
Set conn = Nothing 

Response.Write "Y^전송 되었습니다."
%>