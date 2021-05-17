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
	MENU_IDX	= InjRequest("MENU_IDX")
	EXPDATE	= InjRequest("EXPDATE")
	AUTO_CREATE	= InjRequest("AUTO_CREATE")
	USESDATE	= InjRequest("USESDATE")
	USEEDATE	= InjRequest("USEEDATE")
	TOTCNT		= InjRequest("TOTCNT")
	CD_PARTNER	= InjRequest("CD_PARTNER")
	DC_YN	= InjRequest("DC_YN")
	If FncIsBlank(CPNNAME) Or FncIsBlank(TOTCNT) Then 
		Response.Write "E^정보를 모두 입력해 주세요"
		Response.End
	End If 

	If FncIsBlank(CPNID) Then CPNID = 0
	If FncIsBlank(CPNTYPE) Then CPNTYPE = "PR"
	If FncIsBlank(AUTO_CREATE) Then AUTO_CREATE = "N"
	If FncIsBlank(TOTCNT) Then TOTCNT = 1
	If FncIsBlank(CD_PARTNER) Then CD_PARTNER = "00000"
	If FncIsBlank(EXPDATE) Then EXPDATE = 0
	If FncIsBlank(DC_YN) Then DC_YN = "N"

	If AUTO_CREATE = "N" Then 
		If FncIsBlank(USESDATE) Or FncIsBlank(USEEDATE) Then 
			Response.Write "E^유효기간을 입력해 주세요"
			Response.End
		End If 
	End If

	DISCOUNT = 0
	EXPDATE = 0
	STATUS = 1
    If AUTO_CREATE = "Y" Then
        TOTCNT = 0
    End If
	OPTIONID = 0

	Set objCmd = Server.CreateObject("ADODB.Command")
	WITH objCmd

		.ActiveConnection = conn
		.CommandTimeout = 3000
		.CommandText = BBQHOME_DB &".DBO.s_Common_Coupon_CPNPub_3"
		.CommandType = adCmdStoredProc

		.Parameters.Append .CreateParameter("@CPNID",adInteger,adParamInput,0, CPNID)
		.Parameters.Append .CreateParameter("@CPNNAME",advarchar,adParamInput, 100, CPNNAME)
		.Parameters.Append .CreateParameter("@CPNTYPE",advarchar,adParamInput,10, CPNTYPE)
		.Parameters.Append .CreateParameter("@MENUID",adInteger,adParamInput,0, MENU_IDX)
		.Parameters.Append .CreateParameter("@OPTIONID",adInteger,adParamInput,0, OPTIONID)
		.Parameters.Append .CreateParameter("@DISCOUNT",adInteger,adParamInput,0, 0)
		.Parameters.Append .CreateParameter("@EXPDATE",adInteger,adParamInput,0, EXPDATE)
		.Parameters.Append .CreateParameter("@USESDATE",advarchar,adParamInput,10, USESDATE)
		.Parameters.Append .CreateParameter("@USEEDATE",advarchar,adParamInput,10, USEEDATE)
		.Parameters.Append .CreateParameter("@CD_PARTNER",advarchar,adParamInput,10, CD_PARTNER)
		.Parameters.Append .CreateParameter("@STATUS",adInteger,adParamInput,0, STATUS)
		.Parameters.Append .CreateParameter("@TOTCNT",adInteger,adParamInput,0, TOTCNT)
		.Parameters.Append .CreateParameter("@AUTO_CREATE",advarchar,adParamInput,1, AUTO_CREATE)
		.Parameters.Append .CreateParameter("@DC_YN",advarchar,adParamInput,1, DC_YN)

		.Parameters.Append .CreateParameter("@RETURNCODE",adInteger, adParamOutPut)
		.Parameters.Append .CreateParameter("@OUTCPNID",adInteger, adParamOutPut)

		.Execute  ,  , adExecuteNoRecords

		nRCode = .Parameters("@RETURNCODE")
		CPNID = .Parameters("@OUTCPNID")
	END With
	If nRCode > 0 Then
		Response.Write "E^오류발생"
		Response.End
	End If


    If AUTO_CREATE <> "Y" Then
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
    Else
        nRCode = 0
    End If

	If nRCode > 0 Then
		Response.Write "E^오류발생"
		Response.End
	End If

	Response.Write "Y^적용 되었습니다"
	Response.End
%>