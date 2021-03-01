<%
	Response.CharSet = "euc-kr"
%>
<%
	'*****************************************************
	'* 다날 신용카드 결제
	'*****************************************************
	
	'*****************************************************
	'* 결제 연동에 필요한 Function 및 변수값 설정
    '*
	'* 결제시스템 연동에 대한 문의사항 있으시면 기술지원팀으로 연락 주십시오.
	'* DANAL Commerce Division Technique supporting Team 
	'* EMAIL : tech@danal.co.kr	 
	'******************************************************
%>
<%
	'******************************************************
	'* 결제서버 URL 정의.
	'******************************************************
	Const DN_CREDIT_URL	= "https://tx-creditcard.danalpay.com/credit/"								
	
	'******************************************************
	'* SET TIMEOUT
	'******************************************************
	const lresolv	= 5000	'(/msec)
	const lconnect	= 5000	'(/msec)
	const lsend	= 30000	'(/msec)
	const lreceive	= 30000	'(/msec)

	'******************************************************
	'* CPID		: 다날에서 제공해 드린 CPID
	'* CRYPTOKEY	: 다날에서 제공해 드린 암복호화 PW
	'******************************************************
	If branch_id = "" Then 
	    branch_id = GetReqStr("branch_id","")
	End If 

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_branch_select"

        .Parameters.Append .CreateParameter("@branch_id", adVarChar, adParamInput, 20, branch_id)

        Set rs = .Execute
    End With
    Set cmd = Nothing

    If Not (rs.BOF or rs.EOF) then
        rs.MoveFirst

		DANAL_CPID_CARD = rs("danal_h_cpid")

		CPID = DANAL_CPID_CARD
		CRYPTOKEY = DANAL_PWD_CARD
	Else
		response.write "<script>"
		response.write "	alert('CPID ERROR');"
		response.write "	self.close();"
		response.write  "</script>"
		response.end 

		CPID = DANAL_CPID_OLD
		CRYPTOKEY = DANAL_PWD_CARD
    End If

	If CPID = "" Then 
		response.write "<script>"
		response.write "	alert('가맹점 CPID가 없습니다.');"
		response.write "	self.close();"
		response.write  "</script>"
		response.end 
	End If 

    IVKEY = "d7d02c92cb930b661f107cb92690fc83"

    TEST_AMOUNT = "1004"
		
	'******************************************************
	'* 다날 서버와 통신함수 CallTrans
	'*    - 다날 서버와 통신하는 함수입니다.
	'*    - Debug가 true일경우 웹브라우져에 debugging 메시지를 출력합니다.
	'******************************************************
	Function CallCredit( REQ_DATA , Debug )
        Dim REQ_STR, RES_DATA

		REQ_STR = data2str(REQ_DATA)
        REQ_STR = toEncrypt(REQ_STR)
        REQ_STR = Server.URLEncode(REQ_STR)
        REQ_STR = "CPID=" & CPID & "&DATA=" & REQ_STR

		Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP")
				
		xmlHttp.setTimeouts lresolv, lconnect, lsend, lreceive
		
		xmlHttp.Open "POST",  DN_CREDIT_URL , False
		xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=euc-kr"
	
		xmlHttp.Send(REQ_STR)

		IF xmlHttp.status = 200 Then
			RES_STR = xmlHttp.responseText	
		Else
			RES_STR = "RETURNCODE=-1&RETURNMSG=NETWORK(" & xmlHttp.status & ")"
		End IF

		IF Debug Then
			Response.Write "REQ[" & REQ_STR & "]<BR>"
			Response.Write "RET[" & xmlHttp.status & "]<BR>"	
			Response.Write "RES[" & URLDecode(xmlHttp.responseText) & "]<BR>"
			Response.End
		End IF

        Set RES_DATA = str2data( RES_STR )

        IF RES_DATA.Exists("DATA") = true Then
            RES_STR = RES_DATA.Item("DATA")
            RES_STR = toDecrypt( RES_STR )
            Set RES_DATA = str2data( RES_STR )
        End IF
		
		Set xmlHttp = nothing
		Set CallCredit = RES_DATA
	End Function
	
    Function toEncrypt( str )
        Dim objCrypto
        Dim EncText

        Set objCrypto = Server.CreateObject("DNCryptoCOM.AES")

        objCrypto.SetCharset( "EUC-KR" )
		EncText = objCrypto.EncryptText(CRYPTOKEY, IVKEY, str)

        Set objCrypto = nothing
        toEncrypt = EncText
    End Function

    Function toDecrypt( str )
        Dim objCrypto, DecText

        Set objCrypto = Server.CreateObject("DNCryptoCOM.AES")

        objCrypto.SetCharset( "EUC-KR" )
		DecText = objCrypto.DecryptText(CRYPTOKEY, IVKEY, str)

        Set objCrypto = nothing
        toDecrypt = DecText
    End Function

	Function str2data( str )
		Dim map
		Set map = CreateObject("Scripting.Dictionary")
		map.removeAll()

		data = Split(str, "&")
		
		For i = 0 To UBound(data)
			subData = Split(Trim(data(i)), "=")
			IF UBound(subData) > 0 AND map.Exists(subData(0)) = false Then
				If subData(0) = "RETURNMSG" Or subData(0) = "CARDNAME" Then 
					map.Add subData(0) , subData(1)
				Else
					map.Add subData(0) , URLDecode(subData(1))
				End If 
			End IF
		Next
		
		Set str2data = map
	End Function

	Function data2str( data )
		Dim str
		
		str = ""
		For Each dKey In data
			str = str & dKey & "=" & Server.URLEncode(data.Item(dKey)) & "&"
		Next
		
		data2str = str
	End Function

	Function AddComma(str)
		C = Formatnumber(str,0)
		AddComma = C
	End Function
	
	Function URLDecode(Expression) 
		Dim strSource, strTemp, strResult, strchr 
		Dim lngPos, AddNum, IFKor 

		strSource = Replace(Expression, "+", " ") 
		
		For lngPos = 1 To Len(strSource) 
			AddNum = 2 
			strTemp = Mid(strSource, lngPos, 1) 

			IF strTemp = "%" Then 
				IF lngPos + AddNum < Len(strSource) + 1 Then 
					strchr = CInt("&H" & Mid(strSource, lngPos + 1, AddNum)) 
					IF strchr > 130 Then 
						AddNum = 5 
						IFKor = Mid(strSource, lngPos + 1, AddNum) 
						IFKor = Replace(IFKor, "%", "") 
						strchr = CInt("&H" & IFKor ) 
					End IF
						strResult = strResult & Chr(strchr) 
						lngPos = lngPos + AddNum 
				End IF 
			Else 
				strResult = strResult & strTemp 
			End If 
		Next 

		URLDecode = strResult 
	End Function 
%>