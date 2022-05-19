<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	CPNID	= InjRequest("CPNID")
	CPNNAME	= InjRequest("CPNNAME")
	CPNTYPE	= InjRequest("CPNTYPE")
	MENUID	= InjRequest("MENUID")
	EXPDATE	= InjRequest("EXPDATE")
	USESDATE	= InjRequest("USESDATE")
	USEEDATE	= InjRequest("USEEDATE")
	STATUS		= InjRequest("STATUS")
	TOTCNT		= InjRequest("TOTCNT")
	If FncIsBlank(CPNID) Or FncIsBlank(USESDATE) Or FncIsBlank(USEEDATE) Or FncIsBlank(TOTCNT) Then 
		Response.Write "E^정보를 모두 입력해 주세요"
		Response.End
	End If 

	If FncIsBlank(CPNID) Then CPNID = 0
	If FncIsBlank(CPNTYPE) Then CPNTYPE = "PR"
	If FncIsBlank(TOTCNT) Then TOTCNT = 1
	If FncIsBlank(STATUS) Then STATUS = 1
	If FncIsBlank(EXPDATE) Then EXPDATE = 0
	OPTIONID = 0

	Set objCmd = Server.CreateObject("ADODB.Command")
	WITH objCmd

		.ActiveConnection = conn
		.CommandTimeout = 30000
		.CommandText = BBQHOME_DB &".DBO.s_Common_Coupon_PINPub_Update_2" 
		.CommandType = adCmdStoredProc
		.Parameters.Append .CreateParameter("@CPNID",adInteger,adParamInput,0, CPNID)
		.Parameters.Append .CreateParameter("@USESDATE",advarchar,adParamInput,10, USESDATE)
		.Parameters.Append .CreateParameter("@USEEDATE",advarchar,adParamInput,10, USEEDATE)
		.Parameters.Append .CreateParameter("@OWNERID",advarchar,adParamInput, 50, "")
		.Parameters.Append .CreateParameter("@PINLEN",adInteger,adParamInput,0, 12)
		.Parameters.Append .CreateParameter("@TOTCNT",adInteger,adParamInput,0, TOTCNT)

		.Parameters.Append .CreateParameter("@RETURNCODE",adInteger, adParamOutPut)

		.Execute  ,  , adExecuteNoRecords

		nRCode = .Parameters("@RETURNCODE")
	END WITH

	conn.Close
	Set conn = Nothing

	If nRCode > 0 Then
		Response.Write "E^오류발생"
		Response.End
	End If


	Response.Write "Y^적용 되었습니다"
	Response.End
%>