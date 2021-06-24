<%

'Injection check
Function CheckInjection(str)
    Dim chkStr : chkStr = "',;,document.cookie,@variable,@@variable,+,print,set,%,or,union,and,insert,openrowset,xp_,declare,select,update,delete,drop,--,/*,*/,<script,alert(,</script>,>,<"

    Dim chkArr : chkArr = Split(chkStr,",")

    For Each ss In chkArr
        str = Replace(str,ss,"")
        str = Replace(str,UCASE(ss),"")
    Next

    CheckInjection = str
End Function

' Left Padding
Function PadLeft(str, pad, size)
    PadLeft = Right(String(pad, size) & str, size)
End Function

' Right Padding
Function PadRight(str, pad, size)
    PadRight = Left(str & String(pad, size), size)
End Function

'3항 연산자
Function IIF(condition, ifTrue, ifFalse)
    If condition Then
        IIF = ifTrue
    Else
        IIF = ifFalse
    End If
End Function

' Is Null Value
Function IS_NV(t)
    IS_NV = IsNull(t) Or t = ""
End Function

' Is Number
Function IS_NUM(t)
    If IS_NV(t) Then
        IS_NUM = False
    Else
        If IsNumeric(t) Then
            IS_NUM = True
        Else
            IS_NUM = False
        End If
    End If
End Function

Function C_INT(val)
    If IS_NUM(val) Then
        C_INT = val + 0
    Else
        C_INT = -1
    End If
End Function

Function C_STR(val)
    If IS_NV(val) Then
        C_STR = ""
    Else
        C_STR = "" & CSTR(val)
    End If
End Function

Function CheckLogin
    Dim loginResult : loginResult = False
    ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
    '     loginResult = True
    '     LoginUserIdNo = Session("userIdNo")
    '     LoginUserName = Session("userName")
    ' Else
        If Session("userIdNo") <> "" Then
            LoginUserIdNo = Session("userIdNo")
            LoginUserName = Session("userName")
            loginResult = True
        Else
            LoginUserIdNo = ""
            LoginUserName = ""
            loginResult = False
        End If
    ' End If

    CheckLogin = loginResult
End Function

Function GetCurrentHost
    GetCurrentHost = GetUrlProtocol & "://" & GetUrlHost
End Function

Function GetCurrentFullUrl
    GetCurrentFullUrl = GetUrlProtocol & "://" & GetUrlHost & GetUrlPath & GetUrlQueryString
End Function

Function GetUrlProtocol
    If Request.ServerVariables("HTTPS") = "on" Then
        GetUrlProtocol = "https"
    Else
        GetUrlProtocol = "http"
    End If
End Function

Function GetUrlHost
    ' If Request.ServerVariables("SERVER_PORT") <> 80 Then
    '     GetUrlHost = Request.ServerVariables("HTTP_HOST") & ":" & Request.ServerVariables("SERVER_PORT")
    ' Else
    '     GetUrlHost = Request.ServerVariables("HTTP_HOST")
    ' End If
    GetUrlHost = Request.ServerVariables("HTTP_HOST")
End Function

Function GetUrlPath
    GetUrlPath = Request.ServerVariables("SCRIPT_NAME")
End Function

Function GetUrlQueryString
    If LEN(Request.ServerVariables("QUERY_STRING")) > 0 Then
        GetUrlQueryString = "?" & Request.ServerVariables("QUERY_STRING")
    Else
        GetUrlQueryString = ""
    End If
End Function

Function GetReturnUrl
    GetReturnUrl = GetUrlPath & GetUrlQueryString
End Function

Function GetUrlPageName
    pageName = GetCurrentPath

    If InStr(pageName, "/") > 0 Then
        pageName = Right(pageName, Len(pageName) - InStrRev(pageName, "/"))
    End If

    GetUrlPageName = pageName
End Function


Function GetReqStr(name, default)
    reqVal = Request(name)

    If IsEmpty(reqVal) Or IsNull(reqVal) Or Trim(reqVal) = "" Then reqVal = default

    GetReqStr = reqVal
End Function

Function GetReqNum(name, default)
    reqVal = Request(name)

    If IsEmpty(reqVal) Or IsNull(reqVal) Or Trim(reqVal) = "" Or Not IsNumeric(reqVal) Then reqVal = default

    GetReqNum = reqVal
End Function

Function GetMenuImagePath(file_type, menu_idx)
    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = ""

        .Parameters.Append .CreateParameter("@file_type", adVarChar, adParamInput, 20, file_type)
        .parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , menu_idx)

        Set rs = .Execute
    End With
    Set cmd = Nothing

    If Not (rs.BOF Or rs.EOF) Then
        
    End If
End Function

Function GetMainImagePath(menu_idx)
    GetMainImagePath = GetMenuImagePath("MAIN", menu_idx)
End Function

Function GetCurrentTime
    GetCurrentTime = Replace(FormatDateTime(Now, vbShortTime),":","")
End Function

Function CheckOpenTime
	CHECK_DATETIME = year(date) & Right("0" & month(date),2) & Right("0" & day(date),2) & Right("0" & hour(time),2) & Right("0" & minute(time),2) & Right("0" & second(time),2)
	If CHECK_DATETIME >= "20190615110000" And CHECK_DATETIME < "20190616010000" Then	'U20 축구 결승때문에 연장 체크
		CheckOpenTime = True
	Else
		if G2_SITE_MODE = "production" then 
			CheckOpenTime = GetCurrentTime >= "1100" And GetCurrentTime <= "2300"
		else 
			CheckOpenTime = GetCurrentTime >= "0900" And GetCurrentTime <= "2300"
		end if 
'		If SGPayOn = True Then
'			CheckOpenTime = GetCurrentTime >= "0000" And GetCurrentTime <= "2400"
'		End If
	End If 
End Function

Function ParseAddress(rs)
    paddr = ""
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """addr_idx"":" & rs("addr_idx")
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """addr_name"":""" & rs("addr_name") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """zip_code"":""" & rs("zip_code") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """addr_type"":""" & rs("addr_type") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """address_jibun"":""" & rs("address_jibun") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """address_road"":""" & rs("address_road") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """address_main"":""" & rs("address_main") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """address_detail"":""" & rs("address_detail") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """sido"":""" & rs("sido") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """sigungu"":""" & rs("sigungu") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """sigungu_code"":""" & rs("sigungu_code") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """roadname_code"":""" & rs("roadname_code") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """b_code"":""" & rs("b_code") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """b_name"":""" & rs("bname") & """"
    If paddr <> "" Then paddr = paddr & ","
    paddr = paddr & """mobile"":""" & rs("mobile") & """"

    paddr = "{" & paddr & "}"

    ParseAddress = paddr
End Function

Function AddressToJson(rs)
    ajson = ""
    If IsObject(rs) And Not IsNull(rs) Then
        If rs.RecordCount > 1 Then
            For i = 0 To rs.RecordCount - 1
            Next
        Else
            ajson = ParseAddress(rs)
        End If
    End If

    AddressToJson = ajson
End Function

' Function PMLog(apiurl, req, res)
'     req_url GetCurrentFullUrl
'     req_ip = Request.ServerVariables("REMOTE_ADDR")
'     req_qs = Request.ServerVariables("QUERY_STRING")

'     Set pCmd = Server.CreateObject("ADODB.Command")
'     With pCmd
'         .ActiveConnection = dbconn
'         .NamedParameters = True
'         .CommandType = adCmdStoredProc
'         .CommandText = "tp_payco_log_insert"

'         .Parameters.Append .CreateParameter("@req_page", adVarChar, adParamInput, 1000, req_url)
'         .Parameters.Append .CreateParameter("@api_url", adVarChar, adParamInput, 1000, apiurl)
'         .Parameters.Append .CreateParameter("@req_text", adLongVarWChar, adParamInput, 2147483647, req)
'         .Parameters.Append .CreateParameter("@res_text", adLongVarWChar, adParamInput, 2147483647, res)
'         .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)

'         .Execute
'     End With
'     Set pCmd = Nothing
' End Function

'	Create By Goldman
'	========================================================================================
Function stripTags(byval str)
	if not isNull(str) then
		dim regex
		set regex = new RegExp
		regex.pattern = "<[\/\!]*?[^<>]*?>"
		regex.IgnoreCase = true 'false(대소문자구분), true(구분안함, 기본)
		regex.Global = true 'true(전체문자열), false(처음것만, 기본)

		stripTags = regex.replace(str, "")
		set regex = nothing
	else
		stripTags = str
	end if
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

Function FncIsBlank(str)
	If IsEmpty(str) Or IsNull(str) Or Trim(str &"") = "" Then
		FncIsBlank = true
	Else
		FncIsBlank = false
	End If 
End Function 

Function FncInStr(gubun_sel,code_idx)
	Dim Cnt
	BoolCheck = False
	If FncIsBlank(gubun_sel) Or FncIsBlank(code_idx) Then 
	Else 
		arrgubun_sel = Split(gubun_sel,",")
		For Cnt = 0 To Ubound(arrgubun_sel)
			If ""&arrgubun_sel(Cnt) = ""&code_idx Then 
				BoolCheck = True
				Exit For
			End If 
		Next
	End If
	FncInStr = BoolCheck
End Function

Function Ceil(ByVal intParam)
	Ceil = -(Int(-(intParam)))   
End Function

Function SendXMLHTTP(url)
	set objHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP")

	lResolve = 5 * 1000 
	lConnect = 7200 * 1000	'(default : 60s)
	lSend    = 7200 * 1000	'(default : 5m)
	lReceive = 7200 * 1000	'(default : 60m)

	objHTTP.setTimeouts lResolve, lConnect, lSend, lReceive
	objHTTP.Open "GET", url, FALSE
	objHTTP.send

	SendXMLHTTP = objHTTP.ResponseText
	
	set objHTTP = Nothing
End Function  
'	========================================================================================

Function getEdate(RDATE)
	Dim arrayMonth 
	arrayMonth = array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec" )
	getMonth = Cint(month(RDATE))
	getMonthName = arrayMonth(Cint(getMonth)-1)
	getEdate = day(RDATE) & " " & getMonthName & " " & Year(RDATE)
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

Function DeleteHTML( strText )
	dim contTmp
	set onlyTex = New Regexp
	onlyTex.Pattern= "<[^>]+>"
	onlyTex.Global=true
	strText=onlyTex.Replace(strText," ") ' 구분을 위해 한칸 뛰어쓰기
	DeleteHTML= strText
End Function

function CSRP_TokenCreate()
	set_KeyTable = "A0N1B2A3C4N5D6U7E8M9F0LGOHTITJOKLMNOPQRSTUVWXYZ"
	set_Token = ""
	randomize
	
	for cnt = 1 to 20
		get_KeyPos = int((49 - 1 + 1) * Rnd + 1)
		set_Token = set_Token & mid(set_KeyTable, get_KeyPos, 1)
	next

	session("CSRP_Token") = set_Token
	CSRP_TokenCreate = set_Token
end function

' ----------------------------------------------------------------------------------------------------
'	변수에 기본값 지정
' ----------------------------------------------------------------------------------------------------
Function fNullCheck(ByVal pStr, ByVal pVal, ByVal pType)
	If Trim(pStr) = "" Or IsNull(pStr) Or IsEmpty(pStr) Then
		fNullCheck = Trim(pVal)
	Else
		If pType = "num" Then
			If IsNumeric(pStr) = False Then
				fNullCheck = pVal
			ElseIf pStr > 999999999 Then
				fNullCheck = Trim(pVal)
			Else
				fNullCheck = Trim(pStr)
			End If
		Else
			fNullCheck = Trim(pStr)
		End If
	End If
End Function
%>