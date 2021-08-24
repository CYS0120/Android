<%
function seedEncrypt(bszPlainText,g_bszUser_key,g_bszIV)
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

function seedDecrypt(bszChiperText,g_bszUser_key,g_bszIV)
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

Function HexToDec(hexData)
	
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
	v = v.replace(/,/g, "%");
	v = "%" + v;
	return decodeURIComponent(v); 
}
</script>