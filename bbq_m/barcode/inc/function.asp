<%
	
	'*****************************************************
	'* 연동에 필요한 Function 및 변수값 설정
    '*
	'* 연동에 대한 문의사항 있으시면 기술지원팀으로 연락 주십시오.
	'* DANAL Commerce Division Technique supporting Team 
    '* EMail : crs_tech@danal.co.kr
	'******************************************************
%>
<%
	'******************************************************
	'* 서버 URL 정의.
	'******************************************************
	Const DN_RECEIPT_URL	= "https://tx-cashreceipt.danalpay.com/receipt/"								
	
	'******************************************************
	'* SET TIMEOUT
	'******************************************************
	const lresolv	= 5000	'(/msec)
	const lconnect	= 5000	'(/msec)
	const lsend	= 30000	'(/msec)
	const lreceive	= 30000	'(/msec)

	'******************************************************
	'* CPID		: 다날에서 제공해 드린 CPID
	'* CRYPTOKEY	: 다날에서 제공해 드린 암복호화 KEY(인증KEY - 64자의 Hash화 문자열)
	'* IVKEY		: 고정값 (변경불가) 
	'******************************************************
	CPID  = "xxxxx"
	CRYPTOKEY = "xxxxx"
    IVKEY = "3a79a3d97cd3e068f41cf95a6b9ab93f"

    TEST_AMOUNT = "1004"
		
	'******************************************************
	'* 다날 서버와 통신함수 CallCashReceipt
	'*    - 다날 서버와 통신하는 함수입니다.
	'*    - Debug가 true일경우 웹브라우져에 debugging 메시지를 출력합니다.
	'******************************************************
	Function CallCashReceipt( REQ_DATA , Debug )
        Dim REQ_STR, RES_DATA

		REQ_STR = data2str(REQ_DATA)
        REQ_STR = toEncrypt(REQ_STR)
        REQ_STR = URLEncodeToEuc(REQ_STR)
        REQ_STR = "CPID=" & CPID & "&DATA=" & REQ_STR

		Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP")
				
		xmlHttp.setTimeouts lresolv, lconnect, lsend, lreceive
		
		xmlHttp.Open "POST",  DN_RECEIPT_URL , False
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
			Response.Write "RES[" & URLDecodeToEuc(xmlHttp.responseText) & "]<BR>"
			Response.End
		End IF

        Set RES_DATA = str2data( RES_STR )

        IF RES_DATA.Exists("DATA") = true Then
            RES_STR = RES_DATA.Item("DATA")
            RES_STR = toDecrypt( RES_STR )
            Set RES_DATA = str2data( RES_STR )
        End IF
		
		Set xmlHttp = nothing
		Set CallCashReceipt = RES_DATA
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
				map.Add subData(0) , URLDecodeToEuc(subData(1))
			End IF
		Next
		
		Set str2data = map
	End Function

	Function data2str( data )
		Dim str
		
		str = ""
		For Each dKey In data
			str = str & dKey & "=" & URLEncodeToEuc(data.Item(dKey)) & "&"
		Next
		
		data2str = str
	End Function

	Function AddComma(str)
		C = Formatnumber(str,0)
		AddComma = C
	End Function
	
	Function URLEncodeToEuc(value)
        Set objCrypto = CreateObject("DNCryptoCOM.AES")
        URLEncodeToEuc = objCrypto.UrlEncodeStr(value, "euc-kr")
    End Function

    Function URLDecodeToEuc(value)
        Set objCrypto = CreateObject("DNCryptoCOM.AES")
        URLDecodeToEuc = objCrypto.UrlDecodeStr(value, "euc-kr")
    End Function
%>