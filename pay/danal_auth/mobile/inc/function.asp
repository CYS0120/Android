<%
	'/********************************************************************************
	' *
	' * 다날 인터넷집전화 결제
	' *
	' * - Function Library
	' *	결제 연동에 필요한 Function 및 변수값 설정 
	' *
	' * 결제 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/
	
	Dim CPID, CPPWD, CHARSET
	
	'******************************************************
	' * 인증서버 URL 정의.
	'******************************************************
	Const DN_SERVICE_URL	= "https://uas.teledit.com/uas/"								
	
	'/******************************************************
	' * SET TIMEOUT
	' ******************************************************/
	const lresolv	= 5000	'(/msec)
	const lconnect	= 5000	'(/msec)
	const lsend	= 30000	'(/msec)
	const lreceive	= 30000	'(/msec)

	'/******************************************************
	' * ID		: 다날에서 제공해 드린 CPID
	' * PWD		: 다날에서 제공해 드린 CPPWD
	' * ORDERID	: CP 주문정보
	' ******************************************************/
	ID  = "B010047230"
	PWD = "p2cGNNViYm"
	ORDERID = "ORDERID"

	'/******************************************************
	' *  CHARSET 지정 ( UTF-8:Default or EUC-KR )
	' ******************************************************/
	CHARSET	= "EUC-KR"
	'CHARSET	= "UTF-8"
  
	'/******************************************************
	' * - CallTrans
	' *	다날 서버와 통신하는 함수입니다.
	' *	Debug가 true일경우 웹브라우져에 debugging 메시지를 출력합니다.
	' ******************************************************/  
	Function CallTrans( TransR , Debug )
		
		REQ_STR = data2str(TransR)
		
		Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP")
				
		xmlHttp.setTimeouts lresolv, lconnect, lsend, lreceive
		
		xmlHttp.SetOption 2, xmlHttp.getOption(2)
		xmlHttp.Open "POST",  DN_SERVICE_URL , False
		xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=" & CHARSET
	
		xmlHttp.Send(REQ_STR)

		IF xmlHttp.status = 200 Then
			RES_STR = xmlHttp.responseText	
		Else
			RES_STR = "RETURNCODE=-1&RETURNMSG=NETWORK(" & xmlHttp.status & ")"
		End IF
		
		IF Debug Then
			Response.Write "REQ[" & REQ_STR & "]<BR>"
			Response.Write "RET[" & xmlHttp.status & "]<BR>"	
			Response.Write "RES[" & xmlHttp.responseText & "]<BR>"
			Response.End
		End IF
		
		Set xmlHttp = nothing
		Set CallTrans = str2data(RES_STR)
	End Function

	Function str2data( str )
		Dim map, key, value
		Set map = CreateObject("Scripting.Dictionary")
		map.removeAll()

		data = Split(str, "&")
		
		For i = 0 To UBound(data)
			key = Left(data(i), Instr(data(i), "=")-1)
			value = Right(data(i), Len(data(i))-Instr(data(i), "="))
			
			IF Len(key) > 0 AND Len(value) > 0 AND map.Exists(key) = false Then
				map.Add key , value
			End IF
		Next
		
		Set str2data = map
	End Function

	function data2str( data )
		Dim str
		
		str = ""
		For Each dKey In data
			str = str & dKey & "=" & Server.URLEncode(data.Item(dKey)) & "&"
		Next
		
		data2str = str
	End Function
	
	Function MakeFormInput(byVal arr,dic)
		IF NOT isNull(dic) Then 
			For i = 0 To ubound(dic) 
				IF arr.exists(dic(i)) Then
					arr.remove(dic(i))
				End IF
			NEXT
		End IF

		For Each Key In arr
			Response.Write "<input type='hidden' name='" & Key & "' value='" & arr.Item(Key) & "'>"& chr(10)
		NEXT

		Set arr = nothing 
	End Function

	Function MakeFormInputHTTP(arr, dic)
	
		For Each Key In arr
		
			IF Key <> dic Then
				Response.Write "<INPUT TYPE='HIDDEN' NAME='" & Key & "' VALUE='" & arr.Item(Key) & "'>"& chr(10)
			End IF
			
		NEXT

		Set arr = nothing
	End Function

	Function MakeAddtionalInput(Trans,HTTPVAR,Names) 
		For i = 0 To UBound(Names)
			name = Names(i)

			Trans.Add name , HTTPVAR.Item(name)
		Next
	End Function

	Function GetBgColor(BGCOLOR)
		Dim Color, nBgColor
		
		'/*
		' * Default : Blue
		' */
		Color = 0
		nBgColor = CInt(BGCOLOR)
		
		IF (nBgColor > 0 ) AND (nBgColor < 11) Then
			Color = nBgColor
		End IF
		
		GetBgColor = GetExpression(Color,"00")
	End Function

	Function GetExpression(szString,szExpression)
		Dim szFormat

		If Len(szString) < Len(szExpression) Then
			szFormat = Left(szExpression,Len(szExpression)-Len(szString)) & szString
		Else
			szFormat = szString
		End If

		GetExpression = szFormat
	End Function
	
	Function RegExpReplace(Patrn, TrgtStr, RplcStr)
	
		Dim ObjRegExp
		
		Set ObjRegExp = New RegExp
		
		ObjRegExp.Pattern = Patrn
		ObjRegExp.Global = True
		ObjRegExp.IgnoreCase = True
		
		RegExpReplace = ObjRegExp.Replace(TrgtStr, RplcStr)
		
		Set ObjRegExp = Nothing
		
	End Function
%>