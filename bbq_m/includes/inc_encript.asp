<%
	'---------------------------------------------------------------------------------
	' 암호화/복호화 모듈
	' spgay에서 사용한 것을 가져와서 사용함
	'-----------------------------------------------------------------------------
	Dim AppWebPath

	'---------------------------------------------------------------------------------
	' 가맹점 API 가 호출 당할 경우 도메인 또는 아이피 셋팅하기 위한 변수 ( 도메인이 있을 경우 도메인을 셋팅하시면 됩니다. )
	' 용도 : serviceUrl 및 returnUrl, nonBankbookDepositInformUrl 용.
	' API 호출시 http:// 부터 경로를 전체적으로 써줘야 HttpRequest 통신시 오류발생 안함.
	'---------------------------------------------------------------------------------
	If Request.ServerVariables("HTTPS") = "on" Then
		urlProtocol = "https"
	Else
		urlProtocol = "http"
	End If

	AppWebPath = urlProtocol & "://" & Request.ServerVariables("HTTP_HOST")

	'-----------------------------------------------------------------------------
	' 캐릭터셋 지정
	'-----------------------------------------------------------------------------
	Response.charset = "UTF-8"

	'-----------------------------------------------------------------------------
	' 기업 / 가맹점 코드 선언
	'-----------------------------------------------------------------------------
	Dim g_CORPNO, g_MERTNO, s_MERTNO
	If G2_SITE_MODE = "local" Then
		g_CORPNO = "0001"		' 기업 관리번호
		g_MERTNO = "0001-00001"	' 가맹점 관리번호					
	Else
		g_CORPNO = "0001"		' 기업 관리번호
		g_MERTNO = "0001-00001"	' 가맹점 관리번호					
	End If
	's_MERTNO = "0001-00001"

	'-----------------------------------------------------------------------------
	' 암호화 모듈 및 키 선언
	'-----------------------------------------------------------------------------
	dim g_HASHKEY, g_SEEDKEY, g_SEEDIV
	If G2_SITE_MODE <> "production" Then	' 테스트용 코드
		g_HASHKEY 	= "F3149950A7B6289723F325833F580001"
		g_SEEDKEY 	= "gkR791mVtQlbbuwtcMfs1Q=="
		g_SEEDIV 	= "STDP000173087816"
	else									' 실서버용 코드
		g_HASHKEY 	= "F3149950A7B6289723F325833F580001"
		g_SEEDKEY 	= "AVo/u0UuQbB0p3r+4dIROQ=="
		g_SEEDIV 	= "STDP000173087816"
	end if



%>

<!--#include virtual="/pay/sgpay2/config/base64.asp" -->
<!--#include virtual="/pay/sgpay2/config/KISA_SHA256.asp" -->
<!--#include virtual="/pay/sgpay2/config/KISA_SEED_CBC.asp" -->
<%

    ' // stdpayFunction.asp start
    function seedEncrypt(ByVal bszPlainText, ByVal g_bszUser_key, ByVal g_bszIV)
        Dim i
        Dim bszChiperText
        Dim temp, tempasd
        Dim text, userkey, iv
        
        if(0 >= len(bszPlainText)) then
            seedEncrypt = ""
        else

            userkey = HexToDec(BASE64TOHEX(g_bszUser_key))
            iv = HexToDec(str2hex(g_bszIV))
            text = HexToDec(str2hex(bszPlainText))
            
            bszChiperText = KISA_SEED_CBC.SEED_CBC_Encrypt(userkey, iv, text, 0, UBound(text)+1)
            
            for i=0 to (UBound(bszChiperText))
                temp = temp & Right("0000" & hex(bszChiperText(i)), 2)
                
                If(i <> UBound(bszChiperText)) then
                    temp = temp & ","
                End if
            Next
            
            seedEncrypt = BASE64_ENCODE(temp)
        end if
    end Function

    function seedDecrypt(ByVal bszChiperText, ByVal g_bszUser_key, ByVal g_bszIV)
        Dim i
        Dim bszPlainText
        Dim temp
        Dim text, userkey, iv
        
        if(0 >= len(bszChiperText)) then
            seedDecrypt = ""
        else
            
            userkey = HexToDec(BASE64TOHEX(g_bszUser_key))
            iv = HexToDec(str2hex(g_bszIV))
            text = HexToDec(BASE64TOHEX(bszChiperText))
            bszPlaintext = KISA_SEED_CBC.SEED_CBC_Decrypt(userkey, iv, text, 0, UBound(text)+1)
            
            If isNull(bszPlaintext) Then
                seedDecrypt = ""
            else
            for i=0 to (UBound(bszPlaintext))
                temp = temp & Right("0000" & hex(bszPlaintext(i)), 2)
                If(i <> UBound(bszPlaintext)) then
                    temp = temp & ","
                End if
            Next
            End if
            
            seedDecrypt = hex2str(temp)
        end if
    end function

    Function HexToDec(ByVal hexData)
        
        dataArray = split(hexData,",")
        redim tempArray(ubound(dataArray))

        for i=0 to (ubound(dataArray))
            tempArray(i) = (Cbyte)("&H" & (right("0000" & dataArray(i), 4)))
        Next
            
        HexToDec = tempArray
    End Function

    Function UrlDecode_GBToUtf8(ByVal str) 
		Dim B,ub   
		Dim UtfB   
		Dim UtfB1, UtfB2, UtfB3 
		Dim i, n, s 
		n=0 
		ub=0 
		For i = 1 To Len(str) 
			B=Mid(str, i, 1) 
			Select Case B 
				Case "+" 
					s=s & " " 
				Case "%" 
					ub=Mid(str, i + 1, 2) 
					UtfB = CInt("&H" & ub) 
					If UtfB<128 Then 
						i=i+2 
						s=s & ChrW(UtfB) 
					Else 
						UtfB1=(UtfB And &H0F) * &H1000   
						UtfB2=(CInt("&H" & Mid(str, i + 4, 2)) And &H3F) * &H40       
						UtfB3=CInt("&H" & Mid(str, i + 7, 2)) And &H3F       
						s=s & ChrW(UtfB1 Or UtfB2 Or UtfB3) 
						i=i+8 
					End If 
				Case Else   
					s=s & B 
			End Select 
		Next 
		UrlDecode_GBToUtf8 = s 
	End Function 
%>

<script language="javascript" runat="server" charset="UTF-8">  
function str2hex(szInput){ 
	var wch,x,uch="",szRet="";
	if (szInput == null) szInput = "";
	for (x=0; x<szInput.length; x++){
	  wch=szInput.charCodeAt(x);
	  if (!(wch & 0xFF80)){
	    szRet += "," +  wch.toString(16);
	  }  else if (!(wch & 0xF800)){
	    uch = "," + (wch>>6 | 0xC0).toString(16) + "," + (wch & 0x3F | 0x80).toString(16);
	    szRet += uch;
	  }   else{
	    uch = "," + (wch >> 12 | 0xE0).toString(16) + "," + (((wch >> 6) & 0x3F) | 0x80).toString(16) + "," + (wch & 0x3F | 0x80).toString(16);   
	    szRet += uch;
	  }
	}
	  
	szRet = szRet.substr(1, szRet.length);
	return(szRet.toUpperCase());
}

function hex2str(v)
{
	var return_val = "";
	if(v == null) {
		return_val = "";
	}
	else {
		v = v.replace(/,/g, "%");
		v = "%" + v;
		return_val = decodeURIComponent(v);
	}
	return return_val;
}
</script>
<%
    ' // stdpayFunction.asp end





	'-----------------------------------------------------------------------------
	' 암호화/복호화 예제
	'seedEncrypt(v, g_SEEDKEY, g_SEEDIV) '암호화
	'seedDecrypt(k, g_SEEDKEY, g_SEEDIV) '복호화
	'-----------------------------------------------------------------------------
	
%>