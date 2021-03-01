<%
	
	'*****************************************************
	'* ������ �ʿ��� Function �� ������ ����
    '*
	'* ������ ���� ���ǻ��� �����ø� ������������� ���� �ֽʽÿ�.
	'* DANAL Commerce Division Technique supporting Team 
    '* EMail : crs_tech@danal.co.kr
	'******************************************************
%>
<%
	'******************************************************
	'* ���� URL ����.
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
	'* CPID		: �ٳ����� ������ �帰 CPID
	'* CRYPTOKEY	: �ٳ����� ������ �帰 �Ϻ�ȣȭ KEY(����KEY - 64���� Hashȭ ���ڿ�)
	'* IVKEY		: ������ (����Ұ�) 
	'******************************************************
	CPID  = "xxxxx"
	CRYPTOKEY = "xxxxx"
    IVKEY = "3a79a3d97cd3e068f41cf95a6b9ab93f"

    TEST_AMOUNT = "1004"
		
	'******************************************************
	'* �ٳ� ������ ����Լ� CallCashReceipt
	'*    - �ٳ� ������ ����ϴ� �Լ��Դϴ�.
	'*    - Debug�� true�ϰ�� ���������� debugging �޽����� ����մϴ�.
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