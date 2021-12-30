<%
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

Function unixTime(t)
	unixTime = datediff("s", "01/01/1970 00:00:00", t)
End Function 

Function un_unixTime(t)
	un_unixTime = dateadd("s", t, "01/01/1970 00:00:00")
End Function 

Function GetDateTime()
	TempStr = year(date) & Right("0" & month(date),2) & Right("0" & day(date),2) & Right("0" & hour(time),2) & Right("0" & minute(time),2) & Right("0" & second(time),2)
	GetDateTime = TempStr
End Function 

Function getFormatPhoneNumber(strPhoneNumber)
    if isnull(strPhoneNumber) then
        strPhoneNumber = ""
    else
        strPhoneNumber = Replace(strPhoneNumber, "-", "")

        If Len(strPhoneNumber) > 8 then
            If Left(strPhoneNumber, 2) = "02" Then
                If Len(strPhoneNumber) < 10 then
                    strPhoneNumber = Left(strPhoneNumber, 2) & "-" & Mid(strPhoneNumber, 3, 3) & "-" & Right(strPhoneNumber, 4)
                Else
                    strPhoneNumber = Left(strPhoneNumber, 2) & "-" & Mid(strPhoneNumber, 3, 4) & "-" & Right(strPhoneNumber, 4)
                End If
            Else
                If Len(strPhoneNumber) < 11 then
                    strPhoneNumber = Left(strPhoneNumber, 3) & "-" & Mid(strPhoneNumber, 4, 3) & "-" & Right(strPhoneNumber, 4)
                Else
                    strPhoneNumber = Left(strPhoneNumber, 3) & "-" & Mid(strPhoneNumber, 4, 4) & "-" & Right(strPhoneNumber, 4)
                End If
            End If
        End If
    End If
    getFormatPhoneNumber = strPhoneNumber
End Function

'php ceil 함수와 동일 무조건 올림	
'asp 에서 무조건 올림은 FIX()
Function Ceil(ByVal intParam)
	Ceil = -(Int(-(intParam)))   
End Function  


Sub AlertOnly(byref ment)
%>
	<script type="text/javascript">
		alert("<%=ment%>");
	</script>
<%
End Sub 

Sub subGoToMsg(byref ment, byref mode)
	If ment <> "" And mode <> "" Then 
		If mode = "close" Then 
%>
		<script type="text/javascript">
			alert("<%=ment%>");
			window.close();
		</script>
<%
		ElseIf mode = "back" Then 
%>
		<script type="text/javascript">
			alert("<%=ment%>");
			history.back();
		</script>
<%
		ElseIf mode = "stop" Then 
%>
		<script type="text/javascript">
			alert("<%=ment%>");
		</script>
<%
		Else 
%>
		<script type="text/javascript">
			alert("<%=ment%>");
			location.href = "<%=mode%>";
		</script>
<%
		End If 
		response.End 
	End If 
End Sub 

Sub subParentMove(msg, url)
	If msg <> "" And url <> "" Then 
		Response.write("<script type=""text/javascript"">"& vbCrLf)
		Response.write("alert("""& msg &""");"& vbCrLf)
		Response.write("parent.location.href='"& url &"';"& vbCrLf)
		Response.write("</script>"& vbCrLf)
		Response.End 
	End If 
End Sub 

Sub subParentReload(msg)
	Response.write("<script type=""text/javascript"">"& vbCrLf)
	If msg <> "" Then 
		Response.write("alert('"& msg &"');"& vbCrLf)
	End If 
	Response.write("parent.location.reload();"& vbCrLf)
	Response.write("</script>")
	Response.End 
End Sub 

Sub subOpenerReload(msg)
	Response.write("<script type=""text/javascript"">"& vbCrLf)
	If msg <> "" Then 
		Response.write("alert('"& msg &"');"& vbCrLf)
	End If 
	Response.write("opener.location.reload();"& vbCrLf)
	Response.write("self.close();"& vbCrLf)
	Response.write("</script>")
	Response.End 
End Sub 

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

Function URL_Send(host, params)
	url = host&"?"&params
'	Response.write url & "<BR>"
	Set objHttp = server.CreateObject("Msxml2.ServerXMLHTTP")

	If IsNull(objHttp) Then
		URL_Send = ""
	Else
		objHttp.Open "POST", url, False
		objHttp.SetRequestHeader "Content-Type","application/x-www-form-urlencoded;charset=euc-kr"
		objHttp.Send data

		URL_Send = objHttp.responseText ' 결과데이터 파서로 넘기기 위해 별도 저장

		Set objHttp = Nothing '개체 소멸
	End If
End Function

Function FilewriteLog(file, noti)
    Dim fso, ofile, slog, TempStr
	TempStr = year(date) & "-" & Right("0" & month(date),2) & "-" & Right("0" & day(date),2) & " " & Right("0" & hour(time),2) & ":" & Right("0" & minute(time),2) & ":" & Right("0" & second(time),2)
	U_IP	= GetIPADDR()
	slog	= TempStr & "	" & U_IP & "	" & noti & chr(13)
    
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    if fso.fileExists(file) then    
        Set ofile = fso.OpenTextFile(file, 8, True)
    else
        Set ofile = fso.CreateTextFile(file, True)
    end If
    
    ofile.Writeline slog
    ofile.close
    Set ofile = Nothing
    Set fso = Nothing
End Function

Function URLDecode(Expression)
	Dim strSource, strTemp, strResult, strchr
	Dim lngPos, AddNum, IFKor
	strSource = Replace(Expression, "+", " ")

	For lngPos = 1 To Len(strSource)
		AddNum = 2
		strTemp = Mid(strSource, lngPos, 1)
		If strTemp = "%" Then
			If lngPos + AddNum < Len(strSource) + 1 Then
				strchr = CInt("&H" & Mid(strSource, lngPos + 1, AddNum))
				If strchr > 130 Then 
					AddNum = 5
					IFKor  = Mid(strSource, lngPos + 1, AddNum)
					IFKor  = Replace(IFKor, "%", "")
					strchr = CInt("&H" & IFKor )
				End If
				strResult = strResult & Chr(strchr)
				lngPos = lngPos + AddNum
			End If
		Else
			strResult = strResult & strTemp
		End If
	Next
	URLDecode = strResult
End Function  

Sub SET_COOKIES(BYVAL strVar, Byval strValue)
	Response.Cookies(strVar) = trim(""&strValue)
'	Response.Cookies(strVar).Domain = MALL_DOMAIN
End Sub

Sub SET_COOKIES365(BYVAL strVar, Byval strValue)
	Response.Cookies(strVar) = trim(""&strValue)
	Response.Cookies(strVar).Expires = now + 365
	Response.Cookies(strVar).Path = "/"
	Response.Cookies(strVar).Domain = MALL_DOMAIN
End Sub

'이미지 불러오는 path
Function GetBrandImgPath(CD)
	dim path 
	select Case CD
	case "A" 'bbq
		path = "bbq_d"
	case "I" '창업전략연구소
		path = "bbqstartup_d"
	case "J" '글로벌
		path = "bbqglobal_d"
	case "K" '제네시스
		path = "genesiskorea_d"
	case else 
		path = "bbq_d"
	end select 
	GetBrandImgPath = path
End Function 

%>