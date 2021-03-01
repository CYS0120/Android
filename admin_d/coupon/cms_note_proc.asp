<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	Dim cpnid, pin
	CPNID	= InjRequest("CPNID")
	PIN	= InjRequest("PIN")

    Dim cname, cnote
    cname = InjRequest("cname")
    cnote = InjRequest("cnote")

    Dim objCmd
    Set objCmd = Server.CreateObject("ADODB.Command")

	If CPNID > 0 And Len(PIN) > 0 Then
		WITH objCmd

			.ActiveConnection = conn
			.CommandTimeout = 3000
			.CommandText = BBQHOME_DB &".DBO.UP_COUPON_CANCEL_LOG"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@CPNID",adInteger,adParamInput,0, CPNID)
			.Parameters.Append .CreateParameter("@PIN",advarchar,adParamInput,50, PIN)
			.Parameters.Append .CreateParameter("@USERNAME",advarchar,adParamInput,100, cname)
			.Parameters.Append .CreateParameter("@NOTE",advarchar,adParamInput,5000, cnote)
			.Parameters.Append .CreateParameter("@UPDATE_IP",advarchar,adParamInput,20, GetIPADDR())

			.Execute
		END WITH
	End If
%>
<Script Language="JavaScript">
    opener.document.location.reload();
    self.close();
</Script>
