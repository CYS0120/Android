<%
	'/********************************************************************************
	' *
	' * ´Ù³¯ ÀÎÅÍ³ÝÁýÀüÈ­ °áÁ¦
	' *
	' * - Function Library
	' *	°áÁ¦ ¿¬µ¿¿¡ ÇÊ¿äÇÑ Function ¹× º¯¼ö°ª ¼³Á¤ 
	' *
	' * °áÁ¦ ½Ã½ºÅÛ ¿¬µ¿¿¡ ´ëÇÑ ¹®ÀÇ»çÇ×ÀÌ ÀÖÀ¸½Ã¸é ¼­ºñ½º°³¹ßÆÀÀ¸·Î ¿¬¶ô ÁÖ½Ê½Ã¿À.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/
	
	Dim CPID, CPPWD, CHARSET
	
	'******************************************************
	' * ÀÎÁõ¼­¹ö URL Á¤ÀÇ.
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
	' * ID		: ´Ù³¯¿¡¼­ Á¦°øÇØ µå¸° CPID
	' * PWD		: ´Ù³¯¿¡¼­ Á¦°øÇØ µå¸° CPPWD
	' * ORDERID	: CP ÁÖ¹®Á¤º¸
	' ******************************************************/
	ID  = "9010020800"
	PWD = "fdc0684f239b3f44038760f73788c147e235e90b8ef16b0855d8c0288316213f"
	ORDERID = "ORDERID"

	'/******************************************************
	' *  CHARSET ÁöÁ¤ ( UTF-8:Default or EUC-KR )
	' ******************************************************/
'	CHARSET	= "EUC-KR"
	CHARSET	= "UTF-8"
  
	'/******************************************************
	' * - CallTrans
	' *	´Ù³¯ ¼­¹ö¿Í Åë½ÅÇÏ´Â ÇÔ¼öÀÔ´Ï´Ù.
	' *	Debug°¡ trueÀÏ°æ¿ì À¥ºê¶ó¿ìÁ®¿¡ debugging ¸Þ½ÃÁö¸¦ Ãâ·ÂÇÕ´Ï´Ù.
	' ******************************************************/  
	Function CallTrans( TransR , Debug )
		
		REQ_STR = data2str(TransR)
		
		Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")  '(2022.2.25 ë³€ê²½) CreateObject("MSXML2.ServerXMLHTTP")
				
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